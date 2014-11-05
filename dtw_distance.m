function dtw = dtw_distance(A, B)
    % This function calculates the dynamic time warping distance among two matrices.
    % For Dynamic Time Warping (DTW), please, see E. Keogh, C. A. Ratanamahatana, Exact Indexing of Dynamic Time Warping

    sizeA = length(A);
    sizeB = length(B);
    DTW = zeros(sizeA + 1, sizeB + 1) + Inf;
    DTW(1, 1) = 0;
    
    cost_matrix = abs((repmat(A(:), 1, sizeA) - repmat(B(:)', sizeB, 1))); % Calculate cost values between each point repeatedly

    for m=1:sizeA
        for n=1:sizeB
            DTW (m+1,n+1) = cost_matrix(m, n) + min( [DTW(m, n+1), DTW(m+1, n), DTW(m, n)] ); 
            % Calculate the DTW value for the row
        end
    end
    
    dtw = DTW(sizeA+1, sizeB+1); % set the final value of the matrix to the dtw length
    
end