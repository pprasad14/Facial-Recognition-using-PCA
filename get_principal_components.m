function [projectionPCA,k] = get_principal_components(eigenvalues,V)
    Deigen = 0;
    Teigen = sum(eigenvalues);
    k = 0;
    while(Deigen < 0.95*Teigen) 
        Deigen = sum(eigenvalues(end-k:end));
        k = k + 1;
    end

    projectionPCA = V(:, end-k:end);
end

