function similarity = phase2task1g(f1, f2, connectivity_graph_file)
    % Given two epidemic simulations files and a connectivity graph file
    % computes the similarity between them as 
    % simavg(f1, f2) = ~w1 * A * ~w2,
    % where ~wi is a binary vector consisting of the words extracted from
    % fi and 'A' that measures how close the state time pair, si and ti, 
    % is to the state time pair, sj and tj and how discriminating the windows,~wini
    % and ~winj , are in the database.

    epidemic_file_1 = strcat('epidemic_word_file_avg_',f1);
    epidemic_file_2 = strcat('epidemic_word_file_avg_',f2);
    
    similarity = AMatrixCalculation(epidemic_file_1, epidemic_file_2, connectivity_graph_file);
    
end