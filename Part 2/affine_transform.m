function cq = affine_transform(cp, T)
%% Computer Graphics Assignment Part 2
%% affine transform function accomplises point affine transform and returns the new coordinates of a point or a set of points.
%VARIABLES
% cq = the new returned coordinates of a point or a set of points
% cp = the point or set of points that will have affine transform
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
cq =  T.T * cp; 
cq = cq(1:3, :);
end