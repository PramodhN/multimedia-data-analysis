function phase2task4b(r, choice, k, new_dir, new_file, X, pivot_table, dir, c_graph_file)
% Function to display k most similar simulations to the query file in r dimension space
% r - Number of dimensions
% choice - Takes value from 'a' to 'h' to compute the similarity to use while mapping to 'r' dimensional space
% k - Number of similar simulations to be displayed
% new_dir - directory of query file
% new_file - the query file to be used
% X - obtained from task 4a - The Nxr matrix
% pivot_table - obtained from task 4a - The pivot points used in each iteration
% dir - Directory of existing simulation files

    input_values = csvread('InputValues.csv');
    res = input_values(1);

    epsilon = 0.00001;
    
    if choice == 'a' || choice == 'b'
        new_file = strcat(new_dir, '/', new_file);
    end
    
    for j = 1:r
        % This loop computes the value to be used by the query file in each dimension
        simulation_file_1=strcat(num2str(pivot_table(1,j)),'.csv');
        simulation_file_2=strcat(num2str(pivot_table(2,j)),'.csv');        
        switch choice
            case 'a'
                simulation_file_1=strcat(dir, '/', num2str(pivot_table(1,j)), '.csv');
                simulation_file_2=strcat(dir, '/', num2str(pivot_table(2,j)), '.csv');
                value1 = (1./(phase2task1a(simulation_file_1, new_file) + epsilon));
                value3 = (1./(phase2task1a(simulation_file_2, new_file) + epsilon));
            case 'b'
                simulation_file_1=strcat(dir, '/', num2str(pivot_table(1,j)), '.csv');
                simulation_file_2=strcat(dir, '/', num2str(pivot_table(2,j)), '.csv');
                value1 = (1./(phase2task1b(simulation_file_1, new_file) + epsilon));
                value3 = (1./(phase2task1b(simulation_file_2, new_file) + epsilon));
            case 'c'
                value1 = (1./(phase2task1c(simulation_file_1, new_file) + epsilon));
                value3 = (1./(phase2task1c(simulation_file_2, new_file) + epsilon));
            case 'd'
                value1 = (1./(phase2task1d(simulation_file_1, new_file) + epsilon));
                value3 = (1./(phase2task1d(simulation_file_2, new_file) + epsilon));
            case 'e'
                value1 = (1./(phase2task1e(simulation_file_1, new_file) + epsilon));
                value3 = (1./(phase2task1e(simulation_file_2, new_file) + epsilon));
            case 'f'
                value1 = (1./(phase2task1f(simulation_file_1, new_file, c_graph_file) + epsilon));
                value3 = (1./(phase2task1f(simulation_file_2, new_file, c_graph_file) + epsilon));
            case 'g'
                value1 = (1./(phase2task1g(simulation_file_1, new_file, c_graph_file) + epsilon));
                value3 = (1./(phase2task1g(simulation_file_2, new_file, c_graph_file) + epsilon));
            case 'h'
                value1 = (1./(phase2task1h(simulation_file_1, new_file, c_graph_file) + epsilon));
                value3 = (1./(phase2task1h(simulation_file_2, new_file, c_graph_file) + epsilon));
        end
        value2 = max(X(:,j));
        new(j) = abs(((value1^2) + (value2^2) - (value3^2)) / (2 * value2)); % Using xi formula from FastMap algorithm to map the new file to i-th dimension
    end

    X = [X; new]; % Adding the query file points to the existing Nxr matrix
    
    for j = 1:(size(X,1)-1)
        distance(j) = pdist2(X(j,:),X(size(X,1),:));
    end
    
    [sortedX,sortingIndices] = sort(distance,'ascend');
    sortingIndices = sortingIndices(1:k); % Retrieve the top 'k' similar indices
    
    disp(sortingIndices);
end