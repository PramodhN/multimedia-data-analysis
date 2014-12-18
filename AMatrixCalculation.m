function similarity = AMatrixCalculation(f1, f2, connectivity_graph_file)

	%1. Read the connectivity graph.
    c_graph = csvread(connectivity_graph_file,1,1);
    paths_matrix = shortest_path_calculation(c_graph, 3);

	%2. Read files that contain the words
	F1 = csvread(f1, 0, 1);
	F2 = csvread(f2, 0, 1);
    
    first_column = ones(size(F1,1), 1);
    F1 = [first_column F1];
    F2 = [first_column F2];
	
	%ATS(i, j) contains the time similarity between word i of F1 and word j
    %of F2.
    ATS=zeros(rows(F1), rows(F2));
    max_time = max([max(F1(:, 3)), max(F2(:, 3))]);
    for i = 1:rows(ATS)
        for j = i:columns(ATS)
          ATS(i, j)=1-((abs(F1(i, 3)-F2(j, 3))/max_time))^4;
       end
    end
    
    
    %AD(i, j) contains the geographical similarity between word i of F1 and
    %word j of F2.
    AD=zeros(rows(F1), rows(F2));
    max_paths=max(max(paths_matrix));
    
    for i = 1:rows(AD)
        for j = i:columns(AD)
            AD(i, j) = (paths_matrix(F1(i, 2), F2(j, 2))/max_paths)^4;
        end
    end
	
    %ATSD contains the combination of measures in ATS and AD.
    ATSD = ATS.*AD;
	
    %Discrimination contains how discriminative are words i of F1 and word
    %j of F2.  Discrimination is an inverse concept to frequency.
    
    F1_words = F1(:, 4:columns(F1));
    F2_words = F2(:, 4:columns(F2));
    F1_word_count = zeros(rows(F1_words), 1);
    F2_word_count = zeros(rows(F2_words), 1);
    
    for i = 1:rows(F1_words)
       F1_word_count(i, 1) = sum(ismember(F1_words,F1_words(i, :), 'rows')); 
    end
    
    for i = 1:rows(F2_words)
        F2_word_count(i, 1) = sum(ismember(F2_words, F2_words(i, :), 'rows'));
    end
    
    DISCRIMINATION = zeros(rows(F1_words), rows(F2_words));
    
    rows_D=rows(DISCRIMINATION);
    cols_D=columns(DISCRIMINATION);
    for i = 1:rows_D
        for j = 1:cols_D
           DISCRIMINATION(i, j)=min([(1-(F1_word_count(i, 1)/rows_D)), (1-(F2_word_count(j, 1)/cols_D))]) ; 
        end
    end
    
    A = ATSD.*DISCRIMINATION;
	
	%5. Perform similarity computation.
	w1 = ones(1, rows(A));
	w2 = ones(columns(A), 1);
	similarity = w1*A*w2;

end


function paths_matrix = shortest_path_calculation(A, k)
	%% Given an adjacency matrix, this function returns a paths matrix
	%% paths_matrix(i, j) indicates the number of paths of length less than or equal to k
	%% between states i and j.
	
	paths_matrix=zeros(size(A,1), size(A,2));
	
	B=A;
	for i=1:k
		B = B*A;
		paths_matrix = paths_matrix + B;
    end
    
end