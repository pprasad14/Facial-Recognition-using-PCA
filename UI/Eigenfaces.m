function varargout = Eigenfaces(varargin)
% Eigenfaces MATLAB code for Eigenfaces.fig
%      Eigenfaces, by itself, creates a new Eigenfaces or raises the existing
%      singleton*.
%
%      H = Eigenfaces returns the handle to a new Eigenfaces or the handle to
%      the existing singleton*.
%
%      Eigenfaces('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Eigenfaces.M with the given input arguments.
%
%      Eigenfaces('Property','Value',...) creates a new Eigenfaces or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Eigenfaces_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Eigenfaces_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Eigenfaces

% Last Modified by GUIDE v2.5 27-Dec-2018 02:45:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Eigenfaces_OpeningFcn, ...
                   'gui_OutputFcn',  @Eigenfaces_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});  
end
% End initialization code - DO NOT EDIT


% --- Executes just before Eigenfaces is made visible.
function Eigenfaces_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Eigenfaces (see VARARGIN)

% Choose default command line output for Eigenfaces
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Eigenfaces wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    
    %% LOAD THE MAIA LOGO TO THE FORM
    axes(handles.logo);
    logoImage = imread( 'MAIA.jpg' );
    imshow(logoImage,[]);
    
    %% LOAD EIGENFACES IN THE AXIS
    load pcaData.mat;
    handles.BASEprojectedIMAGES = BASEprojectedIMAGES;
    handles.FacesSmall = FacesSmall;
    handles.projectionPCA = projectionPCA;
    handles.trainFacesColor = trainFacesColor;
    handles.trainIndex = trainIndex;
    handles.trainLabels = trainLabels;
    guidata(hObject,handles)
    
    %% SHOW FIRST EIGENFACE IN THE INPUT AXIS
    axes(handles.input_axis);
    Eigenface = projectionPCA(:,1);
    Eigenface = reshape(Eigenface,[64 64]);
    imshow(Eigenface, []);
    xlabel('EIGENFACE 1');
   
    
    %% SHOW 2-4 EIGENFACES IN THE INPUT AXIS
    
    handlesREsult = [handles.result1, handles.result1,handles.result2,handles.result3];
    for index = 2:4
        Eigenface = projectionPCA(:,index);
        Eigenface = reshape(Eigenface,[64 64]);
        axes(handlesREsult(index));
        imshow(Eigenface, []);
        xlabel(['EIGENFACE '  num2str(index)]);
    end



% --- Outputs from this function are returned to the command line.
function varargout = Eigenfaces_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
patient = handles.patient;
[contoursDiastole] = segmentImagesNew(patient.diastole);
plotEpicardium( patient.diastole,contoursDiastole,handles.input_axis,handles.diastole_axis1);

patient.diastoleSeg = contoursDiastole;
patient.UsedImagesDiastole = patient.diastole(:,:,2:end-1);

linkaxes([handles.input_axis,handles.diastole_axis1],'xy');
Link1 = linkprop([handles.input_axis,handles.diastole_axis1],{'CameraUpVector', 'CameraPosition', 'CameraTarget'});
setappdata(gcf, 'StoreTheLink1', Link1);
view(0,90);

[contoursSystole]= segmentImagesNew(patient.systole);
plotEpicardium(patient.systole,contoursSystole,handles.result_axis,handles.sistole_axis1);

patient.systoleSeg = contoursSystole;
patient.UsedImagesSystole = patient.systole(:,:,2:end-1);

linkaxes([handles.result_axis,handles.sistole_axis1],'xy');
Link = linkprop([handles.result_axis,handles.sistole_axis1],{'CameraUpVector', 'CameraPosition', 'CameraTarget'});
setappdata(gcf, 'StoreTheLink', Link);
view(0,90);


handles.patient=patient;
guidata(hObject,handles)



% --- Executes on button press in processFace.
function processFace_Callback(hObject, eventdata, handles)
% hObject    handle to processFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.png'},'File Selector');
selectedFace = imread([pathname filename]);
handles.selectedFace=selectedFace;
C = strsplit(filename,'_');
filename = char(C(1));
handles.selectedLabel=filename;
guidata(hObject,handles)

%% SHOW SELECTED IMAGE
axes(handles.input_axis);
imshow(selectedFace);
xlabel(filename);

%% APPLY PCA TO THE INPUT FACE
    BASEprojectedIMAGES = handles.BASEprojectedIMAGES;
    FacesSmall = handles.FacesSmall;
    projectionPCA = handles.projectionPCA;
    trainFacesColor = handles.trainFacesColor;
    trainIndex = handles.trainIndex;
    trainLabels = handles.trainLabels;

%% PROJECT THE TEST FACES IN THE PCA SPACE
    selectedFace = rgb2gray(selectedFace);
    querry = double(selectedFace(:)') * projectionPCA;
%% CALCULATE THE EUCLIDIAN DISTANCE
    distances = BASEprojectedIMAGES - querry;
    Eudistance = sum(distances.*distances,2);
    % Sort the euclidian distances
    [~,position] = sort(Eudistance);
    pos = position(1:3);
    
    %% SHOW THE MATCHING FACES
    handlesREsult = [handles.result1,handles.result2,handles.result3];
    for index = 1:3
        axes(handlesREsult(index));
        imshow(uint8(trainFacesColor(:,:,:,pos(index))));
        xlabel(trainLabels(pos(index)));
%         imshow(uint8(FacesSmall(:,:,trainIndex(pos(index))))); 
    end
    
    



% --- Executes on button press in ShowEigenfaces.
function ShowEigenfaces_Callback(hObject, eventdata, handles)
% hObject    handle to ShowEigenfaces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %% SHOW FIRST EIGENFACE IN THE INPUT AXIS
    projectionPCA = handles.projectionPCA;
    axes(handles.input_axis);
    Eigenface = projectionPCA(:,1);
    Eigenface = reshape(Eigenface,[64 64]);
    imshow(Eigenface, []);
    xlabel('EIGENFACE 1');
   
    
    %% SHOW 2-4 EIGENFACES IN THE INPUT AXIS
    
    handlesREsult = [handles.result1, handles.result1,handles.result2,handles.result3];
    for index = 2:4
        Eigenface = projectionPCA(:,index);
        Eigenface = reshape(Eigenface,[64 64]);
        axes(handlesREsult(index));
        imshow(Eigenface, []);
        xlabel(['EIGENFACE '  num2str(index)]);
    end
