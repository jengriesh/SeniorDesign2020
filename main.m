%% Main Metrics Code -- Single View 
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
slices = length(SLICE_NUMBER)+11;
SLICE_NUMBER_MIN = min(SLICE_NUMBER)- 6;
%the code below allows the aneurysm slices to be extracted and put into one
%mXnXi 3D image
post_size_x= 0; %allows the size of an array to increase
count = 0; %code debugger to count how many aneurysm pixels in one slice
number_of_total_aneurysm_pixels = 1; %ocunts total number of pixels that exist
index = 0;
for i=1:slices
    ia_slice = SLICE_NUMBER_MIN+i;%chooses one slice in our 3D set is analyzed and extracts i
    binary_mask_with_aneurysm(:,:,i) = binary_mask(:,:,ia_slice); %saves all the slices of the mask with the aneurysm in i
    brain_with_aneurysm(:,:,i) = brain(:,:,ia_slice);
    [x,y]= find(binary_mask_with_aneurysm(:,:,i))
    
        if x >= 1   
            size_x = length(x)
            size_y = length(y)   
                for a = 1:size_x
                    for b = 1:size_y
                        x_0 = x(b,1)
                        y_0 = y(b,1)
                        pixel_value(number_of_total_aneurysm_pixels) = brain_with_aneurysm(x_0,y_0,i)
                        count = count+1;
                        locations_x(number_of_total_aneurysm_pixels) = x_0;
                        locations_y(number_of_total_aneurysm_pixels) = y_0;
                        number_of_total_aneurysm_pixels = number_of_total_aneurysm_pixels+1;
                    end
                end
                index = index+1;
                pixel_number_per_slice(index) = count;      
        end

    count =0;
    l = l+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%for loop to make all of the slices binary that are before, when there is
%and after the aneurysm
for i = 1:slices
    for a = 1:512   %make universal by taking the size of the image eventually 
        for b = 1:512
            if brain_with_aneurysm(a,b,i) > min(pixel_value) %COULD POSSIBLY BE MI_MASK %smallest pixel in the aneurysm
                brain_with_aneurysm_binary(a,b,i) = 1;
            else
                brain_with_aneurysm_binary(a,b,i) = 0;
            end 
        end
    end
    
end


% %this next line of code is to extract the connected componenet of the
% location of the 

saved_mask_slice_6 = binary_mask_with_aneurysm(:,:,7);
saved_brain_slice_6 = brain_with_aneurysm(:,:,7);
saved_brain_binary_slice_6 = brain_with_aneurysm_binary(:,:,7);
CC = bwconncomp(saved_brain_slice_6)

% subplot(1,2,1)
% imshow(saved_brain_slice_6,[])
% subplot(1,2,2)
% imshow(saved_brain_binary_slice_6,[])
% 

% % for i = 1:512
% %     for j = 1:512
% %         if 
% %             
% %         end   
% %     end
% % end
% 
% % [x2,y2]= find(binary_mask_with_aneurysm(:,:,7))
% % [x3,y3]= find(binary_mask_with_aneurysm(:,:,8))
% % [x4,y4]= find(binary_mask_with_aneurysm(:,:,9))
% % [x5,y5]= find(binary_mask_with_aneurysm(:,:,10))
% % [x6,y6]= find(binary_mask_with_aneurysm(:,:,11))
% % [x7,y7]= find(binary_mask_with_aneurysm(:,:,12))
% % [x8,y8]= find(binary_mask_with_aneurysm(:,:,13))
% % [x9,y9]= find(binary_mask_with_aneurysm(:,:,14)) 
