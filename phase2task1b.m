function similarity_dtw = phase2task1b(epidemic_file_1, epidemic_file_2, resolution)
    % This funciton reads 2 epidemic simulation files, computes the
    % similarity between them using Dynamic Time Warping

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);    
    
    nq_matrix_1 = get_nq_matrix(epidemic_file_1, resolution);
    nq_matrix_2 = get_nq_matrix(epidemic_file_2, resolution);
    
    for i=1:size(nq_matrix_1,2)
        dtw_distance_array(i) = dtw_distance(transpose(nq_matrix_1(:,i)), transpose(nq_matrix_2(:,i))); % Calling the DTW method to calculate distance
    end
    
    similarity_dtw = 1/(1+(mean(dtw_distance_array)));
    
end
