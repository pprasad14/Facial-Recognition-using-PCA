close all
clearvars

%% Get all the images information
faces = load_images();
Fi = load_coordinates();
labels = load_labels();

%% Load predefined locations:
Fd = load_predefined_locations();

%% Initialize the mean with the features of the first image
[FacesSmall , FaceSmallColor] = faces_small(faces,Fi,Fd);

%% SPLIT THE TRAINING AND THE TESTING DATA
[trainIndex, testIndex] = train_test_split();
trainIndex = [1, 2, 5, 6, 8, 10, 11, 12, 13, 16, 18, 20, 21, 22, 23, 27, ...
              28, 30, 31, 32, 33, 36, 38, 39, 41, 43, 45, 47, 48, 49, 51,...
              52, 54, 56, 57, 60, 61, 62, 63, 67, 68, 70, 72, 73, 75, 76,...
              78, 80, 81, 84, 85, 86, 87, 90, 92, 93, 95, 96, 97, 98, 103,...
              104, 105, 106, 108, 109, 112, 114, 115, 116, 117, 118, 121,...
              122, 124, 126, 127, 130, 131, 132, 134, 137, 138, 140, 141,...
              143, 145, 146, 149, 150, 152, 154, 155, 156, 157, 160, 162,...
              163, 164]';
          
testIndex = [3, 4, 7, 9, 14, 15, 17, 19, 24, 25, 26, 29, 34, 35, 37, 40, ...
             42, 44, 46, 50, 53, 55, 58, 59, 64, 65, 66, 69, 71, 74, 77, ...
             79, 82, 83, 88, 89, 91, 94, 99, 100, 101, 102, 107, 110, 111,...
             113, 119, 120, 123, 125, 128, 129,  133, 135, 136, 139, 142, ...
             144, 147, 148, 151, 153, 158, 159, 161, 165]';

% Split the faces
testFaces = FacesSmall(:,:,testIndex);
trainFaces = FacesSmall(:,:,trainIndex);

%Split the labels
testLabels = labels(:,testIndex);
trainLabels = labels(:,trainIndex);

% Generate the testing folder and the training matrix
testFacesColor = FaceSmallColor(:,:,:,testIndex);
trainFacesColor = FaceSmallColor(:,:,:,trainIndex);
cd('test_faces') 
for(index = 1:length(testIndex))
    src = char(testLabels(index) +...
                '_' + num2str(index) + '.png');
    imdata = uint8(testFacesColor(:,:,:,index));
    imwrite(imdata, src,'png')
end
cd ../
%% Obtain the d-dimensional space
Dfaces = get_train_D_faces(trainFaces);

%% Calculate the Covariance matrix
[eigenvalues, V] = get_eigenvalues(Dfaces , size(trainFaces,3));

%% Taking the k principal components to get the 95% of the data
[projectionPCA,k] = get_principal_components(eigenvalues,V);

%% Show the eigenfaces
% show_eigen_faces(projectionPCA,k);

%% CALCULATE THE PROJECTED BASE IMAGES:
BASEprojectedIMAGES = Dfaces*projectionPCA;

%% TEST IMAGES
% Obtain the d-dimensional space
[TESTfaces , p] = get_test_D_faces(testFaces);

%% PROJECT THE TEST FACES IN THE PCA SPACE
TESTprojected = TESTfaces * projectionPCA;

%% SAVE THE IMPORTANT INFORMATION FOR THE PCA ALGORITHM
save pcaData.mat projectionPCA BASEprojectedIMAGES FacesSmall...
                 trainFacesColor trainLabels trainIndex


%% CALCULATE THE EUCLIDIAN DISTANCE AND DISPLAY SIMILAR IMAGES
Statistics = find_euclidian_and_display(TESTprojected,BASEprojectedIMAGES,...
              FacesSmall,testIndex,trainIndex,testLabels,trainLabels, false);

[sum(Statistics(:,1))/66  sum(sum(Statistics')>0)/66]


Statistics = find_euclidian_and_display(TESTprojected,BASEprojectedIMAGES,...
              FacesSmall,testIndex,trainIndex,testLabels,trainLabels, true);