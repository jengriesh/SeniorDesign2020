%% Main Metrics Code -- Single View (updated 2/10/2020)
clear all
close all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 1: Converts the  to binary
%this section loads in 
    %loads the image
    imfile = ('Dicom.nii.gz');
    %loads the mask
    maskfile = ('Mask.nii.gz');
    %Creates the brain matrix
    imbrain = niftiread(imfile);
    %Creates the mask matrix
    immask = niftiread(maskfile);
    %information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz');
%Initalize variable to count # of slices that dont have aneurysms 
%Probably not necessary 
non_ia_slices = 0;
%Initalizs variable that counts slices with the aneurysms in it
num_ia_slices = 0;
%Pass in the mask 
%Output array that tells what slices the aneurysm is in
%binary_mask is a 3D 1s and 0s mask 
% Go through all images in mask 
for i = 1:136
 %makes the image double so that it can be 
mask_slice = -double(immask(:,:, i));  
brain(:,:,i) = double(imbrain(:,:,i)); %makes the brain a double instead of int16
 %find dimesions of mask_slice
[m, n] = size(mask_slice);
 % go through each pixel turn into zero by one binary image
     for l = 1:m
        for j = 1:n
            if mask_slice(l,j) ==  32768 %Check other images for correct thresh
               binary_mask_i(l,j) = 0;
            else
               binary_mask_i(l,j) = 1;
            end 
        end
     end
% ia_slices = iaSlices(binary_mask);
    % number of non-zeros in the slice
    nnz__mask = nnz(binary_mask_i);
    %if there are no non-zero pixels then there is no aneurysm
    if nnz__mask == 0
      % EXIT PROGRAM WITH NO ANUERYSM ERROR
      non_ia_slices =  non_ia_slices +1;
    else
      % How many slices have aneurysm
      num_ia_slices = num_ia_slices +1;
      % array that keeps track ofs what slices the aneurysm is in 
      SLICE_NUMBER(num_ia_slices) = i; 
    end
    binary_mask(:,:,i) = binary_mask_i;
    
end 
% Pass in the array of slices that contain the aneurysms
slices = length(SLICE_NUMBER); %can edit this number to have slices before and after anuerysm
SLICE_NUMBER_MIN = min(SLICE_NUMBER)-1; %can edit this number to have slices before and after anuerysm
%the code below allows the aneurysm slices to be extracted and put into one
%mXnXi 3D image
slice = 0; %code debugger
post_size_x= 0; %allows the size of an array to increase
count = 1; %code debugger to count how many aneurysm pixels in one slice
number_of_total_aneurysm_pixels = 1; %ocunts total number of pixels that exist
newx = 0;
newy = 0;
per_slice_count = 0;
for i=1:slices
    ia_slice = SLICE_NUMBER_MIN+i;%chooses one slice in our 3D set is analyzed and extracts i
    binary_mask_with_aneurysm(:,:,i) = binary_mask(:,:,ia_slice); %saves all the slices of the mask with the aneurysm in i
    brain_with_aneurysm(:,:,i) = brain(:,:,ia_slice);
    [x,y]= find(binary_mask_with_aneurysm(:,:,i));
        %if there is a value in x then the if statement will run to save
        %all of the informations of the locations of the aneurysm in
        %various arrays
         if x >= 1 
            %counts how many anuerysm pixels exist on the image
            size_x = length(x); 
            size_y = length(y);
            %adds #pixels to the previous number to find the exact number
            %of pixels in all of the slices that hold the aneurysm
            newx = size_x + newx;
            newy = size_y + newy;
            
                for a = 1:size_x
                    locations_x(count) = x(a,1); %x locations of aneurysms in each slice
                    locations_y(count) = y(a,1); %y locations of aneurysms in each slice
                    pixel_value(count) = brain_with_aneurysm(x(a,1),y(a,1)); %pixel values of all the aneurysm locations
                    count = count+1; 
                    per_slice_count = per_slice_count+1;  
                end 
                
            slice = 1+slice;
            pixel_per_slice(slice) = per_slice_count; %number of pixels that make up the aneurysm per slice
            per_slice_count = 0;   
         end 
   
    l = l+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% Section 2: Thresholding the brain image
