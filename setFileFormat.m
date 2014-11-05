function file_format = setFileFormat(w)
    % Set format to be used to write into word file    
    file_format = '%s,%d,%d';
    for i = 1:w
        file_format = strcat(file_format, ',%1.4f');
    end
    file_format = strcat(file_format, '\n');
end