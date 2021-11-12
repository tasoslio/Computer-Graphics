classdef PhongMaterial
    %% Computer Graphics Assignment Part 3
    %% PhongMaterial is a class that contains as properties the factors ka, kd, ks and nphong

    properties
        ka 
        kd 
        ks
        nphong
    end
    
    methods
        % constructor of PhongMaterial class
        function obj = PhongMaterial(val1, val2, val3, val4)
           if nargin == 4
               obj.ka = val1;
               obj.kd = val2;
               obj.ks = val3;
               obj.nphong = val4;
           end
       end
    end
end