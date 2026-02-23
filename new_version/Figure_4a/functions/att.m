function [output] = att(Y,D,D1,D2,S)

[N,~] = size(D); % number of units
T = find(sum(D),1)-1;

% truncate data at T+S
Y = Y(:,1:T+S); % outcome matrix of the whole periods
D = D(:,1:T+S); % treatment matrix of the whole periods
D1 = D1(:,1:T+S);
D2 = D2(:,1:T+S);

Y_T = Y(:,1:T); % outcome matrix of pre-treatment periods
Y_S = Y(:,T+1:end);% outcome matrix of post-treatment periods
D_S = D(:,T+1:end);% treatment matrix of post-treatment periods
D1_S = D1(:,T+1:end);
D2_S = D2(:,T+1:end);
Y_ts = Y(:,T+1-S+1:end);
D_ts = D(:,T+1-S+1:end);
D1_ts = D1(:,T+1-S+1:end);
D2_ts = D2(:,T+1-S+1:end);

for i = 1:N
    row = D_ts(i,:);           % 取第 i 行
    idx = find(row==1, 1);     % 第一个 1 的位置
    if idx > 1          % 如果有 1
        start_idx = max(1, idx - S + 1); % 往前 S 个位置
        D_ts(i, start_idx:idx) = 1;     % 改为 1
    end
end

for i = 1:N
    row = D1_ts(i,:);           % 取第 i 行
    idx = find(row==1, 1);     % 第一个 1 的位置
    if idx > 1          % 如果有 1
        start_idx = max(1, idx - S + 1); % 往前 S 个位置
        D1_ts(i, start_idx:idx) = 1;     % 改为 1
    end
end

for i = 1:N
    row = D2_ts(i,:);           % 取第 i 行
    idx = find(row==1, 1);     % 第一个 1 的位置
    if idx > 1          % 如果有 1
        start_idx = max(1, idx - S + 1); % 往前 S 个位置
        D2_ts(i, start_idx:idx) = 1;     % 改为 1
    end
end


% index matrix - [time,unit,event_time]
K = sum(sum(D_ts)); % dimension of gamma, total number of units and treated periods
index_mat = zeros(K,3); % K by 3 matrix
ind = 0;
for s = 1 : 2*S-1 % for each period
    for i = 1 : N % for each unit
        if D_ts(i,s)==1 % for the specific period, if the treatment of the unit equals to 1
            ind = ind+1; % add 1 to index
            index_mat(ind,:) = [s,i,sum(D_ts(i,1:s))]; % index matrix for that index line equals to period, unit, 
                                                      % and total periods that unit has been treated
        end
    end
end

% treatment structure - A_s matrices 
A = zeros(N,K,2*S-1); % unit, total number of units and treated periods, post-treatment periods
for k = 1 : K % for each index
    A(index_mat(k,2),k,index_mat(k,1)) = 1; % unit, index, period
end

% synthetic control weights
[a_hat,B_hat] = synthetic_control_batch(Y_T); % get intercept and the weights
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat); % I - B_hat

% estimation
temp1 = 0;
for s = 1 : 2*S-1 % for each period
    temp1 = temp1+A(:,:,s)'*M_hat*A(:,:,s); % temp1(K*K) = sum(A(N,K)'*M_hat(N,N)*A(N,K))
end

temp2 = 0;
for s = 1 : 2*S-1 % for each period
    temp2 = temp2+A(:,:,s)'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_ts(:,s)-a_hat);
              % temp2(K*1) = sum(A(N,K)'*M_hat(N,N)*Y_S(N,1)-a_hat(N,1))
end

tau_hat = temp1\temp2; % heterogeneous treatment effects

% index matrix - [time,unit,event_time,policy]
K = sum(sum(D_ts)); % dimension of tau
index_mat = zeros(K,4);
ind = 0;
for s = 1 : 2*S-1
    for i = 1 : N
        if D_ts(i,s)==1
            ind = ind+1;
            if D1_ts(i,s) == 1
                index_mat(ind,:) = [s,i,sum(D_ts(i,1:s)),1];
            else
                index_mat(ind,:) = [s,i,sum(D_ts(i,1:s)),2];
            end
                
        end
    end
end


% Policy 1
S1 = max(sum(D1_S,2));
gamma_hat_1 = zeros(2*S1-1,1);
for s = 1 : 2*S1-1
    ind = (index_mat(:,3) == s).*(index_mat(:,4)==1);
    L = ind'/sum(ind);
    gamma_hat_1(s) = L*tau_hat;
end

% Policy 2
S2 = max(sum(D2_S,2));
gamma_hat_2 = zeros(2*S2-1,1);
for s = 1 : 2*S2-1
    ind = (index_mat(:,3) == s).*(index_mat(:,4)==2);
    L = ind'/sum(ind);
    gamma_hat_2(s) = L*tau_hat;
end

output.att_hat1 = gamma_hat_1;
output.att_hat2 = gamma_hat_2;