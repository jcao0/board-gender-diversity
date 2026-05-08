function [a_hat,B_hat] = synthetic_control_batch(Y)
% SYNTHETIC_CONTROL_BATCH calculate all synthetic control weights, using
% each row as the treated and the others as the controls, separately. 

[N,T] = size(Y); % N = units, T = the whole periods
a_hat = zeros(N,1); % N * 1 matrix
B_hat = zeros(N); % N * N matrix

for i = 1 : N % for each unit
    Y_treated = Y(i,:)'; % ith row of Y (unit) (column now)
    temp = Y;
    temp(i,:) = []; % delete the ith row
    Y_untreated = temp'; % remain row (units)

    Y_demeaned = Y_treated-mean(Y_treated); % demean of outcome
    X_demeaned = Y_untreated-repmat(mean(Y_untreated),T,1); % demean of other units
    
    % Initial value（weights)
    b_initial = ones(N-1,1)/(N-1); % a (N-1 * 1) matrix that all numbers are 1/N-1
    % Define the objective function (minimize the squared error)
    Q = @(b)sum((Y_demeaned-X_demeaned*b).^2); % criterion sum((Y-Xb)^2)

    % constraints
    A_eq = ones(1,N-1); % a (1 * N-1) matrix that all numbers are 1
    B_eq = 1;
    LB = zeros(N-1,1); % a (N-1 * 1) matrix that all numbers are 0

    options = optimoptions('fmincon','Display','none'); % set up Nonlinear constraint minimization function
    b_hat = fmincon(Q,b_initial,[],[],A_eq,B_eq,LB,[],[],options); % find min Q through b, limit at sum(b) = 1, b >= 0

    a_hat(i) = mean(Y_treated)-mean(Y_untreated)*b_hat; % intercept
    b_hat = [b_hat(1:i-1);0;b_hat(i:end)]; % add the unit own weights back (0)
    B_hat(i,:) = b_hat'; % make as a matrix
end