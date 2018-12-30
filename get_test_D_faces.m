function [TESTfaces,p] = get_test_D_faces(testFaces)
    k = size(testFaces,1)*size(testFaces,2);
    p = size(testFaces,3);
    TESTfaces = zeros(p , k);

    for index = 1:p
        XT = testFaces(:,:,index);
        TESTfaces(index,:) = XT(:)';
    end
end

