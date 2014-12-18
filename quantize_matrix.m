function quantize = quantize_matrix(nq_matrix, point, quant, resolution)
% Return quantized matrix based on 'resolution' value
    for i = 1:resolution
        if i == 1
            nq_matrix(nq_matrix <= point(i)) = quant(i); % Quantizing first band
        else
            nq_matrix(nq_matrix <= point(i) & nq_matrix > point(i-1)) = quant(i); % Quantizing remaining bands
        end
    end 
    quantize = nq_matrix;
end