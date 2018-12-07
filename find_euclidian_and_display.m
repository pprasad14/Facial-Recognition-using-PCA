function [] = find_euclidian_and_display(p,TESTprojected,BASEprojectedIMAGES,FacesSmall,testIndex,trainIndex)
    for index = 1:p
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
        title('INPUT IMAGE')

        subplot(1,4,2)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(1)))));
        title('MATCH IMAGE 1')

        subplot(1,4,3)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(2)))));
        title('MATCH IMAGE 2')

        subplot(1,4,4)
        imshow(uint8(FacesSmall(:,:,trainIndex(pos(3)))));
        title('MATCH IMAGE 3')
        pause(2)
    end
end

