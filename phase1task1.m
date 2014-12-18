function phase1task1(dir, resolution, window_size, shift_length)
% Function that reads a set of simulation files and creates an epidemic word file for each file
% dir - Directory of existing simulation files
% resolution - The resolution value to be used for quantizing
% window_size - Size of window to be used
% shift_length - The shift of windows 
    
    res_win_shift = [resolution window_size shift_length];
    csvwrite('InputValues.csv',res_win_shift);
    
    if strcmp(dir,'')
        dir = '.'; % In case the given directory is current directory, set dir to '.'
    end
       
    files_list = ls(dir); % Read list of files in 'dir'
    mean = 0;
    standard_deviation = 0.25;
    
    [band, quant, point] = bqp(resolution, mean, standard_deviation); % Calculate band, point and quant values
    
    point(resolution) = 1; % Set last value of 'point' to 1 to avoid avoid minor change in its value (like 1.0000000001)

    file_format = setFileFormat(window_size); % Set file format to write word file
    
    for loop = 3 : size(files_list,1) % loop starts from 3 becase 1 and 2 have '.' and '..' respectively from ls()
        
        L = strtrim(files_list(loop, :)); % Store each file name in directory 'd' one by one
        file_name = strcat(dir, '/', L); % Store file hierarchy (directory/filename)
        
        if strfind(file_name,'.csv') % Check if the file type is 'csv'

            isEpidemic = strfind(file_name,'epidemic_word_file'); % Check if file is not epidemic word file
            if isempty(isEpidemic)            

                m = csvread(file_name, 1, 2); % Read the data file
        
                nq_matrix = normalize_matrix(m); % Normalized matrix

                nq_matrix = quantize_matrix(nq_matrix, point, quant, resolution); % nq_matrix is now quantized
            
                L = strsplit(L, '.');
                L = L{1};
                % Suppose L = '1.csv', it is changed to L = '1' (so as to
                % maintain consistency while writing into epidemic word csv
                % file)
            
                writeEpidemicWordFile(nq_matrix, shift_length, window_size, L, file_format);
                % Create and write into epidemic word files
            
            end
        end
    end
    % End loop
    
end

function writeEpidemicWordFile(nq_matrix, h, w, L, file_format)
    % Write contents to word file based on window length 'w', shift length 'h',
    % file name L, quantized matrix nq_matrix
    file_name = strcat('epidemic_word_file_',L,'.csv');
    fID = fopen(file_name,'w');
    
    [rows, cols] = size(nq_matrix);
    window = 1:w;
    
    for state = 1:cols % Looping through each state
        time = 1;
        while time < rows
            j = time;
            if w > h
                maxhw = w;
            else
                maxhw = h;
            end
            if (time + maxhw) < rows
                for k = 1:w
                    window(k) = nq_matrix(j,state); 
                    % Adding contents to the current window
                    j = j + 1;
                end
            end
            fprintf(fID, file_format, L, state, time, window);                            
            time = time + h; % Shifting window by shift length 'h'
        end
    end
    
    fclose(fID);
end

