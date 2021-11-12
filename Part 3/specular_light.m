function I = specular_light(P, N, color, cam_pos, mat, lights)
    %% Computer Graphics Assignment Part 3
    %% diffuse_light is a function that computes the specular lighting of a point P in a PhongMaterial surface
    % VARIABLES
    % I = The 3x1 intensity for rgb with the specular light added
    % P = the 3x1 coordinates of the point 
    % N = the 3x1 coordinates of the surface's vertical vector 
    % cam_pos = the 3x1 coordinates of the observer(camera)
    % color = the 3x1 rgb values
    % mat = an object of PhongMaterial class
    % lights = an object of PointLight class
    
    % Compute L,V vectors and the dot of N, L vectors based on the notes
    L = (lights.pos' - P) / norm((lights.pos' - P));
    V = (cam_pos - P) / norm(cam_pos - P);
    dotNL = dot(N, L);
    
    % Compute I based on the notes
    fatt = 1;
    I = color + lights.intensity' * fatt * mat.ks * (dot((2 * N * dotNL - L), V) ^ mat.nphong);
    
end