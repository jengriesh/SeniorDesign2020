clear all;
close all;
clc;
impic = niftiread('Dicom.nii.gz');
immask = niftiread('Mask.nii.gz');
info = niftiinfo('Dicom.nii.gz');
A = immask(:,:,85);
% Convert Images to binary bw photos 
[M, N] = size(A);
for k = 1:136
    A = immask(:,:,k);
    for i = 1:M
        for j = 1:N
            if A(i,j) == -32768
                A(i, j) = 0;
            else
                A(i, j) = 1;
                x = i;
                y = j;
            end
        end
    end
    bwimmask(: ,:, k) = A;
      
    % COLOR TO MASK 
    I = bwimmask(: ,:, k);
    rb = 255*uint8(I);
    g = 255 * zeros(size(I), 'uint8');
    rgbimage = cat(3, rb, g, rb);
    colormask(:,:,k) = rgbimage(:,:,3);
%     overlay(:,:,k) = imfuse(impic(:,:,k), colormask(:,:,k), 'blend');
    
    %SUPERIMPOSE THE IMAGES 
    %combinedim(:,:,k) = imadd(impic(:,:,k),rgbimage);
%     combinedim(:,:,k) = imadd(impic(:,:,k),bwimmask(:,:,k));
end
one = rgbimage(:,:,1);
two = rgbimage(:,:,2);
three = rgbimage(:,:,3);

% COLOR IMAGES 
I = bwimmask(: ,:, 85);
rb = 255*uint8(I);
g = 255 * zeros(size(I), 'uint8');
rgbimage = cat(3, rb, g, rb);
% imadd = impic(:,:,50) + rgbimage;
% overlay = imfuse(impic, rgbimage, 'blend');
% figure;
% imshow(overlay);






