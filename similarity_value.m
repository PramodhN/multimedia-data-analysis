function similarity = similarity_value(A, B)
    % This function:
    % 1. Filters the matrices to create two smaller matrices uniqueA and uniqueB that only include unique rows from the original matrix.
    % 2. Creates a new matrix similarity_word that contains the rows that are contained in both uniqueA and uniqueB
    % 3. Returns the size of the similarity_word matrix
    
    [rows1, cols1] = size(A);
    [rows2, cols2] = size(B);
    
    uniqueA = unique(A(:,3:cols1), 'rows');
    uniqueB = unique(B(:,3:cols2), 'rows');
    similarity_word = intersect(uniqueA, uniqueB, 'rows');
    similarity = size(similarity_word, 1);
    
end


