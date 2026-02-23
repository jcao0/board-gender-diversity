%% Set Up

cd('/Figure_3a')
clear
tic 
rng(7)
restoredefaultpath
addpath('functions');
alpha_sig = .05;
% warning('off','all')

%% DATA CLEANING

data = readtable('data_boardgendereige.csv');
N = length(unique(table2array(unique(data(:,1))))); % number of countries
T_S = length(unique(table2array(unique(data(:,3))))); % number of years
Y = reshape(table2array(data(:,7)),T_S,N)'; % outcome matrix
D = reshape(table2array(data(:,4)),T_S,N)'; % treatment matrix
T = find(sum(D),1)-1; % number of pre-treatment periods
S_max = T_S-T; % maximum number of post-treatment periods

S = S_max-3; % truncate data to avoid extrapolating too far
T_S = T+S; % total number of periods
Y = Y(:,1:T+S); % outcome for corresponding period
D = D(:,1:T+S); % all-time treatment status

%% ESTIMATION

output = att(Y,D,S); %function att_event% need to go through

att_hat = output.att_hat;


%% bayesian correct
B = 100;          
multiplier = 500;   

tau_boot = zeros(B,2*S-1); 

rng(123);

for b = 1:B

    w_b = gamrnd(ones(N,1), 1); 
    w_b = w_b / sum(w_b); 

    count = round(w_b * multiplier); 

    Y_b = [];
    D_b = [];
    for i = 1:N
        if count(i) > 0
            Y_b = [Y_b; repmat(Y(i,:), count(i), 1)];
            D_b = [D_b; repmat(D(i,:), count(i), 1)];
        end
    end


   output = att(Y_b,D_b,S); %function att_event% need to go through
   tau_boot(b,:) = (output.att_hat)';
   disp(b) 
end

% CI
lb = quantile(tau_boot, 0.0005); 
ub = quantile(tau_boot, 0.9995);
L = att_hat' - lb;
U = ub - att_hat';

%% export
LB = lb';
UB = ub';
eventtime = (-5:5)';
T = table(eventtime, att_hat, LB, UB, 'VariableNames', {'event','coefficient','lb','ub'});
writetable(T, 'result.csv');