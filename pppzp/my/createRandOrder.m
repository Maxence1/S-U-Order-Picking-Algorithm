function [ orders ] = createRandOrder( orderNum )
%CREATERANDORDER Summary of this function goes here
%   Detailed explanation goes here
for i=1:orderNum
    itemcount=unidrnd(10);
    rowcount=unidrnd(itemcount);
    for j=1:rowcount
        orders(i).list(j,1)=unidrnd(4);
        orders(i).list(j,2)=unidrnd(10);
        orders(i).list(j,3)=1;
    end
    for j=1:itemcount-rowcount
        k=unidrnd(rowcount);
        orders(i).list(k,3)=orders(i).list(k,3)+1;
    end
    [ picker ] = Sjisuanchangdu( orders(i).list );
    orders(i).length=picker.length;
    orders(i).itemcount=itemcount;
end

end

