function [ picker ] = Sjisuanchangdu( orderList )
%JISUANCHANGDU Summary of this function goes here
%   Detailed explanation goes here
picker.location=[0 0];%初始化拣货员坐标
picker.length=0;%初始化拣货路径长度
picker.orderList=orderList;%？？初始化订单
[row,col]=size(orderList);
xiangdaoyouhuo=zeros(4,1);%初始化模型四条巷道（0 0 0 0）
maxyouhuoxiangdao=0;%初始化最大有货巷道号为第0号
minyouhuoxiangdao=999;%初始化最小有货巷道号为第999号

for  i=1:row%从orderList的第1行开始循环至orderList的最后一行
    xiangdaoyouhuo(orderList(i,1))=1;
    if maxyouhuoxiangdao<orderList(i,1)
        maxyouhuoxiangdao=orderList(i,1);
    end
    if minyouhuoxiangdao>orderList(i,1)
       minyouhuoxiangdao=orderList(i,1);
    end
end%将有货物要被拣选的巷道选择出来例（0 1 0 1）

maxhuoweiL=0;%初始化最左端巷道需被拣选货位最大货位号为0
maxhuoweiR=0;%初始化最右端巷道需被拣选货位最大货位号为0
for  i=1:row%从orderList的第1行开始循环至orderList的最后一行
    if orderList(i,1)==minyouhuoxiangdao
        if maxhuoweiL<orderList(i,2)
            maxhuoweiL=orderList(i,2);
        end
    end
    if orderList(i,1)==maxyouhuoxiangdao
        if maxhuoweiR<orderList(i,2)
            maxhuoweiR=orderList(i,2);
        end
    end
end%以上循环找出了一张订单中最右侧巷道和最左侧巷道要被拣选的最大货位号

step=1; 
if maxhuoweiL>maxhuoweiR%当最左侧巷道货位号大于最右侧巷道货位号时计算picker的拣货路径、坐标、行走距离
    picker.path(step,:)=[0 0];
    picker.location=[(minyouhuoxiangdao-1)*6 0];
    picker.length=picker.length+(minyouhuoxiangdao-1)*6;
    step=step+1;
    picker.path(step,:)=picker.location;
    for i=minyouhuoxiangdao:maxyouhuoxiangdao-1
        step=step+1;
        if xiangdaoyouhuo(i,1)==1
            if picker.location(1,2)==0
                picker.location(1,2)=14;
            else
                 picker.location(1,2)=0;
            end
            picker.length=picker.length+14;
            picker.path(step,:)=picker.location;
            step=step+1;
            picker.location(1,1)=picker.location(1,1)+6;
            picker.length=picker.length+6;
            picker.path(step,:)=picker.location;
        else
             picker.location(1,1)=picker.location(1,1)+6;
             picker.length=picker.length+6;
            picker.path(step,:)=picker.location;
        end
    end%以上循环用于最右侧巷道之前的路径计算
    if picker.location(1,2)==0
        step=step+1;
        picker.location(1,2)=maxhuoweiR+1.5;
        picker.length=picker.length+1.5+maxhuoweiR;
        picker.path(step,:)=picker.location;
         step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+1.5+maxhuoweiR;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;
    else%以上代码用于计算最右侧巷道的最大货位取货距离
         
          step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+14;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;%以上代码用于计算返回原点水平距离
    end
else
    %当最左侧巷道货位号小于最右侧巷道货位号时计算picker的拣货路径、坐标、行走距离
    picker.path(step,:)=[0 0];
    picker.location=[(maxyouhuoxiangdao-1)*6 0];
    picker.length=picker.length+(maxyouhuoxiangdao-1)*6;
    step=step+1;
    picker.path(step,:)=picker.location;
    for i=maxyouhuoxiangdao:-1:minyouhuoxiangdao+1
        step=step+1;
        if xiangdaoyouhuo(i,1)==1
            if picker.location(1,2)==0
                picker.location(1,2)=14;
            else
                 picker.location(1,2)=0;
            end
            picker.length=picker.length+14;
            picker.path(step,:)=picker.location;
            step=step+1;
            picker.location(1,1)=picker.location(1,1)-6;
            picker.length=picker.length+6;
            picker.path(step,:)=picker.location;
        else
             picker.location(1,1)=picker.location(1,1)-6;
             picker.length=picker.length+6;
            picker.path(step,:)=picker.location;
        end
    end%以上循环用于最左侧巷道之后的路径计算
    if picker.location(1,2)==0
        step=step+1;
        picker.location(1,2)=maxhuoweiL+1.5;
        picker.length=picker.length+1.5+maxhuoweiL;
        picker.path(step,:)=picker.location;
         step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+1.5+maxhuoweiL;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;
    else%以上代码用于计算最左侧巷道的最大货位取货距离
         
          step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+14;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;%以上代码用于计算返回原点水平距离
    end
end
end

