function [ Quantity ] = orderQuantity( orderList )
%ORDERQUANTITY Summary of this function goes here
%   Detailed explanation goes here
Quantity=0;
[row,col]=size(orderList);
for i=1:row
    Quantity=Quantity+orderList(i,3);
end

end

