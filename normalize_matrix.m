function normal_matrix = normalize_matrix(m)
    % Return normalized matrix for 'm' using its max and min values
    [rows, cols] = size(m);
    maxm = ones(rows,cols) * max(max(m)); % Matrix of all max values in 'm'
    minm = ones(rows,cols) * min(min(m)); % Matrix of all min values in 'm'
    if maxm == minm
        maxm = maxm + 0.0001;
    end
    normal_matrix = (m-minm)./(maxm-minm);
end