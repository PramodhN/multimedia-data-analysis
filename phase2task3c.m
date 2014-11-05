function phase2task3c(dir_name, r, choice, c_graph_file)
% Displays top 'r' latent semantics from a given set of documents using simulation - simulation score
% dir_name - The directory where the simulation files are placed
% r - Number of latent semantics to be returned
% choice - the similarity measure to be used for calculating the score

    if strcmp(dir_name,'')
        dir_name = '.'; 
    end
    
    files_list = ls(dir_name); % Read list of files in the directory   
    
    for outer_loop = 1 : size(files_list,1)-2 % This loop creates the simulation-simulation similarity matrix
        file_name_outer = strcat(num2str(outer_loop),'.csv'); % File that will be used in this iteration
        for inner_loop = 1 : size(files_list,1)-2
            file_name_inner = strcat(num2str(inner_loop),'.csv'); % Files that will be compared with the file in this interation
            switch choice % Choose appropriate similarity measure and get the similarity value
                case 'a'        
                  new_file = strcat(dir_name, '/', file_name_outer);
                  file_name_inner = strcat(dir_name, '/', file_name_inner);
                  similarity(outer_loop,inner_loop)= phase2task1a(new_file , file_name_inner);             
                case 'b'        
                  new_file = strcat(dir_name, '/',file_name_outer);
                  file_name_inner = strcat(dir_name, '/', file_name_inner);
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
    
    [U, S, V] = svd(similarity,'econ'); % Perform SVD on the simulation-simulation similarity matrix
    
    semantic_object_space =  U(:,1:r); % The latent semantic vectors
    
    r_latent_semantics = semantic_object_space(:,1:r);
    
    csvwrite('C_latent_semantics.csv',r_latent_semantics); % Store latent semantics to use in task 3f
    csvwrite('3c_V_Matrix.csv',V(:,1:r)); % Store V matrix to use in task 3f
    csvwrite('3c_S_Matrix.csv',S(1:r,1:r)); % Store S matrix to use in task 3f
    
    for i = 1:r
        [sortedX,sortingIndices] = sort(U(:,i),'descend'); % Ranking each latent semantic
        for j= 1:size(U(:,i),1)
            simulation_file(j,1) = sortingIndices(j); 
            simulation_score(j,1) = U(sortingIndices(j), i);
            % This loop finds out the <simulation file, simulation score> values
        end
        disp([simulation_file simulation_score]); % Display the latent semantic
    end 
end