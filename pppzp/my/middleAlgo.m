function [ picker ] = middleAlgo( order,PARAM  )


%   函数的功能：     计算最初版本的U型路线
%   函数的描述：     输入为订单列表，返回为
%   函数的使用：     picker=middleAlgo( order,PARAM )
%   输入：
%            order          :       一个订单, 二维数组,  (roadNum, colNum, itemCount)    =>(巷道值, 所在巷道的位置, 商品所需数量)  
%            PARAM          :       保存了一些初始化参数
%   输出：
%            picker        :      拣货员对象
%               -path       :      拣货员的行走轨迹
%               -length   :      拣货员的总路程



%%--------------------------------1.初始化变量-----------------------------------------------------------------------------
              
    SHELF_NUM             = PARAM.SHELF_NUM;                  % 货架数量
    ROAD_NUM               = PARAM.ROAD_NUM;                    % 巷道数量
    ITEM_NUM               = PARAM.ITEM_NUM;                    % 每个货架上的数量
    ROAD_WIDTH           = PARAM.ROAD_WIDTH;                % 巷道宽度
    SHELF_WIDTH         = PARAM.SHELF_WIDTH;              % 货架宽度
    SHELF_LENGTH       = PARAM.SHELF_LENGTH;            % 货架长度
    STREET_WIDTH       = PARAM.STREET_WIDTH;            % 上下过道总宽度
    
    % 默认货架最上编号最大，货架最下编号最小
    % 默认不考虑拣货车的容量问题
    % 默认巷道走的顺序是从小编号的巷道走到大编号的巷道


%%  -------------------------------2.找出第一个有货的巷道和最后一个有货的巷道--------------------------------------------

    minPos      = min( order ) ; 
    minRoad    = minPos(1);
    maxPos      = max( order );
    maxRoad    = maxPos(1);


%% -------------------------------3.以middle分开上下两层----------------------------------------------------------------------------------
    
    middle = SHELF_LENGTH/2;
    for i=1:ROAD_NUM
        xiangdao(i).first = [];
        xiangdao(i).second = [];
    end
    for i=1:length(order)
        if(order(i,2) <= middle)
            xiangdao(order(i,1)).first = [xiangdao(order(i,1)).first;order(i,:)];
        else
            xiangdao(order(i,1)).second = [xiangdao(order(i,1)).second;order(i,:)];
        end
    end
    
 %%-------------------------------4.开始拣货----------------------------------------------------------------------------------
    
 picker.path = [0,0];
 for i=1:maxRoad-1
     if( length(xiangdao(i).first) ~= 0)
         %记录入口坐标,横坐标 = i*(两个货架宽 + 一个巷道宽)
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
         %找出巷道中距离最远的那个货品
        itemList = xiangdao(i).first;
        [ ~, pos ] = sort( itemList( :, 2 ) ); 
        itemListSorted = itemList(  pos ,:);
        lastItemPos = itemListSorted(end,:);
        picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
         %拣货完成后回到street
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     end
 end
 
 %到达maxRoad路口
 picker.path = [picker.path; [(maxRoad -1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
 
 %但是如果是最后一列的话就视情况而定：
 %1.如果上半部分没有一个货品，直接返回street然后返回起点
 %2.如果上半部分存在货品，不应该返回street而是直接前行
 hasSecond = -1;
 for i = 1:maxRoad
     if( length(xiangdao(i).second) ~= 0 )
         hasSecond = 1;
     end
 end

 if(hasSecond == -1)
     %如果不存在上半部分,回到street,回到原点
     picker.path = [picker.path;[(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     picker.path = [picker.path;[0,0]];
     return ; 
 else
     %如果存在上半部分，往上走，再往回走
     picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
     for i = maxRoad-1:-1:minRoad +1
         if( length(xiangdao(i).second) ~= 0 )
         %记录入口坐标,横坐标 = i*(两个货架宽 + 一个巷道宽)
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
         %对于每一个商品
         [itemCount, ~] = size(size(xiangdao(i).second));
         for item = 1:itemCount
             %以此记录货品的坐标,纵坐标 = 半个street宽度 +  货物的高度
             temp = xiangdao(i).second(item,:);
             picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),temp(2) + STREET_WIDTH/2]];
         end
         %拣货完成后回到street
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
         end
     end
     %到达第一个巷道
     picker.path = [picker.path; [(minRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
     picker.path = [picker.path; [(minRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     picker.path = [picker.path; [0,0]];
     return;
 end
 
 
%%-------------------------------5.计算拣货总路程----------------------------------------------------------------------------------
totalLength = 0;
for i = 2:length(picker.path)-1
    currentLocation = picker.path(i,:);
    lastLocation = picker.path(i-1,:);
    if(currentLocation(1) == lastLocation(1))
        if(currentLocation(2) == lastLocation(2))
            continue;
        else
            totalLength = totalLength + abs(currentLocation(2) - lastLocation(2));
        end
    else
        if(currentLocation(2) == lastLocation(2))
            totalLength = totalLength + abs(currentLocation(1) - lastLocation(1));
        else
            printf('wrong path')
            break;
        end
    end
end

lastPos = picker.path(length(picker.path)-1,:);
if(lastPos(1) == 0)
    totalLength = totalLength + lastPos(2);
else
    totalLength = totalLength + lastPos(1);
end 

end
    
         
   