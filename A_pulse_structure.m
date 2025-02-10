clear; clc; close all

% parameters and path
folder = 'G:\공유 드라이브\BSL-Data\Processed_data\Hyundai_dataset\HNE_가속조건\4C 10 Li-plating';
filename = 'RPT CH13.mat';
Q0 = 55.5; %[Ah]


% data load
load([folder '\' filename])


% % visualization
 N_step = length(data);
% figure(1); hold on
% 
% for i = 1:N_step
% 
%     x = data(i).t; % sec
%     y1 = data(i).V; % V
%     y2 = data(i).I/Q0; % C-rate
% 
%     yyaxis left
%     plot(x,y1,'-')
%     yyaxis right
%     plot(x,y2,'-')
% 
% 
% end


% generate struct
pulse_num = 0;

for i = 1:N_step

    I_step_avg = mean(data(i).I/Q0);
    dt_step = data(i).t(end) -data(i).t(1);


    if (dt_step > 28 && dt_step < 32)&& (I_step_avg > 0.98 && I_step_avg < 1.02)
        pulse_num = pulse_num +1;
        pulse_struct(pulse_num).t = data(i).t;
        pulse_struct(pulse_num).V = data(i).V;
        pulse_struct(pulse_num).I = data(i).I;
        pulse_struct(pulse_num).OCV = data(i-1).V(end);


    end
 

end

clear i x y1 y2
i = 3;
x = pulse_struct(i).t;
y1 = pulse_struct(i).V-pulse_struct(i).OCV;
y2 = pulse_struct(i).I;

figure(2)
yyaxis left
plot(x,y1,'o-')
yyaxis right
plot(x,y2,'o-')