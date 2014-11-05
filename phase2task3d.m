function  phase2task3d(query_file_name, query_directory, k, algo_choice, dir_name, similarity_measure_choice, c_graph_file)
% Displays k most similar simulations to the given input query
% query_file_name - The name of the file to be used for querying
% query_directory - The directory in which the query file is placed
% k - The number of nearest neighbors to be displayed
% dir_name - The directory where the simulation files are placed
% algo_choice - Takes value 'a' or 'b' or 'c' to choose which operation needs to be done to find k nearest neighbors
% similarity_measure_choice - the similarity measure to be used for calculating the score in case of task 3f
    
    input_values = csvread('InputValues.csv');
    resolution = input_values(1);

    switch(algo_choice) 
        case 'c' 
        	Query_distances = find_query_similarity_score(query_file_name, query_directory, similarity_measure_choice ,dir_name,c_graph_file);
            V_Matrix = csvread('3c_V_Matrix.csv');
    		S_Matrix = csvread('3c_S_Matrix.csv');
            Document_concept_space = csvread('C_latent_semantics.csv'); % Read the 'r' latent semantics
            Query_cordinates = Query_distances * V_Matrix * inv(S_Matrix); % Map the new query to the existing 'r' latent semantics
            display_k_most_similar_files(Document_concept_space,Query_cordinates,k); 
        case 'a'
            Query_feauture_vector = get_query_feature_vector(query_file_name);	   
    		V_Matrix = csvread('3a_V_Matrix.csv');
    		S_Matrix = csvread('3a_S_Matrix.csv');
            Document_concept_space = csvread('3a_U_Matrix.csv');
            Query_cordinates = Query_feauture_vector * V_Matrix * inv(S_Matrix);
            display_k_most_similar_files(Document_concept_space,Query_cordinates,k);			                
        case 'b'
            ExistingDP = csvread('3b_DP_Matrix.csv');
            DP = create_new_LDA(dir_name, query_file_name, size(ExistingDP,2));
            DP = full(DP);
            display_k_most_similar_files(DP(1:(size(DP,1)-1), :), DP(size(DP,1), :), k);
    end
end

function Query_distances = find_query_similarity_score(query_file_name,query_directory, similarity_measure_choice ,dir_name,c_graph_file)       
% This function returns the similarity value between the query file and each of the existing simulation files 

    if strcmp(dir_name,'')
        dir_name = '.'; 
    end
    if similarity_measure_choice == 'a' || similarity_measure_choice == 'b'
        query_file_name = strcat(query_directory, '/', query_file_name);
    end

    files_list = ls(dir_name); % Read list of files in the directory   
    switch(similarity_measure_choice)
        case 'a'
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(dir_name, '/', num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1a(query_file_name,file_name);
               end
        case 'b'
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(dir_name, '/', num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1b(query_file_name,file_name);
               end
        case 'c'
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1c(query_file_name,file_name);
               end
        case 'd'
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1d(query_file_name,file_name);
               end
        case 'e'             
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1e(query_file_name,file_name);
               end
        case 'f'             
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1f(query_file_name,file_name, c_graph_file);
               end
        case 'g'             
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1g(query_file_name,file_name, c_graph_file);
               end
        case 'h'             
               for i = 1:size(files_list,1)-2 
                    file_name= strcat(num2str(i), '.csv');
                    Query_distances(1,i) = phase2task1h(query_file_name,file_name, c_graph_file);
               end
        end
end

             
function Query_vector = get_query_feature_vector(query_file_name)
% This function returns the number of words present in the new query
% document compared to the dictionary of words

	file_name  = strcat('epidemic_word_file_',query_file_name);
	unique_words_list = csvread('UniqueWords.csv');
	A = csvread(file_name, 0, 1);
	for i = 1:size(unique_words_list, 1)
        words_presence = ismember(A(:,3:size(A,2)), unique_words_list(i, :), 'rows'); % Check for presence of each word from dictionary
        Query_vector(1, i) = sum(words_presence); % Count the number of times the word occurs in the document
    end
end
 
function display_k_most_similar_files(Document_concept_space,Query_cordinates,k)
% This function displays the 'k' most similar simulations to the given
% query file

	for i = 1:size(Document_concept_space,1)
        document_vector = Document_concept_space(i,:);
        euc_dist_mat = abs(document_vector - Query_cordinates);
        euc_dist = 0;
        for j =1:size(euc_dist_mat,2)
            euc_dist = euc_dist + euc_dist_mat(1,j);
        end
        euc_distance(i,1) = euc_dist;
	end
                
    [sortedValues,sortIndex] = sort(euc_distance(:),'ascend');  
    
	maxIndex = sortIndex(1:k);  %# Get a linear index into A of the 'k' similar values
 	for i = 1:size(maxIndex,1)
 	    disp(maxIndex(i,1));
	end
	                                                      
end

function DP = create_new_LDA(dir_name, query_file_name, r)
 
    [WS,DS] = get_LDA_Input(dir_name);
    file_num = max(DS) + 1;
    
    files_list = ls(dir_name);
    unique_words_list = get_unique_words(files_list);
        
    N = 300; % Set number of iterations to be used in Gibbs Sampler
    SEED = 3; % Sets the seed for the random number generator
    OUTPUT = 0; % Display minimal output
    ALPHA = 1;
    BETA = 0.01;
    
    file_name = strcat('epidemic_word_file_',query_file_name);
    A = csvread(file_name, 0, 1);
    [presence_matrix presence_locations] = ismember(A(:,3:size(A,2)), unique_words_list, 'rows'); % Check presence of dictionary words in each file

    WS = [WS presence_locations']; % Store location of word in dictionary for all files
    DS = [DS (ones(1, size(A,1)))*file_num]; % Store file name for the new words
            
    cd LDA;
    [ WP,DP,Z ] = GibbsSamplerLDA( WS, DS, r, N, ALPHA, BETA, SEED, OUTPUT ); % Executing LDA package
    cd ..;
    
    total_docs = sum(DP, 2);
    DP = DP./total_docs(1);
    
end