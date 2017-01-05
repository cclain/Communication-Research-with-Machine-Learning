function [bestloss,ypredict]=function_svm_rbf_sentiment(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
bestloss=[1,1,1,1,1];
bestsigma=[1,1,1,1];



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
    
    for k=-5:1:3
        t = templateSVM('KernelFunction','gaussian', 'KernelScale',2^k);
        svmc =  fitcecoc(features_new,label_new, 'Learners' ,t);
        cvsvmc=crossval(svmc);
        tempbestloss=kfoldLoss(cvsvmc);
        if tempbestloss<bestloss(i)
            bestsigma(i)=2^k;
            bestloss(i)=tempbestloss;
            ypredict(remain_list,i)=kfoldPredict(cvsvmc);
        end

    end
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
bestloss
bestsigma
end

