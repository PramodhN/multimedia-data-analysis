function generate_heatmap(choice, c_graph_file, file_name, map_row, map_col, map_pos, resolution)
% This function gets a file name and a choice to generate a heat map.
% This function uses map_row, map_col and map_pos to place the heat map in allocated space
% The resolution value is used for choices 'a' and 'b'
% The connectivity graph 'c_graph_file' is used for the rest of the operations

    switch choice
        case 'a'
            epidemic_file = '';
        case 'b'
            epidemic_file = '';
        case 'c'
            epidemic_file = 'epidemic_word_file_';
        case 'd'
            epidemic_file = 'epidemic_word_file_avg_';
        case 'e'
            epidemic_file = 'epidemic_word_file_diff_';
        case 'f'
            epidemic_file = 'epidemic_word_file_';
        case 'g'
            epidemic_file = 'epidemic_word_file_avg_';
        case 'h'
            epidemic_file = 'epidemic_word_file_diff_';
        otherwise
            epidemic_file = 'ERROR';
    end
    
    simulation_file = strcat(epidemic_file, file_name); % Set name for simulation file
    if choice == 'a' || choice == 'b'
        heat_map = get_nq_matrix(simulation_file, resolution); % Plot the normalized quantized matrix
    else
        A = csvread(simulation_file, 0, 1); % Open the file to be plotted into matrix A
        [rows, cols] = size(A);
    
        for i = 1:rows
            window = A(i, 3:cols);
            A(i,(cols+1)) = norm(window, 2); % Adding an extra column to A having 2nd norm value of the windows
        end
    
        B = unique(A(:,2)); % Find the time stamps in word file
    
        c_graph = csvread(c_graph_file,1,1); % Read the connectivity graph 
    
        heat_map = 0;
        i = 1;
        j = 1;
    
        while i < rows 
            heat_map(j, 1:size(B, 1)) = A(i:(i + size(B, 1)-1), (cols+1))'; 
            % Entering the 2nd norm values for each time stamp and state into heat_map matrix
    
            j = j + 1; % Shift to next row for heat_map
            i = i + size(B, 1); % Shift to next set of 2nd norm values for the next state
        end
    end
    subplot(map_row, map_col, map_pos)
    imagesc(heat_map);
    colormap('hot');
    axis ij square % Make the plot shape to be square
    str = num2str(file_name);
    text(1,-10,str);
    %colorbar;
end