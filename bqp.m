function [band, quant, point] = bqp(r, mean, sd)
    % Return length of each 'band', value('quant') to be assigned to each
    % band, and 'point' of end of each band
    quant = 1:r;
    prevband = 0;
    band = 1:r;
    point = 1:r;
    band(1) = 0;
    for i = 1:r
        band(i) = gaussian_calc(mean, sd, (i-1)/r, i/r, r);         
        if i == 1
            quant(i) = band(i)/2;
            point(i) = band(i);
        else
            prevband = band(i-1) + prevband;
            quant(i) = prevband + (band(i)/2);
            point(i) = point(i-1) + band(i);
        end
    end
end