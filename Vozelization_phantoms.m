%Voxelization of Phantom
% This code voxelizes our phantoms and outputs the correct orientation
% NIFTI file to run through our main code to obtain the metrics.

%% Phantom #1- Straight BV with spherical IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_normal.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 20;  %x length (length of diameter of BV + half of IA diameter)
n = 15;   %y length (BV diameter)
r = 15;  %z length (depth- length of BV)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_normal.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74  %where aneurysm is?
    i = i + 1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_normal.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_normal.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% Phantom #2- Straight BV with ovular IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_Oval.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 19;  %x length (length of BV + half of IA diameter)
n = 15;   %y length (BV diameter)
r = 15;  %z length (depth- length of BV)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_Oval.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74
    i = i +1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_Oval.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_Oval.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% Phantom #3- Splined BV with spherical, smaller IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_Spline.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 19;  %x length (length of BV + half of IA diameter)
n = 15;   %y length (BV diameter)
r = 15;  %z length (depth- length of BV)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_Spline.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74
    i = i +1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_Spline.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_Spline.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% Aneurysm #1- Straight BV with spherical IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_normal.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 10;  %x length
n = 10;   %y length
r = 5;  %z length (about 5.21, rounded to 5)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_normal.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74
    i = i +1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_normal.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_normal.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% Aneurysm #2- Straight BV with ovular IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_Oval.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 8;  %x length
n = 8;   %y length
r = 10;  %z length
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_Oval.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74
    i = i +1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_Oval.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_Oval.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight

%% Aneurysm #3- Splined BV with spherical, smaller IA
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_Spline.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 8;  %x length
n = 8;   %y length
r = 4;  %z length (about 4.17, rounded to 4)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_Spline.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end
%Create zeros to pad in file:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
B = zeros(512,512,136);
i =0;
for s = 60:74
    i = i +1;
B(:,:,s) = padarray(voxel(:,:,i),[251 252], 0, 'both');
end
%     loads the image
    imfile = ('Dicom.nii.gz');
%     loads the mask
    maskfile = ('Mask.nii.gz');
%     Creates the brain matrix
    imbrain = niftiread(imfile);
%     Creates the mask matrix
    immask = niftiread(maskfile);
%     information about files
    brain_info = niftiinfo('Dicom.nii.gz');
    mask_info = niftiinfo('Mask.nii.gz')
    
B = int16(B);
niftiwrite(B, 'Phantom_Spline.nii', mask_info);
phantom_normal_info = niftiinfo('Phantom_Spline.nii')

figure;
imshow3D(voxel)

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight