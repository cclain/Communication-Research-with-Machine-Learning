function [singlebestloss,multibestloss,single_num]=function_svm_single_sentiment(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
singlebestloss=[1,1,1,1,0];
multibestloss=[1,1,1,1,0];
single_num=[1,1,1,1];


for i=1:4
    
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
    
    svmc =  fitcecoc(features_new,label_new);
    cvsvmc=crossval(svmc);
    singlebestloss(i)=kfoldLoss(cvsvmc);
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
    temp_predict=predict(svmc,features_new); 
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

