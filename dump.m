%% 1/28/2020 Connected componenets
% Step #: search the brain imag e for the pixel location of the aneurysm, find the
% lowest value of all of the aneurysm for that point,
% Step #: Threshold per that lowest value of the aneurysm
% Step #: use "dilation" method to extract all the components connected to
% the  pixel locations of the aneurysm
% Step #: 
% X = brain;
% labels = zeros(size(X)); %matrix of zeros the size of Binary Rice Image
% nonzeros=find(X == 1);% finds nonzero components of binary image
% count = 0; %to count the number of rice
% SE = ones(3);
% brain_matrix = zeros(m,n);
% while(~isempty(nonzeros))
%     count = count+1; %determines the number of rice per iteration
%     logic = zeros(size(X));%creates a matrix of zeros to fill with the unique integer position, after each iteration of the loop, logic values chagne based on where the loop is in its count
%     nonzeros = nonzeros(1); %each iteration of the loop, the nonzero will be a different number based on where the loop is in counting the  
%     logic(nonzeros) = 1; %the first set of 1's found in the matrix will be filled into the all zero matrix
% 
%     dilate = X&imdilate(logic, SE);%the single rice count in question is dilated with the structuring element
%    %if the rice piece is not equal to the dilation of the logical image, 
%    %then all of the zero components of the logic matrix will cover all of the rice pieces
%    %This loop will continue to fill the logic vector until the entire rice
%    %piece is accounted for
%     while(~isequal(logic, dilate)) 
%         logic = dilate;
%         dilate = X&imdilate(logic, SE);%dilates the image at each point that is in the rice
%     end
%     
%     Position = find(dilate == 1); %this will place the position of the currently counted rice into a position vector
%     X(Position) = 0; %replaces the position of the original binary image with 0 to avoid counting this rice piece again
%     labels(Position) = count; %the postiion of this rice piece is placed in the matrix created before this while loop size of the original image and filled with zeros
%     nonzeros=find(X==1); %the new matrix is created without the previous rice count
%     
% end
% s = regionprops(labels, 'centroid'); 
% 
% hold on %allows a number to be displayed on the each rice pieces centroid.
% for a = 1: numel(s)%k is the rice count that is extracted from the centroid array that analyzed the centroid of each counted rice piece
%     c = s(a).Centroid; %takes the value of the position of the centroid for each rice piece and allows a position to be obtained
%     text(c(1),c(2),sprintf('%d',a), 'HorizontalAlignment','center', 'VerticalAlignment','middle');%places the number of rice at the centroid of the rice piece
% end
% 
% hold off


%% 1/28/2020 trying to write nii to png file

close all
clear all
clc
%loads the file in 
imfile = ('Dicom.nii.gz');
maskfile = ('Mask.nii.gz');
%reads the file
impic = niftiread(imfile);
immask = niftiread(maskfile);
alto = 1;
n =1;
while n == 1
%chooses which image in our 3D set is analyzed and extracts it
% mask = -double(immask(:,:,alto));
brain = mat2gray(double(impic(:,:,alto)));
number = sprintf('mask1_slice%03d.png', alto)

imwrite(brain, number)
if alto == 2
    n = 2;
else 
    alto = alto+1;
end 

end



















