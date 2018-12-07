function [eigenvalues , V] = get_eigenvalues(Dfaces , p)
    SIGMA = (1/(p-1)) * (Dfaces'*Dfaces);
    [V,D,W] = eig(SIGMA);
    eigenvalues = eig(SIGMA);
end

