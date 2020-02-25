function text2spectrogram(instring,outpath,textheight,textlocation,alteraspect,volume,blurparams)
%   IM2SPECTROGRAM(INSTRING, OUTPATH, {HEIGHT}, {LOCATION}, {ALTERASPECT}, {PADBAR}, {VOLUME}, {BLURPARAMS})
%       use inverse short-time Fourier transform to encode a text string as a marquee in audio spectra
%       Output is 44100 Hz 16-bit WAV
%
%   INPICT a string
%   OUTPATH is the path of the output .wav file
%   HEIGHT is the height of the text characters relative to 22kHz (0 to 1)
%   LOCATION is the frequency location of the text centerline (0 to 1)
%   ALTERASPECT is a scaling parameter used to adjust the geometry of the text in the spectrogram.
%       This is necessary since scaling of spectrogram output in various viewers is pretty much arbitrary.
%       Pick something that works with whatever you use to view the audio output.  (default is 1)
%   VOLUME specifies a gain for the output.  Clipping will occur beyond unity. (default is 1)
%   BLURPARAMS optionally specifies alternate parameters for FSPECIAL() with a gaussian kernel
%       Slight blurring helps reduce artifacts on sharp edges. 
%       Specified as a vector of the format [SIZE, SIGMA]
%       default is [3 5], set to [0 0] for no blur
%
% This function relies upon the STFT/ISTFT tools by Hristo Zhivomirov 
% http://www.mathworks.com/matlabcentral/fileexchange/45197-short-time-fourier-transformation--stft--with-matlab-implementation
% and TEXT2IM() by Tobias Kiessling 
% http://www.mathworks.com/matlabcentral/fileexchange/19896-convert-text-to-an-image

if ~exist('blurparams','var')
    blurparams=[3 1]; % radius, amount for gaussian kernel
end

if ~exist('volume','var')
    volume=1;
end

if ~exist('alteraspect','var')
    alteraspect=1;
end

magicnum=660;       
samplefreq=44100;

inpict=uint8(text2im(instring));
inpict=255*(1-inpict);

% convert location to frequency 
textlocation=textlocation*(samplefreq/2);

% keep text within frequency range, dump warning when clamping
toplim=samplefreq*(1-textheight/2)/2;
botlim=samplefreq/2-toplim;
if (textlocation > toplim); 
    textlocation=toplim; 
    disp('supramaximal text center');
end
if (textlocation < botlim); 
    textlocation=botlim; 
    disp('subminimal text center');
end

inaspect=length(inpict(1,:))/length(inpict(:,1));
inpict=imresize(inpict,magicnum*textheight*[1 inaspect]);
botpad=floor(magicnum*((2*textlocation/samplefreq) - textheight/2));
toppad=ceil(magicnum*(1-textheight)-botpad);

inpict=padarray(inpict,[0 10],'both'); % pad ends
inpict=padarray(inpict,[toppad 0],'pre'); % top pad
inpict=padarray(inpict,[botpad 0],'post'); % bottom pad
inaspect=length(inpict(1,:))/length(inpict(:,1)); % recalculate
inpict=imresize(inpict,magicnum*[1 alteraspect*inaspect]);
inpict=flipud(inpict);      % flip image (low-f on bottom)

if (sum(blurparams) > 0);
    h=fspecial('gaussian', blurparams(1)*[1 1], blurparams(2));
    inpict=imfilter(inpict,h);
end

nft=length(inpict(:,1))*2-2;
h=nft; 
[x,~]=istft(inpict,h,nft,samplefreq);

xp=x/(max(abs(x))*1.0001)*volume;
if verLessThan('matlab','8')
	wavwrite(xp, samplefreq, 16, outpath);
else
	audiowrite(outpath, xp, samplefreq, 'bitspersample', 16);
end

return





