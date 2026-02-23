%%This script test the spill-over effect of board gender policy using SSC
%%Results includes: 1. event-time treatment effect (treatment effect by event-time averaged across units) 2. individual spillover effect (spillover effect by event-time and unit)
%%spill-over units are those untreated units affected by policy of earliest-treated units
%%Two hyperparameter are: 1. target sample periods (remove data in later years for clear interpretation); 2. spill-over units 

cd('/Figure_7')
clear
tic 
rng(7)
restoredefaultpath
addpath('functions');
alpha_sig = .05;
% warning('off','all')
%% LOAD DATA
data = readtable('data_boardgendereige.csv');


%%  Prepare data for analysis
%%Remove data out of the target
%%removed data including: 1.later treated unit 2. observation in later years

%%extract treated units and treated time for removing data
data_treat = data(data{:,4}==1, :);%%observations of treated units
data_first_treat = data_treat(data_treat.time == min(data_treat.time), {'unit','time'}); %%data of earlist-treated unit
units_first_treat = unique(data_first_treat.unit); %% id of earlist-treated unit
year_first_treat = unique(data_first_treat.time);%% treated time of earlist-treated unit
years_treat = groupsummary(data_treat, "unit", "min", "time"); %% treated time of each treated units


%%remove data of :1. units treated within S_max years following the earlist-treated time 2. periods after S_max years following the the earlist-treated time
%%replace S_max if needed. S_max is a hyperparameter, the results will include event-time effect up to S_max.
S_max = 6; 
drop_units = years_treat.unit(years_treat.min_time <= year_first_treat + S_max); %%units treated within K years following the earlist-treated time
%drop_units = drop_units(~ismember(drop_units,units_first_treat)); %%do not remove the earlist-treated units

idx = ~ismember(data.unit, drop_units) & data.time <= year_first_treat + S_max; % data to remove: units treated within K years and data after K years
data_spillover = data(idx, :); % data used for analyize
unique(data_spillover.unit)

%% Specify spillover structure: 
%%specify units affected by the spillover
%%replace units_spillover if needed. units_spillover are hyperparameter, replace it with units you deemed to be affected by spillover
units_spillover1 = {'Ireland', 'Luxembourg', 'Czech Republic', 'Slovenia', 'Austria'};
%closest

%%create spillover treatment dummy
data_spillover.treated_spillover1 = zeros(height(data_spillover),1) ;
idx = ismember(data_spillover.unit, units_spillover1) & data_spillover.time >= year_first_treat;
data_spillover.treated_spillover1(idx) = 1;
data_spillover = sortrows(data_spillover, {'unit','time'}, "ascend");

%% Specify spillover structure: 
%%specify units affected by the spillover
%%replace units_spillover if needed. units_spillover are hyperparameter, replace it with units you deemed to be affected by spillover
units_spillover2 = {'Croatia','Portugal','Latvia','Lithuania','Estonia'}; %Germany and Poland host the most immigrant from 4 first-treated countries 

%%create spillover treatment dummy
data_spillover.treated_spillover2 = zeros(height(data_spillover),1) ;
idx = ismember(data_spillover.unit, units_spillover2) & data_spillover.time >= year_first_treat;
data_spillover.treated_spillover2(idx) = 1;
data_spillover = sortrows(data_spillover, {'unit','time'}, "ascend");
%% Create matrix for estimation
head(data_spillover,5)
N = length(unique(table2array(unique(data_spillover(:,1))))); % number of units
T1 = length(unique(table2array(unique(data_spillover(:,3))))); % number of periods
Y = reshape(table2array(data_spillover(:,7)),T1,N)'; % all-time outcome matrix
D_spill1 = reshape(table2array(data_spillover(:,8)),T1,N)'; % all-time spillover matrix
D_spill2 = reshape(table2array(data_spillover(:,9)),T1,N)'; % all-time spillover matrix
D = D_spill1 + D_spill2; % all-time treatment matrix
T = find(sum(D),1)-1; % number of pre-treatment periods
S = S_max; % number of taget post-treatment periods
T1 = T+S; % total number of taget periods
Y = Y(:,1:T1); % outcome within taget periods
D = D(:,1:T1); % treatment matrix within taget periods
D_S = D(:,T+1:T+S); % post-treatment matrix within taget periods
D1 = D_spill1(:,1:T1); % spillover within taget periods
D1_S = D_spill1(:,T+1:T+S); % post-treatment spillover within taget periods
D2 = D_spill2(:,1:T1); % spillover within taget periods
D2_S = D_spill2(:,T+1:T+S); % post-treatment spillover within taget periods

%% Estimation and inference 
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
eventtime = (-5:5)';
T = table(eventtime, att_hat1, LB1, UB1, att_hat2, LB2, UB2, 'VariableNames', {'event','coefficient1','lb1','ub1','coefficient2','lb2','ub2'});
writetable(T, 'result.csv');
