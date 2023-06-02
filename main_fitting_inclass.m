clear
clc
close all

% load data
load('data.mat')


figure(1); hold on
plot(x_data,y_data,'o')



% Initial guess

para_0 = [0.2, 0.7];
y_0 = func_model(x_data,para_0);

figure(1)
plot(x_data,y_0,'-')


% cost contour
para1_vec = 0:0.01:1;
para2_vec = 0.1:0.01:1.5;
for i = 1:length(para1_vec)
    for j = 1:length(para2_vec)

cost(i,j) = func_cost(x_data,y_data,[para1_vec(i),para2_vec(j)]);
    end
end

figure(2)
surface(para1_vec,para2_vec,cost')
figure(3); hold on
contourf(para1_vec,para2_vec,cost',50)
scatter(para_0(1),para_0(2),'o')
scatter(para_hat(1),para_hat(2),'o')

% Fitting (cost minimization)
fhandle_cost = @(para)func_cost(x_data,y_data,para);
para_hat = fmincon(fhandle_cost,para_0,[],[],[],[],[0,0],[2,2]);

y_hat = func_model(x_data,para_hat);

figure(1)
plot(x_data,y_hat,'-')
legend('data','initialguess','fittedmodel')