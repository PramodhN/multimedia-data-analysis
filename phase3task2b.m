function phase3task2b(query_dir, query_file, b, ksimulation)
% This function reads a directory of simulation files and bits per dimension and creates an in-memory index structure using VA indexing
% query_dir - Directory of where query file exists
% query_file - Query file name
% b - number of bits
% ksimulation - number of similar simulations required.

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);
    window_size = input_values(2);
    shift_length = input_values(3);
    
    phase1task1(query_dir, resolution, window_size, shift_length);
    
    epidemic_file = strcat('epidemic_word_file_',query_file);
    A = csvread(epidemic_file,0,1);

    onlyWordsQuery = A(:,3:end);
    bits_per_dimension = floor(b/size(onlyWordsQuery,2))+1;
    partitions = 2^bits_per_dimension; % Calculating the number of partitions   
    
    
	[band, quant, point] = bqp(partitions, 0, 0.25);
    
    for i=1:size(onlyWordsQuery,2)
        for j=1:partitions
            for k=1:size(onlyWordsQuery,1)
                if onlyWordsQuery(k,i) < point(j)
                    onlyWordsQuery(k,i) = j; % Partitioning the query
                end
            end
        end
    end    
    
    load('VAIndexStructure.mat'); % Loading the index structure
    
    meanQuery = mean(onlyWordsQuery);
    
    for i=1:(size(unique(onlyWords(:,1)),1))
        index1=(i-1)*size(onlyWordsQuery,1)+1;
        index2=i*size(onlyWordsQuery,1);
        fileMatrix = onlyWords(index1:index2,4:end);
        meanFileMatrix = mean(fileMatrix);
        distance(i)=pdist2(meanFileMatrix,meanQuery); % Finding the distance between query and simulation
    end
    onlyWords = onlyWords(:,4:end);
    sizeOfAccess = size(onlyWords,1)*bits_per_dimension/8;
    [sortedX,sortedIndices] = sort(distance);
    sortedIndices = sortedIndices(1:ksimulation); % k similar simulations
    disp(['Similar simulations : ' num2str(sortedIndices)]);
    disp(['Bytes of data processed : ' num2str(sizeOfAccess) ' bytes']);
    disp(['Number of compressed vectors needed : ' num2str(ksimulation)]);
end