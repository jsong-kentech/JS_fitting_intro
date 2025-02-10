clear; clc; close all

% hyper parameters
filename = 'postprocessing_HPPC.mat';
c_mat = lines(9);
tau1_0 = 5; % [sec]
tau2_0 = 60;

% data
load(filename)

for i_pulse = 1:size(n1C_pulse,1)

    x = n1C_pulse.t{i_pulse,1}-n1C_pulse.t{i_pulse,1}(1);
    y1 = n1C_pulse.V{i_pulse,1}-n1C_pulse.V_final(i_pulse); % dV from OCV
    y2 = n1C_pulse.I{i_pulse,1};



figure(1)
subplot(5,2,i_pulse)
%yyaxis left
plot(x, y1,'o','Color',c_mat(1,:))
ylim([1.1*min(y1) 0])
%yyaxis right
%plot(x, y2,'o')
%ylim([1.1*min(y2) 0])


% model visualization

para0 = [abs(y1(1))/abs(y2(1)) abs(y1(end) - y1(1))/abs(y2(1))/2 tau1_0 abs(y1(end) - y1(1))/abs(y2(1))/2 tau2_0]; % initial guess
y_model = func_2RC(x,y2,para0);

hold on
%yyaxis left
plot(x,y_model,'-','Color',c_mat(2,:))

% legend({})


%% fitting CASE 1
% initial guess
    %para0
% bound 
    lb= [0 0 1 0 1];
    ub = para0*10;
% weight
    weight = ones(size(y1)); % uniform weighting

% fitting
        options = optimset('display','iter','MaxIter',400,'MaxFunEvals',1e5,...
        'TolFun',1e-10,'TolX',1e-8,'FinDiffType','central');    
        para_hat = fmincon(@(para)func_cost(y1,para,x,y2,weight),para0,[],[],[],[],lb,ub,[],options);
    
% visualize
    y_model_hat = func_2RC(x,y2,para_hat);

%    yyaxis left
    plot(x,y_model_hat,'-','Color',c_mat(3,:))



end
% %% initial guess
% 
% para0_mat =[para0; 0.001 0.001 65; 0.0013 0.0018*2 60; 0.0013 0.0018 60*1.5; 0.0013*0.6 0.0018*0.5 60];
% 
% 
% for i = 1: size(para0_mat,1)
% 
% 
%     para0 = para0_mat(i,:);
%     lb= [0 0 1];
%     ub = para0*10;
% 
%     % initial model 
%     y_model = func_1RC(x,y2,para0);
%     figure(4)
%     hold on
%     %yyaxis left
%     plot(x,y_model,'-','Color',c_mat(2,:));
% 
%     % fitted model
%     para_hat = fmincon(@(para)func_cost(y1,para,x,y2,weight),para0,[],[],[],[],lb,ub,[],options);
% 
%     % visualize
%     y_model_hat = func_1RC(x,y2,para_hat);
%     figure(4)
%     hold on
%     %    yyaxis left
%     plot(x,y_model_hat,'-','Color',c_mat(3,:))
% 
% end
% 
% 


%%

% model
function y = func_2RC(t,I,para)
% x; time in sec
% para(1) = R0 [ohm]
% para (2) = R1 [ohm]
% para (3) = tau1 [sec]
% para (4) = R2 [ohm]
% para (5) = tau2 [sec]
% y = overpotential (V - OCV) [V]

R0 = para(1);
R1 = para(2);
tau1 = para(3);
R2 = para(4);
tau2 = para(5);
y = I*R0 + I*R1.*(1-exp(-t/tau1))+I*R2.*(1-exp(-t/tau2));

end


% cost (weight)
function cost = func_cost(y_data,para,t,I,weight)
% this is a cost function to be minimized
y_model = func_2RC(t,I,para);
cost = sqrt(mean((y_data - y_model).*weight).^2); % RMSE error

end