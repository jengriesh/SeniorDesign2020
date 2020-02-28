clear all
close all
clc

brain = niftiread('Dicom.nii.gz');
mask = niftiread('Mask.nii.gz');
mask = double(mask);
% Convert mask to binary bw photos 
M = 512;
N = 512;
for k = 100:136
    A = mask(:,:,k);
    for i = 1:M
        for j = 1:N
            if A(i,j) == -32768
                A(i, j) = 0;
            else
                A(i, j) = 1;
            end
        end
    end
    mask(:,:,k) = A;
    
    I = mask(: ,:, k);
    rb = 255*uint8(I);
    g = 255 * zeros(size(I), 'uint8');
    rgbimage = cat(3, rb, g, rb);
    colormask(:,:,k) = rgbimage(:,:,3);
%   imshow(colormask(:,:,49));
    brain1 = brain(:,:,k);
    mask1 = mask(:,:,k);
    tea= (imfuse(mask1, brain1));
    overlay(:,:,:,k) = tea;
    imwrite(tea,sprintf('OVERLAY/overlaybrain%d.png', k));
    
    te = 0;
end


% imshow(overlay(:,:,:,45), [])
%%
for k = 100:136
      
    figure;
    imshow(overlay(:,:,:,k));
    colormap(jet);
    saveas(gcf,sprintf('ColoredBrain1/colorbrain%d.png', k));
    
end

%%
% 
% for i = 1:9
%     im = imread(sprintf('brain1/brain1_slice00%d.png', i));
%     figure;
%     imshow(im);
%     colormap(jet);
%     saveas(gcf,sprintf('ColoredBrain1/colorbrain00%d.png', i));
% end
% 
% X = imread('brain1_slice001.png');
% 
% % X is your image
% [M,N] = size(X);
% % Assign A as zero
% A = zeros(M,N);
% % Iterate through X, to assign A
% for i=1:M
%    for j=1:N
%       if(X(i,j) >=48)   % Assuming uint8, 255 would be white
%          A(i,j) = 1;      % Assign 1 to transparent color(white)
%       end
%    end
% end

% im = imread('brain1_slice001.png');
% figure;
% imshow(im);
% colormap(jet);
% saveas(gcf,'colorbrain001.png');
% 
%%
% Resizing the Images 
for k = 10:99
    colorim = imread(sprintf('Mask_BrainOverlay/colorbrain0%d.png', k));
    
    zero_array = zeros([1024 1024]);
    
    sizeim = zero_array + colorim; 
    
    imwrite(sizeim,sprintf('ColoredSizedIm/colorbrain0%d.png', k) );

end

%%
for k = 1:9
img = imread(sprintf('ColoredSizedIm/colorbrain00%d.png', k));

imshow(img);
export_fig(sprintf('VISimages/VISim00%d.png', k),'-transparent')

end

%%
for k = 1:9
    colorim = imread(sprintf('Mask_BrainOverlay/colorbrain00%d.png', k));
    
    grayim = rgb2gray(colorim);
    mserRegions = detectMSERFeatures(grayim);
    mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));
    
    mserMask = false(size(grayim));
    ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
    mserMask(ind) = true;
    f=figure();imshow(mserMask,'Border','tight');
    maskedimage = immultiply(colorim, repmat(mserMask, [1, 1, size(colorim, 3)]));
    imshow(maskedimage,'Border','tight');
    
    imwrite(maskedimage, sprintf('VISimages/brain1_slice00%d.png', k), 'Transparency', [0 0 0]);

%     % X is your image
%     [M,N] = size(X);
%     % Assign A as zero
%     A = zeros(M,N);
%     % Iterate through X, to assign A
%     for i=1:M
%        for j=1:N
%           if(X(i,j) >=48)   % Assuming uint8, 255 would be white
%              A(i,j) = 1;      % Assign 1 to transparent color(white)
%           end
%        end
%     end
%    imwrite(X,sprintf('VISimages/brain1_slice00%d.png', k),'Alpha',A);
end


%% 

for k = 1:9
% img = imread(sprintf('ColoredSizedIm/colorbrain00%d.png', k));

im = CropAndResize(sprintf('Mask_BrainOverlay/colorbrain00%d.png', k),'T',1024);
imwrite(im,sprintf('ColoredSizedIm/colorbrain00%d.png', k) );
im1 = CropAndResize(sprintf('Mask_BrainOverlay/colorbrain00%d.png', k),'L',1024);
imwrite(im1,sprintf('ColoredSizedIm/colorbrain00%d.png', k) );

end

%% 

for k = 100:136
img = imread(sprintf('Mask_BrainOverlay/colorbrain%d.png', k));

im = imcrop(img, [0 0 1024 1024]);
imwrite(im,sprintf('ColoredSizedIm/colorbrain%d.png', k));

end

%% 

for k = 136
img = imread(sprintf('OVERLAY/overlaybrain%d.png', k));

[M N] = size(img);
for i = 1: M
    for j = 1: N
        if img(i, j) < 53
            img(i, j) = 0;
        end
        
    end
end

im = padarray(img, [256 256]);

imwrite(im,sprintf('ColoredSizedIm/colorbrain%d.png', k), 'Transparency', [0 0 0]);

end

%%
imwrite(maskedimage, 'YourFileName.png', 'Transparency', [0 0 0]);



