function [WS,DS] = get_LDA_Input(dirr)
% This function reads a set of simulation files and returns the following values
%
% WS - a 1 x |N| vector where |WS(k)| contains the vocabulary index of the kth word token, and |N| is the number of word tokens. 
% DS - a 1 x |N| vector where |DS(k)| contains the document index of the kth word token. 

    files_list = ls(dirr); % Read list of files in 'dirr'
    unique_words_list = get_unique_words(files_list); % Get the list of all dictionary words
    
    WS = [];
    DS = [];
    
    for loop = 1 : size(files_list,1)-2 
        file_name = strcat('epidemic_word_file_',num2str(loop),'.csv');
        A = csvread(file_name, 0, 1);
       [presence_matrix presence_locations] = ismember(A(:,3:size(A,2)), unique_words_list, 'rows'); % Check presence of dictionary words in each file
       WS = [WS presence_locations']; % Store location of word in dictionary for all files
       DS = [DS (ones(1, size(A,1)).*loop)]; % Store file names for the new set of words
    end
    
end







