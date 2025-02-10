clear; clc; close all

% parameters
Q0 =55.5;


load('G:\공유 드라이브\BSL-Data\Processed_data\Hyundai_dataset\HNE_가속조건\4C 10 Li-plating\RPT CH13.mat')

N_step=length(data);
figure(1)
hold on

for i = 1:N_step

    x = data(i).t;
    y1 = data(i).V;
    y2 = data(i).I/Q0;
    yyaxis left
    plot(x,y1,'-')
    yyaxis right
    plot(x,y2,'-')


end
hold off