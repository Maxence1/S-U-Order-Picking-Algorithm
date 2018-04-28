function [ picker ] = SUAlgo( order,PARAM )

%   �����Ĺ��ܣ�     ����S+U��·��
%   ������������     ����Ϊ�����б�����Ϊ
%   ������ʹ�ã�     picker=SUAlgo( order,PARAM )
%   ���룺
%            order          :       һ������, ��ά����,  (roadNum, colNum, itemCount)    =>(���ֵ, ���������λ��, ��Ʒ��������)  
%            PARAM          :       ������һЩ��ʼ������
%   �����
%            picker        :      ���Ա����
%               -path       :      ���Ա�����߹켣
%               -length   :      ���Ա����·��


%%--------------------------------1.��ʼ������-----------------------------------------------------------------------------
              
    SHELF_NUM             = PARAM.SHELF_NUM;                  % ��������
    ROAD_NUM               = PARAM.ROAD_NUM;                    % �������
    ITEM_NUM               = PARAM.ITEM_NUM;                    % ÿ�������ϵ�����
    ROAD_WIDTH           = PARAM.ROAD_WIDTH;                % ������
    SHELF_WIDTH         = PARAM.SHELF_WIDTH;              % ���ܿ��
    SHELF_LENGTH       = PARAM.SHELF_LENGTH;            % ���ܳ���
    STREET_WIDTH       = PARAM.STREET_WIDTH;            % ���¹����ܿ��

%%  -------------------------------2.�ҳ���һ���л�����������һ���л������--------------------------------------------

    minPos      = min( order ) ; 
    minRoad    = minPos(1);
    maxPos      = max( order );
    maxRoad    = maxPos(1);


%% -------------------------------3.��middle�ֿ���������,first�ϰ�㣬second�°��----------------------------------------------------------------------------------
    
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
    

    
%%-------------------------------4.��ʼ���----------------------------------------------------------------------------------
picker.path= [0,0];
for i = 1:maxRoad-1
    %�����i���������㣬������׸���������ô��
    if(i ~= 1)
        lastPath= picker.path(end,:);
        picker.path = [picker.path; [lastPath(1)+ROAD_WIDTH+ 2*SHELF_WIDTH,lastPath(2)]];
    end
    lastPath = picker.path(end,:);
    if(length(xiangdao(i).first) == 0 && length(xiangdao(i).second) == 0)
        %����������û����,��ô����������һ�����
        continue;
    else
        %˵�����������л����
        if(lastPath(2)== 0)
            %1.����Ǵ��µ��ϣ����second�Ƿ��л���������S,û����U
            if(length(xiangdao(i).second) == 0)
                %�������ֻ��ǰ�벿���л��U��
                %�����ҵ�first����Զ���Ǹ�����㣬Ȼ�󷵻����ɵ������
                %�ҳ�����о�����Զ���Ǹ���Ʒ
                itemList = xiangdao(i).first;
                [ ~, pos ] = sort( itemList( :, 2 ) ); 
                itemListSorted = itemList(  pos ,:);
                lastItemPos = itemListSorted(end,:);
                picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
                 %�����ɺ�ص�street
                 picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
            else
                %������������л����Ҫֱ�Ӵ���ȥ
                picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
                continue;
            end
        else
              %2.������ϵ��£����first�Ƿ��л���������S,û����U
                if(length(xiangdao(i).first) == 0)
                %�������ֻ��ǰ�벿���л��U��
                %�����ҵ�first����Զ���Ǹ�����㣬Ȼ�󷵻����ɵ������
                %�ҳ�����о�����Զ���Ǹ���Ʒ
                    itemList = xiangdao(i).second;
                    [ ~, pos ] = sort( itemList( :, 2 ) ); 
                    itemListSorted = itemList(  pos ,:);
                    lastItemPos = itemListSorted(1,:);
                    picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
                     %�����ɺ�ص�street
                     picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
                else
                    %������������л����Ҫֱ�Ӵ���ȥ
                    picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
                    continue;
                end
        end
    end
end
        
%���ڿ�ʼ����maxRoad��Ҳ�������һ���л������
if(maxRoad ~= 1)
    lastPath= picker.path(end,:);
    picker.path = [picker.path; [lastPath(1)+ROAD_WIDTH+ 2*SHELF_WIDTH,lastPath(2)]];
end
%������ϵ���
lastPath= picker.path(end,:);
if(lastPath(2) ~=0)
    picker.path = [picker.path;[(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
    picker.path=[picker.path;[0,0]];
else
    %�ҳ�����о�����Զ���Ǹ���Ʒ
    itemList = [xiangdao(maxRoad).first; xiangdao(maxRoad).second];
    [ ~, pos ] = sort( itemList( :, 2 ) ); 
    itemListSorted = itemList(  pos ,:);
    lastItemPos = itemListSorted(end,:);
    picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
     %�����ɺ�ص�street
    picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
    picker.path=[picker.path;[0,0]];
end

%%-------------------------------5.��������·��----------------------------------------------------------------------------------
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
 
 