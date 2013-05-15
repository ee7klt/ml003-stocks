% Linear Regression with multiple variables

clear all; close all; clc

% Training Set
ts = 800;     
% Sample Set
ss = 400;     % out of sample
% startFrom
startFrom = 50;

% Loading CSV data of SPY
% X1 col 6   => SPY Volume(t)
% X2 col 7   => SPY Yield(t-1)
% X3 col 8   => SPY SMA(50) close(t)
% Y  col 10  => SPY Yield(t)

fprintf('Loading data ...\n');
data = csvread('hdata2.csv');
X = data(startFrom:ts, 6:8);
y = data(startFrom:ts, 9);
m = length(y);
% Add intercept term to X
X = [ones(m, 1) X];


% Normalizing
%fprintf('Normalizing Features ...\n');
%mu = mean(X);
%sigma = std(X);
%X_norm = studentize(X);
%X = X_norm;

% Solution with Normal Equation
fprintf('Solving with Normal Equation ...\n');
theta = pinv(X'*X) * X' * y;
theta

% Prediction on new data
time    = data((ts+1):(ts+ss) , 1);
newdata = data((ts+1):(ts+ss) , 6:8);
realYield = data((ts+1):(ts+ss), 9);
pX = [ones(length(realYield),1) newdata];

% predicted values
pred = pX * theta;
fprintf("Predicted Yield = %f   vs Real Yield = %f \n",pred,realYield);

%
%short = zeros(ss,1);
%short_yield = zeros(ss,1);
%long  = zeros(ss,1);
%long_yield = zeros(ss,1);
%for i = 1:ss
	%if (pred(i)>0) & (realYield(i)>0) 
%	 long(i) = 1;	 
	 %long_yield(i)=realYield(i);
	%end
	%if (pred(i)<0) & (realYield(i)<0) 
%	 short(i) = -1;
	 %short_yield(i)=realYield(i);
	%end;	
%endfor

global_equity = zeros(ss,1);
for j = 2:ss
    if abs(pred(j))>0.002
		global_equity(j) = global_equity(j-1) + realYield(j);
	else
		global_equity(j) = global_equity(j-1);
	end;
endfor


figure;
hold on;
plot(global_equity);
ylabel('Global Yield');
xlabel('Days(t)');
%hold off;


