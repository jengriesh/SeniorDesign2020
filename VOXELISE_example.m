clear all
close all
clc

%Plot the original STL mesh:
% figure
[stlcoords] = READ_stl('Phantom_Oval.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal
m = 19;
n = 15;
r = 15; 
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
%to create zeros to pad:
%slice 68 --> middle of r : 8
%pixel 256 --> middle of m: 5
%pixel 256 --> middle of n : 4
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

%extracts the aneurysm using information about the blood vessel
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


%loads things
maskfile = ('Mask.nii.gz')
%Creates the matrices
immask = niftiread(maskfile);
%information about mask
mask_info = niftiinfo('Mask.nii.gz');

%saves images into files (change the names of files as needed)
B = int16(B);
niftiwrite(B, 'Phantom_Oval.nii', mask_info);
bob_info = niftiinfo('Phantom_Oval.nii');

Aneurysm = int16(Aneurysm);
niftiwrite(Aneurysm, 'Aneurysm_Oval.nii', mask_info);
a_info = niftiinfo('Aneurysm_Oval.nii');


figure
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