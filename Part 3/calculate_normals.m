function normals = calculate_normals(vertices, face_indices)
    %% Computer Graphics Assignment Part 3
    %% calculate_normals is a function that computes the normal vector of the triangles of a 3D object
    % VARIABLES
    % normals = the returned normal vectors
    % vertices = array 3xNv with the vertices of the triangles
    % face_indices = array 3xNt that describes the triangles
    
    % Initialize normals variable
    tri = zeros(3, length(face_indices));
    normals = zeros(3, length(vertices));
    face_indices = face_indices';
    
    for k = 1 : length(face_indices)
        % Compute the 3 edges and find the cross 
        edge1 = vertices(:, face_indices(1, k));
        edge2 = vertices(:, face_indices(2, k));
        edge3 = vertices(:, face_indices(3, k));
        
        n = cross(edge1 - edge2, edge1 - edge3);
 
        tri(:, k) = n;
    end
    for k = 1 : length(vertices)
        % Find the new faces
        new_faces = face_indices(1, :) == k | face_indices(2, :) == k | face_indices(3, :) == k;
        n = sum(tri(:, new_faces), 2);
        normals(:, k) = n ./ norm(n);
    end
end