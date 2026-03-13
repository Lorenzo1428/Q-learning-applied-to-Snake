clc
clear
close all

M = load('save80000.mat').Q;
%N = nonzeros(Q)
%length(nonzeros(M))
dec2bin(338,12);
[rows ~] = find(M);
M = M(~all(M == 0, 2),:);
%length(nonzeros(M))