%The INPUT to this section is 
%for loop to make all of the slices binary that are before, when there is
%and after the aneurysm. where below h is equal to the mode of the
%pixel_values with the anuerysm.
threshold = median(pixel_value);
%the mode, max, and min calculations below are used to extract the loaction
%of the anuerysm in hopes of finding the bloo vessel attached to it
mode_x = mode(locations_x);
mode_y = mode(locations_y);
max_x = max(locations_x);
max_y = max(locations_y);
min_x = min(locations_x);
min_y = min(locations_y);
%the for loop below thresholds the brain image so that it becomes binary
for i = 1:slices
    for a = 1:512   %make universal by taking the size of the image eventually 
        for b = 1:512
            if brain_with_aneurysm(a,b,i) >= threshold %unsure of what the trheshold should actually be. this needs to be more looked at
                brain_with_aneurysm_binary(a,b,i) = 1;
            else
                brain_with_aneurysm_binary(a,b,i) = 0;
            end 
        end
    end   
end
number = 0; %code debugger
% this for loop allows the blood vessel to be extracted 
for i = 1:slices
       brain = brain_with_aneurysm_binary(:,:,i);
%finds and labels all of the connected components with a specific pixel value, unless there are no 
%connected components in which this function will leave the pixel value as zero       
       label = bwlabel(brain); 
       val = label(min_x, min_y); %determines the pixel values conneccted to the aneurysm
%if the anuerysm is not on the blood vessel then the pixel value should have been 0, ...
%so if this occurs theis while loop will keep searching until it finds a pixel value that is not zero                
        while  val == 0 
            number = number + 1;
            val = label(mode_x+number, mode_y+number);
        end 
%on the brain_with_aneurysm image it keeps only the components connected to the anuerysm
        for a = 1:512
               for b = 1:512
                    if val == label(a,b)
                       blood_vessel(a,b,i) = 1;
                   else
                       blood_vessel(a,b,i) = 0;
                   end
               end
        end
        number = 0;
end
%the below for loop overlays the aneurysm mask and the blood vessel and
%turns it into grayscale so it can all be saved as one mxnxi matrix
for s = 1: slices
    v = 44+s;
    mask  = binary_mask_with_aneurysm(:,:,s);
    blood_V = blood_vessel(:,:,s);
    over_layed = imfuse(mask, blood_V);
    overlayed_images(:,:,s) = rgb2gray(over_layed);
    bob = imfuse(overlayed_images(:,:,s), imbrain(:,:,v));
    four_d(:,:,:,s) = bob;%outputs a 4D image such that we can use to try and put it through a 3D viewer and have it look mildly normal
    time = 44+s;
    immy =imbrain(:,:,46);
    faloola = imfuse(immy, bob);
%     imshow(faloola,[]);
%     time = 1; %code debugger
%     pasta = sprintf('BV_A_Brain00%d.png', s);
    jennaTest = '3';
%     imwrite(four_d(:,:,:,s), pasta);
end
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Section #: to use line tracing to try and find center
close all;
%This for loop is to analyze all of the pixel values in one slice to find
%the values that make up the blood vessel versus the values that make up
%the the aneurysm
    for a= 1:512
        for b = 1:512  
               if overlayed_images(a,b,5) ~= 0
                   value = overlayed_images(a,b,5);
               end 
        end
    end
    mode_bood_vessel_pixel_value = mode(value);
%The if statement below says:
%if the pixel value is above zero, the pixels will be analzyed from there
    for a= 1:512
            for b = 1:512  
                    if overlayed_images(a,b,5) == mode_bood_vessel_pixel_value
                          just_BV(a,b) = 1;   %record value at a,b,s in overlayed images
                    else
                          just_BV(a,b) = 0;
                    end
            end
    end
%code below allows the ellipse to be created *this was taken from a MATLAB forum so the    
s = regionprops(just_BV,'Orientation','Centroid','MajorAxisLength', 'MinorAxisLength', 'Centroid')
center = s.Centroid;
xAmplitude = s.MinorAxisLength/2;
yAmplitude = s.MajorAxisLength/2;
xCenter = center(1,1);
yCenter = center(1,2);
t = linspace(0, 360,1000);
xOriginal = xAmplitude * sind(t) + xCenter;
yOriginal = yAmplitude * cosd(t) + yCenter;
rotationAngle = s.Orientation;
transformMatrix = [cosd(rotationAngle), sind(rotationAngle);-sind(rotationAngle), cosd(rotationAngle)];
xAligned = (xOriginal - xCenter);
yAligned = (yOriginal - yCenter);
xyAligned = [xAligned; yAligned]';
xyRotated = xyAligned * transformMatrix;
xRotated = xyRotated(:, 1) + xCenter;
yRotated = xyRotated(:, 2) + yCenter;

vertical   = s.MajorAxisLength * (sin(s.Orientation)) * brain_info.PixelDimensions(1,1);
horizontal = s.MajorAxisLength * (cos(s.Orientation)) * brain_info.PixelDimensions(1,2);

