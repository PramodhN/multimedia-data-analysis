function [X, pivot_table, mapping_error] = getNkMatrix(distance_matrix, r)
% Function that returns a Nxr matrix from given NxN distance matrix

    for i=1:r
        [pivot1, pivot2] = choose_pivots(distance_matrix); % Get the pivot points for this distance matrix
        pivot_table(1, i) = pivot1;
        pivot_table(2, i) = pivot2; % Adding pivot points to the pivot table
        
        if distance_matrix(pivot1, pivot2) == 0
            for j=1:size(distance_matrix, 1)
                X(j, i)=0;
            end
            return
        end
        
        for j=1:size(distance_matrix, 1)
            % Find xi value for the given point using the pivots
            X(j, i) = (((distance_matrix(pivot1, j))^2) + ((distance_matrix(pivot1, pivot2))^2) - ((distance_matrix(pivot2, j))^2)) / (2*(distance_matrix(pivot1, pivot2)));
        end
        
        temp_distance_matrix = distance_matrix;
        
        for j=1:size(distance_matrix, 1)
            for k=1:size(distance_matrix, 1)
                % Update the column entry one by one until 'r' columns
                distance_matrix(j, k) = sqrt( abs ((distance_matrix(j, k)^2) - ((X(j, i) - X(k, i))^2)) );
            end
        end
        
        mapping_error(i) = abs(sum(distance_matrix(:)) - sum(temp_distance_matrix(:)));
        
    end
    %End loop
end