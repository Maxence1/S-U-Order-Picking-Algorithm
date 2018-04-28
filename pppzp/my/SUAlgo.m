function [ picker ] = SUAlgo( order,PARAM )

%   函数的功能：     计算S+U型路线
%   函数的描述：     输入为订单列表，返回为
%   函数的使用：     picker=SUAlgo( order,PARAM )
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

%%  -------------------------------2.找出第一个有货的巷道和最后一个有货的巷道--------------------------------------------

    minPos      = min( order ) ; 
    minRoad    = minPos(1);
    maxPos      = max( order );
    maxRoad    = maxPos(1);


%% -------------------------------3.以middle分开上下两层,first上半层，second下半层----------------------------------------------------------------------------------
    
    middle = SHELF_LENGTH/2;
    for i=1:ROAD_NUM
        xiangdao(i).first = [];
        xiangdao(i).second = [];
    end
    [orderNum ,~ ] = size(order);
    for i=1:orderNum
        if(order(i,2) <= middle)
            xiangdao(order(i,1)).first = [xiangdao(order(i,1)).first;order(i,:)];
        else
            xiangdao(order(i,1)).second = [xiangdao(order(i,1)).second;order(i,:)];
        end
    end
    

    
%%-------------------------------4.开始拣货----------------------------------------------------------------------------------
picker.path= [0,0];
for i = 1:maxRoad-1
    %进入第i条巷道，打点，如果是首个巷道，不用打点
    if(i ~= 1)
        lastPath= picker.path(end,:);
        picker.path = [picker.path; [lastPath(1)+ROAD_WIDTH+ 2*SHELF_WIDTH,lastPath(2)]];
    end
    lastPath = picker.path(end,:);
    if(length(xiangdao(i).first) == 0 && length(xiangdao(i).second) == 0)
        %如果这条巷道没货物,那么继续处理下一个巷道
        continue;
    else
        %说明这个巷道是有货物的
        if(lastPath(2)== 0)
            %1.如果是从下到上，检查second是否有货物，如果有则S,没有则U
            if(length(xiangdao(i).second) == 0)
                %这条巷道只有前半部分有货物，U型
                %首先找到first中最远的那个，打点，然后返回主干道，打点
                %找出巷道中距离最远的那个货品
                itemList = xiangdao(i).first;
                [ ~, pos ] = sort( itemList( :, 2 ) ); 
                itemListSorted = itemList(  pos ,:);
                lastItemPos = itemListSorted(end,:);
                picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
                 %拣货完成后回到street
                 picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
            else
                %这条巷道后半段有货物，需要直接穿过去
                picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
                continue;
            end
        else
              %2.如果从上到下，检查first是否有货物，如果有则S,没有则U
                if(length(xiangdao(i).first) == 0)
                %这条巷道只有前半部分有货物，U型
                %首先找到first中最远的那个，打点，然后返回主干道，打点
                %找出巷道中距离最远的那个货品
                    itemList = xiangdao(i).second;
                    [ ~, pos ] = sort( itemList( :, 2 ) ); 
                    itemListSorted = itemList(  pos ,:);
                    lastItemPos = itemListSorted(1,:);
                    picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
                     %拣货完成后回到street
                     picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
                else
                    %这条巷道后半段有货物，需要直接穿过去
                    picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
                    continue;
                end
        end
    end
end
        
%现在开始处理maxRoad，也就是最后一个有货的巷道
if(maxRoad ~= 1)
    lastPath= picker.path(end,:);
    picker.path = [picker.path; [lastPath(1)+ROAD_WIDTH+ 2*SHELF_WIDTH,lastPath(2)]];
end
%如果从上到下
lastPath= picker.path(end,:);
if(lastPath(2) ~=0)
    picker.path = [picker.path;[(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
    picker.path=[picker.path;[0,0]];
else
    %找出巷道中距离最远的那个货品
    itemList = [xiangdao(maxRoad).first; xiangdao(maxRoad).second];
    [ ~, pos ] = sort( itemList( :, 2 ) ); 
    itemListSorted = itemList(  pos ,:);
    lastItemPos = itemListSorted(end,:);
    picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
     %拣货完成后回到street
    picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
    picker.path=[picker.path;[0,0]];
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
            sprintf('wrong path! something wrong with your algo, please re-check ')
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


picker.length = totalLength;
end
 
 