function IM = CropAndResize(filename, pos, resolution)
%CROPANDRESIZE Crops padding and resizes the image. 
%   IM = CropAndResize(FILENAME, POS, RESOLUTION), crops all padding on the
%        sides (top/right/bottom/left) of FILENAME and sets the image size
%        with regards to RESOLUTION. Using this function will overwrite
%        FILENAME.
%
%   - FILENAME       The name of your image file (including path).
%     (char)
%
%   - POS            The position of the padding specified by a single
%     (char)         character: T (top), B(bottom), R (right) or L (left).
%                    If the padding is on multiple sides of the image,
%                    please provide only 1 of the characters above.
%
%   - RESOLUTION     The resolution of the output image if you are looking
%     (double)       for a specific output resolution.
%
%   Examples
%   --------
%       % Crop image
%       IM = CropAndResize('test-image.jpg','T');
%       imshow(IM);
%
%       % Crop and resize image to X-by-1080 pixels
%       IM = CropAndResize('test-image.jpg','T',1080);
%       imshow(IM);
%   --------
%   
%   Created by:               Yves Terzibasiyan
%   Last modified:            14 Oct. '18
%   With the help of:         Mathworks forum members
%                             - Image Analyst
%                             - Walter Roberson

    if(nargin < 2)
        error('Please provide the position argument: T/B/L/R');
    end

    %read image
    I = imread(filename);
    [ih,iw,d] = size(I);
    
    %check FILENAME
    if d == 3
        rI = I(:,:,1);
        gI = I(:,:,2);
        bI = I(:,:,3);
    end
    
    %check POS
    switch pos
        case 'T' %top middle pixel value
            if d == 3
                vR = rI(1,round(iw/2));
                vG = gI(1,round(iw/2));
                vB = bI(1,round(iw/2));
            else
                vGRAY = I(1,round(iw/2));
            end
        case 'B' %bottom middle pixel value
            if d == 3
                vR = rI(ih,round(iw/2));
                vG = gI(ih,round(iw/2));
                vB = bI(ih,round(iw/2));
            else
                vGRAY = I(ih,round(iw/2));
            end
        case 'L' %left middle pixel value
            if d == 3
                vR = rI(round(ih/2),1);
                vG = gI(round(ih/2),1);
                vB = bI(round(ih/2),1);
            else
                vGRAY = I(round(ih/2),1);
            end
        case 'R' %right middle pixel value
            if d == 3
                vR = rI(round(ih/2),iw);
                vG = gI(round(ih/2),iw);
                vB = bI(round(ih/2),iw);
            else
                vGRAY = I(round(ih/2),iw);
            end
        otherwise
            error('The POS argument is invalid. Please specify where your padding is by give one of the following input arguments for POS: T (top), B (bottom), L (left), R (right). If the padding is on more than 1 side, just choose any of earlier given options.');
    end
    
    if d == 3 %RGB
        disp('Image = RGB.');
        disp(['Padding color found: (' num2str(vR) ',' num2str(vG) ',' num2str(vB) ').']);
       
        %define red/green/blue channels    
        rI = I(:,:,1);
        gI = I(:,:,2);
        bI = I(:,:,3);
    
        %create mask
        mask = ~((rI == vR) & (gI == vG) & (bI == vB));
        %mask rows/columns
        [maskRows, maskColumns] = find(mask);
        
        %rows
        r1 = min(maskRows);r2 = max(maskRows);
        %columns
        c1 = min(maskColumns);c2 = max(maskColumns);
    
        %return image
        IM = I(r1:r2, c1:c2, :);
    else %GRAY
        disp('Image = GRAYSCALE.');
        disp(['Padding color found: (' num2str(vGRAY) ').']);
        W = all(I == vGRAY, 3);
        
        %mask row/columns
        maskc = ~all(W, 1);
        maskr = ~all(W, 2);
        
        %return image
        IM = I(maskr, maskc);
    end
    
    isaninteger = @(x)isfinite(x) & x==floor(x);
    if (exist('resolution','var') == 0)
        disp('You have chosen to save your image without resizing.');
        imwrite(IM,filename);
    elseif (exist('resolution','var') == 1 && isaninteger(resolution) == 1)
        [h, w, ~] = size(IM);
        disp(['You have chosen to save your image with a resolution of ' num2str(round((resolution/h)*w)) '-by-' num2str(resolution) ' pixels.']); 
        imwrite(imresize(IM,resolution/h),filename);
    else
        error('The optional input argument is non-integer value. Please provider an integer value e.g. 1080.');
    end
end