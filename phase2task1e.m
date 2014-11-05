function similarity = phase2task1e(file_1, file_2)
    % Given two epidemic simulations files 
    % computes the similarity between them as 
    % simdiffword(f1, f2) = ~w1 ~w2,
    % where ~wi is a binary vector consisting of the difference words extracted from fi            
    epidemic_file_1 = strcat('epidemic_word_file_diff_',file_1);
    epidemic_file_2 = strcat('epidemic_word_file_diff_',file_2);
    A = csvread(epidemic_file_1, 0, 1);
    B = csvread(epidemic_file_2, 0, 1);
    similarity = similarity_value(A, B);

end