function [ picker ] = Ujisuanchangdu( order )
%UJISUANCHANGDU Summary of this function goes here
%   Detailed explanation goes here
picker.location=[0 0];%��ʼ�����Ա����
picker.length=0;%��ʼ�����·������
picker.order=order;%������ʼ������

xiangdaoyouhuo=zeros(4,1);%��ʼ��ģ�����������0 0 0 0��
maxyouhuoxiangdao=0;%��ʼ������л������Ϊ��0��
minyouhuoxiangdao=999;%��ʼ����С�л������Ϊ��999��

for  i=1:length(order)%��order�ĵ�1�п�ʼѭ����order�����һ��
    xiangdaoyouhuo(order(i,1))=1;%���л���Ҫ����ѡ�����ѡ���������0 1 0 1��
    if maxyouhuoxiangdao<order(i,1)
        maxyouhuoxiangdao=order(i,1);
    end
    if minyouhuoxiangdao>order(i,1)
       minyouhuoxiangdao=order(i,1);
    end
end

end

