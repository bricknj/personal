%Optimal Path to pay off student loans
%Started in Oct 2017
%Only pays in full

%Group = [A B C D E F G H I]
%Group = [1 2 3 4 5 6 7 8 9]
%%
clear all
clc
%%
% ***MUST UPDATE***
%Need to recalculate and change payment distributions to each loan every
%month (or at least every few months) Certainly by Oct 2022
%***It would be helpful to calc based on interest rate to pay based on
%equalizing all monthly interest charges (or highest ones) and then offsetting

time = 53; %total run time
terma = 17; %months before top 2 loans converge
termb = 25; %# of months before next convergence

%---Current Balance----------
balA = 3340;
balB = 350;
balC = 2830;
balD = 3803;
balE = 1103;
balF = 4149;
balG = 1078;
balH = 2163;
balI = 4059;

bal = [balA balB balC balD balE balF balG balH balI];

%---TOTAL MONTHLY PAYMENT------
paymon = 500;

%%
%---Does not need to be updated-------
%Number of loans
qty = 9;

%Interest Rate
int_rate = [0.034 0.068 0.0386 0.0466 0.0466 0.0429 0.0429 0.0386 0.0376];

%---Current Accrued Interest----- ***Must change to MONTHLY***
intA = 2.32;
intB = 0.53;
intC = 2.23;
intD = 4.01;
intE = 1.06;
intF = 2.93;
intG = 0.94;
intH = 1.7;
intI = 3.15;
intsum = [intA intB intC intD intE intF intG intH intI];

%Principal Balance
bal_prin = [3500 402.96 3005.93 4500 1177.73 5500 1135.05 2101.53 4821.72];

%Minimum Monthly Payment
a = 35.11;
b = 8.2;
c = 34.43;
d = 47.12;
e = 13.47;
f = 56.59;
g = 11.8;
h = 23.1;
i = 48.94;
minpay = [a b c d e f g h i];
minpaytot = sum(minpay);

%%
%Additional payment per group for each month
r = paymon - minpaytot; %Funds remaining after minimums paid

    pone = 0.32*r; %AMT paid to loan with most interest
    ptwo = 0.22*r;
    pthree = 0.17*r;
    pfour = 0.11*r;
    pfive = 0.06*r;
    psix = 0.05*r;
    pseven = 0.04*r;
    peight = 0.03*r;
    pnine = 0.00*r; %AMT paid to loan with least interest
    
    pmon = [pone ptwo pthree pfour pfive psix pseven peight pnine];
    
%Additional payments after top 2 loan accruals converge
    qone = 0.27*r; %AMT paid to loan with most interest
    qtwo = 0.27*r;
    qthree = 0.15*r;
    qfour = 0.1*r;
    qfive = 0.06*r;
    qsix = 0.05*r;
    qseven = 0.04*r;
    qeight = 0.03*r;
    qnine = 0.03*r; %AMT paid to loan with least interest
    
    qmon = [qone qtwo qthree qfour qfive qsix qseven qeight qnine];
    
%Additional payments after top 5 loan accruals converge
    rone = 0.23*r; %AMT paid to loan with most interest
    rtwo = 0.22*r;
    rthree = 0.15*r;
    rfour = 0.15*r;
    rfive = 0.1*r;
    rsix = 0.05*r;
    rseven = 0.04*r;
    reight = 0.03*r;
    rnine = 0.03*r; %AMT paid to loan with least interest
    
    rmon = [rone rtwo rthree rfour rfive rsix rseven reight rnine];
    
%Optimal Monthly Payment (Solving for)
%syms A B C D E F G H I;

