function [budget,CCR]=alloc_func(mlist)
k=12;
plist=[0.66,0.675,0.736,0.711,0.681,0.687,0.674,0.488,0.69,0.664,0.683,0.679];
plist=[0.7,0.706,0.741,0.729,0.678,0.698,0.671,0.492,0.691,0.654,0.726,0.65]
nlist=[104,47,29,76,201,199,96,13,138,33,32,2];
n=sum(nlist);
n_ratio=nlist/n;
CCR=0;
budget=0;
for i=1:k
   groupsum=0;
   for m=ceil(mlist(i)/2) :mlist(i)
       tempsum=nchoosek(mlist(i),m)*(plist(i)^m)*(1-plist(i))^(mlist(i)-m);
       groupsum=groupsum+tempsum;
   end
   CCR=CCR+groupsum*n_ratio(i);
   budget=budget+nlist(i)*mlist(i)*0.05;
end

end