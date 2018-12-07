function [TESTfaces,p] = get_test_D_faces(testFaces, trainFaces)
    k = size(testFaces,1)*size(testFaces,2);
    p = size(testFaces,3);
    TESTfaces = zeros(p , k);

    for index = 1:p
        XT = trainFaces(:,:,index);
        TESTfaces(index,:) = XT(:)';
    end
end

