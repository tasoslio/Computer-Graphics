classdef PointLight
    %% Computer Graphics Assignment Part 3
    %% PointLight is a class that contains as properties the point of the light source(pos) and the intensity for rgb.
    properties
       pos 
       intensity
    end

    methods
        % constructor of PointLight class
        function obj = PointLight(val1, val2)
               if nargin == 2
                   obj.pos = val1;
                   obj.intensity = val2;
               end
           end
    end

end