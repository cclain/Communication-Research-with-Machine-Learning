function [bestloss,ypredict]=function_svm_candidate(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
bestloss=[1,1,1,1,1];
bestsigma=[1,1,1,1];
for i=1:4
    for k=-5:1:3
        t = templateSVM('KernelFunction','gaussian', 'KernelScale',2^k);
        svmc =  fitcecoc(features,label_c(:,i), 'Learners' ,t);
        cvsvmc=crossval(svmc);
        tempbestloss=kfoldLoss(cvsvmc);
        if tempbestloss<bestloss(i)
            bestsigma(i)=2^k;
            bestloss(i)=tempbestloss;
            ypredict(:,i)=kfoldPredict(cvsvmc);
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

