


para_true = [0.39, 0.97];
x_data = 0:0.2:10;


y_true = func_model(x_data,para_true);

figure(1)
plot(x_data,y_true,'-r'); hold on



y_noise = y_true.*normrnd(0,0.02,size(y_true));
y_data = y_true + y_noise;

plot(x_data,y_data,'ob')

save('data.mat','x_data','y_data')