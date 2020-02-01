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

%Function to extract the blood vessel
% blood_vessel = extractbloodvessel(impic, immask);

%Initalize variable to count # of slices that dont have aneurysms 
%Probably not necessary 
non_ia_slices = 0;
%Initalizs variable that counts slices with the aneurysms in it
num_ia_slices = 0;


%Pass in the mask 
%Output array that tells what slices the aneurysm is in 

% Go through all images in mask 
for i = 1:136
 %pulling out one slice of the mask
 %Why is it -double
 mask_slice = -double(immask(:,:, i));  
 %find dimesions of mask_slice
 [m, n] = size(mask_slice);
 % go through each pixel turn into zero by one binary image
 for l = 1:m
    for j = 1:n
        if mask_slice(l,j) ==  32768 %Check other images for correct thresh
            binary_mask(l,j) = 0;
        else
           binary_mask(l,j) = 1;
        end 
    end
 end
    % number of non-zeros in the slice
    nnz_faloola_mask = nnz(binary_mask);
    %if there are no non-zero pixels then there is no aneurysm
    if nnz_faloola_mask == 0
      % EXIT PROGRAM WITH NO ANUERYSM ERROR
      non_ia_slices =  non_ia_slices +1;
    else
      % How many slices have aneurysm
      num_ia_slices = num_ia_slices +1;
      % array that keeps track of what slices the aneurysm is in 
      SLICE_NUMBER(num_ia_slices) = i; 
    end
end 

% Pass in the array of slices that contain the aneurysms

slices = size(SLICE_NUMBER);
for i=0:slices
    ia_slice = i;%chooses one slice in our 3D set is analyzed and extracts it
    mask = -double(immask(:,:,ia_slice));
    brain = double(imbrain(:,:,ia_slice));
    [m, n ] = size(brain);
    min_mask = min(mask(:,:));%takes the minimum value in the matrix of the mask and uses it for nothing right now
    %MATTOGRAY easier to 
    brain = 32768+brain;%normalizes the brain image to get smaller pixel values
    % Makes the mask black and white again?????? Because it isnt saved
    % earlier
    for k = 1:m
        for j = 1:n
            if mask(k,j) ==  32768
                mask(k,j) = 0;
            else
               mask(k,j) = 1;
            end 
        end
    end
end
%searches for where the nonzeros are and records their location in the
%values x and y
[y x z] = find(mask);
%nnz_mask counts the number of non zero pixels
nnz_mask= nnz(mask);
sizey = size(y,1);
sizex = size(x,1);
%search the brain image itself for the location of the aneurysm, extract a
%larger area and determine the smallest pixel size to use for the threshold
%of the new brain binarized image
%creates the binarized image
for i = 1:m
    for j = 1:n
        if brain(i,j) > 13000 %COULD POSSIBLY BE MI_MASK %smallest pixel in the aneurysm
            brain(i,j) = 1;
        else
           brain(i,j) = 0;
        end 
    end
end
%needs to auto populate the for statements with the location of the
%aneurysm

%from the location of the mask which is stored x and y 
for i = 256:261
    for j = 160:169
        if brain(i,j) ~= 0
           brain_matrix(i,j) = 1;
        else
        end
 
    end
end