function [ picker ] = Ujisuanchangdu( order )
%UJISUANCHANGDU Summary of this function goes here
%   Detailed explanation goes here
picker.location=[0 0];%初始化拣货员坐标
picker.length=0;%初始化拣货路径长度
picker.order=order;%？？初始化订单

xiangdaoyouhuo=zeros(4,1);%初始化模型四条巷道（0 0 0 0）
maxyouhuoxiangdao=0;%初始化最大有货巷道号为第0号
minyouhuoxiangdao=999;%初始化最小有货巷道号为第999号

for  i=1:length(order)%从order的第1行开始循环至order的最后一行
    xiangdaoyouhuo(order(i,1))=1;%将有货物要被拣选的巷道选择出来例（0 1 0 1）
    if maxyouhuoxiangdao<order(i,1)
        maxyouhuoxiangdao=order(i,1);
    end
    if minyouhuoxiangdao>order(i,1)
       minyouhuoxiangdao=order(i,1);
    end
end

end

