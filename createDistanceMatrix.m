function distance_matrix = createDistanceMatrix(choice, dir, c_graph_file)
% Function to create distance matrix for simulation files in a given directory
% choice - The choice for similarity measure to be used - 'a' to 'h'
% dir - directory of existing files
% resolution - resolution value to be used in case of choice 'a' or 'b'

    if strcmp(dir,'')
        dir = '.'; 
    end
    
    files_list = ls(dir); % Read list of files in the directory
    
    for outer_loop = 1 : size(files_list,1)-2 
        file_name_outer = strcat(num2str(outer_loop),'.csv'); % File that will be used in this iteration
        for inner_loop = 1 : size(files_list,1)-2
            file_name_inner = strcat(num2str(inner_loop),'.csv'); % Files that will be compared with the file in this interation
            switch choice % Choose appropriate similarity measure and get the similarity value
                case 'a'        
                  new_file = strcat(dir, '/', file_name_outer);
                  file_name_inner = strcat(dir, '/', file_name_inner);
                  similarity(outer_loop,inner_loop)= phase2task1a(new_file , file_name_inner);             
                case 'b'        
                  new_file = strcat(dir, '/',file_name_outer);
                  file_name_inner = strcat(dir, '/', file_name_inner);
                  similarity(outer_loop,inner_loop)= phase2task1b(new_file, file_name_inner);                        
                case 'c'
                  similarity(outer_loop,inner_loop)= phase2task1c(file_name_outer, file_name_inner);   
                case 'd'
                  similarity(outer_loop,inner_loop)= phase2task1d(file_name_outer, file_name_inner); 
                case 'e'
                  similarity(outer_loop,inner_loop)= phase2task1e(file_name_outer, file_name_inner);   
                case 'f'
                  similarity(outer_loop,inner_loop)= phase2task1f(file_name_outer, file_name_inner, c_graph_file);  
                case 'g'
                  similarity(outer_loop,inner_loop)= phase2task1g(file_name_outer, file_name_inner, c_graph_file);  
                case 'h'
                  similarity(outer_loop,inner_loop)= phase2task1h(file_name_outer, file_name_inner, c_graph_file);  
            end
        end
    end
    
    epsilon = 0.00001;
    distance_matrix = abs((1./(similarity + epsilon)));
    distance_matrix(1 : size(distance_matrix,1)+1 : size(distance_matrix,1)^2) = 0;
    % Since distance varies inversely with similarity, reversing the values in similarity matrix
            
end