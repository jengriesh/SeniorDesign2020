%% Test Phantoms Code: This code runs through our phantom files (the whole phantom and aneurysm mask files) and outputs their metrics.
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1: Converts the  to binary
%loads the image and mask, Creates the brain and mask matrix, Information about files
    imfile = ('Phantom_Normal.nii');   imbrain = double(niftiread(imfile));    brain_info = niftiinfo('Phantom_Normal.nii');
    maskfile = ('Aneurysm_Normal.nii'); immask = double(niftiread(maskfile));    mask_info = niftiinfo('Aneurysm_normal.nii');

%gets info about sizes of image    
    imagesize = size(imbrain);
    r = imagesize(1,3);
    m = imagesize(1,1);
    n = imagesize(1,2);

%Initalize variables to count # of slices that dont have aneurysms and counts slices with the aneurysms in it
    non_ia_slices = 0;
    num_ia_slices = 0;
    
for i = 1:r
        binary_mask_i = immask(:,:,i);       
        nnz__mask = nnz(binary_mask_i); %number of non-zeros in the slice
        %if there are no non-zero pixels then there is no aneurysm
        %How many slices have aneurysm
        %array that keeps track ofs what slices the aneurysm is in 
        %EXIT PROGRAM WITH NO ANUERYSM ERROR PUT IN ONCE METRICS CODE HAS BEEN
        %COMPLETED
        if nnz__mask == 0
          non_ia_slices =  non_ia_slices +1;
        else
          num_ia_slices = num_ia_slices +1;
          SLICE_NUMBER(num_ia_slices) = i; 
        end

end 
slices = length(SLICE_NUMBER);
firstANSlice = min(SLICE_NUMBER);
for s = 1:slices
    i = firstANSlice-1 + s;

        brain = imbrain(:,:,i);
        mask = immask(:,:,i);
        fusedimage = imfuse(brain, mask);
        overlayed_images(:,:,s) = rgb2gray(fusedimage);

end

%% Uses function "Metrics" to analyze the ellipse surrounding the blood vessel
%This for loop is to analyze all of the pixel values in one slice to find
%the values that make up the blood vessel versus the values that make up
%the the aneurysm
addition = 1;
for s = 1:slices
    for a= 1:512
        for b = 1:512  
               if overlayed_images(a,b,s) ~= 0
                   value(addition) = overlayed_images(a,b,s);
                   addition = addition +1;
               end 
        end
    end
    mode_bood_vessel_pixel_value = mode(value);
%if the pixel value is above zero, the pixels will be analzyed from there
    for a= 1:512
            for b = 1:512  
                    if overlayed_images(a,b,s) == mode_bood_vessel_pixel_value
                          just_BV(a,b,s) = 1;   %record value at a,b,s in overlayed images
                    else
                          just_BV(a,b,s) = 0;
                    end
            end
    end
    
        for a= 1:512
            for b = 1:512  
                    if overlayed_images(a,b,s) ~= mode_bood_vessel_pixel_value && overlayed_images(a,b,s) ~= 0
                          just_AN(a,b,s) = 1;   %record value at a,b,s in overlayed images
                    else
                          just_AN(a,b,s) = 0;
                    end
            end
        end
end 
PreviousLengthAN = 0;
PreviousLengthBV = 0;
for s = 1:slices
    [MajorAxisBV, MinorAxisBV, OrientationBV, xRotatedBV, yRotatedBV, CenterBV] = metrics(just_BV(:,:,s));
%calculation to break up the major axis into x and y components to find the dimensions of the major axis in mm
    verticalBV   = MajorAxisBV* (sin(OrientationBV)) * brain_info.PixelDimensions(1,1);
    horizontalBV = MajorAxisBV * (cos(OrientationBV)) * brain_info.PixelDimensions(1,2);
    subtractedBV = MajorAxisBV - MinorAxisBV;
    LengthBV = sqrt(verticalBV^2 + horizontalBV^2); %pythagorean theorem 
    fprintf("Slice Number:%f \nLength in mm:%f \nMajor-Minor:%f",s, LengthBV, subtractedBV);
% %dislay the images
%         figure
%         imshow(just_BV(:,:,s))
%         hold on
%         plot(xRotatedBV, yRotatedBV, 'LineWidth', 2);
%         plot(CenterBV(1,1), CenterBV(1,2),'*');
%         hold off
[MajorAxisAN, MinorAxisAN, OrientationAN, xRotatedAN, yRotatedAN, CenterAN] = metrics(just_AN(:,:,s));
%fprintf('MajorAxis:%f \n MinorAxis:%f \n Orientation:%f \n Center:%f', MajorAxis, MinorAxis, Orientation, Center)
%calculation to break up the major axis into x and y components to find the
%dimensions of the major axis in mm
verticalAN   = MajorAxisAN* (sin(OrientationAN)) * mask_info.PixelDimensions(1,1);
horizontalAN = MajorAxisAN * (cos(OrientationAN)) * mask_info.PixelDimensions(1,2);
subtractedAN = MajorAxisAN - MinorAxisAN;
LengthAN = sqrt(verticalAN^2 + horizontalAN^2); %pythagorean theorem 
fprintf("Slice Number:%f \nLength in mm:%f \nMajor-Minor:%f",s, LengthAN, subtractedAN);
% %dislay the images
%         figure
%         imshow(just_AN(:,:,s))
%         hold on
%         plot(xRotatedAN, yRotatedAN, 'LineWidth', 2);
%         plot(CenterAN(1,1), CenterAN(1,2),'*');
%         hold off

%largest diameter:
if LengthBV > PreviousLengthBV
   BVLargestLength = LengthBV;  
end 
PreviousLengthBV = LengthBV;

if LengthAN > PreviousLengthAN
   ANLargestLength = LengthAN;  
end 
PreviousLengthAN = LengthAN;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Size Ratio
SizeRatio = ANLargestLength/BVLargestLength;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Section #: regionprops3 with blood vessel
close all
for s = 1:slices
%This for loop is to analyze all of the pixel values in one slice to find
%the values that make up the blood vessel versus the values that make up
%the the aneurysm  
    for a= 1:512
        for b = 1:512  
               if overlayed_images(a,b,s) ~= 0
                   value = overlayed_images(a,b,s);
               end 
        end
    end
    mode_bood_vessel_pixel_value = mode(value) ;
    
    for a= 1:512
        for b = 1:512  
                if overlayed_images(a,b,s) == mode_bood_vessel_pixel_value
                      just_BV_3D(a,b,s) = 1;   %record value at a,b,s in overlayed images
                else
                      just_BV_3D(a,b,s) = 0;
                end
        end
    end
    
    for a= 1:512
        for b = 1:512  
                if overlayed_images(a,b,s) == 0
                      overlayed_images(a,b,s) = 0;  
                else
                      overlayed_images(a,b,s) = 1;
                end
        end
    end

    
end 
% %  
stats_BV = regionprops3(just_BV_3D, 'all')
% plotcube('Pos',[stats_BV.BoundingBox])
stats_BV_ANEURYSM = regionprops3(overlayed_images,'all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

