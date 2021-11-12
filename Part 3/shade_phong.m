function Y = shade_phong(vertsp, vertsn, vertsc, bcoords, cam_pos, mat, lights, Ia, X)
    %% Computer Graphics Assignment Part 3
    %% shade_phong is a function that paints with the phong method a triangle
    % VARIABLES
    % Y = the returned image
    % vertsp = array 2x3 with the 2d coordinates for each vertice
    % vertsn = array 3x3 with the normals of the triangle
    % vertsc = array 3x3 with the vertices' colors of the triangle
    % bcoords = array 3x1 with the weigth of the triangle
    % cam_pos = array 3x1 with the coordinates of the camera
    % mat = an object of PhongMaterial class
    % lights = an object of PointLight class
    % Ia = the ambient I
    % X = the initial image
    
    %Initialize the variables x_k_min,x_k_max,y_k_min,y_k_max for filling algorithm
    x_k_min = [0,0,0];
    x_k_max = [0,0,0];
    y_k_min = [0,0,0];
    y_k_max = [0,0,0];
    vertices_2d = vertsp';
    
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
    edge(1) = struct('x1',vertices_2d(1,1),'y1',vertices_2d(1,2),'x2',vertices_2d(2,1),'y2',vertices_2d(2,2),'grad',gradient1, 'normal', vertsn(:,1), 'color', vertsc(:,1));
    edge(2) = struct('x1',vertices_2d(2,1),'y1',vertices_2d(2,2),'x2',vertices_2d(3,1),'y2',vertices_2d(3,2),'grad',gradient2, 'normal', vertsn(:,2), 'color', vertsc(:,2));
    edge(3) = struct('x1',vertices_2d(3,1),'y1',vertices_2d(3,2),'x2',vertices_2d(1,1),'y2',vertices_2d(1,2),'grad',gradient3, 'normal', vertsn(:,3), 'color', vertsc(:,3));


    % Create a struct for active points that contains the coordinates and the
    % gradients of vertices
    active_points = struct('x1',0,'y1',0,'x2',0,'y2',0,'grad1',0,'grad2',0, 'normal1',[0;0;0], 'normal2',[0;0;0], 'color1', [0;0;0], 'color2', [0;0;0]);
    
    % Find active points
    q = 1;

    for k = 1 : 3
        if edge(k).y1 == y_min && edge(k).grad ~= 0
            active_points.x1 = edge(k).x1;
            active_points.y1 = edge(k).y1;
            active_points.grad1 = edge(k).grad;
            active_points.normal1 = edge(k).normal;
            active_points.color1 = edge(k).color;
            active_edges(q) = k;
            q = q + 1;

        elseif edge(k).y2 == y_min && edge(k).grad ~= 0
            active_points.x2 = edge(k).x2;
            active_points.y2 = edge(k).y2;
            active_points.grad2 = edge(k).grad;
            active_points.normal2 = edge(k).normal;
            active_points.color2 = edge(k).color;
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

    % From here starts Scanline Algorithm
    if ver_same_line == 1 
        
        % vertices belong to the vertical same line
        [max_y, max_index] = max(vertices_2d(:,2));
        [min_y, min_index] = min(vertices_2d(:,2));
        
        norm1 = edge(max_index).normal;
        norm2 = edge(min_index).normal;
        
        
        color1 = edge(max_index).color;
        color2 = edge(min_index).color;
        
        
        for y = min_y : max_y
            
            % Interpolation to normals and colors to find the color
            final_normal = norm1 + (norm1 - norm2) * (y - min_y) / (max_y - min_y);
            final_color = color1 + (color1 - color2) * (y - min_y) / (max_y - min_y);
            
            final_normal = final_normal(:);
            final_color = final_color(:);
            
            Iam = ambient_light(mat, final_color, Ia');
            Idif = diffuse_light(bcoords, final_normal, Iam, mat, lights);
            Isp = specular_light(bcoords, final_normal, Idif, cam_pos, mat, lights);

            X(y, vertices_2d(1,1), :) = Isp;

        end
        
        
    elseif hor_same_line == 1
        % vertices belong to the horizontal same line
        [max_x, max_index] = max(vertices_2d(:,1));
        [min_x, min_index] = min(vertices_2d(:,1));
        
        norm1 = edge(max_index).normal;
        norm2 = edge(min_index).normal;
        
        color1 = edge(max_index).color;
        color2 = edge(min_index).color;
        
        for x = min_x : max_x
            % Interpolation to normals and colors to find the color
            final_normal = norm1 + (norm1 - norm2) * (x - min_x) / (max_x - min_x);
            final_color = color1 + (color1 - color2) * (x - min_x) / (max_x - min_x);
            
            final_normal = final_normal(:);
            final_color = final_color(:);
            
            
            Iam = ambient_light(mat, final_color, Ia');
            Idif = diffuse_light(bcoords, final_normal, Iam, mat, lights);
            Isp = specular_light(bcoords, final_normal, Idif, cam_pos, mat, lights);

            X(vertices_2d(1,2), x, :) = Isp;

        end
        
        
        
    elseif same_line == 1
        % vertices belong to lines with same slope
        [max_y, max_index] = max(vertices_2d(:,2));
        [min_y, min_index] = min(vertices_2d(:,2));
        
        
        norm1 = edge(max_index).normal;
        norm2 = edge(min_index).normal;
        
        color1 = edge(max_index).color;
        color2 = edge(min_index).color;
        
        start_x = vertices_2d(min_index, 1);
        x = start_x;
        x_mod = start_x;
        
        
        for y = min_y : max_y

            current_point = [x, y];
            max_vertex = [vertices_2d(max_index, 1), vertices_2d(max_index, 2)];
            min_vertex = [vertices_2d(min_index, 1), vertices_2d(min_index, 2)];
            
            final_normal = norm1 + (norm1 - norm2) * norm(current_point - max_vertex) / norm(min_vertex - max_vertex);
            final_color = color1 + (color1 - color2) * norm(current_point - max_vertex) / norm(min_vertex - max_vertex);

            Iam = ambient_light(mat, final_color, Ia');
            Idif = diffuse_light(bcoords, final_normal, Iam, mat, lights);
            Isp = specular_light(bcoords, final_normal, Idif, cam_pos, mat, lights);
            
            
            X(y, x, :) = Isp;

            x_mod = x_mod + 1 / edge(1).grad;
            x = round(x_mod);

        end
        
        
    else
        %General case
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
                    temp_swap = active_points.normal1;
                    active_points.normal1 = active_points.normal2;
                    active_points.normal2 = temp_swap;
                    temp_swap = active_points.color1;
                    active_points.color1 = active_points.color2;
                    active_points.color2 = temp_swap;

            end

            flag_first_act_point_surpassed = 0;
            
            
            %Scan for first time in order to make linear interpolation with
            %dim = 2 to find A,B 
            for x = round(active_points.x1)-1 : 1200
                if x >= active_points.x1 && flag_first_act_point_surpassed == 0
                    
                    if isequaln(active_points.grad1, edge(1).grad)
                        find_active_edge = 1;
                    end

                    if isequaln(active_points.grad1, edge(2).grad)
                        find_active_edge = 2;
                    end


                    if isequaln(active_points.grad1, edge(3).grad)
                        find_active_edge = 3;
                    end
                    
                    %find colors
                    if find_active_edge == 3
                        norm1 = vertsn(:, find_active_edge);
                        norm2 = vertsn(:,find_active_edge - 2);
                        
                        color1 = vertsc(:, find_active_edge);
                        color2 = vertsc(:, find_active_edge - 2);
                    else
                        
                        norm1 = vertsn(:, find_active_edge);
                        norm2 = vertsn(:,find_active_edge + 1);
                        
                        color1 = vertsc(:, find_active_edge);
                        color2 = vertsc(:, find_active_edge + 1);
                        
                    end
                    
                    %make linear interpolation with dim 2 to find A
                    current_point = [x,y];
                    first_vertex = [edge(find_active_edge).x1, edge(find_active_edge).y1];
                    second_vertex = [edge(find_active_edge).x2, edge(find_active_edge).y2];
                    
                    final_normalA = norm1 + (norm2 - norm1) * norm(current_point - first_vertex) / norm(second_vertex - first_vertex);
                    
                    final_colorA = color1 + (color2 - color1) * norm(current_point - first_vertex) / norm(second_vertex - first_vertex);
                    
                    
                    final_normalA = final_normalA(:);
                    final_colorA = final_colorA(:);
                    
                    Iam = ambient_light(mat, final_colorA, Ia');
                    Idif = diffuse_light(bcoords, final_normalA, Iam, mat, lights);
                    Isp = specular_light(bcoords, final_normalA, Idif, cam_pos, mat, lights);
                    
                    X(y, x, :) = Isp;
                    
                    flag_first_act_point_surpassed = 1;
                    
                elseif abs(x - active_points.x2) < 1
                    if isequaln(active_points.grad2, edge(1).grad) 
                        find_active_edge = 1;
                    end

                    if isequaln(active_points.grad2, edge(2).grad) 
                        find_active_edge = 2;
                    end

                    if isequaln(active_points.grad2, edge(3).grad)
                        find_active_edge = 3;
                    end
                    
                    
                    %find colors
                    if find_active_edge == 3
                        norm1 = vertsn(:, find_active_edge);
                        norm2 = vertsn(:,find_active_edge - 2);
                        
                        color1 = vertsc(:, find_active_edge);
                        color2 = vertsc(:, find_active_edge - 2);
                    else
                        norm1 = vertsn(:, find_active_edge);
                        norm2 = vertsn(:,find_active_edge + 1);
                        
                        color1 = vertsc(:, find_active_edge);
                        color2 = vertsc(:, find_active_edge + 1);
                    end
                    
                    %make linear interpolation with dim 2 to find B
                    current_point = [x,y];
                    first_vertex = [edge(find_active_edge).x1, edge(find_active_edge).y1];
                    second_vertex = [edge(find_active_edge).x2, edge(find_active_edge).y2];
                    final_normalB = norm1 + (norm2 - norm1) * norm(current_point - first_vertex) / norm(second_vertex - first_vertex);
                    final_colorB = color1 + (color2 - color1) * norm(current_point - first_vertex) / norm(second_vertex - first_vertex);
                    
                    final_normalB = final_normalB(:);
                    final_colorB = final_colorB(:);
                    
                    Iam = ambient_light(mat, final_colorB, Ia');
                    Idif = diffuse_light(bcoords, final_normalB, Iam, mat, lights);
                    Isp = specular_light(bcoords, final_normalB, Idif, cam_pos, mat, lights);
                    
                    X(y, x, :) = Isp;
                    
                end
                
                if x > active_points.x2
                    break;
                end
                
                
                
            end
            counter_for_crosses = 0;
            flag_first_act_point_surpassed = 0;

            %Scan for second time in order to make linear interpolation with
            %dim = 1 to find the final colors
            for x = round(active_points.x1)-1 : 1200
                
                if x >= active_points.x1 && flag_first_act_point_surpassed == 0
                    flag_first_act_point_surpassed = 1;
                    counter_for_crosses = counter_for_crosses + 1;
                end

                if x >= active_points.x2
                    counter_for_crosses = counter_for_crosses + 1;

                end
                
                %paint the right pixels with rgb
                if mod(counter_for_crosses, 2) == 1
                    p1 = [active_points.x1, active_points.y1];
                    p2 = [active_points.x2, active_points.y2];
                    final_color = vector_interp(p1, p2, [x,y], final_colorA, final_colorB, 1);
                    final_normal = vector_interp(p1, p2, [x,y], final_normalA, final_normalB, 1);
                    
                    Iam = ambient_light(mat, final_color, Ia');
                    Idif = diffuse_light(bcoords, final_normal, Iam, mat, lights);
                    Isp = specular_light(bcoords, final_normal, Idif, cam_pos, mat, lights);
                    
                    X(y, x, :) = Isp;
                    
                end
                
                
                %escape if second active point surpassed
                if x >= active_points.x2
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
                    if isequaln(freq(k), 2)
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
    
    Y = X;
end