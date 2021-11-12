%% Computer Graphics Assignment Part 1
%% demo_gouraud.m
% This demo script uses the gouraud method in order to paint the triangles of the racoon.

% clear workspace
clear;

fprintf('\nDemo Gouraud Method starts here!!!\n');

% load the information about racoon
try
    load('racoon_hw1.mat');
    fprintf('Data have been loaded\n');
catch
    fprintf('The data have not been loaded! Error!!!\n\n');
end

% Calculate the time while calling the render function for gouraud
% painting(renderer = 1)
tic 
fprintf('Racoon is painted with the gouraud method. Time counting starts from here.\nAverage time is 20 - 45 sec');
racoon_img = render(vertices_2d, faces, vertex_colors, depth, 1);
% Show and save the image
imshow(racoon_img);
imwrite(racoon_img, 'Gouraud_racoon.jpg');
fprintf('Time counting stops here\n');
toc

fprintf('Demo Gouraud Method has been finished\n');