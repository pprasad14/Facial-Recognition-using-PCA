close all
clearvars
clc

%% Get all the images information
faces = load_images();
Fi = load_coordinates();
labels = load_labels();

%% Load predefined locations:
Fd = load_predefined_locations();

%% Initialize the mean with the features of the first image
FacesSmall = faces_small(faces,Fi,Fd);

%% SPLIT THE TRAINING AND THE TESTING DATA
[trainIndex, testIndex] = train_test_split();

% Split the faces
testFaces = FacesSmall(:,:,testIndex);
trainFaces = FacesSmall(:,:,trainIndex);

%Split the labels
testLabels = labels(:,testIndex);
trainLabels = labels(:,trainIndex);

%% Obtain the d-dimensional space
Dfaces = get_train_D_faces(trainFaces);

%% Calculate the Covariance matrix
[eigenvalues, V] = get_eigenvalues(Dfaces , size(trainFaces,3));

%% Taking the k principal components to get the 95% of the data
[projectionPCA,k] = get_principal_components(eigenvalues,V);

%% Show the eigenfaces
show_eigen_faces(projectionPCA,k);

%% CALCULATE THE PROJECTED BASE IMAGES:
BASEprojectedIMAGES = Dfaces*projectionPCA;

%% TEST IMAGES
% Obtain the d-dimensional space
[TESTfaces , p] = get_test_D_faces(testFaces);

%% PROJECT THE TRAINING FACES IN THE PCA SPACE
TESTprojected = TESTfaces * projectionPCA;

%% CALCULATE THE EUCLIDIAN DISTANCE AND DISPLAY SIMILAR IMAGES
Statistics = find_euclidian_and_display(TESTprojected,BASEprojectedIMAGES,...
              FacesSmall,testIndex,trainIndex,testLabels,trainLabels, false);