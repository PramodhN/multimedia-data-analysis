function [pivot1, pivot2] = choose_pivots(distance_matrix)
% Function to choose pivot points for a given distance matrix

    [max_value, max_index] = max(distance_matrix(:)); % Get the longest distance and its index
    pivot1 = ceil(max_index/size(distance_matrix, 1)); % First pivot value - column number
    pivot2 = mod(max_index, size(distance_matrix, 2)); % Second pivot value - row number
    if pivot2 == 0
        pivot2 = size(distance_matrix, 2);
    end
    
end