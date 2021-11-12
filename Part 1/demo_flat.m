%% Computer Graphics Assignment Part 1
% This demo script uses the flat method in order to paint the triangles of the racoon.

% clear workspace
clear;

fprintf('\nDemo Flat Method starts here!!!\n');

% load the information about racoon
try
    load('racoon_hw1.mat');
    fprintf('Data have been loaded\n');
catch
    fprintf('The data have not been loaded! Error!!!\n\n');
end

% Calculate the time while calling the render function for flat
% painting(renderer = 0)
tic 
fprintf('Racoon is painted with the flat method. Time counting starts from here.\nAverage time is approximately 5 - 15 sec');
racoon_img = render(vertices_2d, faces, vertex_colors, depth, 0);
%Show and save the image
imshow(racoon_img);
imwrite(racoon_img,'Flat_racoon.jpg');
fprintf('Time counting stops here\n');
toc

fprintf('Demo Flat Method has been finished\n');
