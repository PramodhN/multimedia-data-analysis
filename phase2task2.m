function phase2task2(new_file, new_dir, k, choice, dir, c_graph_file, weight)
% This function reads a query file, displays the k most similar simulation to the query file and visualizes the results in a heat map
% new_file - The query file to be compared with
% new_dir - The directory of query file
% k - Number of similar simulations to be visualized
% choice - Takes values from 'a' to 'h' to choose corresponding similarity measure
% dir - Directory of existing simulation files
% c_graph_file - The location matrix file
% weight - required to create avg and diff files for the query file. Required in case of choices 'c' to 'h'
        
    input_values = csvread('InputValues.csv');
    resolution = input_values(1);
    window_size = input_values(2);
    shift_length = input_values(3);

    if strcmp(dir,'')
        dir = '.'; % In case the given directory is current directory, set dir to '.'
    end
    files_list = ls(dir); % Read list of files in 'dir'
    if k > (size(files_list,1)-2) % Check if k value is greater than the existing files
        msg = 'k value is greater than existing files';
        error(msg);
    end
    
    if choice == 'a' || choice == 'b'
        new_file_with_dir = strcat(new_dir, '/', new_file);
    else
        phase1task1(new_dir, resolution, window_size, shift_length); 
        % Perform phase1 tasks on the new file to create its corresponding word, avg and diff files
        phase1task2(new_dir, c_graph_file, weight);
    end
    
    for loop = 3 : size(files_list,1) % Starting loop from 3 to ignore the files '.' and '..'
        file_name = strtrim(files_list(loop, :)); % Store each file name in directory 'd' one by one  
        if strfind(file_name,'.csv') % Check if the file type is 'csv'
            isEpidemic = strfind(file_name,'epidemic_word_file'); % Check if file is not epidemic word file
            if isempty(isEpidemic)
                switch choice
                    case 'a'
                        file_name = strcat(dir, '/', file_name);
                        similarity(loop-2) = phase2task1a(new_file_with_dir, file_name);
                    case 'b'
                        file_name = strcat(dir, '/', file_name);
                        similarity(loop-2) = phase2task1b(new_file_with_dir, file_name);
                    case 'c'
                        similarity(loop-2) = phase2task1c(new_file, file_name);
                    case 'd'
                        similarity(loop-2) = phase2task1d(new_file, file_name);
                    case 'e'
                        similarity(loop-2) = phase2task1e(new_file, file_name);
                    case 'f'
                        similarity(loop-2) = phase2task1f(new_file, file_name, c_graph_file);
                    case 'g'
                        similarity(loop-2) = phase2task1g(new_file, file_name, c_graph_file);
                    case 'h'
                        similarity(loop-2) = phase2task1h(new_file, file_name, c_graph_file);
                end
            end
        end
    end
    
    [sortedX,sortingIndices] = sort(similarity,'descend'); % Sorting the similarity values in descending order
    sortingIndices = sortingIndices(1:k); % Retrieving top k most similar simulations

    map_row = ceil((k+1)/3);
    map_col = 3;
    
    % Generating heat map for the new file
    if choice == 'a' || choice == 'b'
        generate_heatmap(choice, '', new_file_with_dir, map_row, map_col, 1, resolution); 
    else
        generate_heatmap(choice, c_graph_file, new_file, map_row, map_col, 1);
    end
    
    for loop = 1:k
        % This loop generates heat maps for the 'k' similar simulations
        fname_value = strcat(files_list(sortingIndices(loop)+2, :), ' --> ', num2str(sortedX(loop)));
        if choice == 'a' || choice == 'b'
            generate_heatmap(choice, '', strcat(dir, '/', files_list(sortingIndices(loop)+2, :)), map_row, map_col, loop + 1, resolution);
        else
            generate_heatmap(choice, c_graph_file, files_list(sortingIndices(loop)+2, :), map_row, map_col, loop + 1);
        end
        disp(fname_value);
    end    
end