%%--------------------------------1.��ʼ������-----------------------------------------------------------------------------
    % Ĭ�ϻ������ϱ����󣬻������±����С
    % Ĭ�ϲ����Ǽ��������������
    % Ĭ������ߵ�˳���Ǵ�С��ŵ�����ߵ����ŵ����
        
    PARAM.SHELF_NUM             = 8;                                        % ��������
    PARAM.ROAD_NUM               = PARAM.SHELF_NUM / 2;      % �������
    PARAM.ITEM_NUM               = 30;                                      % ÿ�������ϵ�����
    PARAM.ROAD_WIDTH           = 1;                                        % ������
    PARAM.SHELF_WIDTH         = 1;                                        % ���ܿ��
    PARAM.SHELF_LENGTH       = 30;                                      % ���ܳ���
    PARAM.STREET_WIDTH       = 1;                                        % ���¹����ܿ��
    
  
%%    ------------------------------2.������충���б�-----------------------------------------------------------------------------
% ���Լ���㹹��Ķ����б�    
%     count = 1;
%     order = [];
%     for i =1 : ROAD_NUM
%         for j = 1:SHELF_LENGTH
%             randNum = rand();
%             if(randNum > 0.8)
%                 hasItem = 1;
%             else
%                 hasItem = 0;
%             end
%             if(hasItem == 1)
%                 order= [order;[i,j]];  
%             end
%         end
%     end


%ʹ��֮ǰ��������Ķ����б�
orders=createRandOrder2(50,PARAM);
[neworders,totalsavedis,previousTotalDis,afterTotalDis]=orderBatching(orders);
order = (neworders(1,1).list);
%%    ------------------------------3.ִ���㷨-----------------------------------------------------------------------------    
  
%U��
% picker = middleAlgo(order,PARAM);


%S+U��
picker = SUAlgo(order,PARAM);
  
    
    
%%    ------------------------------5.�㷨���̿��ӻ�-----------------------------------------------------------------------------    

    path = picker.path;
    
    %���ܱ��ͼ
     subplot(2,2,1);
     plot(order(:,1),order(:,2),'O');
     xlim([0,PARAM.ROAD_NUM+1]);
     ylim([0,PARAM.SHELF_LENGTH+1]);
     xlabel('��Ʒ�����');
     ylabel('��Ʒλ�ú�');
     title('ͼ1-���ܱ��ͼ');
     
     
     %��Ʒλ��ͼ
     subplot(2,2,2);
     itemX = (order(:,1)-1) * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH);
     itemY = order(:,2) +PARAM.STREET_WIDTH/2;
     plot(itemX,itemY ,'O');
     xlim([0,PARAM.ROAD_NUM * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH)+1]);
     ylim([0,PARAM.STREET_WIDTH + PARAM.SHELF_LENGTH+1]);
     xlabel('��Ʒλ�ú�����');
     ylabel('��Ʒλ��������');
     title('ͼ2-��Ʒλ��ͼ');
       
       
     %���Ա·��ͼ
     subplot(2,2,3);
     for i = 1:length(path)-1
         plot([path(i,1),path(i+1,1)],[path(i,2),path(i+1,2)],'-o');
          title('ͼ3-���Ա·��ͼ');
         xlim([0,PARAM.ROAD_NUM * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH)+1]);
         ylim([0,PARAM.STREET_WIDTH + PARAM.SHELF_LENGTH+1]);
         hold on;
         pause(0.4);
     end