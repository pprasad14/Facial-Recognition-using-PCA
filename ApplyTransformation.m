function [Fprime] = ApplyTransformation(A, b, F)
%% APPLY TRANSFORMATION to the set of points 
Fprime = (A*F'+b)';
