function phase1task3(simulation_file, choice, c_graph_file)
    
    switch choice
        case 1
            epidemic_file = 'epidemic_word_file_';
        case 2
            epidemic_file = 'epidemic_word_file_avg_';
        case 3
            epidemic_file = 'epidemic_word_file_diff_';
        otherwise
            epidemic_file = 'ERROR';
    end
    
    simulation_file = strcat(epidemic_file, simulation_file);
    
    A = csvread(simulation_file, 0, 1); % Open the file to be plotted into matrix A
    [rows, cols] = size(A);
    
    for i = 1:rows
        window = A(i, 3:cols);
        A(i,(cols+1)) = norm(window, 2); % Adding an extra column to A having 2nd norm value of the windows
    end
    
    B = unique(A(:,2)); % Find the time stamps in word file
    
    c_graph = xlsread(c_graph_file); % Read the connectivity graph 
    
    heat_map = 0;
    i = 1;
    j = 1;
    
    while i < rows 
        heat_map(j, 1:size(B, 1)) = A(i:(i + size(B, 1)-1), (cols+1))'; 
        % Entering the 2nd norm values for each time stamp and state into heat_map matrix
        
        j = j + 1; % Shift to next row for heat_map
        i = i + size(B, 1); % Shift to next set of 2nd norm values for the next state
    end
    
    max_strength = max(max(heat_map)); % Find maximum value in heat map
    min_strength = min(min(heat_map)); % Find minimum value in heat map
    
    x = findPositionInMatrix(heat_map, max_strength); % Find row with maximum value. 
    y = findPositionInMatrix(heat_map, min_strength); % Find row with minimum value. 
    
    [rows, cols] = size(heat_map);
    
    colormap('hot'); % Set colormap
    
    imagesc(heat_map); % Draw image and scale colormap to values range
    colorbar;
    hold;
        
    drawRectanglesAndText('g', 'y', c_graph, y, rows); % Mark the state with minimum value and its 1 hop neighbors
    drawRectanglesAndText('b', 'c', c_graph, x, rows); % Mark the state with maximum value and its 1 hop neighbors
end

function position = findPositionInMatrix(heat_map, strength)
    % Return the position of 'strength' value in heat map. In case of more than one row with same value, return a random row from the list of those rows
    I = find(heat_map == strength);
    position = randsample(I, 1);
    if size(I) == 1
        position = I;
    end
end

function drawRectanglesAndText(maincolor, onehopcolor, c_graph, point_to_be_plot, rows)
    % Mark the states in corresponding rows
    state_names = ['AK'; 'AL'; 'AR'; 'AZ'; 'CA'; 'CO'; 'CT'; 'DC'; 'DE'; 'FL'; 'GA'; 'HI'; 'IA'; 'ID'; 'IL'; 'IN'; 'KS'; 'KY'; 'LA'; 'MA'; 'MD'; 'ME'; 'MI'; 'MN'; 'MO'; 'MS'; 'MT'; 'NC'; 'ND'; 'NE'; 'NH'; 'NJ'; 'NM'; 'NV'; 'NY'; 'OH'; 'OK'; 'OR'; 'PA'; 'RI'; 'SC'; 'SD'; 'TN'; 'TX'; 'UT'; 'VA'; 'VT'; 'WA'; 'WI'; 'WV'; 'WY'];
    r = mod(point_to_be_plot, rows);
    if r == 0
        r = rows; % Find the state number
    end
    c = ceil(point_to_be_plot/rows);
    rectangle('Position', [c-0.5,r-0.5,4,1]); % Display rectangle in the row that corresponds to that state
    str = state_names(r, :);
    text(c,r,str, 'color', maincolor); % Write state name near the rectangle
    HN = find(c_graph(r, :) == 1);
    for k = 1:size(HN, 2)
        rectangle('Position', [c-0.5,HN(k)-0.5,4,1]); % Display rectangle in the row that corresponds to 1 hop neighbor
        str = state_names(HN(k), :);
        text(c, HN(k), str, 'color', onehopcolor); % Write text near 1 hop neighbor state
    end
end