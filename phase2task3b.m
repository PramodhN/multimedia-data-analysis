function phase2task3b(dirr, r, ALPHA, BETA)
% Function to find top 'r' latent semantics for a given set of simulation
% files using Latent Dirichlet Allocation
% r - number of latent semantics to be reported
% dirr - directory of existing simulations

    [WS,DS] = get_LDA_Input(dirr);
    
    if nargin < 3 % In case ALPHA and BETA are not entered, give default values
        ALPHA = 1;
        BETA = 0.01;
    end
    
    N = 300; % Set number of iterations to be used in Gibbs Sampler
    SEED = 3; % Sets the seed for the random number generator
    OUTPUT = 0; % Display minimal output
    
    cd LDA;
    [ WP,DP,Z ] = GibbsSamplerLDA( WS, DS, r, N, ALPHA, BETA, SEED, OUTPUT ); % Executing LDA package
    cd ..;
    
    DP = full(DP); % Extracting parse matrix
    total_docs = sum(DP, 2);
    DP = DP./total_docs(1);
    
	for i = 1:r
        [sortedX,sortingIndices] = sort(DP(:,i),'descend'); % Ranking each latent semantic
        for j= 1:size(DP(:,i),1)
            simulation_file(j,1) = sortingIndices(j); 
            simulation_score(j,1) = DP(sortingIndices(j), i);
            % This loop finds out the <simulation file, simulation score> values
        end
        disp([simulation_file simulation_score]); % Display the latent semantic
    end
    
    csvwrite('3b_DP_Matrix.csv',DP);
    
end