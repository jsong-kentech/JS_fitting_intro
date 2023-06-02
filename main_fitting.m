clear; clc; close all


% Load data
load("data.mat")

% Initial guess
para_0 = [0.5,1];
y_0 = func_model(x_data,para_0);

% fitting by cost function minimization
fhandle_cost = @(x)func_cost(x_data,y_data,x);
para_hat = fmincon(fhandle_cost,para_0,[],[],[],[],[0 0],[2 2]);
y_hat = func_model(x_data,para_hat);

figure(1); hold on
plot(x_data,y_data,'o')
plot(x_data,y_0,'-')
plot(x_data,y_hat,'-')
legend('data','initial guess','fitted model')





%% handy matlab built-in function
fit_func = fittype('func_model(x,[a,b])');
f = fit(x_data',y_data',fit_func,'StartPoint',para_0);
figure(1); hold on
plot(x_data,f(x_data),'--')
legend('data','initial guess','fitted model','fit2')
