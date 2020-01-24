clear all
close all
clc
immask = niftiread('Mask.nii.gz');
imbrain = niftiread('Dicom.nii.gz');

