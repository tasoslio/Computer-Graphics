function Y = paint_triangle_flat(img, vertices_2d, vertex_colors)
%% Computer Graphics Assignment Part 1
%% paint_triangle flat applies a color to triangle based on the average of 
% the colors of the triangle's vertices

%VARIABLES
% img: the already existing image with its triangles
% vertices_2d: Integer array 3x2 that contains the coordinates of
% triangle's vertices in each line.
% vertex_colors: Array 3x3 that contains the color of triangle's
% vertex in each line with RGB values[0,1]
% Y: Array MxNx3 that contains the RGB values for all the parts of the
% triangle and the already existing triangles


%Initialize the variables x_k_min,x_k_max,y_k_min,y_k_max for filling algorithm
x_k_min = [0,0,0];
x_k_max = [0,0,0];
y_k_min = [0,0,0];
y_k_max = [0,0,0];

%Find the x_k_min,x_k_max,y_k_min,y_k_max for every edge
for k = 1 : 3 
    if k == 3
        x_k_min(k) = min(vertices_2d(k,1), vertices_2d(k-2,1));
        x_k_max(k) = max(vertices_2d(k,1), vertices_2d(k-2,1));
        y_k_min(k) = min(vertices_2d(k,2), vertices_2d(k-2,2));
        y_k_max(k) = max(vertices_2d(k,2), vertices_2d(k-2,2));
      
    else 
        x_k_min(k) = min(vertices_2d(k,1), vertices_2d(k+1,1));
        x_k_max(k) = max(vertices_2d(k,1), vertices_2d(k+1,1));
        y_k_min(k) = min(vertices_2d(k,2), vertices_2d(k+1,2));
        y_k_max(k) = max(vertices_2d(k,2), vertices_2d(k+1,2));
    
    end

end  

%The smallest ymin and the biggest ymax
y_min = min(y_k_min(:));
y_max = max(y_k_max(:));

% Check if there is horizontal line on top or bottom
hor_line_top = 0;
hor_line_bottom = 0;

if y_k_min(1) == y_k_min(2) &&  y_k_min(2) == y_k_min(3)
    hor_line_bottom = 1;
end

if y_k_max(1) == y_k_max(2) && y_k_max(2) == y_k_max(3)
    hor_line_top = 1;
end


active_edges = [0; 0];

% The gradient for every edge
gradient1 = (vertices_2d(2,2) - vertices_2d(1,2)) / (vertices_2d(2,1) - vertices_2d(1,1));
gradient2 = (vertices_2d(3,2) - vertices_2d(2,2)) / (vertices_2d(3,1) - vertices_2d(2,1));
gradient3 = (vertices_2d(1,2) - vertices_2d(3,2)) / (vertices_2d(1,1) - vertices_2d(3,1));



% Create a struct for every edge with the coordinates of 2 vertices and its
% gradient
edge(1) = struct('x1',vertices_2d(1,1),'y1',vertices_2d(1,2),'x2',vertices_2d(2,1),'y2',vertices_2d(2,2),'grad',gradient1);
edge(2) = struct('x1',vertices_2d(2,1),'y1',vertices_2d(2,2),'x2',vertices_2d(3,1),'y2',vertices_2d(3,2),'grad',gradient2);
edge(3) = struct('x1',vertices_2d(3,1),'y1',vertices_2d(3,2),'x2',vertices_2d(1,1),'y2',vertices_2d(1,2),'grad',gradient3); 


% Create a struct for active points that contains the coordinates and the
% gradients of vertices
active_points = struct('x1',0,'y1',0,'x2',0,'y2',0,'grad1',0,'grad2',0);


% Find active points
q = 1;

for k = 1 : 3
    if edge(k).y1 == y_min && edge(k).grad ~= 0
        active_points.x1 = edge(k).x1;
        active_points.y1 = edge(k).y1;
        active_points.grad1 = edge(k).grad;
        active_edges(q) = k;
        q = q + 1;
    
    elseif edge(k).y2 == y_min && edge(k).grad ~= 0
        active_points.x2 = edge(k).x2;
        active_points.y2 = edge(k).y2;
        active_points.grad2 = edge(k).grad;
        active_edges(q) = k;
        q = q + 1;
    end
        
end

%Check if vertices belong either to the same line or to the same vertical
%line or to the same horizontal line
hor_same_line = 0;
ver_same_line = 0;
same_line = 0;

if vertices_2d(1,1) == vertices_2d(2,1) && vertices_2d(2,1) == vertices_2d(3,1) 
    ver_same_line = 1;
end

if vertices_2d(1,2) == vertices_2d(2,2) && vertices_2d(2,2) == vertices_2d(3,2) 
    hor_same_line = 1;
end

if edge(1).grad == edge(2).grad && edge(2).grad == edge(3).grad
    if edge(1).grad ~= 0 && edge(2).grad ~= 0 && edge(3).grad ~= 0
        same_line = 1;
    end
end

