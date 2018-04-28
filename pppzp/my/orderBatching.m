function [ orders, totalsavedis,previousTotalDis,afterTotalDis] = orderBatching( orders )
%ORDERBATCHING Summary of this function goes here
%   Detailed explanation goes here
carLimit=10;
orderBatched=1;
totalsavedis=0;
previousTotalDis=0;
afterTotalDis=0;
for i=1:length(orders)
    previousTotalDis=previousTotalDis+orders(i).length;
end
while orderBatched>0
    orderBatched=0;
    for i=1:length(orders)-1
        for j=i+1:length(orders)
            Quantity1=orderQuantity(orders(i).list);
            Quantity2=orderQuantity(orders(j).list);
            if Quantity1+Quantity2<=carLimit
                orderBatched=orderBatched+1;
                newOrder(orderBatched).orderdad=i;
                newOrder(orderBatched).ordermom=j;
                newOrder(orderBatched).list=[orders(i).list;orders(j).list];
                picker1=Sjisuanchangdu(orders(i).list);
                picker2=Sjisuanchangdu(orders(j).list);
                picker3=Sjisuanchangdu(newOrder(orderBatched).list);
                newOrder(orderBatched).length=picker3.length;
                newOrder(orderBatched).savedis=picker1.length+picker2.length-picker3.length;
                newOrder(orderBatched).itemcount=Quantity1+Quantity2;
            end
        end
    end
    
    if orderBatched>0
        maxsavedis=-9999;
        maxsaveindex=0;
        for i=1:orderBatched
            if  newOrder(i).savedis>maxsavedis
                maxsavedis=newOrder(i).savedis;
                maxsaveindex=i;
            end
        end
        refreshOrders=[];
        refreshOrders(1).list=newOrder(maxsaveindex).list;
        refreshOrders(1).length=newOrder(maxsaveindex).length;
        refreshOrders(1).itemcount=newOrder(maxsaveindex).itemcount;
        j=2;
        for i=1:length(orders)
            if (i~=newOrder(maxsaveindex).orderdad) && (i~=newOrder(maxsaveindex).ordermom)
                refreshOrders(j)=orders(i);
                j=j+1;
            end
        end
        totalsavedis=totalsavedis+maxsavedis;
        orders=refreshOrders;
    end
end
for i=1:length(orders)
   afterTotalDis=afterTotalDis+orders(i).length;
end
end

