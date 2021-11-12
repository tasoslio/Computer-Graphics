function I = ambient_light(mat, color, Ia)
    %% Computer Graphics Assignment Part 3
    %% ambient_light is a function that computes the lighting of a point P in a PhongMaterial surface
    % VARIABLES
    % I = The 3x1 intensity for rgb that is reflected from the point
    % mat = an object of PhongMaterial class
    % color = the 3x1 rgb values
    % Ia = a 3 x 1 vector that contains the values of the reflection of the
    % environment

    % Compute I based on notes
    I = color + mat.ka * Ia;

end