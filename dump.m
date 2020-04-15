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
%% Main Metrics Code -- Single View 
% Closes all windows and clears all variables
close all
clear all
clc

%loads the image
imfile = ('Dicom.nii.gz');
%loads the mask
maskfile = ('Mask.nii.gz');

%Creates the brain matrix
imbrain = niftiread(imfile);
%Creates the mask matrix
immask = niftiread(maskfile);

%Initalize variable to count # of slices that dont have aneurysms 
%Probably not necessary 
non_ia_slices = 0;
%Initalizs variable that counts slices with the aneurysms in it
num_ia_slices = 0;


%Pass in the mask 
%Output array that tells what slices the aneurysm is in

%binary_mask is a 3D 1s and 0s mask 
% binary_mask = mask2bin(immask);
% Go through all images in mask 
for i = 1:136
 %makes the image double so that it can be 
mask_slice = -double(immask(:,:, i));  
brain(:,:,i) = double(imbrain(:,:,i)); %makes the brain a double instead of int16
 %find dimesions of mask_slice
 [m, n] = size(mask_slice);
 % go through each pixel turn into zero by one binary image
 for l = 1:m
    for j = 1:n
        if mask_slice(l,j) ==  32768 %Check other images for correct thresh
            binary_mask_i(l,j) = 0;
        else
           binary_mask_i(l,j) = 1;
        end 
    end
    
 end
% ia_slices = iaSlices(binary_mask);
    % number of non-zeros in the slice
    nnz__mask = nnz(binary_mask_i);
    %if there are no non-zero pixels then there is no aneurysm
    if nnz__mask == 0
      % EXIT PROGRAM WITH NO ANUERYSM ERROR
      non_ia_slices =  non_ia_slices +1;
    else
      % How many slices have aneurysm
      num_ia_slices = num_ia_slices +1;
      % array that keeps track ofs what slices the aneurysm is in 
      SLICE_NUMBER(num_ia_slices) = i; 
    end
    binary_mask(:,:,i) = binary_mask_i;
    
end 
% Pass in the array of slices that contain the aneurysms
slices = length(SLICE_NUMBER)+11;
SLICE_NUMBER_MIN = min(SLICE_NUMBER)- 6;
%the code below allows the aneurysm slices to be extracted and put into one
%mXnXi 3D image
slice = 0; %code debugger
post_size_x= 0; %allows the size of an array to increase
count = 0; %code debugger to count how many aneurysm pixels in one slice
number_of_total_aneurysm_pixels = 1; %ocunts total number of pixels that exist
for i=1:slices
    ia_slice = SLICE_NUMBER_MIN+i;%chooses one slice in our 3D set is analyzed and extracts i
    binary_mask_with_aneurysm(:,:,i) = binary_mask(:,:,ia_slice); %saves all the slices of the mask with the aneurysm in i
    brain_with_aneurysm(:,:,i) = brain(:,:,ia_slice);
    [x,y]= find(binary_mask_with_aneurysm(:,:,i));
    
        if x >= 1   
            size_x = length(x);
            size_y = length(y);   
                for a = 1:size_x
                    for b = 1:size_y
                        x_0 = x(b,1);
                        y_0 = y(b,1);
                        pixel_value(number_of_total_aneurysm_pixels) = brain_with_aneurysm(x_0,y_0,i);
                        count = count+1;
                        locations_x(number_of_total_aneurysm_pixels) = x_0;
                        locations_y(number_of_total_aneurysm_pixels) = y_0;
                        number_of_total_aneurysm_pixels = number_of_total_aneurysm_pixels+1;
                    end
                end
                slice = 1+slice;
                a_slice_number_aneurysm(slice) = i;
                anerusym_pixels_per_slice(slice) =  count;
            count = 0;
        end
    count =0;
    l = l+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%for loop to make all of the slices binary that are before, when there is
%and after the aneurysm
for i = 1:slices
    for a = 1:512   %make universal by taking the size of the image eventually 
        for b = 1:512
            if brain_with_aneurysm(a,b,i) > min(pixel_value) %COULD POSSIBLY BE MI_MASK %smallest pixel in the aneurysm
                brain_with_aneurysm_binary(a,b,i) = 1;
            else
                brain_with_aneurysm_binary(a,b,i) = 0;
            end 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
        end
    end
    
end

%% Main Metrics Code -- Single View  version 2/10/2020
%doesn't work becuase there was a misunderstanding of the number of pixels
%that made up each aneurysm
% Closes all windows and clears all variables
close all
clear all
clc

%loads the image
imfile = ('Dicom.nii.gz');
%loads the mask
maskfile = ('Mask.nii.gz');

