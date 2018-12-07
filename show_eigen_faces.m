function [] = show_eigen_faces(projectionPCA,k)
    for index = 1 : k
        Eigenface = projectionPCA(:,index);
        Eigenface1 = 255*((Eigenface - min(Eigenface))/...
                     (max(Eigenface) - min(Eigenface)) );
        Eigenface = reshape(Eigenface1,[64 64]);
        figure(index);
        mVal = round(mean(Eigenface1));
        imshow(Eigenface, [mVal-5 mVal+5])
    end
end

