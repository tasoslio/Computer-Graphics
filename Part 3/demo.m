%% Computer Graphics Assignment Part 3
%% demo.m
% This demo script uses gouraud and phong method to paint the racoon with
% the illumination


% load the file
try
    load('hw3.mat');
    fprintf('Data have been loaded\n');
catch
    fprintf('The data have not been loaded! Error!!!\n\n');
end

%% Gouraud shader
fprintf('\n Gouraud method starts here!!!\n');

shader = 1;

%% Ambient
Ka = ka;
Kd = 0*kd;
Ks = 0*ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nGouraud Ambient starts here!!!');

%% render_object (gouraud)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(1);
imshow(Y);
imwrite(Y, 'gouraud_ambient.jpg');
fprintf('\n Gouraud Ambient completed\n');

%% Difussion 
Ka = 0*ka;
Kd = kd;
Ks = 0*ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nGouraud Diffusion starts here!!!');

%% render_object (gouraud)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(2);
imshow(Y);
imwrite(Y, 'gouraud_diffusion.jpg');
fprintf('\n Gouraud Diffusion completed\n');

%% Specular 
Ka = 0*ka;
Kd = 0*kd;
Ks = ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nGouraud Specular starts here!!!');

%% render_object (gouraud)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(3);
imshow(Y);
imwrite(Y, 'gouraud_specular.jpg');
fprintf('\n Gouraud Specular completed\n');
%% All together 
Ka = ka;
Kd = kd;
Ks = ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nGouraud All starts here!!!');

%% render_object (gouraud)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(4);
imshow(Y);
imwrite(Y, 'gouraud_all.jpg');
fprintf('\n Gouraud All completed\n');

%% Phong shader
fprintf('\n Phong method starts here!!!\n');

shader = 2;

%% Ambient
Ka = ka;
Kd = 0*kd;
Ks = 0*ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nPhong Ambient starts here!!!');

%% render_object (phong)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(5);
imshow(Y);
imwrite(Y, 'phong_ambient.jpg');
fprintf('\n Phong Ambient completed\n');

%% Difussion 
Ka = 0*ka;
Kd = kd;
Ks = 0*ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nPhong Diffusion starts here!!!');

%% render_object (phong)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(6);
imshow(Y);
imwrite(Y, 'phong_diffusion.jpg');
fprintf('\n Phong Diffusion completed\n');

%% Specular 
Ka = 0*ka;
Kd = 0*kd;
Ks = ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nPhong Specular starts here!!!');
%% render_object (phong)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(7);
imshow(Y);
imwrite(Y, 'phong_specular.jpg');
fprintf('\n Phong Specular completed\n');

%% All together 
Ka = ka;
Kd = kd;
Ks = ks;

mat = PhongMaterial(Ka, Kd, Ks, n_phong);
lights = PointLight(point_light_pos', point_light_intensity);
fprintf('\nPhong All starts here!!!');

%% render_object (phong)
Y = render_object(shader, focal, eye, lookat, up, bg_color, M, N, H, W, verts, vert_colors, face_indices, mat, lights, Ia);
figure(8);
imshow(Y);
imwrite(Y, 'phong_all.jpg');
fprintf('\n Phong All completed\n');
