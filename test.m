clear all 
close all
clc

%% Get all the images information
faces = load_images();
Fi = load_coordinates();
labels = load_labels();

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
    for index=1:length(Fi)
        Fiprime = Fi(:,:,index);
        [A,b] = FindTransformation(Fiprime,Fbar);
        Fiprime = ApplyTransformation(A, b, Fiprime);
        AllFprim(:,:,index) = Fiprime;
        AllA(:,:,index) = A;
        Allb(:,:,index) = b;
        FbarNext = sum(AllFprim,3)/length(Fi);
    end
    diffF =  norm( FbarPrev - FbarNext );
    Fbar = FbarNext;
    numIterations = numIterations + 1;
end

FacesSmall = zeros(64,64,3,length(Fi));
for index=1:length(Fi)
    FacesSmall(:,:,index) = ...
            rgb2gray( AffineTransformation(faces(:,:,:,index),AllA(:,:,index),Allb(:,:,index)) ) ;
end

%% SPLIT THE TRAINING AND THE TESTING DATA
testIndex0 = randperm(5);

% Test images indexes
testIndex1 = testIndex0(1):5: 160+testIndex0(1);
testIndex2 = testIndex0(2):5: 160+testIndex0(2);
testIndex = [ testIndex1 testIndex2]';

% Training images indexes
trainIndex1 = testIndex0(3):5: 160+testIndex0(3);
trainIndex2 = testIndex0(4):5: 160+testIndex0(4);
trainIndex3 = testIndex0(5):5: 160+testIndex0(5);
trainIndex = [ trainIndex1 trainIndex2 trainIndex3]';

% Split the faces
testFaces = FacesSmall(:,:,testIndex);
trainFaces = FacesSmall(:,:,trainIndex);
%Split the labels
testLabels = labels(:,testIndex);
trainLabels = labels(:,trainIndex);


%% Obtain the d-dimensional space
k = size(trainFaces,1)*size(trainFaces,2);
p = size(trainFaces,3);
Dfaces = zeros(p , k);

for index = 1:p
    X = FacesSmall(:,:,trainFaces(index));
    Dfaces(index,:) = X(:)';
end

%% Calculate the Covariance matrix
SIGMA = (1/(p-1)) * (Dfaces'*Dfaces);
[V,D,W] = eig(SIGMA);
eigenvalues = eig(SIGMA);
%% Taking the k principal components to get the 95% of the data
Deigen = 0;
Teigen = sum(eigenvalues);
k=-1;
while(Deigen < 0.99*Teigen)
    k = k + 1;
    Deigen = sum(eigenvalues(end-k:end));
end

projectionPCA = V(:, end-k:end);

%% Show the eigenfaces
for index = 1 : k
    Eigenface = projectionPCA(:,index);
    Eigenface1 = 255*((Eigenface - min(Eigenface))/...
                 (max(Eigenface) - min(Eigenface)) );
    Eigenface = reshape(Eigenface1,[64 64]);
    figure(index);
    mVal = round(mean(Eigenface1));
    imshow(Eigenface, [mVal-5 mVal+5])
end


%% CALCULATE THE PROJECTED BASE IMAGES:
BASEprojectedIMAGES = Dfaces*projectionPCA;


%% TEST IMAGES
% Obtain the d-dimensional space
k = size(testFaces,1)*size(testFaces,2);
p = size(testFaces,3);
TESTfaces = zeros(p , k);

for index = 1:p
    XT = FacesSmall(:,:,testIndex(index));
    TESTfaces(index,:) = XT(:)';
end

%% PROJECT THE TRAINING FACES IN THE PCA SPACE
TESTprojected = TESTfaces * projectionPCA;

%% CALCULATE THE EUCLIDIAN DISTANCE
for index = 1:p
    querry = TESTprojected(index,:);
    distances = BASEprojectedIMAGES - querry;
    Eudistanc = sum(distances.*distances,2);
    
    
    pos = zeros(3,1);
    for index1=1:3
      [~,pos(index1)] = min(Eudistanc);
      % remove for the next iteration the last smallest value:
      Eudistanc(pos(index1)) = [];
    end
    
    subplot(4,1,1)
    imshow(uint8(FacesSmall(:,:,testIndex(index))));
    title('INPUT IMAGE')
    
    subplot(4,1,2)
    imshow(uint8(FacesSmall(:,:,trainIndex(pos(1)))));
    title('INPUT IMAGE')
    
    subplot(4,1,3)
    imshow(uint8(FacesSmall(:,:,trainIndex(pos(2)))));
    title('INPUT IMAGE')
    
    subplot(4,1,4)
    imshow(uint8(FacesSmall(:,:,trainIndex(pos(3)))));
    title('INPUT IMAGE')
    pause(2)
end



