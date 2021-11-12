function value = vector_interp(p1, p2, a, V1, V2, dim)
%% Computer Graphics Assignment Part 1
%% vector_interp returns the value of linear interpolation of V1, V2

%%VARIABLES
% p1, p2: 2 peaks of a triangle in 2D coordinates
% a: the spot where the linear interpolation be applied
% V1, V2: 3D values of the two peaks
% dim: the direction where the interpolation be applied.
% dim: 1 for horizontal, 2 for vertical


%Calculate the differences
diff_p1_p2 = (p2(dim) - p1(dim));
diff_a_p1 = (a(dim) - p1(dim));

if p1(dim) ~= p2(dim)
  
    %Return color
    value = V1 + (V2 - V1)*diff_a_p1/diff_p1_p2;
else 
    
    %Return color
    value = (V1 + V2) / 2;

    
end