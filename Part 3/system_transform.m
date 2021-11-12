function dp = system_transform(cp, T)
%% Computer Graphics Assignment Part 2
%% system_transform function calculates the coordinates of a point or a set of points to an other system.
%VARIABLES
% dp = the new returned coordinates of a point or a set of points of the
% new system
% cp = the point or set of points that will have system transform
% T = an object of class transformation_matrix

% Find the dimensions of cp
[dim1, dim2] = size(cp);
% Check the first dimension. Need to be 3.
if dim1 ~= 3
    cp = cp';
    dim2 = dim1;
end
% Make cp valid with homogenous 
cp = [ cp; ones(1, dim2)];
% Calculate the coordinates to the new system with the inverse array of T.T
inv_T = inv(T.T);
dp = inv_T * cp;
end