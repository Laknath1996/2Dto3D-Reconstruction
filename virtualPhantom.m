%Author : Ashwin de Silva
%Last Updated : 2018 Mar 9

%Creation of Virtual spherical Phantom and Obtaining its 2D Projections
%=========================================================================

clear all;
close all;

%get the params from the user

prompt = {'Enter Xus (cm):','Enter Yus (cm):','Enter sx (cm):'...
    'Enter sy (cm):','Enter FOV (Degrees):'...
    'Enter Angle per Frame (Degrees):','Enter R (cm):','Enter Yp (cm):'};
dlg_title = 'Input User Parameters';
num_lines = 1;
def = {'10','10','0.1','0.1','120','2','2','6'}; %default values
answer = inputdlg(prompt,dlg_title,num_lines,def);
Xus = str2double(answer(1));Yus = str2double(answer(2));
sx = str2double(answer(3));sy = str2double(answer(4));
FOV = str2double(answer(5));APF = str2double(answer(6));
R = str2double(answer(7));Yp = str2double(answer(8));

%define figures

h = figure;
image_index = 1;

%make folder 

mkdir('Projection_Images');
cd('Projection_Images');

%define frame stack
frames = zeros(Xus/sx,Yus/sy,[]);
angulation = [];
for angle = -FOV/2 : APF : FOV/2
    %generate the parametric array 
    t = linspace(0,2*pi,1000);
    
    %convert the angle to radians
    alpha = angle*pi/180;
    
    %calculate A
    A = 1 + (tan(alpha))^2;
    
    if (R^2 - Yp^2 +  Yp^2/A < 0) 
        continue;
    end
   
    %Parametric eqautions of the intersection contours    
    x = sqrt(R^2 - Yp^2 +  Yp^2/A)*cos(t);
    y = Yp/A + sqrt(R^2 - Yp^2 +  Yp^2/A)/sqrt(A)*sin(t);
    z = y*tan(alpha);

    %Get the computed points in to a matrix
    points = [x;y;z];
    
    %plot the intersection contours
    h = plot3(points(1,:),points(2,:),points(3,:));hold on;
    title('Intersection Contours');axis tight;
    
    %compute the rotational matrix 
    Rx = rotx(-angle);
    
    %flatten the inclined contour
    points = Rx*points;
    
    %extract the X,Y coordinates from the flattened contour
    X = points(1,:);
    Y = points(2,:);
    
    %apply a shift to X coordinates
    X = X + Xus/2;
    
    %create an image pad
    image_pad = zeros(Xus/sx,Yus/sy);
    Xn = roundn(X,-1)*10;
    Yn = roundn(Y,-1)*10;
    
    %Sketch the boundary of the contour on the image pad
    for i = 1 : numel(Xn)
        image_pad(Xn(i),Yn(i)) = 255;
    end
    
    %convert the image pad matrix to uni8
    im = mat2gray(image_pad);
    
    %fill the contour interior to complete the projection image
    im = imfill(im,'holes');
    
    %save the image
    filename = 'p%d.bmp';
    filename = sprintf(filename,image_index);
    image_index = image_index + 1;
    imwrite(im,filename);
    
    %update the frame stack
    
    frames(:,:,end+1) = im;
    angulation(end+1) = angle;
end

%save the intersection contour plot and the frame stack
saveas(h,'Intersection_contours.fig');
save('frames.mat','frames','angulation');
cd ..