%%
%----5 Year-10 Month Projection------- Excel says ~5 years
t = 1;
for i = 1:time %In terms of months
    payleft(i,1) = paymon - minpaytot; %Remaining funds after min payments on all accounts(same as r)
        
    %----Interest and Minimum Payments Made-----
    for j = 1:qty
        if bal(i,j) > 0 %Removes negative values
            intmon(i,j) = bal(i,j)*int_rate(1,j)/365.25*30; %Interest of each month
            intsum(i+1,j) = intsum(i,j) + intmon(i,j);  %Adds to the total interest accrued
                                                        %(Currently unused???)
            bal(i+1,j) = bal(i,j) + intmon(i,j) - minpay(1,j); %Balance for next month
            if i < terma %Before top 2 loans converge
                 pmonworking(i,j) = pmon(1,j); %Makes new matrix row with identical cells to pmon per month
            elseif i < termb
                pmonworking(i,j) = qmon(1,j); %Makes new matrix row with identical cells to qmon per month
            else
                pmonworking(i,j) = rmon(1,j); %Makes new matrix row with identical cells to rmon per month
            end
            if bal(i+1,j) < 0 %Removes negative values
                bal(i+1,j) = 0;
            end
        else
            bal(i,j) = 0;
            payleft(i) = payleft(i) + minpay(j);    %Applies min payment for loans which have already
                                                    %been paid back into available funds
        end

    end
   % maxint(i,1) = max(intmon(i,:)); %Finds value of max interest per month
   % maxgroup(i,1) = find(intmon(i,:) == max(intmon(i,:))); %Finds group with max interest per month
    
    %---Puts extra money toward loans with more interest per month------
    intmonsort(i,:) = sort(intmon(i,:),'descend'); %Sorts loans (high interest/month to low int/month)
    balmonsort(i,:) = sort(bal(i,:),'descend'); %Sorts loans (high balance/month to low bal/month)
    
    if i < terma %Before top 2 loans converge
        payleft(i) = payleft(i) - sum(pmon);
        pmonworking(i,1) = pmon(1) + payleft(i);
    elseif i < termb
        payleft(i) = payleft(i) - sum(qmon);
        pmonworking(i,1) = qmon(1) + payleft(i);
    else
        payleft(i) = payleft(i) - sum(rmon);
        pmonworking(i,1) = rmon(1) + payleft(i);
    end
      
    
    
    %I THINK SOMEWHERE AROUND HERE I MIXED UP payleft and pmonworking, but
    %not totally sure******
    
    
    %Count how many loans still owe money, and only apply steps to those
    %from now on
    nonzero = 0;
    for z = 1:qty
        if bal(i+1,z) > 0
            nonzero = nonzero + 1;
        end
    end
    
    
    for k = 1:nonzero %max to least interest/month loans
        if i < termb
            order(i,k) = find(intmon(i,:) == intmonsort(i,k)); %group with highest int/month in 1 column
        else
            order(i,k) = find(bal(i,:) == balmonsort(i,k)); %group with highest bal/month in 1 column
        end
        if bal(i+1,order(i,k)) < 0 %Removes negative values
            bal(i+1,order(i,k)) = 0;
            if i < terma %Before top 2 loans converge
                pmonworking(i,1) = pmonworking(i,1) + pmon(k);
            elseif i < termb
                pmonworking(i,1) = pmonworking(i,1) + qmon(k);
            else
                pmonworking(i,1) = pmonworking(i,1) + rmon(k);
            end
        end
    end
    
    for n = 1:nonzero
        if bal(i+1,order(i,n)) < 0 %Removes negative values
            bal(i+1,order(i,n)) = 0;
        else
            bal(i+1,order(i,n)) = bal(i+1,order(i,n)) - pmonworking(i,n); %Pays additional $ to loan with 
                                                                        %max interest per month
        end
    end
    
    t(i+1,1) = t(i) + 1; %Time [Months]
    i = i+1;
end

sumcost = paymon * (i+1)    %Is this an accurate representation?

for ii = 1:qty
    if bal(i,ii) < 0
        bal(i,ii) = 0;
    end
end

%%
%This Month's Optimal Payments
for m = 1:qty
    paygroup(m) = find(order(1,:) == m); %Identifies the loan group related to each ranking from sorting
    
  %***MUST FIX IF USING QMON AND RMON******
    payadd(m) = pmon(paygroup(m)); %Identifies additional $ to each loan group based on ranking
    tot(m) = minpay(m) + payadd(m);
end

A = tot(1);
B = tot(2);
C = tot(3);
D = tot(4);
E = tot(5);
F = tot(6);
G = tot(7);
H = tot(8);
I = tot(9);

totsum = sum(tot(:))

%%
%---PLOTS----------
%This plot tracks each loan's balance over time
plot(t,bal(:,1)); %Group A
hold on;
plot(t,bal(:,2)); %Group B
hold on;
plot(t,bal(:,3)); %Group C
hold on;
plot(t,bal(:,4)); %Group D
hold on;
plot(t,bal(:,5)); %Group E
hold on;
plot(t,bal(:,6)); %Group F
hold on;
plot(t,bal(:,7)); %Group G
hold on;
plot(t,bal(:,8)); %Group H
hold on;
plot(t,bal(:,9)); %Group I
legend('A','B','C','D','E','F','G','H','I');

%This plot compares the interest accrued per loan over time
%figure;
%plot(t(1:i-1),intmonsort(:,1)); %Loan with highest monthly interest accrued (NOT necessarily A)
%hold on;
%plot(t(1:i-1),intmonsort(:,2)); 
%hold on;
%plot(t(1:i-1),intmonsort(:,3)); 
%hold on;
%plot(t(1:i-1),intmonsort(:,4)); 
%hold on;
%plot(t(1:i-1),intmonsort(:,5));
%hold on;
%plot(t(1:i-1),intmonsort(:,6));
%hold on;
%plot(t(1:i-1),intmonsort(:,7)); 
%hold on;
%plot(t(1:i-1),intmonsort(:,8)); 
%hold on;
%plot(t(1:i-1),intmonsort(:,9));
%legend('1','2','3','4','5','6','7','8','9');

%payleft(i,1) = payleft(i-1,1);
%figure;
%plot(t,payleft);