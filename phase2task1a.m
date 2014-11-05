function similarity = phase2task1a(epidemic_file_1, epidemic_file_2)
    % This funciton reads 2 epidemic simulation files, computes the
    % similarity between them using eucledian distance

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);    
    
    nq_matrix_1 = get_nq_matrix(epidemic_file_1, resolution);
    nq_matrix_2 = get_nq_matrix(epidemic_file_2, resolution);
        
    for i=1:size(nq_matrix_1,2)
        % Calculating the eucledian distance between the points
        distance_array(i) = pdist2(transpose(nq_matrix_1(:,i)), transpose(nq_matrix_2(:,i))); % Calculating eucledian distance between each states of file 1 and 2
    end
    
    similarity = 1/(1+(mean(distance_array))); 

end