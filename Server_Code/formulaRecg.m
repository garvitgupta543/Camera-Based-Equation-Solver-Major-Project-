% This function is the hook-up of all the process of the image
% and get the computation result
% This line is used when applied on an Android phone
% function  formulaRecg(input_img_path ,output_img_path)
% This line is used when applied in Matlan
function  formulaRecg(InputImg)

% Entrance of the application
%-----------------------------------------------------------------------------
% processing function for formula recognition
%------------------------------------------------------------------------------
% INPUT:
% input_img_path 	- input image path
% output_img_path 	- output image path
%--------------------------------------------------------------------------
% This line should be uncommented if applied on a phone
%InputImg1 = imread('test.png');
% preprocess the image
preprocess(InputImg);