for k = 1:5
filename = strcat('shah',string(k));
ext = '.jpg';
n = imread(strcat(char(filename),ext)); 
imshow(n);
[x,y] = ginput(5);
z = zeros(5,2);
for i = 1:5
    z(i,1) = round(x(i));
    z(i,2) = round(y(i));
end
dlmwrite(strcat(filename,'.txt'),z);
end
% z
% round(x) 
% round(y)

 