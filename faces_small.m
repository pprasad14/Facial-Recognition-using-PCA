function [FacesSmall,FaceSmallColor] = faces_small(faces, Fi, Fd)
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

    FacesSmall = zeros(64,64,length(Fi));
    FaceSmallColor = zeros(64,64,3,length(Fi));
    for index=1:length(Fi)
        indFace = faces(:,:,:,index);
        indA = AllA(:,:,index);
        indB = Allb(:,:,index);
        faceSmall = AffineTransformation( indFace, indA, indB);
        faceSmall_1 = rgb2gray(uint8(faceSmall));
%         faceSmall_1 = imadjust(faceSmall_1);
        % rgb2lin ->>0.6667    0.8333
        % rgb2lin(adjust) ->> 0.6970    0.8182 
        % rgb2grey ->>  0.7424    0.7879
        % rgb2hsv
        FacesSmall(:,:,index) = faceSmall_1;
%         FacesSmall(:,:,index) = rgb2gray(faceSmall);
        FaceSmallColor(:,:,:,index) = faceSmall;
    end
end

