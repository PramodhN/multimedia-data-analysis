function nq_matrix = get_nq_matrix(epidemic_file, resolution)
% Function to normalize and quantize the values in the epidemic file
% epidemic_file - The simulation file to be quantized
% resolution - The number of values to be quantized to
    mean_value = 0;
    standard_deviation = 0.25;
    
    [band, quant, point] = bqp(resolution, mean_value, standard_deviation); % Calculate band, point and quant values

    point(resolution) = 1; % Set last value of 'point' to 1 to avoid avoid minor change in its value (like 1.0000000001)
    
    A = csvread(epidemic_file, 1, 2); % Read the data file 1
    
    nq_matrix = normalize_matrix(A); % Normalized matrix
    nq_matrix = quantize_matrix(nq_matrix, point, quant, resolution); % nq_matrix_1 is now quantized
    
end