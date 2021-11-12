%% Computer Graphics Assignment Part 2
%% demo.m
% This demo script uses all the functions of the assignment 2 in order to
% present the pipeline of afine transforms, projection from 3d to 2d,
% rasterize to pixels of the image and finally paint the object.

% Clear the workspace 
clc
clear

%% Load data %%
fprintf('\nDemo of Assignment 2 starts here!\n');
try
    load('hw2.mat');
    fprintf('Data have been loaded\n');
catch
    fprintf('The data have not been loaded! Error!!!\n\n');
end

%% Step 0 -Initial position 
% 0.1 Render object with render_object
fprintf('\nRender the initial image\n');
I0 = render_object(V, F, C, M, N, H, W, w, cv, ck, cu);

% Save result
imwrite(I0, '0.jpg');
fprintf('\nInitial Image has been saved as 0.jpg\n');

%% Step 0.5 - Create a transformation matrix
Lh = transformation_matrix(eye(4));

%% Step 1 - Translate the transformation matrix by t1

% 1.1 Apply translation
fprintf('\nApply translation to object with t1');
Lh = Lh.translate(t1);
p1 = affine_transform(V, Lh);

% 1.2 Render object with render_object
fprintf('\nRender the second image with translation by t1');
I1 = render_object(p1, F, C, M, N, H, W, w, cv, ck, cu);

% Save result
imwrite(I1, '1.jpg');
fprintf('\nSecond Image has been saved as 1.jpg\n');

%% Step 2 - Rotate the transformation matrix by theta around given axis
% 2.1 Apply rotation
fprintf('\nApply rotation to object with theta and axis vector g');
Lh = transformation_matrix(eye(4));
Lh = Lh.rotate(theta, g);
p2 = affine_transform(p1, Lh);

% 2.2 Render object with render_object
fprintf('\nRender the third image with rotation by theta and axis vector g');
I2 = render_object(p2, F, C, M, N, H, W, w, cv, ck, cu);

% Save result
imwrite(I2, '2.jpg');
fprintf('\nThird Image has been saved as 2.jpg\n');

%% Step 3 - Translate the transformation matrix back
% 3.1 Apply translation
fprintf('\nApply translation to object with t2');
Lh = transformation_matrix(eye(4));
Lh = Lh.translate(t2);
p3 = affine_transform(p2, Lh);

% 3.2 Render object with render_object
fprintf('\nRender the fourth image with translation by t2');
I3 = render_object(p3, F, C, M, N, H, W, w, cv, ck, cu);

% Save result
imwrite(I3, '3.jpg');
fprintf('\nFourth Image has been saved as 3.jpg\n');
