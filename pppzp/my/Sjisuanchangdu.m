function [ picker ] = Sjisuanchangdu( orderList )
%JISUANCHANGDU Summary of this function goes here
%   Detailed explanation goes here
picker.location=[0 0];%��ʼ�����Ա����
picker.length=0;%��ʼ�����·������
picker.orderList=orderList;%������ʼ������
[row,col]=size(orderList);
xiangdaoyouhuo=zeros(4,1);%��ʼ��ģ�����������0 0 0 0��
maxyouhuoxiangdao=0;%��ʼ������л������Ϊ��0��
minyouhuoxiangdao=999;%��ʼ����С�л������Ϊ��999��

for  i=1:row%��orderList�ĵ�1�п�ʼѭ����orderList�����һ��
    xiangdaoyouhuo(orderList(i,1))=1;
    if maxyouhuoxiangdao<orderList(i,1)
        maxyouhuoxiangdao=orderList(i,1);
    end
    if minyouhuoxiangdao>orderList(i,1)
       minyouhuoxiangdao=orderList(i,1);
    end
end%���л���Ҫ����ѡ�����ѡ���������0 1 0 1��

maxhuoweiL=0;%��ʼ�����������豻��ѡ��λ����λ��Ϊ0
maxhuoweiR=0;%��ʼ�����Ҷ�����豻��ѡ��λ����λ��Ϊ0
for  i=1:row%��orderList�ĵ�1�п�ʼѭ����orderList�����һ��
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
end%����ѭ���ҳ���һ�Ŷ��������Ҳ��������������Ҫ����ѡ������λ��

step=1; 
if maxhuoweiL>maxhuoweiR%������������λ�Ŵ������Ҳ������λ��ʱ����picker�ļ��·�������ꡢ���߾���
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
    end%����ѭ���������Ҳ����֮ǰ��·������
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
    else%���ϴ������ڼ������Ҳ����������λȡ������
         
          step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+14;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;%���ϴ������ڼ��㷵��ԭ��ˮƽ����
    end
else
    %������������λ��С�����Ҳ������λ��ʱ����picker�ļ��·�������ꡢ���߾���
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
    end%����ѭ��������������֮���·������
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
    else%���ϴ������ڼ�����������������λȡ������
         
          step=step+1;
        picker.location(1,2)=0;
        picker.length=picker.length+14;
        picker.path(step,:)=picker.location;
        step=step+1;
        picker.length=picker.length+picker.location(1,1);
        picker.location(1,1)=0;
        picker.path(step,:)=picker.location;%���ϴ������ڼ��㷵��ԭ��ˮƽ����
    end
end
end

