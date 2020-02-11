%% Main Metrics Code -- Single View (updated 2/10/2020)
% Closes all windows and clears all variables
close all
clear all
clc
%loads the image
imfile = ('Dicom.nii.gz');
%loads the mask
maskfile = ('Mask.nii.gz');
    %Creates the brain matrix
    imbrain = niftiread(imfile);
    %Creates the mask matrix
    immask = niftiread(maskfile);
%Initalize variable to count # of slices that dont have aneurysms 
%Probably not necessary 
non_ia_slices = 0;
%Initalizs variable that counts slices with the aneurysms in it
num_ia_slices = 0;
%Pass in the mask 
%Output array that tells what slices the aneurysm is in
%binary_mask is a 3D 1s and 0s mask 
% binary_mask = mask2bin(immask);
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
%for loop to make all of the slices binary that are before, when there is
%and after the aneurysm. where below h is equal to the mode of the
%pixel_values with the anuerysm.
threshold = mode(pixel_value);
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
%         while  val == 0 
%             number = number + 1;
%             val = label(mode_x+number, mode_y+number);
%         end 
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
%       merry = merry+1 
end
%the below for loop overlays the aneurysm mask and the blood vessel and
%turns it into grayscale so it can all be saved as one mxnxi matrix
for s = 1: slices
    mask  = binary_mask_with_aneurysm(:,:,s);
    blood_V = blood_vessel(:,:,s);
    over_layed = imfuse(mask, blood_V);
    overlayed_images(:,:,s) = rgb2gray(over_layed);
    bob = overlayed_images(:,:,s);
time = 1; %code debugger
end
bobbie = blood_vessel(:,:,4).*brain_with_aneurysm(:,:,4);
% save(overlay.png, overlayed_images);
%the overall output of this code is the grayscale images that are overlayed
%with the bloodvessel and the aneurysm