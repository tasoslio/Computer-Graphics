function I = render_object(p, F, C, M, N, H, W, w, cv, clookat, cup)
%% Computer Graphics Assignment Part 2
%% render_object calculates the coordinates of the image to paint with functions project_cam_ku, rasterize and paints the object with function render. 
%VARIABLES
% I = the returned painted image
% p = the 3D dimensions of the image 
% F = Array that contains the vertices of the triangles
% C = Array that contains the RGB values of the vertices
% M, N = the dimensions of the image
% H, W = the dimensions in inches of the panel
% w = the distance of the center
% cv = the coordinates of the camera
% clookat = the coordinates where camera lookat
% cup = the coordinates of the up vector

% Find the 2D projection and the depth of the image
[P_2d_before_rasterization, D] = project_cam_ku(w, cv , clookat , cup , p);

% Rasterize the 2D coordinates based on the pixels of the image
P_2d_after_rasterization = rasterize(P_2d_before_rasterization, M, N, H, W );

% Paint the image with renderer = 1 for Gouraud painting
I = render(P_2d_after_rasterization',F,C,D,1);
    
end
