function [bestloss,bestleafsize]=function_dt_sentiment(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
bestloss=[1,1,1,1,1];
bestleafsize=[1,1,1,1];
for i=1:4
    
    features_new=features;
    label_new=label_c(:,i);
    delete_list=[];
    remain_list=[];
    for j=1:n
        if label_c(j,i)==0
            delete_list=[delete_list,j]; 
        else
            remain_list=[remain_list,j];
        end     
    end
    features_new(delete_list,:)=[];
    label_new(delete_list)=[];
    for minleafnum=5:20
        treec = fitctree(features_new,label_new,'CrossVal','on','MinLeafSize',minleafnum);
        lossc=kfoldLoss(treec);
        if lossc<bestloss(i)
            bestloss(i)=lossc;
            bestleafsize(i)=minleafnum;
        end
    end
    besttree = fitctree(features_new,label_new,'MinLeafSize',bestleafsize(i));
    temp_predict=predict(besttree,features_new);  
    ypredict(remain_list,i)=temp_predict;
    i
end
losscount=0;
for j=1:n
    if ~(isequal(ypredict(j,:),label_c(j,:)))
        losscount=losscount+1;
    end
        
end
totalloss=losscount/n;
bestloss(5)=totalloss;
end