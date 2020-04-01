close all
clear all
clc
%Plot the original STL mesh:
% figure
[stlcoords] = READ_stl('Phantoom.stl');
% xco = squeeze( stlcoords(:,1,:) )';
% yco = squeeze( stlcoords(:,2,:) )';
% zco = squeeze( stlcoords(:,3,:) )';
% [hpat] = patch(xco,yco,zco,'b');
% axis equal
m = 512;
n = 512;
r = 136;
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantoom.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end

    %loads the image
    imfile = ('Dicom.nii.gz')
    %loads the mask
    maskfile = ('Mask.nii.gz')
    %Creates the brain matrix
    imbrain = niftiread(imfile);
    %Creates the mask matrix
    immask = niftiread(maskfile);
    %information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
voxel = int16(voxel);
niftiwrite(voxel, 'bob.nii', mask_info);
bob_info = niftiinfo('bob.nii')

% figure
% imshow3D(voxel)
% %Show the voxelised result:
% figure;
% subplot(1,3,1);
% imagesc(squeeze(sum(OUTPUTgrid,1)));
% colormap(gray(256));
% xlabel('Z-direction');
% ylabel('Y-direction');
% 
% 
% subplot(1,3,2);
% imagesc(squeeze(sum(OUTPUTgrid,2)));
% colormap(gray(256));
% xlabel('Z-direction');
% ylabel('X-direction');
% 
% 
% subplot(1,3,3);
% imagesc(squeeze(sum(OUTPUTgrid,3)));
% colormap(gray(256));
% xlabel('Y-direction');
% ylabel('X-direction');
