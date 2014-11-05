function gauss = gaussian_calc(mean, sd, x, y, r)
% Return Gaussian length for given mean and standard deviation.
% x and y are the limits for the integral
    gauss_func = @(r)(1/ (sd * sqrt(2 * pi)) ) .* (exp((r-mean).*(mean-r)/(2 * sd * sd))); % Defining Gaussian function
    numerator = integral(gauss_func, x, y); 
    denominator = integral(gauss_func, 0, 1);
    gauss = numerator/denominator;
    
end