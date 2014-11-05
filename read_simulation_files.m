function [A, B, rows1, cols1, rows2, cols2] = read_simulation_files(file1_path, file2_path)
    %This function reads simulation files and returns those files as matrices A and B.
    %It also returns the dimensions of those two matrices in fields rows1, cols1, rows2, cols2
    
    A = read_simulation_file(file1_path);
    B = read_simulation_file(file2_path);
    [rows1, cols1] = size(A);
    [rows2, cols2] = size(B);

end

function A = read_simulation_file(file1)
    %This function takes as input the path to a simulation file and returns the content represented as a matrix.
    A = csvread(file1, 0, 1);
    
end

