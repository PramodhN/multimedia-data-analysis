function phase3task3b(directory,choice,k,c_graph_file)
% Displays top 'r' latent semantics from a given set of documents using simulation - simulation score
% dir_name - The directory where the simulation files are placed
% r - Number of latent semantics to be returned
% choice - the similarity measure to be used for calculating the score
% threshold - threshold value beyond which there will be an edge between
% two nodes(simulation files)

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);

    files_list = ls(directory); % Read list of files in 'directory' 
    M = csvread('AdjacencyMatrix.csv');
    N = size(M, 2); % N is equal to half the size of M
    v = rand(N, 1);
    v = v ./ norm(v, 1);
    last_v = ones(N, 1) * inf;

    d = 0.80;
    v_quadratic_error = 0.001;
    M_hat = (d .* M) + (((1 - d) / N) .* ones(N, N));
 
    while(norm(v - last_v, 2) > v_quadratic_error)
        last_v = v;
        v = M_hat * v;
      
    end

    [sortedX,sortingIndices] = sort(v,'descend'); % Sorting the similarity values in descending order
    sortingIndices = sortingIndices(1:k); % Retrieving top k most similar simulationsdisp(maxIndex); 

    map_row = ceil((k+1)/3);
    map_col = 3;
    
    for loop = 1:k
        % This loop generates heat maps for the 'k' similar simulations
        if choice == 'a' || choice == 'b'
            generate_heatmap(choice, '', strcat(directory, '/', files_list(sortingIndices(loop)+2, :)), map_row, map_col, loop, resolution);
        else
            generate_heatmap(choice, c_graph_file, files_list(sortingIndices(loop)+2, :), map_row, map_col, loop);
        end
    end 
  
end