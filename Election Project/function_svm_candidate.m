function [bestloss,ypredict]=function_svm_candidate(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
bestloss=[1,1,1,1,1];

for i=1:4
    svmc =  fitcecoc(features,label_c(:,i));
    cvsvmc=crossval(svmc);
    bestloss(i)=kfoldLoss(cvsvmc);
    ypredict(:,i)=kfoldPredict(cvsvmc);

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

end

