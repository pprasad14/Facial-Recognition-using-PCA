% Example Matlab script as provided with textbook:
%
%  Fundamentals of Digital Image Processing: A Practical Approach with Examples in Matlab
%  Chris J. Solomon and Toby P. Breckon, Wiley-Blackwell, 2010
%  ISBN: 0470844736, DOI:10.1002/9780470689776, http://www.fundipbook.com
%

%% cycle through all PNG files in a given directory
%% (and in this case display them)
%% [for use with suggested student projects on www.fundipbook.com/materials/]

%% change '*.png' in code below for other image types


list = dir('*.jpg');
number_of_files = size(list);
x = zeros(1,6);
x = string(x);
j = 1;
for i= 1: number_of_files(1,1)
    filename = list(i).name;
    I = imread(filename);
    if size(I,1)*size(I,2) ~= 76800
        x(j) = filename;
        j=j+1;
    end
%     imshow(I);
%     pause(0.2)
end