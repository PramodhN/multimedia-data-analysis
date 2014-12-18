function phase3task1a(L,k,dirr)
% This function reads a directory of simulation files and creates an in-memory index structure using Locality sensitive hashing
% L - The number of layers in hash structure
% k - Number of random hash functions in each layer
% dirr - Directory of existing simulation files

    files_list = ls(dirr);
    disp('Preparing dictionary ...');
    dictionary = get_unique_words(files_list); % Creating the dictionary for existing simulations
    
    feature_list = [];

    disp('Extracting features ...');
    for i = 1 : size(files_list,1)-2
        epidemic_file = strcat('epidemic_word_file_',num2str(i),'.csv');
        A = csvread(epidemic_file);
        for j = 1:size(dictionary, 1)
            words_presence = ismember(A(:,4:size(A,2)), dictionary(j, :), 'rows'); % Check for presence of each word from dictionary
            file_frequency(j) = sum(words_presence); % Count the number of times the word occurs in the document
        end
        file_frequency = file_frequency(file_frequency ~= max(file_frequency));
        feature_list = [feature_list; file_frequency]; % Creating the feature matrix for each file
    end
    
    w = 4;
    
    [band, quant, point] = bqp(size(feature_list,2), 0, 0.25); % Get the gaussian bands
    
    b = zeros(L,k);
    band_index = 1;
    
    disp('Creating index structure ...');
    for i = 1:L
        for j = 1:k
            randomband(band_index, :) = band(randperm(size(band,2))); % Random distribution of gaussian bands
            b(i, j) = randi(w, 1); % Random value between 0 and w
            for file = 1:size(feature_list,1)
                hash(i,j,file) = ((randomband(band_index, :) * feature_list(file,:)' + b(i, j))/w); 
                % Calculating the hash value using the random hash function for each file
            end
            band_index = band_index + 1;
        end
    end
    
    save('IndexStructure.mat','hash'); % Save the index structure in memory
    save('IndexVariables.mat','hash','dictionary','randomband','b');
    
    size_of_index_structure = dir('IndexStructure.mat');
    
    disp(['Size of index structure : ' num2str(getfield(size_of_index_structure, 'bytes')) ' bytes']); % Display the size of index structure

end