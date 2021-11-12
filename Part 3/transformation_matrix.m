classdef transformation_matrix
%% Computer Graphics Assignment Part 2
%% transformation_matrix is a class with a properties a homogenous array T of affine transform and methods rotate and translate.

   properties
       T 
   end
   
   methods
       % constructor of the transformation_matrix class
       function obj = transformation_matrix(val)
           if nargin == 1
               obj.T = val;
           end
       end
       % This function updates the homogenous array of an affine transformation of
       % rotation with angle theta and vector u based on Rodriguez type
       function obj = rotate(obj, theta, u)
           % Type of Rodrigues
           R11 = (1 - cos(theta)) * (u(1) ^ 2) + cos(theta);
           R12 = (1 - cos(theta)) * u(1) * u(2) - sin(theta) * u(3);
           R13 = (1 - cos(theta)) * u(1) * u(3) + sin(theta) * u(2);
           R21 = (1 - cos(theta)) * u(2) * u(1) + sin(theta) * u(3);
           R22 = (1 - cos(theta)) * (u(2) ^ 2) + cos(theta);
           R23 = (1 - cos(theta)) * u(2) * u(3) - sin(theta) * u(1);
           R31 = (1 - cos(theta)) * u(3) * u(1) - sin(theta) * u(2);
           R32 = (1 - cos(theta)) * u(3) * u(2) + sin(theta) * u(1);
           R33 = (1 - cos(theta)) * (u(3) ^ 2) + cos(theta);
           R = [ R11 R12 R13; R21 R22 R23; R31 R32 R33 ];
           new_T = [ R zeros(3,1); zeros(1,3) 1];
           obj.T = new_T;
       end
       % This function returns the homogenous array of afine transformation
       % with vector t
       function obj = translate(obj,t)
           obj.T(1, 4) = t(1);
           obj.T(2, 4) = t(2);
           obj.T(3, 4) = t(3);
       end
   end
    
end