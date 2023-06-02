clear; clc; close all


%% data visualization
load("data.mat")
figure(1)
plot(x_data,y_data,'o')




%% function visualization
x_vec = 0:0.1:10;
para_0 = [0.5,1];
y_model = func_model(x_vec,para_0);
figure(1); hold on;
plot(x_vec,y_model,'-')


%% cost function visualization
para1_vec = 0.05:0.05:1;
para2_vec = 0.5:0.02:1.5;
for i = 1:length(para1_vec)
    for j = 1:length(para2_vec)
        para_ij = [para1_vec(i),para2_vec(j)];
        cost(i,j) = func_cost(x_data,y_data,para_ij);
    end
end

figure(2)
surface(para1_vec,para2_vec,cost')
figure(3)
contourf(para1_vec,para2_vec,cost',50)

%% 