%Find the average colors based on the colors of the triangle's vertices
red = (vertex_colors(1,1) + vertex_colors(2,1) + vertex_colors(3,1)) / 3;
green = (vertex_colors(1,2) + vertex_colors(2,2) + vertex_colors(3,2)) / 3;
blue = (vertex_colors(1,3) + vertex_colors(2,3) + vertex_colors(3,3)) / 3;

color = [red green blue];

% From here starts Scanline Algorithm

if ver_same_line == 1
    % vertices belong to the vertical same line
        max_y = max(vertices_2d(:,2));
        min_y = min(vertices_2d(:,2));
        for y = min_y : max_y
            img(y, vertices_2d(1,1), :) = color;
        end
    
elseif hor_same_line == 1
    % vertices belong to the horizontal same line
        max_x = max(vertices_2d(:,1));
        min_x = min(vertices_2d(:,1));
        for x = min_x : max_x 
            img(vertices_2d(1,2), x, :) = color;
        end
        
elseif same_line == 1
    % vertices belong to line with same slope
        max_y = max(vertices_2d(:,2));
        [min_y, j] = min(vertices_2d(:,2));
        start_x = vertices_2d(j, 1);
        x = start_x;
        x_mod = start_x;
        for y = min_y : max_y
            img(y, x, :) = color;
            x_mod = x_mod + 1 / edge(1).grad;
            x = round(x_mod);
        end
    
else
    for y = y_min : y_max
        % Sort active points
        if active_points.x2 < active_points.x1
                temp_swap = active_points.x1;
                active_points.x1 = active_points.x2;
                active_points.x2 = temp_swap;
                temp_swap = active_points.y1;
                active_points.y1 = active_points.y2;
                active_points.y2 = temp_swap;
                temp_swap = active_points.grad1;
                active_points.grad1 = active_points.grad2;
                active_points.grad2 = temp_swap;
                
        end
        
        
        counter_for_crosses = 0;
        flag_first_act_point_surpassed = 0;
        
        
        %scanning the canva
        for x = round(active_points.x1)-1 : 1200
            
            %active point found and calculate the crosses
            if x >= active_points.x1 && flag_first_act_point_surpassed == 0
                flag_first_act_point_surpassed = 1;
                counter_for_crosses = counter_for_crosses + 1;
                
            elseif x >= active_points.x2
                counter_for_crosses = counter_for_crosses + 1;
                
            end
            
            %paint the right pixels with rgb
            if mod(counter_for_crosses, 2) == 1
                img(y, x, :) = color;
            end
            
            %escape if second active point surpassed
            if x > active_points.x2
                break;
            end
        end
        
        % Find the active edges
        if y + 1 == max(y_k_min(:)) && hor_line_top ~= 1 && hor_line_bottom ~= 1  
            
            q = 1;
            array = [0;0];
            new_active_edges = [0;0];
            
            
            for k = 1:3
                if isequaln(edge(k).y1, max(y_k_min(:))) || isequaln(edge(k).y2, max(y_k_min(:)))
                    array(q) = k;
                    q = q + 1;
                    
                end
            end
            
            q = 1;
            % frequency of elements 
            freq = histcounts([active_edges; array]);
            
            for k = 1 : length(freq)
                if isequaln(freq(k), 1)
                        new_active_edges(q) = k;
                        q = q + 1;
                end
            end
            
            %find the common edges from old and new active one
            flag = [1;1;1];
            for k = 1 : 3
                if isequaln(edge(k).grad, edge(active_edges(1)).grad) || isequaln(edge(k).grad, edge(active_edges(2)).grad)
                    flag(k) = 0;
                end
            end
            
            % Element with value 2 needs to be replaced
            for k = 1 : 3
                if freq(k) == 2
                    new_array = k;
                end
            end
            
            
            for k = 1 : 3
                if flag(k) ~= 0
                    if edge(k).y1 == max(y_k_min(:))
                        new_y = edge(k).y1;
                        new_x = edge(k).x1;
                    elseif edge(k).y2 == max(y_k_min(:))
                        new_y = edge(k).y2;
                        new_x = edge(k).x2;
                    end
                    
                    grad = edge(k).grad;
                    
                end
                
                if isequaln(k, new_array)
                    prev_grad = edge(k).grad;
                end
            end
            
            if isequaln(active_points.grad1, prev_grad)
                active_points.x1 = new_x;
                active_points.y1 = new_y;
                active_points.grad1 = grad;
                active_points.y2 = active_points.y2 + 1;
                active_points.x2 = active_points.x2 + 1 / active_points.grad2;
                
            elseif isequaln(active_points.grad2, prev_grad)
                
                active_points.x2 = new_x;
                active_points.y2 = new_y;
                active_points.grad2 = grad;
                active_points.y1 = active_points.y1 + 1;
                active_points.x1 = active_points.x1 + 1 / active_points.grad1;
                
            end
        
            active_edges = new_active_edges;
        
        else
            active_points.y1 = active_points.y1 + 1;
            active_points.x1 = active_points.x1 + 1 / active_points.grad1;
            active_points.y2 = active_points.y2 + 1;
            active_points.x2 = active_points.x2 + 1 / active_points.grad2;

        end
        
    end
    
    
end


Y = img;

%end of function paint_triangle_flat
end