%Creates the brain matrix
imbrain = niftiread(imfile);
%Creates the mask matrix
immask = niftiread(maskfile);

%Initalize variable to count # of slices that dont have aneurysms 
%Probably not necessary 
non_ia_slices = 0;
%Initalizs variable that counts slices with the aneurysms in it
num_ia_slices = 0;


%Pass in the mask 
%Output array that tells what slices the aneurysm is in

%binary_mask is a 3D 1s and 0s mask 
% binary_mask = mask2bin(immask);
% Go through all images in mask 
for i = 1:136
 %makes the image double so that it can be 
mask_slice = -double(immask(:,:, i));  
brain(:,:,i) = double(imbrain(:,:,i)); %makes the brain a double instead of int16
 %find dimesions of mask_slice
 [m, n] = size(mask_slice);
 % go through each pixel turn into zero by one binary image
 for l = 1:m
    for j = 1:n
        if mask_slice(l,j) ==  32768 %Check other images for correct thresh
            binary_mask_i(l,j) = 0;
        else
           binary_mask_i(l,j) = 1;
        end 
    end
    
 end
% ia_slices = iaSlices(binary_mask);
    % number of non-zeros in the slice
    nnz__mask = nnz(binary_mask_i);
    %if there are no non-zero pixels then there is no aneurysm
    if nnz__mask == 0
      % EXIT PROGRAM WITH NO ANUERYSM ERROR
      non_ia_slices =  non_ia_slices +1;
    else
      % How many slices have aneurysm
      num_ia_slices = num_ia_slices +1;
      % array that keeps track ofs what slices the aneurysm is in 
      SLICE_NUMBER(num_ia_slices) = i; 
    end
    binary_mask(:,:,i) = binary_mask_i;
    
end 
% Pass in the array of slices that contain the aneurysms
slices = length(SLICE_NUMBER)+11;
SLICE_NUMBER_MIN = min(SLICE_NUMBER)- 6;
%the code below allows the aneurysm slices to be extracted and put into one
%mXnXi 3D image
post_size_x= 0; %allows the size of an array to increase
count = 0; %code debugger to count how many aneurysm pixels in one slice
number_of_total_aneurysm_pixels = 1; %ocunts total number of pixels that exist
index = 0;
for i=1:slices
    ia_slice = SLICE_NUMBER_MIN+i;%chooses one slice in our 3D set is analyzed and extracts i
    binary_mask_with_aneurysm(:,:,i) = binary_mask(:,:,ia_slice); %saves all the slices of the mask with the aneurysm in i
    brain_with_aneurysm(:,:,i) = brain(:,:,ia_slice);
    [x,y]= find(binary_mask_with_aneurysm(:,:,i))
    
        if x >= 1   
            size_x = length(x)
            size_y = length(y)   
                for a = 1:size_x
                    for b = 1:size_y
                        x_0 = x(b,1)
                        y_0 = y(b,1)
                        pixel_value(number_of_total_aneurysm_pixels) = brain_with_aneurysm(x_0,y_0,i)
                        count = count+1;
                        locations_x(number_of_total_aneurysm_pixels) = x_0;
                        locations_y(number_of_total_aneurysm_pixels) = y_0;
                        number_of_total_aneurysm_pixels = number_of_total_aneurysm_pixels+1;
                    end
                end
                index = index+1;
                pixel_number_per_slice(index) = count;      
        end

    count =0;
    l = l+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%for loop to make all of the slices binary that are before, when there is
%and after the aneurysm
for i = 1:slices
    for a = 1:512   %make universal by taking the size of the image eventually 
        for b = 1:512
            if brain_with_aneurysm(a,b,i) > min(pixel_value) %COULD POSSIBLY BE MI_MASK %smallest pixel in the aneurysm
                brain_with_aneurysm_binary(a,b,i) = 1;
            else
                brain_with_aneurysm_binary(a,b,i) = 0;
            end 
        end
    end
    
end


% %this next line of code is to extract the connected componenet of the
% location of the 

saved_mask_slice_6 = binary_mask_with_aneurysm(:,:,7);
saved_brain_slice_6 = brain_with_aneurysm(:,:,7);
saved_brain_binary_slice_6 = brain_with_aneurysm_binary(:,:,7);
CC = bwconncomp(saved_brain_slice_6)

% subplot(1,2,1)
% imshow(saved_brain_slice_6,[])
% subplot(1,2,2)
% imshow(saved_brain_binary_slice_6,[])
% 

