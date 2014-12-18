function similar_simulations(new_file, new_dir, k, unique_vector,dir)
% This function reads a query file and displays k similar simulations to it in a given directory of simulations
% new_file - The query file
% new_dir - The directory in which the query file is present
% k - number of similar simulations to be displayed
% unique_vector - A vector containing the list of simulations that need to be process in the directory 'dir'

    new_file_with_dir = strcat(new_dir, '/', new_file);
    
    maxsize = max(size(unique_vector,1), size(unique_vector,2));
    
    for loop = 1 : maxsize
                file_name = strcat(dir, '/', num2str(unique_vector(loop)), '.csv');
                similarity(loop) = phase2task1a(new_file_with_dir, file_name); % Find the distance similarity between the query and simulations
    end
    
    [sortedX,sortingIndices] = sort(similarity,'descend'); % Sorting the similarity values in descending order
    sortingIndices = sortingIndices(1:k); % Retrieving top k most similar simulations

    k_similar_files = [];
    
    for loop = 1 : size(sortingIndices,2)
        k_similar_files = [k_similar_files unique_vector(sortingIndices(loop))]; 
        % Retreive the similar simulations in decreasing order of similarity
    end
    
    disp(['"t" similar simulations : ' num2str(k_similar_files)]);

end