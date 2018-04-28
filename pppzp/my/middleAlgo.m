function [ picker ] = middleAlgo( order,PARAM  )


%   �����Ĺ��ܣ�     ��������汾��U��·��
%   ������������     ����Ϊ�����б�����Ϊ
%   ������ʹ�ã�     picker=middleAlgo( order,PARAM )
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
    
    % Ĭ�ϻ������ϱ����󣬻������±����С
    % Ĭ�ϲ����Ǽ��������������
    % Ĭ������ߵ�˳���Ǵ�С��ŵ�����ߵ����ŵ����


%%  -------------------------------2.�ҳ���һ���л�����������һ���л������--------------------------------------------

    minPos      = min( order ) ; 
    minRoad    = minPos(1);
    maxPos      = max( order );
    maxRoad    = maxPos(1);


%% -------------------------------3.��middle�ֿ���������----------------------------------------------------------------------------------
    
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
    
 %%-------------------------------4.��ʼ���----------------------------------------------------------------------------------
    
 picker.path = [0,0];
 for i=1:maxRoad-1
     if( length(xiangdao(i).first) ~= 0)
         %��¼�������,������ = i*(�������ܿ� + һ�������)
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
         %�ҳ�����о�����Զ���Ǹ���Ʒ
        itemList = xiangdao(i).first;
        [ ~, pos ] = sort( itemList( :, 2 ) ); 
        itemListSorted = itemList(  pos ,:);
        lastItemPos = itemListSorted(end,:);
        picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),lastItemPos(2) + STREET_WIDTH/2]];
         %�����ɺ�ص�street
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     end
 end
 
 %����maxRoad·��
 picker.path = [picker.path; [(maxRoad -1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
 
 %������������һ�еĻ��������������
 %1.����ϰ벿��û��һ����Ʒ��ֱ�ӷ���streetȻ�󷵻����
 %2.����ϰ벿�ִ��ڻ�Ʒ����Ӧ�÷���street����ֱ��ǰ��
 hasSecond = -1;
 for i = 1:maxRoad
     if( length(xiangdao(i).second) ~= 0 )
         hasSecond = 1;
     end
 end

 if(hasSecond == -1)
     %����������ϰ벿��,�ص�street,�ص�ԭ��
     picker.path = [picker.path;[(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     picker.path = [picker.path;[0,0]];
     return ; 
 else
     %��������ϰ벿�֣������ߣ���������
     picker.path = [picker.path; [(maxRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
     for i = maxRoad-1:-1:minRoad +1
         if( length(xiangdao(i).second) ~= 0 )
         %��¼�������,������ = i*(�������ܿ� + һ�������)
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
         %����ÿһ����Ʒ
         [itemCount, ~] = size(size(xiangdao(i).second));
         for item = 1:itemCount
             %�Դ˼�¼��Ʒ������,������ = ���street��� +  ����ĸ߶�
             temp = xiangdao(i).second(item,:);
             picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),temp(2) + STREET_WIDTH/2]];
         end
         %�����ɺ�ص�street
         picker.path = [picker.path; [(i-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
         end
     end
     %�����һ�����
     picker.path = [picker.path; [(minRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),SHELF_LENGTH + STREET_WIDTH]];
     picker.path = [picker.path; [(minRoad-1)*(2*SHELF_WIDTH + ROAD_WIDTH),0]];
     picker.path = [picker.path; [0,0]];
     return;
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
    
         
   