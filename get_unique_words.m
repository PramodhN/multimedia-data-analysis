function dictionary = get_unique_words(files_list)
%This function reads a list of file names and creates a list of all words
%in these files. Then it returns a set of unique words obtained from all
%the given simulation files
    words_list = [];
    for loop = 3 : size(files_list,1) % loop starts from 3 becase 1 and 2 have '.' and '..' respectively from ls() 
        L = strtrim(files_list(loop, :)); % Store each file name in directory 'd' one by one
        file_name = strcat('epidemic_word_file_',L);
        A = csvread(file_name, 0, 1);
        uniqueA = unique(A(:,3:size(A,2)), 'rows'); % Getting list of words present in the file
        words_list = [words_list; uniqueA]; % Adding the words to the dictionary
    end
    
    dictionary = unique(words_list, 'rows'); % Picking out the unique words from the dictionary
end