length = sqrt(vertical^2 + horizontal^2);
figure
imshow(just_BV)
hold on
plot(xRotated, yRotated, 'LineWidth', 2);
plot(s.Centroid(1,1), s.Centroid(1,2),'*');
hold off


%% find the centroid of all of the slicesand 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Section #: regionprops3 with blood vessel
% % close all
% % for s = 1:slices
% % %This for loop is to analyze all of the pixel values in one slice to find
% % %the values that make up the blood vessel versus the values that make up
% % %the the aneurysm
% %     
% %     for a= 1:512
% %         for b = 1:512  
% %                if overlayed_images(a,b,s) ~= 0
% %                    value = overlayed_images(a,b,s);
% %                end 
% %         end
% %     end
% %     mode_bood_vessel_pixel_value = mode(value) ;
% %     
% %     for a= 1:512
% %         for b = 1:512  
% %                 if overlayed_images(a,b,s) == mode_bood_vessel_pixel_value
% %                       just_BV_3D(a,b,s) = 1;   %record value at a,b,s in overlayed images
% %                 else
% %                       just_BV_3D(a,b,s) = 0;
% %                 end
% %         end
% %     end
% %     
% %     for a= 1:512
% %         for b = 1:512  
% %                 if overlayed_images(a,b,s) == 0
% %                       overlayed_images(a,b,s) = 0;  
% %                 else
% %                       overlayed_images(a,b,s) = 1;
% %                 end
% %         end
% %     end
% % 
% %     
% % end 
% %  
% % stats_BV = regionprops3(just_BV_3D, 'all')
% % % plotcube('Pos',[stats_BV.BoundingBox])
% % stats_BV_ANEURYSM = regionprops3(overlayed_images,'all')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Section #: to count to the right and diagonally to determine aneurysm size
% %using the verlyaed image of the blood vessel and the aneurysm
% length =0;
% horiz_count = 0;
% diag_count = 0;
% %the large for loop below allows you to check for the middle of the blood
% %vessel
% for s = 1:slices
% %This for loop is to analyze all of the pixel values in one slice to find
% %the values that make up the blood vessel versus the values that make up
% %the the aneurysm
%     for a= 1:512
%         for b = 1:512  
%                if overlayed_images(a,b,s) ~= 0
%                    value = overlayed_images(a,b,s);
%                end 
%         end
%     end
%     mode_bood_vessel_pixel_value = mode(value)
%  
% %for loop that allows you to use the blood vessel pixel values to the right
% %of the aneurysm
%     for a= 1:512
%         for b = 1:512  
% %The if statement below says:
% %if the pixel value is above zero, the pixels will be analzyed from there
%                 if overlayed_images(a,b,s) > 0
%                       pixel = overlayed_images(a,b,s);   %record value at a,b,s in overlayed images
% %The if statement below says:
% %if the value above is not equal to the mode of the bloodvessel then the code will record, 
% %what location it is (pixel value should not be zero or 150)                   
%                     if  pixel ~= mode_bood_vessel_pixel_value 
%                            pixel_right =  overlayed_images(a,b+1,s); %
%                            c = 1;%sets the value for the increment to move to the right by one pixel
%                            d=1;
%                            k =0;% sets the value for the while loop
%                            j=0;
%                                if (pixel ~= pixel_right) && (pixel_right ~= 0)
%          %then if the pixel value to the right of it is not equal to 0 or the pixel value 
%          %itself, then count until it you reach a zero as implemented with the
%          %while loops below
%                                     %to search horizontallly 
%                                     while k==0
%                                         c= c+1;
%                                         pixel_right =  overlayed_images(a,b+c,s);
%                                         horiz_count = horiz_count+1 ;
%                                         if pixel_right == 0
%                                             k = 1;
%                                             horiz_length_slice = horiz_count;
%                                         end
%                                     end    
%                                     horiz_count = 0;
%            %to count in the diagonal direction                                     
%                                      while j==0
%                                         d= d+1;
%                                         pixel_diag =  overlayed_images(a+d,b+d,s);
%                                         diag_count = diag_count+1 ;
%                                         fprintf("a=%d\nb=%d\npixel=%d\npixel_right=%d\n\n\n\n", a,b, pixel, pixel_diag);                    
%                                         if pixel_diag == 0
%                                             j = 1;
%                                             diag_length_slice = diag_count;
%                                         end
%                                     end 
%                                        diag_count = 0;
%                                end 
%                                
%                     end
%                 end              	
%         end
%     end   
%     length_horizontal(s) = horiz_length_slice;
%     length_diagonal(s) = diag_length_slice;   
%     check =  1;
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Section #: uses previously found middle of bloodvessel (pixel point) to determine 
% %using the middle point, you go up and over then use pythagorean theorem to
% %find a length.


