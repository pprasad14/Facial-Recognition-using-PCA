function [face_matrix] = load_images()

    %% setting directory where images are present
    directory = "all_face_data/";

    %% finding the number of images in directory
    list = dir('all_face_data/*.jpg');
    number_of_jpg_files = size(list,1);

    %% storing image file names
    img_names = string(zeros(1,number_of_jpg_files));
    for i = 1: number_of_jpg_files
        img_names(i) = list(i).name;
    end

    rows = 320;
    columns = 240;
    %% Creating a empty matrix to store the faces
    face_matrix = zeros(rows, columns, 3, number_of_jpg_files);

    for i = 1: number_of_jpg_files
        temp_file = char(strcat(directory,img_names(i)));
        image = imread(temp_file);
        face_matrix(:,:,:,i) = image;
    end

end