% % for i = 1:512
% %     for j = 1:512
% %         if 
% %             
% %         end   
% %     end
% % end
% 
% % [x2,y2]= find(binary_mask_with_aneurysm(:,:,7))
% % [x3,y3]= find(binary_mask_with_aneurysm(:,:,8))
% % [x4,y4]= find(binary_mask_with_aneurysm(:,:,9))
% % [x5,y5]= find(binary_mask_with_aneurysm(:,:,10))
% % [x6,y6]= find(binary_mask_with_aneurysm(:,:,11))
% % [x7,y7]= find(binary_mask_with_aneurysm(:,:,12))
% % [x8,y8]= find(binary_mask_with_aneurysm(:,:,13))
% % [x9,y9]= find(binary_mask_with_aneurysm(:,:,14)) 
%% 
% Closes all windows and clears all variables
close all
clear all
clc

%loads the image
imfile = ('Dicom.nii.gz');
%loads the mask
maskfile = ('Mask.nii.gz');


view_nii(imfile);

%% 
clear all
close all
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
clearvars;
% format long g;
% format compact;
% fontSize = 20;
% darkGreen = [0, 0.6, 0];
% Parameterize the equation.
t = linspace(0, 360,1000);
xAmplitude = 1;
yAmplitude = 2.5;
xCenter = 2.5;
yCenter = 5;
xOriginal = xAmplitude * sind(t) + xCenter;
yOriginal = yAmplitude * cosd(t) + yCenter;
% Now plot the rotated ellipse.
% plot(xOriginal, yOriginal, 'b-', 'LineWidth', 2);
% axis equal
% grid on;
% xlabel('X', 'FontSize', fontSize);
% ylabel('Y', 'FontSize', fontSize);
% title('Rotated Ellipses', 'FontSize', fontSize);
% xlim([-3, 8]);
% ylim([-3, 8]);
% Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized','OuterPosition',[0 0 1 1]);
% drawnow;
hold on;
% Now plot more ellipses and multiply it by a rotation matrix.
% https://en.wikipedia.org/wiki/Rotation_matrix
% For each angle, subtract the center, multiply by the rotation matrix and add back in the center.
 rotationAngle = -33;
  transformMatrix = [cosd(rotationAngle), sind(rotationAngle);...
    -sind(rotationAngle), cosd(rotationAngle)];
  xAligned = (xOriginal - xCenter);
  yAligned = (yOriginal - yCenter/2);
  xyAligned = [xAligned; yAligned]';
  xyRotated = xyAligned * transformMatrix;
  xRotated = xyRotated(:, 1) + xCenter;
  yRotated = xyRotated(:, 2) + yCenter/2;
  hold on;
  plot(xRotated, yRotated, 'LineWidth', 2);
 
  
slope = tand(s.Orientation);
x1 = 250;
y1 = slope * x1 
x2 = 260;
y2 = slope * x2 
figure

plot(xRotated, yRotated, 'LineWidth', 2);
hold on
plot([abs(y1) abs(y2)], [(x1) (x2)]);
xlim([160 170])
ylim([255 265])

%%
% % %this section is region props to find a dameter
% %     figure
% %     imshow(just_BV(:,:))
% %     hold on
% %     stats = regionprops('table',just_BV(:,:),'BoundingBox','ConvexArea','ConvexHull')
% %     CH = cat(1,stats.ConvexHull)
% %     convex_hull = CH{1}
% %     plot(convex_hull(:,1), convex_hull(:,2),'LineWidth', 2)
% %     hold off
% % %this section is to trace the boundary of the blood vessel using bwboundares
% %     figure
% %     boundaries_blood_v_bwboundaries = bwboundaries(just_BV(:,:));
% %     imshow(just_BV(:,:))
% %     hold on
% %        b = boundaries_blood_v_bwboundaries{1}
% %        pause = 1
% %        plot(b(:,2),b(:,1),'g','LineWidth',1);
% %     hold off
% %     
% % %this section uses bwtraceboundary
% %     figure
% %     imshow(just_BV(:,:))
% %     hold on
% %     bwtrace_blood_v_boundaries = bwtraceboundary(just_BV(:,:), [257 160], 'E')
% %     plot(bwtrace_blood_v_boundaries(:,2), bwtrace_blood_v_boundaries(:,1),'g', 'LineWidth', 1);
% %     hold off

%%  
% %loads the image and mask
%     imfile = ('Dicom.nii.gz');
%     maskfile = ('Mask.nii.gz');
% %Creates the brain and mask matrix
%     imbrain = niftiread(imfile);
%     immask = niftiread(maskfile);
% %information about files
%     brain_info = niftiinfo('Dicom.nii.gz');
%     mask_info = niftiinfo('Mask.nii.gz');
nii = load_nii('Dicom.nii.gz')
view_nii(nii)
   
   
   
   
   
   