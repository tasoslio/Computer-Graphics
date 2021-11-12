function Prast = rasterize(P, M, N, H, W)
%% Computer Graphics Assignment Part 2
%% rasterize function depicts the coordinates to integer pixels of the image
%VARIABLES
% Prast = the new returned projection based on the pixels of the image
% P = the projection 2D before the rasterization
% M, N = the dimensions of the image
% H, W = the dimensions in inches of the panel

% Initialize the Prast and the arrays of the normalized x and y
[dim1, dim2] = size(P);
x_normalized = zeros(1, dim2);
y_normalized = zeros(1, dim2);
Prast = zeros(2, dim2);

% Compute the Prast based on the normalized x and y and find the nearest
% pixel with round
for k = 1 : dim2
    x_normalized(1, k) = (P(1, k) + W / 2) / W;
    y_normalized(1, k) = (P(2, k) + H / 2) / H;
    Prast(1, k) = floor((1 - x_normalized(1, k)) * M);
    Prast(2, k) = floor((1 - y_normalized(1, k)) * N);
end

    
end