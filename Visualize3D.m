%Visualize the sphere and the respective image slices
% % % % figure;
% % % % [x,y,z] = sphere;
% % % % surf(x*2,y*2+6,z*2);
% % % % hold on;
% % % % xlim([-10,10]);
% % % % ylim([-10,10]);
% % % % zlim([-10,10]);
% % % % 
% % % % for alpha = -15 : 2 : 15;
% % % %     [X,Y] = meshgrid(-10:.2:10, -10:.2:10);
% % % %     Z = tan(alpha/180*pi)*Y;
% % % %     surf(Z)
% % % %     hold on;
% % % %     pause;
% % % % end

angle = 0;
t = linspace(0,2*pi,1000);
alpha = angle*pi/180;
A = 1 + (tan(alpha))^2;

x = sqrt(-32 + 36/A)*cos(t);
y = 6/A + sqrt(-32 + 36/A)/sqrt(A)*sin(t);
z = y*tan(alpha);

points = [x;y;z];

R = rotx(-angle);

points = R*points;
points(3,:) = 0;
X = points(1,:);
X = X + 5;
Y = points(2,:);
plot(X,Y);
axis equal;
xlim([0,10]);
ylim([0,10]);

image_pad = zeros(100,100);
Xn = roundn(X,-1)*10;
Yn = roundn(Y,-1)*10;

for i = 1 : numel(Xn)
        image_pad(Xn(i),Yn(i)) = 255;
end

im = mat2gray(image_pad);
im = imfill(im,'holes');
imshow(im);




