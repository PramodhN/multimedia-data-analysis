function phase1task2(dir, c_graph_file, weight)
% Function that reads a list of simulation files and computes the average and difference files for each simulation
% dir - Directory of existing simulation files
% c_graph_file - The location matrix excel file
% weight - The weight to be used for calculating average

    if strcmp(dir,'')
        dir = '.'; % In case the given directory is current directory, set dir to '.'
    end
    
    files_list = ls(dir);
        
    c_graph = csvread(c_graph_file,1,1); % Read connectivity graph
    
    for loop = 3 : size(files_list,1) % loop starts from 3 becase 1 and 2 have '.' and '..' respectively from ls()
        
        L = strtrim(files_list(loop, :)); % Store each file name in directory 'd' one by one  
        file_name = strcat(dir, '/', L); % Store file hierarchy (directory/filename)
        
        if strfind(file_name,'.csv') % Check if the file type is 'csv'

            isEpidemic = strfind(file_name,'epidemic_word_file'); % Check if file is not epidemic word file
            
            if isempty(isEpidemic)            

                L = strsplit(L, '.');
                L = L{1};
                % Suppose L = '1.csv', it is changed to L = '1' (so as to
                % maintain consistency while writing into epidemic word csv
                % file)
            
                createAvgDiffFile(c_graph, weight, L);
                % Create and write average and difference files for the word
                % file created above            
            end
        end
    end
    %End loop
end

function createAvgDiffFile(c_graph, weight, L)
    % Create epidemic average and diff file using the epidemic word file,
    % connectivity graph and 'weight' input
    
    file_name = strcat('epidemic_word_file_',L,'.csv');
    wf = csvread(file_name, 0, 1);
    [rows, cols] = size(wf);
    window_size = cols - 2;
    file_format = setFileFormat(window_size); % Set file format to write word file

    file_name = strcat('epidemic_word_file_avg_',L,'.csv');
    fID1 = fopen(file_name,'w');
    file_name = strcat('epidemic_word_file_diff_',L,'.csv');
    fID2 = fopen(file_name,'w');
    for j = 1:rows
        state = wf(j, 1); % Current state
        time = wf(j, 2); % Current time stamp
        window = wf(j, 3:(window_size+2)); % Window contents of current state
        HN = find(c_graph(state, :) == 1); % 1 hop neighbors of current state
        avg_matrix = 0;
        avg_weight = 0;
        if size(HN,2) > 1 % In case there are more than one, hop neighbors
            for k = 1:size(HN,2)
                avg_matrix(k,1:window_size) = wf(wf(:,1)==HN(k) & wf(:,2)==time, 3:(window_size+2));
                % Average values of 1 hop neighbors
            end
            avg_weight = mean(avg_matrix);
        elseif size(HN,2) == 0 % In case there are no, hop neighbors
            avg_weight = zeros(1,window_size);
        elseif size(HN,2) == 1 % In case there is just one, hop neighbor
            avg_weight = wf(wf(:,1)==HN(1) & wf(:,2)==time, 3:(window_size+2));
        end
        
        window_avg = (weight * window) + ((1-weight) * avg_weight);
        % Calculating win avg
        
        window_diff = (window - avg_weight)./window;
        % Calculating win diff
        
        fprintf(fID1, file_format, L, state, time, window_avg); % Write to avg file
        fprintf(fID2, file_format, L, state, time, window_diff); % Write to diff file
    end
    fclose(fID1);
    fclose(fID2);
end