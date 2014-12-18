function phase3task1b(query_dir, query_file, t,dirr)
% This function reads a query file and finds its nearest neighbors using the index structure created in previous task
% query_dir - Directory of existing simulation files
% query_file - The file for which nearest neighbors needs to be found
% t - Number of similar simulations to be displayed

    input_values = csvread('InputValues.csv');
    resolution = input_values(1);
    window_size = input_values(2);
    shift_length = input_values(3);
    
    phase1task1(query_dir,resolution,window_size,shift_length);

    query_epidemic_file = strcat('epidemic_word_file_', query_file); % Set epidemic query file name
	load('IndexVariables.mat'); % Load the index structure and random hash function
    
    L = size(hash, 1);
    k = size(hash, 2);
    bytes_processed = hash;
    
    disp('Extracting features from query file ...');
    A = csvread(query_epidemic_file,0,1); % Read the query word file
    for j = 1:size(dictionary, 1)
        words_presence = ismember(A(:,3:size(A,2)), dictionary(j, :), 'rows'); % Check for presence of each word from dictionary
        file_frequency(j) = sum(words_presence); % Count the number of times the word occurs in the document
    end
	file_frequency = file_frequency(file_frequency ~= max(file_frequency(:))); % Create the feature array for query file
    
	disp('Creating index structure for query file ...');
    query_hash = zeros(L,k);
    band_index = 1;
    w = 4;
    for i = 1:L
        for j = 1:k
            query_hash(i, j) = ((randomband(band_index, :) * file_frequency' + b(i, j))/w); 
            % Calculating the hash value using the random hash function for query file
            band_index = band_index + 1;
        end
    end
    
    disp('Matching the buckets of query file with existing index structure ...');
    for i = 1:L
        for j = 1:k
            m = max(hash(i,j,:));
            condition = 1;
            pow = 0;
            while condition
                if m < 10
                    m = m * 10;
                    pow = pow + 1;
                else
                    condition = 0;
                end
            end
            hash(i,j,:) = floor(hash(i,j,:).* power(10,pow)); % Assigning buckets to each simulation
            query_hash(i, j) = floor(query_hash(i,j,:).* power(10,pow)); % Finding buckets for the query file
        end
    end
    
    bucket_index = 1;
    
    for i = 1:L
        for j = 1:k
            index = 1;
            for file = 1:size(hash,3)
                if hash(i,j,file) == query_hash(i,j)
                    bucket(bucket_index, index) = file; 
                    % Creating the bucket matrix which stores simulations in each L*k hash functions.
                    index = index + 1;
                end
            end
            bucket_index = bucket_index + 1;
        end
    end
    
    
    unique_vectors_array = [];
    for i = 1:size(bucket,1) % This loop identifies the length upto which the hash functions need to be processed to find 't' similar simulations
        row_array = bucket(i, :);
        unique_vectors_array = [unique_vectors_array (unique(row_array(row_array~=0)))];
        unique_vectors_array = unique(unique_vectors_array);
        if size(unique_vectors_array,2) > t
            break; % Break the loop when more than 't' similar simulations have been found
        end
    end
    
    j = ceil(i/L);
    bytes_processed = bytes_processed(1:j,:,:); % The amount of index structure processed to find nearest neighbors for the query
    j = j*L;
    overall_vectors = bucket(1:j,:);
    save('IndexProcessed.mat','bytes_processed');
    bucket = bucket(1:i,:);
    
    disp('Generating list of unique vectors ...');
    unique_vectors = unique(bucket(bucket~=0));
    
    disp(sprintf('\n'));
    disp('Finding "t" similar simulations ...');
    similar_simulations(query_file, query_dir, t, unique_vectors, dirr); % Display the similar simulations

    disp(sprintf('\n'));
    
    maxsize = max(size(unique_vectors,1), size(unique_vectors,2));
    disp(['Number of unique vectors considered : ' num2str(maxsize)]);

    disp(['Number of overall vectors considered : ' num2str(size(unique(overall_vectors(overall_vectors~=0)),1)*size(unique(overall_vectors(overall_vectors~=0)),2))]);
    
    processed_index_structure = dir('IndexProcessed.mat');
    disp(['Number of bytes processed from index : ' num2str(getfield(processed_index_structure, 'bytes')) ' bytes']);
    
end