% BLEND MODE DEMOS

%% color blend modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; %clc
bg=imread('sources/table.jpg');

s=size(bg);
hx=0:360/s(2):(360-360/s(2));
hy=0:180/s(1):(180-180/s(1));
[Hx Hy]=meshgrid(hx,hy);
S=ones(size(Hx))*0.8;
Y=ones(size(Hx))*0.5;
fg1=hsy2rgb(cat(3,mod(Hx+Hy,360),S,Y),'pastel');
%fg1=lingrad(s,[0 0; 1 0],[1 1 0; 1 0 0]*255);

fg2=flipdim(fg1,1);
mask=eoline(true(s(1:2)),2,[20 40]);
fg=replacepixels(fg1,fg2,mask);
%huemask=lingrad(s,[0 0; 0 1],[0 0 0; 1 1 1]*255);
%fg=imblend(huemask,fg,1,'permute y>h',0.5);

A=imblend(fg,bg,1,'color');
B=imblend(fg,bg,1,'color lchab');
C=imblend(fg,bg,1,'color lchsr');
D=imblend(fg,bg,1,'color hsyp');
E=imblend(fg,bg,1,'color hsl');

Y0=double(mono(bg,'y'));
L0=double(mono(bg,'llch'));
a=uint8((abs(Y0-double(mono(A,'y')))+abs(L0-double(mono(A,'llch'))))/2);
b=uint8((abs(Y0-double(mono(B,'y')))+abs(L0-double(mono(B,'llch'))))/2);
c=uint8((abs(Y0-double(mono(C,'y')))+abs(L0-double(mono(C,'llch'))))/2);
d=uint8((abs(Y0-double(mono(D,'y')))+abs(L0-double(mono(D,'llch'))))/2);
e=uint8((abs(Y0-double(mono(D,'y')))+abs(L0-double(mono(D,'llch'))))/2);

limits=stretchlim(cat(1,a,b,c,d,e));
error1=repmat(imadjust(cat(1,a,b,c,d,e),limits),[1 1 3]);
color1=cat(1,A,B,C,D,E);
group1=cat(2,color1,error1);

imshow(255-group1)
imwrite(fg,'examples/imblendex6.jpg','jpeg','Quality',90);
imwrite(group1,'examples/imblendex7.jpg','jpeg','Quality',90);

sa=sum(sum(a))
sb=sum(sum(b))
sc=sum(sum(c))
sd=sum(sum(d))
se=sum(sum(e))

%% contrast & light modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
bg=imread('sources/table.jpg');
bg=imresize(bg,0.5);

s=size(bg);
fg1=lingrad(s,[0 0; 1 1],[1 0 0; 1 1 0; 0 1 0; 0 1 1; 0 0 1; 1 0 1; 1 0 0]*255);
sgrad=lingrad(s,[0 0; 0.8 0],[0 0 0; 1 1 1]*255);
vgrad=lingrad(s,[1 0; 0.2 0],[0 0 0; 1 1 1]*255);
fg1=imblend(sgrad,fg1,1,'transfer v_hsv>s_hsv');
fg=imblend(vgrad,fg1,1,'transfer v_hsv>v_hsv');

A=imblend(fg,bg,1,'softlight');
B=imblend(fg,bg,1,'overlay');
C=imblend(fg,bg,1,'phoenix');
D=imblend(fg,bg,1,'posterize');

E=imblend(fg,bg,1,'hardlight');
F=imblend(fg,bg,1,'vividlight');
G=imblend(fg,bg,1,'pinlight');
H=imblend(fg,bg,1,'hardmix');

L=cat(1,A,B,C,D);
R=cat(1,E,F,G,H);
group=cat(2,L,R);


imshow(255-group)

%% contrast modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
bg=imread('sources/table.jpg');

s=size(bg);
fg1=lingrad(s,[0 0; 1 1],([0 0 0; 1 1 1]+2)*255/4);
fg2=flipdim(fg1,1);
mask=eoline(true(s(1:2)),2,[20 40]);
fg=replacepixels(fg1,fg2,mask);

A=imblend(fg,bg,1,'scale add');
B=imblend(fg,bg,1,'scale mult');
C=imblend(fg,bg,1,'contrast');

group=cat(1,A,B,C);

imshow(255-group)
%imwrite(fg,'examples/imblendex10.jpg','jpeg','Quality',90);
%imwrite(group,'examples/imblendex11.jpg','jpeg','Quality',90);

