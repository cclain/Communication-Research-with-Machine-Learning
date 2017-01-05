data=importdata('C:\Users\Administrator\Desktop\election project\result5\Matrix_Probabilities1.csv');
P=data.data;
P=P(:,2:4);
P=transpose(P);
n=length(P(1,:));
%%create ccr gap matrix
ccrgap=zeros(2,n);
ccrgap(1,:)=P(2,:)-P(1,:);
ccrgap(2,:)=P(3,:)-P(2,:);
%%create position gap matrix
Pos=ccrgap;
Pos(2,:)=sum(ccrgap);
%%initiate budget and CCR
budget=0.05*n*1;
CCR=sum(P(1,:));
budgetlist=[budget];
CCRlist=[CCR];

%%initiate allocation matrix for all tweets
alloc=ones(1,n);
alloclist=alloc;
max13=0;
%max15=0;
ccr_gain=1;
Pos=ccrgap;
m=[];
while(ccr_gain>=0)
    [max13,I13]=max(Pos(1,:));
    temp=[I13,Pos(1,I13),Pos(2,I13)];
    m=horzcat(m,temp');
    ccr_gain=max13;
    Pos(1,I13)=Pos(2,I13);
    Pos(2,I13)=-10;
    budget=budget+2*0.05;
    alloc(I13)=alloc(I13)+2;   
    if ccr_gain>=0
        CCR=CCR+ccr_gain;
        CCRlist=[CCRlist,CCR];
        budgetlist=[budgetlist,budget];
        alloclist=vertcat(alloclist,alloc);
    end
    
end
CCRlist=CCRlist/n;
plot(budgetlist,CCRlist,'r')
hold on
result_mat135=importdata('C:\Users\Administrator\Desktop\election project\result6\result_mat135.mat');
plot(result_mat135(:,1),result_mat135(:,2),'b');
budgets=194.95;
ccr1=0.7;
scatter(budgets,ccr1,100,'g','filled');
grid
xlim([45 200])
xlabel('Budget')
ylabel('CCR')

% title('empirical best budget-ccr allocation')
% legend('individual tweet allocation','1_3_5 group allocation')

