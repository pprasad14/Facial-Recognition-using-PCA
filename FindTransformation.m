function [A,b] = FindTransformation(F,Fd)

%% FIND THE AFFINE TRANSFORMATION FOR THE SET OF GIVEN POINTS
onesVec =  ones(size(F(:,2)));
zeroVec = zeros(size(F(:,2)));
%% FORMULATING THE LEAST SQUARES MATRIXES
Aprime1 = [ F(:,1) F(:,2) onesVec zeroVec zeroVec zeroVec];
Aprime2 = [ zeroVec zeroVec zeroVec F(:,1) F(:,2) onesVec];
Aprime =  [Aprime1 ; Aprime2];
bprime =  [Fd(:,1) ; Fd(:,2)];
%% USE THE PSEUDO INVERSE IN THE MATRIXES
x=pinv(Aprime)*bprime;
%% REGROUP THE TRASFORMATION
A=[x(1) x(2) ; x(4) x(5)];
b=[x(3) ; x(6)];



