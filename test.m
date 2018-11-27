clear all 
close all
clc

%% Get all the images information
faces = load_images();
Fi = load_coordinates();
labels = load_labels();


for i=1:length(Fi)
%     count = mod(i,6);
%     heading = strcat(labels(i),string(count));
%    imshow(insertMarker(uint8(faces(:,:,:,i)),Fi(:,:,i),'o','size',10)), title(heading);
    imshow(insertMarker(uint8(faces(:,:,:,i)),Fi(:,:,i),'o','size',10)), title(i);

    pause(0.5);
end


%% Define predefined locations:
Fd = [13 20 ; 50 20; 34 34 ; 16 50 ; 48 50];

%% Initialize the mean with the features of the first image
Fbar = Fi(:,:,1);
diffF =  norm(Fbar);
numIterations = 0;
while(diffF > 0.0001)
    %% (a) Start Iterating
    [A,b] = FindTransformation(Fbar,Fd);
    %% (b) Apply this transformation
    FbarPrime = ApplyTransformation(A, b, Fbar);
    FbarPrev = Fbar;
    Fbar = FbarPrime;
    %% (c) For every image find the transformation
    AllFprim = zeros(size(Fi));
    AllA = zeros(2,2,size(Fi,3));
    Allb = zeros(2,1,size(Fi,3));
    for i=1:length(Fi)
        Fiprime = Fi(:,:,i);
        [A,b] = FindTransformation(Fiprime,Fbar);
        Fiprime = ApplyTransformation(A, b, Fiprime);
        AllFprim(:,:,i) = Fiprime;
        AllA(:,:,i) = A;
        Allb(:,:,i) = b;
        FbarNext = sum(AllFprim,3)/length(Fi);
    end
    diffF =  norm( FbarPrev - FbarNext );
    Fbar = FbarNext;
    numIterations = numIterations + 1;
end

FacesSmall = zeros(64,64,3,length(Fi));
for i=1:length(Fi)
    FacesSmall(:,:,:,i) = ...
            AffineTransformation(faces(:,:,:,i),AllA(:,:,i),Allb(:,:,i));
    pause(1);
end

