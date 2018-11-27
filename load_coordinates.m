function [coordinate_matrix] = load_coordinates()

    %setting directory where coordinates are present
    directory = "all_face_data/";

    %finding the number of .txt files in directory
    list = dir('all_face_data/*.txt');
    number_of_txt_files = size(list,1);

    %storing image file names
    txt_names = string(zeros(1,number_of_txt_files));
    for i = 1: number_of_txt_files
        txt_names(i) = list(i).name;
    end
% 
%     rows = 5;
%     columns = 2;
%     depth = number_of_txt_files;

    file_name = char(strcat(directory,txt_names(1)));
    coordinate_matrix = round(importdata(file_name));

    for i = 2 : number_of_txt_files
        temp_file = char(strcat(directory,txt_names(i)));
        temp = importdata(temp_file);
        coordinate_matrix = cat(3, coordinate_matrix, temp);
    end
end



