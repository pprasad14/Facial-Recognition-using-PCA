function [Dfaces] = get_train_D_faces(trainFaces)
    k = size(trainFaces,1)*size(trainFaces,2);
    p = size(trainFaces,3);
    Dfaces = zeros(p , k);

    for index = 1:p
        X = trainFaces(:,:,index);
        Dfaces(index,:) = X(:)';
    end
end

