function [P, D] = project_cam(w, cv, cx, cy, cz, p)
%% Computer Graphics Assignment Part 2
%% project_cam function finds and returns the perspective projections and the depth of the points
%VARIABLES
% P = the perspective projections of the points
% D = the new depth of the points
% w = the distance of the center
% cv = the coordinates of the camera
% cx, cy, cz = the coordinates of th
% p = the coordinates of the point we want

% Calculate the dimensions of p
[dim1, dim2] = size(p);
% Check the first dimension. Need to be 3.
if dim1 ~= 3
    p = p';
    dim2 = dim1;
end
% Initialize P,D
P = zeros(2, dim2);
D = zeros(1, dim2);

% Find array of Rodriguez and d
R = [ cx cy cz];
d = cv;
% Create the homogenous array and assign it to transformation_matrix class
L = [ R d ; zeros(1,3) 1];
T = transformation_matrix(L);
% Find the new system coordinates of p with function system_transform
new_system_p = system_transform(p, T);
% Project from 3D to 2D and calculate the depth
for k = 1:dim2
    x = (w * new_system_p(1,k)) / new_system_p(3,k);
    y = (w * new_system_p(2,k)) / new_system_p(3,k);
    P(1,k) = x;
    P(2,k) = y;
    D(k) = new_system_p(3,k);
end

end