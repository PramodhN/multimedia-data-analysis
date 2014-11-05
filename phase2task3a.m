function phase2task3a(dirr, r)
% Displays top 'r' latent semantics from a given set of documents
% dirr - The directory where the simulation files are placed
% r - Number of latent semantics to be returned

    if strcmp(dirr,'')
        dirr = '.'; % In case the given directory is current directory, set dir to '.'
    end
    
    files_list = ls(dirr); % Read list of files in 'dir'
    
    unique_words_list = get_unique_words(files_list); % Get the dictionary of words
        
    for loop = 1 : size(files_list,1)-2 
        file_name = strcat('epidemic_word_file_',num2str(loop),'.csv');
        A = csvread(file_name, 0, 1);
        for i = 1:size(unique_words_list, 1)
            words_presence = ismember(A(:,3:size(A,2)), unique_words_list(i, :), 'rows'); % Check for presence of each word from dictionary
            document_term_matrix(loop, i) = sum(words_presence); % Count the number of times the word occurs in the document
        end
    end
    [U, S, V] = svd(document_term_matrix, 'econ'); % Performing SVD

    for i = 1:r
        [sortedX,sortingIndices] = sort(U(:,i),'descend'); % Ranking each latent semantic
        for j= 1:size(U(:,i),1)
            simulation_file(j,1) = sortingIndices(j); 
            simulation_score(j,1) = U(sortingIndices(j), i);
            % This loop finds out the <simulation file, simulation score> values
        end
        disp([simulation_file simulation_score]); % Display the latent semantic
    end
    
    csvwrite('UniqueWords.csv',unique_words_list) % Saving the dictionary in a file for task 3(d)
    csvwrite('3a_U_Matrix.csv',U(:,1:r));
    csvwrite('3a_V_Matrix.csv',V(:,1:r));
    csvwrite('3a_S_Matrix.csv',S(1:r,1:r));

end