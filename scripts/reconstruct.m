%Author : Ashwin de Silva
%Last Updated : 2018 Mar 9

%Recontrusing the 3D object from the 2D images
%===========================================================

clear all;
close all;

cd ..
cd('Projection_Images');
load('frames.mat');

%create a voxel space

w = 100; %arbitray Value
h = 100; %arbitray Value
b = 100; %arbitray Value

vspace = zeros(w,b,h);

theta = abs(angulation(1)); %get starting angle

%obtain the voxel space

frame_index = 1;
for angle = -theta : 2 : theta
    Rx = rotx(-angle); %compute the rotational matrix
    for i = 1 : 100
        for j = 1 : 100
            points = Rx*[i,j,0]';
            points(3) = points(3)+w/2; %give the shift to the z data
            points = ceil(points);
            frame = double(frames(:,:,frame_index));
            vspace(points(1),points(2),points(3)) = frame(i,j);
        end
    end
    frame_index = frame_index + 1;
end



%smoothen the volume

% % % % %vspace = smooth3(vspace,'gaussian',21);

patch(isocaps(vspace,.01),...
   'FaceColor','interp','EdgeColor','none');
p1 = patch(isosurface(vspace,.01),...
   'FaceColor','blue','EdgeColor','none');
vspace = smooth3(vspace,'gaussian',15);
isonormals(vspace,p1);
view(3); 
axis vis3d tight
axis equal
camlight left
colormap('jet');
lighting gouraud

%render the volume

%VoxelPlotter(uint8(vspace));

%save the vspace as a mat file

save('vspace.mat','vspace');


