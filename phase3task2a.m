function phase3task2a(dirr,b)
% This function reads a directory of simulation files and bits per dimension and creates an in-memory index structure using VA indexing
% dirr - Directory of existing simulation files
% b - Number of bits
    files_list = ls(dirr);
    combinedWordFile = [];
    for i = 1 : size(files_list,1)-2 % creating a combined wordfile of all the epidemic word files
        epidemic_file = strcat('epidemic_word_file_',num2str(i),'.csv');
        A = csvread(epidemic_file);
        combinedWordFile = [combinedWordFile; A];
    end
    onlyWords = combinedWordFile(:,4:end);
    bits_per_dimension = floor(b/size(onlyWords,2))+1;
    partitions = 2^bits_per_dimension; % Calculating the number of partitions
        
    [band, quant, point] = bqp(partitions, 0, 0.25); % Find the partition points

    index_structure = [];
    for i=1:size(onlyWords,2)
        for j=1:partitions
            for k=1:size(onlyWords,1)
                if onlyWords(k,i) < point(j)
                    onlyWords(k,i) = j; % Assigning partition to the point
                end
            end
        end
    end
    onlyWords = [combinedWordFile(:,1:3) onlyWords]; % Creating the complete index
    save('VAIndexStructure.mat','onlyWords'); % Storing the index structure
    
    size_of_index_structure = dir('VAIndexStructure.mat');
    
    disp(['Size of index structure : ' num2str(getfield(size_of_index_structure, 'bytes')) ' bytes']); % Display the size of index structure
    
end