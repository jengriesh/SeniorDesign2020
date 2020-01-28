clear all
close all
clc
immask = niftiread('Mask.nii.gz');
imbrain = niftiread('Dicom.nii.gz');

imfile = ('Dicom.nii.gz');
maskfile = ('Mask.nii.gz');

impic = niftiread(imfile);
immask = niftiread(maskfile);

pearl = nii2png(imfile);