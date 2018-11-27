function outputImage = AffineTransformation(inputImage,A,b)
    inputImage = im2double(inputImage);
    outputImage = zeros(64,64,size(inputImage,3));
    %% Get a cropped version of the image
    for j = 1:size(outputImage,2)
        for i = 1:size(outputImage,1)
            um = A^-1*( [j;i] - b );
            um = round(um);
            try
                outputImage(i,j,:) = inputImage(um(2), um(1),:);
            catch
                outputImage(i,j,:) = [0; 0; 0];
            end
        end
    end
    outputImage = uint8(outputImage);
    imshow(outputImage);
end
