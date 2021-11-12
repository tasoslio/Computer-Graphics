function Img = render(vertices_2d, faces, vertex_colors, depth, renderer)
%% Computer Graphics Assignment Part 1
%% render is called to paint the triangles of the object either with
%the flat method or the gouraud method based on their depth

%%VARIABLES
% Img: The already existing image MxNx3
% verices_2d: Array Lx2 that contains 2d coordinates of L vertices
% faces: Kx3 array that contains the vertices of the triangles
% vertex_colors: Array Lx3 that contains the RGB values of the vertices
% depth: Array Lx1 that contains the depth of each vertex before the 2d
% projection
% renderer: Scalar check variable to decide with which method the object
% will be painted. 0 for Flat, 1 for Gouraud.

% The size of image
M_value = 1200;
N_value = 1200;

%The empty image(all the pixels white)
Img = ones(M_value,N_value,3);

% Find the mean deapth in order to sort the depths of triangles
tri_depth = zeros(length(faces), 1);
for k = 1 : length(faces)
    tri_depth(k) = (sum(depth(faces(k, :)))) / length(faces);
end

[~, index] = sort(tri_depth, 'descend');
faces = faces(index, :);


%Paint the triangles with flat or gouraud method based on renderer

if renderer == 0
   for k = 1 : length(tri_depth)
       Img = paint_triangle_flat(Img, vertices_2d(faces(k, :), :), vertex_colors(faces(k, :), :));
   end
elseif renderer == 1
   for k = 1 : length(tri_depth)
       Img = paint_triangle_gouraud(Img, vertices_2d(faces(k, :), :), vertex_colors(faces(k, :), :));
   end
else
   disp(renderer);
   fprintf('Wrong code renderer. Please Select 0 for Flat 1 for Gouraud');
end


end