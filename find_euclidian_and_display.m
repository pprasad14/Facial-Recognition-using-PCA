function [Statistics] = find_euclidian_and_display(TESTprojected,BASEprojectedIMAGES,FacesSmall,testIndex,trainIndex,testLabels,trainLabels,enableshow)
    Statistics = zeros(size(TESTprojected,1),3);
    for index = 1:size(TESTprojected,1)
        
        querry = TESTprojected(index,:);
        distances = BASEprojectedIMAGES - querry;
        Eudistance = sum(distances.*distances,2);

        % Sort the euclidian distances
        [~,position] = sort(Eudistance);
        pos = position(1:3);
    %     pos = zeros(3,1);
    %     for index1=1:3
    %       [~,pos(index1)] = min(Eudistanc);
    %       % remove for the next iteration the last smallest value:
    %       Eudistanc(pos(index1)) = [];
    %     end

        subplot(1,4,1)
        imshow(uint8(FacesSmall(:,:,testIndex(index))));
        title(testLabels(index)+char(num2str(testIndex(index))) )

        subplot(1,4,2)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(1)))));
        title(trainLabels(pos(1))+char(num2str(trainIndex(pos(1)))))
        if( testLabels(index) == trainLabels(pos(1)) )
            Statistics(index,1) = 1;
        end

        subplot(1,4,3)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(2)))));
        title(trainLabels(pos(2))+char(num2str(trainIndex(pos(2)))))
        if( testLabels(index) == trainLabels(pos(2)) )
            Statistics(index,2) = 1;
        end

        subplot(1,4,4)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(3)))));
        title(trainLabels(pos(3))+char(num2str(trainIndex(pos(3)))))
        if( testLabels(index) == trainLabels(pos(3)) )
            Statistics(index,3) = 1;
        end
        
        if(enableshow==true)
            pause
        end
    end
end

