%%--------------------------------1.初始化变量-----------------------------------------------------------------------------
    % 默认货架最上编号最大，货架最下编号最小
    % 默认不考虑拣货车的容量问题
    % 默认巷道走的顺序是从小编号的巷道走到大编号的巷道
        
    PARAM.SHELF_NUM             = 8;                                        % 货架数量
    PARAM.ROAD_NUM               = PARAM.SHELF_NUM / 2;      % 巷道数量
    PARAM.ITEM_NUM               = 30;                                      % 每个货架上的数量
    PARAM.ROAD_WIDTH           = 1;                                        % 巷道宽度
    PARAM.SHELF_WIDTH         = 1;                                        % 货架宽度
    PARAM.SHELF_LENGTH       = 30;                                      % 货架长度
    PARAM.STREET_WIDTH       = 1;                                        % 上下过道总宽度
    
  
%%    ------------------------------2.随机构造订单列表-----------------------------------------------------------------------------
% 我自己随便构造的订单列表    
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


%使用之前方法构造的订单列表
orders=createRandOrder2(50,PARAM);
[neworders,totalsavedis,previousTotalDis,afterTotalDis]=orderBatching(orders);
order = (neworders(1,1).list);
%%    ------------------------------3.执行算法-----------------------------------------------------------------------------    
  
%U型
% picker = middleAlgo(order,PARAM);


%S+U型
picker = SUAlgo(order,PARAM);
  
    
    
%%    ------------------------------5.算法过程可视化-----------------------------------------------------------------------------    

    path = picker.path;
    
    %货架编号图
     subplot(2,2,1);
     plot(order(:,1),order(:,2),'O');
     xlim([0,PARAM.ROAD_NUM+1]);
     ylim([0,PARAM.SHELF_LENGTH+1]);
     xlabel('货品巷道号');
     ylabel('货品位置号');
     title('图1-货架编号图');
     
     
     %货品位置图
     subplot(2,2,2);
     itemX = (order(:,1)-1) * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH);
     itemY = order(:,2) +PARAM.STREET_WIDTH/2;
     plot(itemX,itemY ,'O');
     xlim([0,PARAM.ROAD_NUM * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH)+1]);
     ylim([0,PARAM.STREET_WIDTH + PARAM.SHELF_LENGTH+1]);
     xlabel('货品位置横坐标');
     ylabel('货品位置纵坐标');
     title('图2-货品位置图');
       
       
     %拣货员路线图
     subplot(2,2,3);
     for i = 1:length(path)-1
         plot([path(i,1),path(i+1,1)],[path(i,2),path(i+1,2)],'-o');
          title('图3-拣货员路线图');
         xlim([0,PARAM.ROAD_NUM * (2*PARAM.SHELF_WIDTH + PARAM.ROAD_WIDTH)+1]);
         ylim([0,PARAM.STREET_WIDTH + PARAM.SHELF_LENGTH+1]);
         hold on;
         pause(0.4);
     end