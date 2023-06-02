function [y] = func_model(t,para)


% t is the function argument (1-variable)
% para is a parameter vector (2-component vector)
% y is the function output (1-variable)

y = 1-exp(-para(1)*t.^para(2));




end

