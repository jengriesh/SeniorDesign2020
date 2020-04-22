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

%Zero padding
B = zeros(512,512,136);
i =0;
%to place the aneurysm you need to know where you want to start the
%aneurysm placement. You start at 60 for the slice number becuase it will
%have the middle of the blood vessel be at about the middle of the totla
%number of slices. 
    %starts at 60 then it goes to 60+r-1 to get the number of slices that
    %comprise the BV
for s = 60:74 %corresponds to value of r, it has to comprise r number of values
    %the width starts at row 246 and goes until 246+m-1 
    for a = 246: 265
        %the height goes from column 248 and goes until 248+n-1
        for b = 248: 262  
        %the voxels don't go by the deimensions that "B" goes. SO you have
        %to adjust the values above. so the slice will always be s-(s-1),
        %a-(a-1) and b-(b-1)
        s1 = s - 59;
        a1 = a - 245;
        b1 = b - 247;
        %B(:,:,s) = padarray(voxel(:,:,i),[246 248], 0, 'both'); %[(up and down padding(based on m)) (left and right padding (based on  n))]
        B(a,b,s) =  voxel(a1,b1,s1) ;   
        end
    end
end

CopyB = B(:,:,60);
Aneurysm = zeros(512,512,136);
for i = 60:74
    for a = 1:512
        for b = 1:512
            if CopyB(a,b) == B(a,b,i)
               Aneurysm(a,b,i) = 0;
            else
               Aneurysm(a,b,i) = 1;
            end 
            
        end
    end
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
niftiwrite(B, 'Phantom_Normal.nii', mask_info);
bob_info = niftiinfo('Phantom_Normal.nii');
Aneurysm = int16(Aneurysm);
niftiwrite(Aneurysm, 'Aneurysm_Normal.nii', mask_info);
a_info = niftiinfo('Aneurysm_Normal.nii');

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

%Zero padding
B = zeros(512,512,136);
i =0;
%to place the aneurysm you need to know where you want to start the
%aneurysm placement. You start at 60 for the slice number becuase it will
%have the middle of the blood vessel be at about the middle of the totla
%number of slices. 
    %starts at 60 then it goes to 60+r-1 to get the number of slices that
    %comprise the BV
for s = 60:74 %corresponds to value of r, it has to comprise r number of values
    %the width starts at row 246 and goes until 246+m-1 
    for a = 246: 264
        %the height goes from column 248 and goes until 248+n-1
        for b = 248: 262  
        %the voxels don't go by the deimensions that "B" goes. SO you have
        %to adjust the values above. so the slice will always be s-(s-1),
        %a-(a-1) and b-(b-1)
        s1 = s - 59;
        a1 = a - 245;
        b1 = b - 247;
        %B(:,:,s) = padarray(voxel(:,:,i),[246 248], 0, 'both'); %[(up and down padding(based on m)) (left and right padding (based on  n))]
        B(a,b,s) =  voxel(a1,b1,s1) ;   
        end
    end
end

CopyB = B(:,:,60);
Aneurysm = zeros(512,512,136);
for i = 60:74
    for a = 1:512
        for b = 1:512
            if CopyB(a,b) == B(a,b,i)
               Aneurysm(a,b,i) = 0;
            else
               Aneurysm(a,b,i) = 1;
            end 
            
        end
    end
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
bob_info = niftiinfo('Phantom_Oval.nii');
Aneurysm = int16(Aneurysm);
niftiwrite(Aneurysm, 'Aneurysm_Oval.nii', mask_info);
a_info = niftiinfo('Aneurysm_Oval.nii');
    
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

%Zero padding
B = zeros(512,512,136);
i =0;
%to place the aneurysm you need to know where you want to start the
%aneurysm placement. You start at 60 for the slice number becuase it will
%have the middle of the blood vessel be at about the middle of the totla
%number of slices. 
    %starts at 60 then it goes to 60+r-1 to get the number of slices that
    %comprise the BV
for s = 60:74 %corresponds to value of r, it has to comprise r number of values
    %the width starts at row 246 and goes until 246+m-1 
    for a = 246: 264
        %the height goes from column 248 and goes until 248+n-1
        for b = 248: 262  
        %the voxels don't go by the deimensions that "B" goes. SO you have
        %to adjust the values above. so the slice will always be s-(s-1),
        %a-(a-1) and b-(b-1)
        s1 = s - 59;
        a1 = a - 245;
        b1 = b - 247;
        %B(:,:,s) = padarray(voxel(:,:,i),[246 248], 0, 'both'); %[(up and down padding(based on m)) (left and right padding (based on  n))]
        B(a,b,s) =  voxel(a1,b1,s1) ;   
        end
    end
end

CopyB = B(:,:,60);
Aneurysm = zeros(512,512,136);
for i = 60:74
    for a = 1:512
        for b = 1:512
            if CopyB(a,b) == B(a,b,i)
               Aneurysm(a,b,i) = 0;
            else
               Aneurysm(a,b,i) = 1;
            end 
            
        end
    end
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
bob_info = niftiinfo('Phantom_Spline.nii');
Aneurysm = int16(Aneurysm);
niftiwrite(Aneurysm, 'Aneurysm_Spline.nii', mask_info);
a_info = niftiinfo('Aneurysm_Spline.nii');


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

%% Phantom #1b- For percent change (larger IA diameter)
close all
clear all
clc
%Plot the original STL mesh:
[stlcoords] = READ_stl('Phantom_1b.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Size of image based on length of phantom
m = 22;  %x length (length of diameter of BV + half of IA diameter) (originally 22.5)
n = 15;   %y length (BV diameter)
r = 15;  %z length (depth- length of BV)
%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(m,n,r,'Phantom_1b.stl','xyz');
for s = 1: r
    for a = 1:m
        for b =1:n
           value = double(OUTPUTgrid(a,b,s));
           voxel(a,b,s) = value;
       end
    end
end

%Zero padding
B = zeros(512,512,136);
i =0;
%to place the aneurysm you need to know where you want to start the
%aneurysm placement. You start at 60 for the slice number becuase it will
%have the middle of the blood vessel be at about the middle of the totla
%number of slices. 
    %starts at 60 then it goes to 60+r-1 to get the number of slices that
    %comprise the BV
for s = 60:74 %corresponds to value of r, it has to comprise r number of values
    %the width starts at row 246 and goes until 246+m-1 
    for a = 246: 267
        %the height goes from column 248 and goes until 248+n-1
        for b = 248: 262  
        %the voxels don't go by the deimensions that "B" goes. SO you have
        %to adjust the values above. so the slice will always be s-(s-1),
        %a-(a-1) and b-(b-1)
        s1 = s - 59;
        a1 = a - 245;
        b1 = b - 247;
        %B(:,:,s) = padarray(voxel(:,:,i),[246 248], 0, 'both'); %[(up and down padding(based on m)) (left and right padding (based on  n))]
        B(a,b,s) =  voxel(a1,b1,s1) ;   
        end
    end
end

CopyB = B(:,:,60);
Aneurysm = zeros(512,512,136);
for i = 60:74
    for a = 1:512
        for b = 1:512
            if CopyB(a,b) == B(a,b,i)
               Aneurysm(a,b,i) = 0;
            else
               Aneurysm(a,b,i) = 1;
            end 
            
        end
    end
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
niftiwrite(B, 'Phantom_1b.nii', mask_info);
bob_info = niftiinfo('Phantom_Normal.nii');
Aneurysm = int16(Aneurysm);
niftiwrite(Aneurysm, 'Aneurysm_1b.nii', mask_info);
a_info = niftiinfo('Aneurysm_1b.nii');


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

