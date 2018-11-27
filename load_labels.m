function [labels] = load_labels

    %finding the number of .txt files in directory
    list = dir('all_face_data/*.txt');
    number_of_txt_files = size(list,1);

    %storing image file names
    txt_names = string(zeros(1,number_of_txt_files));
    for i = 1: number_of_txt_files
        txt_names(i) = list(i).name;
    end
    
    
    exp = '.txt';
    labels = string(zeros(1,number_of_txt_files / 5));
    pos = 1;
    for i = 1 : 1 : number_of_txt_files
        str = char(txt_names(i));
        sub_str = str(1: regexp(str,exp)-2);
        labels(pos) = sub_str;
        pos = pos + 1;
    end

end