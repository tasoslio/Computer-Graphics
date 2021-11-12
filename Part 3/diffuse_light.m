function I = diffuse_light(P, N, color, mat, lights)
    %% Computer Graphics Assignment Part 3
    %% diffuse_light is a function that computes the diffused lighting of a point P in a PhongMaterial surface
    % VARIABLES
    % I = The 3x1 intensity for rgb with the diffused light added
    % P = the 3x1 coordinates of the point 
    % N = the 3x1 coordinates of the surface's vertical vector 
    % color = the 3x1 rgb values
    % mat = an object of PhongMaterial class
    % lights = an object of PointLight class
    
    % Compute the L vector based on the notes
    L = (lights.pos' - P);
    L = L / norm(L);
    
    % Compute I based on the notes
    fatt = 1;
    I = color + lights.intensity' * fatt * mat.kd * dot(N, L);
end