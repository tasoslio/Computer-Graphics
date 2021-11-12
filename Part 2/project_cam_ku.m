function [P, D] = project_cam_ku(w, cv , clookat , cup , p)
%% Computer Graphics Assignment Part 2
%% project_cam_ku function finds and returns the perspective projections and the depth of the points based the up vector and the point lookat
%VARIABLES
% P = the perspective projections of the points
% D = the new depth of the points
% w = the distance of the center
% cv = the coordinates of the camera
% clookat = the coordinates where camera lookat
% cup = the coordinates of the up vector
% p = the coordinates of the point we want

% Find the cx, cy, cz of for the project_cam based on the cv, clookat, cup
zc = (clookat - cv) / norm(clookat - cv);
t = cup - dot(cup, zc) * zc;
yc = t / norm(t);
xc = cross(yc, zc);

% Return the P, D
[P,D] = project_cam(w, cv , xc , yc, zc, p);


end