function phase3task3c(directory,choice,k,file_1,file_2)

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);

    files_list = ls(directory); 
    
    for i = 1 : size(files_list,1)-2
        l = strtrim(files_list(i+2, :));
        if strcmp(l,file_1)
            sim_file_1 = i;
        end
        if strcmp(l,file_2)
            sim_file_2 = i;
        end
    end
    
A = csvread('AdjacencyMatrix.csv');
Query = zeros(size(A,1),1);
Query(sim_file_1,1) = 0.5;
Query(sim_file_2,1) = 0.5;

U = Query;

for i = 1:size(A,2)
  A(:,i) = A(:,i) ./ sum(A(:,i));
end

prev = ones(size(A,1),1) .* 10;
   
c = 0.5;

V = U;


while(norm(U - prev, 2) > 0.01)
  prev = U;
  X = A * U;
  Y = (1-c) .* X;
  Z = c .* V;
  U = Y + Z;
end

U(sim_file_1,1) = 0;
U(sim_file_2,1) = 0;

    [sortedX,sortingIndices] = sort(U,'descend'); % Sorting the similarity values in descending order
    sortingIndices = sortingIndices(1:k); % Retrieving top k most similar simulationsdisp(maxIndex); 

    map_row = (ceil((k+1)/3))+1;
    map_col = 3;
    
    for loop = 1:k
        % This loop generates heat maps for the 'k' similar simulations
        if choice == 'a' || choice == 'b'
            generate_heatmap(choice, '', strcat(directory, '/', files_list(sortingIndices(loop)+2, :)), map_row, map_col, loop, resolution);
        else
            generate_heatmap(choice, c_graph_file, files_list(sortingIndices(loop)+2, :), map_row, map_col, loop);
        end
    end 
    if choice == 'a' || choice == 'b'
            generate_heatmap(choice, '', strcat(directory, '/', files_list(sim_file_1+2, :)), map_row, map_col, loop+1, resolution);
        else
            generate_heatmap(choice, c_graph_file, files_list(sim_file_1+2, :), map_row, map_col, loop);
    end    
    if choice == 'a' || choice == 'b'
            generate_heatmap(choice, '', strcat(directory, '/', files_list(sim_file_2+2, :)), map_row, map_col, loop+2, resolution);
        else
            generate_heatmap(choice, c_graph_file, files_list(sim_file_2+2, :), map_row, map_col, loop);
    end    

end




 




