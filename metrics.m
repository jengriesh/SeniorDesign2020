function [MajorAxis, MinorAxis, Orientation, xRotated, yRotated, Center] = metrics(Image)

%code below allows the ellipse to be created *this was taken from a MATLAB forum so the    
stats = regionprops(Image,'Orientation','Centroid','MajorAxisLength', 'MinorAxisLength', 'Centroid')
%metrics fed back to the original 
Center = stats.Centroid;
Orientation = stats.Orientation;
MajorAxis = stats.MajorAxisLength;
MinorAxis = stats.MinorAxisLength;

if Orientation >= -30 
    xAmplitude = MajorAxis/2;
    yAmplitude = MinorAxis/2;
else 
    xAmplitude = MinorAxis/2;
    yAmplitude = MajorAxis/2;
end 
    
xCenter = Center(1,1);
yCenter = Center(1,2);
t = linspace(0, 360,1000);
xOriginal = xAmplitude * sind(t) + xCenter;
yOriginal = yAmplitude * cosd(t) + yCenter;
rotationAngle = Orientation;
transformMatrix = [cosd(rotationAngle), sind(rotationAngle);-sind(rotationAngle), cosd(rotationAngle)];
xAligned = (xOriginal - xCenter);
yAligned = (yOriginal - yCenter);
xyAligned = [xAligned; yAligned]';
xyRotated = xyAligned * transformMatrix;
xRotated = xyRotated(:, 1) + xCenter;
yRotated = xyRotated(:, 2) + yCenter;

end 