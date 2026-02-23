%% Set Up

cd('Figure_5a')
clear
tic 
rng(7)
restoredefaultpath
addpath('functions');
alpha_sig = .05;
% warning('off','all')

%% DATA CLEARNING

data = readtable('data_hr.csv');
% head(data,5)
N = length(unique(table2array(unique(data(:,1))))); % number of units
T1 = length(unique(table2array(unique(data(:,3))))); % number of units
Y = reshape(table2array(data(:,10)),T1,N)'; 
D = reshape(table2array(data(:,4)),T1,N)'; 
D1 = reshape(table2array(data(:,5)),T1,N)'; 
D2 = reshape(table2array(data(:,6)),T1,N)'; 
T = find(sum(D),1)-1; % number of pre-treatment periods
S_max = T1-T; % maximum number of post-treatment periods

S = S_max-23; % truncate data to avoid extrapolating too far
T1 = T+S; % total number of periods
Y = Y(:,1:T1); % outcome 
D = D(:,1:T1); % all-time treatment status
D_S = D(:,T+1:T+S); % post-treatment treatment status
D1 = D1(:,1:T1);
D2 = D2(:,1:T1);
D1_S = D1(:,T+1:T+S);
D2_S = D2(:,T+1:T+S);

%% ESTIMATION

output = att(Y,D,D1,D2,S); %function att_event% need to go through

att_hat1 = output.att_hat1;

att_hat2 = output.att_hat2;

%% bayesian correct
B = 100;          
multiplier = 500;   

tau_boot1 = zeros(B,2*S-1); 
tau_boot2 = zeros(B,2*S-1); 

rng(123);

for b = 1:B

    w_b = gamrnd(ones(N,1), 1); 
    w_b = w_b / sum(w_b); 

    count = round(w_b * multiplier); 

    Y_b = [];
    D_b = [];
    D1_b = [];
    D2_b = [];
    for i = 1:N
        if count(i) > 0
            Y_b = [Y_b; repmat(Y(i,:), count(i), 1)];
            D_b = [D_b; repmat(D(i,:), count(i), 1)];
            D1_b = [D1_b; repmat(D1(i,:), count(i), 1)];
            D2_b = [D2_b; repmat(D2(i,:), count(i), 1)];
        end
    end


   output = att(Y_b,D_b,D1_b,D2_b,S); %function att_event% need to go through
   tmp = (output.att_hat1)';   % 强制转成行向量
   L = length(tmp);
   tau_boot1(b, :) = NaN;       % ① 整行先填 NaN
   tau_boot1(b, 1:L) = tmp;     % ② 有多少填多少

   tmp = (output.att_hat2)';   % 强制转成行向量
   L = length(tmp);
   tau_boot2(b, :) = NaN;       % ① 整行先填 NaN
   tau_boot2(b, 1:L) = tmp;     % ② 有多少填多少
   disp(b) 
end

% CI
lb1 = quantile(tau_boot1, 0.025); 
ub1 = quantile(tau_boot1, 0.975);
L1 = att_hat1' - lb1;
U1 = ub1 - att_hat1';

lb2 = quantile(tau_boot2, 0.025); 
ub2 = quantile(tau_boot2, 0.975);
L2 = att_hat2' - lb2;
U2 = ub2 - att_hat2';



%% export
LB1 = lb1';
UB1 = ub1';
LB2 = lb2';
UB2 = ub2';
eventtime = (-11:11)';
T = table(eventtime, att_hat1, LB1, UB1, att_hat2, LB2, UB2, 'VariableNames', {'event','coefficient1','lb1','ub1','coefficient2','lb2','ub2'});
writetable(T, 'result.csv');


