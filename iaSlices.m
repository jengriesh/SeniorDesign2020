function [SLICE_NUMBER] = iaSlices(bwmask)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
num_ia_slices = 0;
for i = 1:136
    % number of non-zeros in the slice
    nnz__mask = nnz(bwmask);
    %if there are no non-zero pixels then there is no aneurysm
    if nnz__mask ~= 0
      % How many slices have aneurysm
      num_ia_slices = num_ia_slices +1;
      % array that keeps track of what slices the aneurysm is in 
      SLICE_NUMBER(num_ia_slices) = i; 
    end
end
end

