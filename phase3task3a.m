function phase3task3a(dir_name, choice, threshold)
% Creates adjacency matrix using 
% dir_name - The directory where the simulation files are placed
% choice - the similarity measure to be used for calculating the score
% threshold - threshold value beyond which there will be an edge between two nodes(simulation files)

    if strcmp(dir_name,'')
        dir_name = '.'; 
    end
    
    files_list = ls(dir_name); % Read list of files in the directory   
    adjacency_matrix = [];
    for outer_loop = 1 : size(files_list,1)-2 % This loop creates the simulation-simulation similarity matrix
        file_name_outer = strtrim(files_list(outer_loop+2, :)); % File that will be used in this iteration
        for inner_loop = outer_loop : size(files_list,1)-2
            file_name_inner = strtrim(files_list(inner_loop+2, :)); % Files that will be compared with the file in this interation
            disp([file_name_outer file_name_inner]);
            switch choice % Choose appropriate similarity measure and get the adjacency_matrix value
                case 'a'        
                    new_file = strcat(dir_name, '/', file_name_outer);
                    file_name_inner = strcat(dir_name, '/', file_name_inner);
                    sim_value = phase2task1a(new_file , file_name_inner);
                    if(sim_value > threshold)
                        adjacency_matrix(outer_loop,inner_loop) = sim_value;
                        adjacency_matrix(inner_loop,outer_loop) = sim_value;
                    else
                        adjacency_matrix(outer_loop,inner_loop) = 0;	
                        adjacency_matrix(inner_loop,outer_loop) = 0;
                    end	              
                case 'b'        
                    new_file = strcat(dir_name, '/',file_name_outer);
                    file_name_inner = strcat(dir_name, '/', file_name_inner);
                    sim_value = phase2task1b(new_file, file_name_inner);
                    if(sim_value > threshold)
                        adjacency_matrix(outer_loop,inner_loop) = sim_value;
                        adjacency_matrix(inner_loop,outer_loop) = sim_value;
                    else
                        adjacency_matrix(outer_loop,inner_loop) = 0;
                        adjacency_matrix(inner_loop,outer_loop) = 0;
                    end		                        
                case 'c'
                    sim_value = phase2task1c(file_name_outer, file_name_inner);
                    if(sim_value > threshold)
                        adjacency_matrix(outer_loop,inner_loop) = sim_value;
                        adjacency_matrix(inner_loop,outer_loop) = sim_value;
                    else
                        adjacency_matrix(outer_loop,inner_loop) = 0;
                        adjacency_matrix(inner_loop,outer_loop) = 0;
                    end
                case 'd'
                    sim_value = phase2task1d(file_name_outer, file_name_inner); 
                    if(sim_value > threshold)
                        adjacency_matrix(outer_loop,inner_loop) = sim_value;
                        adjacency_matrix(inner_loop,outer_loop) = sim_value;
                    else
                        adjacency_matrix(outer_loop,inner_loop) = 0;
                        adjacency_matrix(inner_loop,outer_loop) = 0;
                    end
                case 'e'
                    sim_value= phase2task1e(file_name_outer, file_name_inner);   
                    if(sim_value > threshold)
                        adjacency_matrix(outer_loop,inner_loop) = sim_value;
                        adjacency_matrix(inner_loop,outer_loop) = sim_value;
                    else
                        adjacency_matrix(outer_loop,inner_loop) = 0;
                        adjacency_matrix(inner_loop,outer_loop) = 0;
                    end
            end
        end
    end

    csvwrite('AdjacencyMatrix.csv',adjacency_matrix); %store the adjacency matrix
end
