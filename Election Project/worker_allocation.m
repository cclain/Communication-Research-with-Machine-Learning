data=importdata('C:\Users\Administrator\Desktop\election project\result5\Matrix_Probabilities1.csv');
group=data.data;
sortrows(group);
group=sortrows(group);
k=12;
n=3^k;
alloc_mat=zeros(n,k);
for i=k:-1:1
    temparray1=ones(1,3^(i-1));
    temparray2=3*ones(1,3^(i-1));
    temparray3=5*ones(1,3^(i-1));
%     temparray1=2*ones(1,3^(i-1));
%     temparray2=3*ones(1,3^(i-1));
%     temparray3=4*ones(1,3^(i-1));
    alloc_mat(:,i)=repmat([temparray1,temparray2,temparray3],1,3^(k-i))';   
end
budget=zeros(n,1);
CCR=zeros(n,1);
% dev=zeros(n,1);
for i=1:n
    mlist=alloc_mat(i,:);
    [budget(i),CCR(i)]=alloc_em_func(mlist,group);    
%     [budget(i),CCR(i)]=alloc_func(mlist);
end
index=1:n;
result_mat=sortrows([budget,CCR,index']);

delete_list=[];
for i=1:n-1
    if result_mat(i,1)==result_mat(i+1,1)
       delete_list=[delete_list,i];
    end 
    if mod(i,10000)==0
        i
    end
end
result_mat(delete_list,:)=[];
delete_list=[1,1];
while ~(isempty(delete_list))
    delete_list=[];
    for i=1:length(result_mat(:,1))-1
        if result_mat(i,2)>result_mat(i+1,2)
           delete_list=[delete_list,i+1];
        end 
    end
    result_mat(delete_list,:)=[];
end

% scatter(budget,CCR,1);
% hold on
budgets=194.95;
ccr1=0.7;
scatter(budgets,ccr1);
hold on
plot(result_mat(:,1),result_mat(:,2),'r');
hold on
result_mat35=importdata('result_mat35.mat');
plot(result_mat35(:,1),result_mat35(:,2),'b');
xlabel('budget');
ylabel('CCR');
title('best budget-CCR graph')
legend('paper allcoation','1_3_5 allocation','3_5 allocation')
% legend('all allocation','best budget-CCR curve','paper allcoation')

best_alloc=alloc_mat(result_mat(:,3),:);
% plot(mat1(:,1),mat1(:,2));
% hold on
% plot(mat2(:,1),mat2(:,2));
% hold on
% plot(mat3(:,1),mat3(:,2));
% hold on
% legend('allocate 1,3,5 workers','allocate 2,3,4 workers','allocate 2,3,4 workers,one more with tie')
% xlabel('budget');
% ylabel('CCR');
% title('best budget-CCR graph')

% plot(result_mat(:,1),result_mat(:,2));
% hold on
% h=errorbar(result_mat(:,1),result_mat(:,2),result_mat(:,3),'c'); set(h,'linestyle','none');
