function [bestloss,bestleafsize]=function_dt_candidate(label_c,features)
n=length(label_c(:,1));
ypredict=zeros(n,4);
bestloss=[1,1,1,1,1];
bestleafsize=[1,1,1,1];
for i=1:4
    for minleafnum=5:20
        treec = fitctree(features,label_c(:,i),'CrossVal','on','MinLeafSize',minleafnum);
        lossc=kfoldLoss(treec);
        if lossc<bestloss(i)
            bestloss(i)=lossc;
            bestleafsize(i)=minleafnum;
        end
    end
    besttree = fitctree(features,label_c(:,i),'MinLeafSize',bestleafsize(i));
    ypredict(:,i)=predict(besttree,features);    
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