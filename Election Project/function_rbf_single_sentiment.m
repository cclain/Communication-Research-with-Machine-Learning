function [singlebestloss,bestsigma,single_num]=function_rbf_single_sentiment(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
singlebestloss=[1,1,1,1,0];
bestsigma=[0,0,0,0];
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
    
    for k=-5:1:5
        t = templateSVM('KernelFunction','gaussian', 'KernelScale',2^k);
        svmc =  fitcecoc(features_new,label_new, 'Learners' ,t);
        cvsvmc=crossval(svmc);
        tempbestloss=kfoldLoss(cvsvmc);
        if tempbestloss<singlebestloss(i)
            bestsigma(i)=2^k;
            singlebestloss(i)=tempbestloss;
        end
    end
    i
end
singlebestloss(5)=dot(singlebestloss(1:4),single_num)/sum(single_num);
end

