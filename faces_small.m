function [FacesSmall] = faces_small(faces, Fi, Fd)
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
    for index=1:length(Fi)
        indFace = faces(:,:,:,index);
        indA = AllA(:,:,index);
        indB = Allb(:,:,index);
        faceSmall = AffineTransformation( indFace, indA, indB);
        FacesSmall(:,:,index) = rgb2gray(faceSmall);
    end
end

