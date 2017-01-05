function [singlebestloss,multibestloss,single_num,bestleafsize]=function_dt_single_sentiment(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
singlebestloss=[1,1,1,1,0];
multibestloss=[1,1,1,1,0];
bestleafsize=[1,1,1,1];
single_num=[1,1,1,1];
for i=1:4
    %%%build decision tree and calculate loss foringle candiate sentiment
    features_new=features;
    label_new=label_c(:,i);
    delete_list=[];
    remain_list=[];
    for j=1:n
        if (label_c(j,i)~=0) && (sum(label_c(j,:))==label_c(j,i))           
            remain_list=[remain_list,j];
        else
            delete_list=[delete_list,j]; 
        end     
    end
    features_new(delete_list,:)=[];
    label_new(delete_list)=[];
    single_num(i)=length(label_new);
    for minleafnum=5:20
        treec = fitctree(features_new,label_new,'CrossVal','on','MinLeafSize',minleafnum);
        lossc=kfoldLoss(treec);
        if lossc<singlebestloss(i)
            singlebestloss(i)=lossc;
            bestleafsize(i)=minleafnum;
        end
    end
    besttree = fitctree(features_new,label_new,'MinLeafSize',bestleafsize(i));
    %%%calculate loss for multi-candidate sentiment
    %%%label_new and feature_new have been updated for multi-candidate case
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
    temp_predict=predict(besttree,features_new); 
    multibestloss(i)=1-sum(diag(confusionmat(temp_predict,label_new)))/length(temp_predict);
    ypredict(remain_list,i)=temp_predict;
    i
end
singlebestloss(5)=dot(singlebestloss(1:4),single_num)/sum(single_num);
losscount=0;
for j=1:n
    if ~(isequal(ypredict(j,:),label_c(j,:)))
        losscount=losscount+1;
    end
        
end
totalloss=losscount/n;
multibestloss(5)=totalloss;
end