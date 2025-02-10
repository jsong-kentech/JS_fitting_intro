clear; clc; close all

% hyper parameters
filename = 'postprocessing_HPPC.mat';
c_mat = lines(9);

% data
load(filename)
x = n1C_pulse.t{1,1}-n1C_pulse.t{1,1}(1);
y1 = n1C_pulse.V{1,1}-n1C_pulse.V_final(1); % dV from OCV
y2 = n1C_pulse.I{1,1};

figure(1)
%yyaxis left
plot(x, y1,'o','Color',c_mat(1,:))
ylim([1.1*min(y1) 0])
%yyaxis right
%plot(x, y2,'o')
%ylim([1.1*min(y2) 0])


% model visualization

para0 = [0.0013 0.0018 60]; % initial guess
y_model = func_1RC(x,y2,para0);
figure(1)
hold on
%yyaxis left
plot(x,y_model,'-','Color',c_mat(2,:))

% legend({})


%% fitting CASE 1
% initial guess
    %para0
% bound 
    lb= [0 0 1];
    ub = para0*10;
% weight
    weight = ones(size(y1)); % uniform weighting

% fitting
        options = optimset('display','iter','MaxIter',400,'MaxFunEvals',1e5,...
        'TolFun',1e-10,'TolX',1e-8,'FinDiffType','central');    
        para_hat = fmincon(@(para)func_cost(y1,para,x,y2,weight),para0,[],[],[],[],lb,ub,[],options);
    
% visualize
    y_model_hat = func_1RC(x,y2,para_hat);
    figure(1)
    hold on
%    yyaxis left
    plot(x,y_model_hat,'-','Color',c_mat(3,:))


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
function y = func_1RC(t,I,para)
% x; time in sec
% para(1) = R0 [ohm]
% para (2) = R1 [ohm]
% para (3) = tau1 [ohm]
% y = overpotential (V - OCV) [V]

R0 = para(1);
R1 = para(2);
tau1 = para(3);
y = I*R0 + I*R1.*(1-exp(-t/tau1));

end

% cost (weight)
function cost = func_cost(y_data,para,t,I,weight)
% this is a cost function to be minimized
y_model = func_1RC(t,I,para);
cost = sqrt(mean((y_data - y_model).*weight).^2); % RMSE error

end