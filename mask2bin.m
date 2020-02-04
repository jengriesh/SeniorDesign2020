function [bwmask] = mask2bin(mask)
%MASK2BIN Summary of this function goes here
%   input: the mask that is not in 1s and 0s 
%   output: the binary mask in 1s and 0s
bwmask = zeros(512,512,136);

for i = 1:136
 %pulling out one slice of the mask
 %Why is it -double
 mask_slice = -double(mask(:,:, i));  
 %find dimesions of mask_slice
 [m, n] = size(mask_slice);
 % go through each pixel turn into zero by one binary image
 for l = 1:m
    for j = 1:n
        if mask_slice(l,j) ==  32768 %Check other images for correct thresh
            bw_mask(l,j) = 0;
        else
           bw_mask(l,j) = 1;
        end 
    end
 end
 bwmask(:,:,i) = bw_mask;

end