%% hue & saturation modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
bg=imread('sources/table.jpg');

s=size(bg);
fg1=lingrad(s,[0 0; 1 1],[1 0 0; 1 1 0; 0 1 0; 0 1 1; 0 0 1; 1 0 1; 1 0 0]*255);
sgrad=lingrad(s,[0 0; 1 0],[0 0 0; 1 1 1]*255);
vgrad=lingrad(s,[1 0; 0 0],[0 0 0; 1 1 1]*255);
fg1=imblend(sgrad,fg1,1,'transfer v_hsv>s_hsv');
fg1=imblend(vgrad,fg1,1,'transfer v_hsv>v_hsv');
fg2=flipdim(fg1,1);
mask=eoline(true(s(1:2)),2,[20 40]);
fg=replacepixels(fg1,fg2,mask);

A=imblend(fg,bg,1,'transfer hhsv>hhsv');
B=imblend(fg,bg,1,'transfer hhsi>hhsi');
C=imblend(fg,bg,1,'transfer hlch>hlch');
D=imblend(fg,bg,1,'transfer hhusl>hhusl');

E=imblend(fg,bg,1,'transfer shsv>shsv');
F=imblend(fg,bg,1,'transfer shsi>shsi');
G=imblend(fg,bg,1,'transfer clch>clch');
H=imblend(fg,bg,1,'transfer shusl>shusl');

group1=cat(1,cat(2,A,B),cat(2,C,D));
group2=cat(1,cat(2,E,F),cat(2,G,H));

imshow(255-group1)
imwrite(fg,'examples/imblendex12.jpg','jpeg','Quality',90);
imwrite(group1,'examples/imblendex13.jpg','jpeg','Quality',90);
imwrite(group2,'examples/imblendex14.jpg','jpeg','Quality',90);

%% lighten & darken modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
bg=imread('sources/table.jpg');

s=size(bg);
fg1=lingrad(s,[0 0; 1 1],[1 0 0; 1 1 0; 0 1 0; 0 1 1; 0 0 1; 1 0 1; 1 0 0]*255);
sgrad=lingrad(s,[0 0; 1 0],[0 0 0; 1 1 1]*255);
vgrad=lingrad(s,[1 0; 0 0],[0 0 0; 1 1 1]*255);
fg1=imblend(sgrad,fg1,1,'transfer v_hsv>s_hsv');
fg=imblend(vgrad,fg1,1,'transfer v_hsv>v_hsv');

A=imblend(fg,bg,1,'lighten rgb');
B=imblend(fg,bg,1,'lighten y');
C=imblend(fg,bg,1,'darken rgb');
D=imblend(fg,bg,1,'darken y');

group=cat(1,cat(2,A,B),cat(2,C,D));

imshow(255-group)
imwrite(fg,'examples/imblendex15.jpg','jpeg','Quality',90);
%imwrite(group,'examples/imblendex16.jpg','jpeg','Quality',90);

%% dodge & burn modes demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
bg=imread('sources/table.jpg');
bg=imresize(bg,0.5);

s=size(bg);
fg1=lingrad(s,[0 0; 1 1],[0 0 0; 1 1 1]*255,'ease');
sgrad=lingrad(s,[0 0; 1 0],[0 0 0; 1 1 1]*255);
vgrad=lingrad(s,[1 0; 0 0],[0 0 0; 1 1 1]*255);
fg1=imblend(sgrad,fg1,1,'transfer v_hsv>s_hsv');
fg=imblend(vgrad,fg1,1,'transfer v_hsv>v_hsv');

A=imblend(fg,bg,1,'colordodge');
B=imblend(fg,bg,1,'lineardodge');
C=imblend(fg,bg,1,'softdodge');
D=imblend(fg,bg,1,'colorburn');
E=imblend(fg,bg,1,'linearburn');
F=imblend(fg,bg,1,'softburn');

group=cat(2,cat(1,A,B,C),cat(1,D,E,F));

imshow(255-group)

%% compositing demo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc
[fg,~,fga]=imread('sources/bluebars.png');
[bg,~,bga]=imread('sources/redbars.png');
fg=cat(3,fg,fga);
bg=cat(3,bg,bga);

svgmult=imblend(fg,bg,1,'multiply','svg');
gimpmult=imblend(fg,bg,1,'multiply','gimp');

group=cat(1,svgmult,gimpmult);

imshow(255-group(:,:,1:3))
imwrite(group(:,:,1:3),'examples/imblendex17.png','alpha',group(:,:,4));











