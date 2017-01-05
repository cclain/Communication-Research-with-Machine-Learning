function [budget,CCR]=alloc_em_func(mlist,group)
k=12;
%plist=[0.66,0.675,0.736,0.711,0.681,0.687,0.674,0.488,0.69,0.664,0.683,0.679];
nlist=[104,47,29,76,201,199,96,13,138,33,32,2];
ngroup=[0,104,151,180,256,457,656,752,765,903,936,968,970];
n=sum(nlist);
budget=0;
chooselist=zeros(n,1);
for i=1:k
   %sum over tweet correct rate in a certain node 
   chooselist(ngroup(i)+1:ngroup(i+1))=group(ngroup(i)+1:ngroup(i+1),ceil(mlist(i)*0.5+1.5));
   budget=budget+nlist(i)*mlist(i)*0.05;
end
% tempone=ones(n,1);
%dev=dot(chooselist,(tempone-chooselist));
%dev=sqrt(dev)/n;
CCR=sum(chooselist)/n;
end
