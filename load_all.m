function [outputArg1,outputArg2] = load_all(inputArg1,inputArg2)

%% setting directory where images are present
    directory = "all_face_data/";
    total_no_of_files = length(dir('all_face_data/*.*')) - 2;
    
    rows = 320;
    columns = 240;
    
    number_of_jpg_files = total_no_of_files/2
    face_matrix = zeros(rows, columns, 3, number_of_jpg_files);
    



end

