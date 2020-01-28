function brain_matrix = extractbloodvessel(image_picture, image_mask)


no_aneurysm_slices = 0;
ANEURYSM = 0;
% THIS WILL GET YOU THE NUMBER OF SLICES WITH AN ANEURYSM AND EXTRACT THAT
% NUMBER 
for i= 1:136%extract the next image in the stack
 faloola = -double(image_mask(:,:, i));
 [m, n] = size(faloola);
 for l = 1:m
    for o = 1:n
        if faloola(l,o) ==  32768
            faloola_mask(l,o) = 0;
        else
           faloola_mask(l,o) = 1;
        end 
    end
 end
nnz_faloola_mask = nnz(faloola_mask);
if nnz_faloola_mask == 0
  no_aneurysm_slices =  no_aneurysm_slices +1;
else
  ANEURYSM = ANEURYSM +1;
  SLICE_NUMBER(ANEURYSM) = i; 
end
end 
alto = 47;%chooses which image in our 3D set is analyzed and extracts it
mask = -double(image_mask(:,:,alto));
brain = double(image_picture(:,:,alto));
[m, n ] = size(brain);
min_mask = min(mask(:,:));%takes the minimum value in the matrix of the mask and uses it for nothing right now
brain = 32768+brain;%normalizes the brain image to get smaller pixel values
for i = 1:m
    for j = 1:n
        if mask(i,j) ==  32768
            mask(i,j) = 0;
        else
           mask(i,j) = 1;
        end 
    end
end
%searches for where the nonzeros are and records their location in the
%values x and y
[y x] = find(mask);
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
        if brain(i,j) > 13000 %smallest pixel in the aneurysm
            brain(i,j) = 1;
        else
           brain(i,j) = 0;
        end 
    end
end
%needs to auto populate the for statements with the location of the
%aneurysm
for i = 256:261
    for j = 160:169
        if brain(i,j) ~= 0
           brain_matrix(i,j) = 1;
        else
        end
 
    end
end


end
