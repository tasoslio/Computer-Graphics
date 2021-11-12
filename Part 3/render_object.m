function Img = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia)
    %% Computer Graphics Assignment Part 3
    %% render_object is a function that paints the object either with gouraud or phong method
    % VARIABLES
    % Img = the returned image
    % shader = scalar variable in order to choose gouraud or phong method
    % focal = the distance from the camera 
    % eye = the coordinates of camera
    % lookat = the coordinates of the target point 
    % up = the up vector of the camera
    % bg_color = the background color
    % M, N = the dimensions of the image
    % H, W = the dimensions of the camera
    % verts = array 3xNv with the vertices of the triangles
    % vert_colors = array 3xNv with the color for each vertice
    % face_indices = array 3xNt that describes the triangles
    % mat = an object of PhongMaterial class
    % lights = an object of PointLight class
    % Ia = the ambient I
    
    
    % Find the 2D projection and the depth of the image
    [P_2d_before_rasterization, D] = project_cam_ku(focal, eye , lookat , up , verts);
    
    % Rasterize the 2D coordinates based on the pixels of the image
    P_2d_after_rasterization = rasterize(P_2d_before_rasterization, M, N, H, W );
    
    % Find the normals and initialize variables in order to paint the 3D
    % object
    normals = calculate_normals(verts, face_indices);
    face_indices = face_indices';
    vert_colors = vert_colors';
    L = length(D);
    A = length(face_indices);
    d = zeros(L, 1);
    if bg_color == 1
        Y = ones(M, N, 3);
    end
    
    vertsp = zeros(2, 3);
    vertsn = zeros(3, 3);
    vertsc = zeros(3, 3);
    
    % Find the depth
    for k = 1 : A
        dim1 = D(face_indices(1, k));
        dim2 = D(face_indices(2, k));
        dim3 = D(face_indices(3, k));
        final_depth = sum([dim1 dim2 dim3]) / 3;
        d(k) = final_depth;
    end
    
    % Create a table for helping compute the parameters of the painting
    % functions
    table = [d face_indices(1, :)' face_indices(2, :)' face_indices(3, :)'];
    table = sortrows(table, 1);
    
    % Compute vertsp, vertsn, vertsc, bcoords
    for k = A : -1 : 1
        vertsp(:, 1 : 3) = P_2d_after_rasterization(:, table(k, 2 : 4));
        vertsn(:, 1 : 3) = normals(:, table(k, 2 : 4));
        vertsc(:, 1 : 3) = vert_colors(:, table(k, 2 : 4));
        bcoords = (verts(:, table(k, 2)) + verts(:, table(k, 3)) + verts(:, table(k, 4))) / 3;
        
        if shader == 1
            % Paint the object with gouraud method
            Y = shade_gouraud(vertsp, vertsn, vertsc, bcoords, eye, mat, lights, Ia, Y);
            
        elseif shader == 2
            Y = shade_phong(vertsp, vertsn, vertsc, bcoords, eye, mat, lights, Ia, Y);
            
        end
        
    end
   % Return Image
   Img = Y; 

end