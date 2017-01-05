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
max13=[0,0];
max15=0;
ccr_gain=1;
cnt=0;
m=[];

while(ccr_gain>=0)
    [allmax13,allI13]=sort(Pos(1,:),'descend');
    max13=allmax13(1:2);
    I13=allI13(1:2);
    [max15,I15]=max(Pos(2,:));
    
    if max15>=sum(max13) && max15>max13(1) && max15>max13(2)
        ccr_gain=max15;
        Pos(:,I15)=[-2,-2];
        budget=budget+4*0.05;
        alloc(I15)=alloc(I15)+4;
        cnt=cnt+1;
    else
        ccr_gain=max13(1);
        if alloc(I13(1))==1
            Pos(1,I13(1))=ccrgap(2,I13(1));
            Pos(2,I13(1))=-2;
            budget=budget+0.05*2;
            alloc(I13(1))=alloc(I13(1))+2;
        elseif alloc(I13(1))==3
            Pos(:,I13(1))=[-2,-2];
            budget=budget+0.05*2;
            alloc(I13(1))=alloc(I13(1))+2;
        end
            
    end
    if ccr_gain>=0
        CCR=CCR+ccr_gain;
        CCRlist=[CCRlist,CCR];
        budgetlist=[budgetlist,budget];
        alloclist=vertcat(alloclist,alloc);
    end
 temp=[max15,max13];
 m=horzcat(m,temp');
end
CCRlist=CCRlist/n;
plot(budgetlist,CCRlist,'r')
hold on
result_mat135=importdata('C:\Users\Administrator\Desktop\election project\result6\result_mat135.mat');
plot(result_mat135(:,1),result_mat135(:,2),'b');
xlabel('budget')
ylabel('CCR')
title('empirical best budget-ccr allocation')
legend('individual tweet allocation','1_3_5 group allocation')

