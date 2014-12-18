function phase3task4a(dirr,label_file,K)
% Labels the incoming query file using the pre-existing training set given.
% dirr - The directory where the simulation files are placed
% K - number of neighbors to look for 
% label_file - training set

    file_names=[];
    [labels,files]=xlsread(label_file);
    files=files(2:size(files),1);
    files=char(files);
    
    disp('Reading the label file ...');
    for i=1:size(files)
        a=strsplit(files(i,:),'.');
        a=char(a);
        num=str2num(a(1,:));
        file_names=[file_names;num];
    end

    if strcmp(dirr,'')
        dirr = '.'; % In case the given directory is current directory, set dir to '.'
    end
    
    files_list = ls(dirr); % Read list of files in 'dir'
    
    unique_words_list = csvread('UniqueWords.csv'); % Get the dictionary of words
      
    for loop = 1 : size(files_list,1)-2
        L = strtrim(files_list(loop+2, :));
        file_name = strcat('epidemic_word_file_',L);
        A = csvread(file_name, 0, 1);
        for i = 1:size(unique_words_list, 1)
            words_presence = ismember(A(:,3:size(A,2)), unique_words_list(i, :), 'rows'); % Check for presence of each word from dictionary
            document_term_matrix(loop, i) = sum(words_presence); % Count the number of times the word occurs in the document
        end
    end
    csvwrite('DocumentTermMatrix.csv',document_term_matrix);
    a=document_term_matrix;

    [row,col]=size(document_term_matrix);
    
    [frow,fcol]=size(file_names);
    dist=zeros(row,frow);

    if(K>frow)
        disp('number of neighbors greater than number of labeled files, enter a smaller number');
        return
    end
    
    % Calculating the distance matrix
    for i=1:row
        for j=1:frow
            dist(i,j)=norm(a(i,:)-a(j,:));
        end
    end

    % Labeling all the unlabeled files and writing them to a CSV file
    for query = 1 : size(files_list,1)-2 
        [vals,indices]=sort(dist(query,:));
        ret=[query,mode(labels(indices(1:1+K),1))];
        dlmwrite('OutputLabels.csv',ret,'delimiter',',','-append');
    end

end