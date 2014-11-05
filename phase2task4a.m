function [X, pivot_table, mapping_error] = phase2task4a(dir, r, choice, c_graph_file)
% Maps a given NxN matrix to Nxk dimensions
% choice - Character value from 'a' to 'h' to choose the corresponding similarity measure
% r - Number of dimensions to be reduced to.
% dir - Directory where simulation files are present

    distance_matrix = createDistanceMatrix(choice, dir, c_graph_file); % creates NxN matrix
    
    [X, pivot_table, mapping_error] = getNkMatrix(distance_matrix, r); % gets the Nxk matrix and the pivot points used in each iteration
    
end