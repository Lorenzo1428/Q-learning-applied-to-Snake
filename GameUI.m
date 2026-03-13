clc
clear
close all

axes(Position=[-0.10 0.08 0.85 0.85],Color='black')
map = [0 0 0; 0 0 0;0 0 0; 0 0 0];
img = imagesc(zeros(32));
colormap(map);
axis("off","square");
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%map = [0 0 0; 0 0.7 0;0 0.9 0; 1 0 0];
%Q = zeros(4095,4);
%set(gcf,'Position' ,[0,0,800,800])
%img = imagesc(zeros(32));
%colormap(map);
global score match matches episodes record records;
score = uicontrol("Style","text","String",'0',Position=[1330 776 80 30],ForegroundColor='red',FontSize=22);
matches = uicontrol("Style","text","String",'0',Position=[1330 876 80 30],ForegroundColor='red',FontSize=22);
episodes = uicontrol("Style","text","String",'0',Position=[1350 576 100 30],ForegroundColor='red',FontSize=22);
records = uicontrol("Style","text","String",'0',Position=[1350 676 60 30],ForegroundColor='red',FontSize=22);
 
titleTxt = uicontrol("Style","text","String",'Snake',FontSize=35,Position=[200 920 150 55], ForegroundColor=[0 0.5 0],FontWeight='bold',FontAngle='italic');
matchTxt = uicontrol("Style","text","String",'Partite:',FontSize=25,Position=[1200 850 150 60], ForegroundColor=[0 0 0.5],FontWeight='bold',FontAngle='italic');
counterTxt = uicontrol("Style","text","String",'Punti:',FontSize=25,Position=[1200 750 150 60], ForegroundColor=[0 0 0.5],FontWeight='bold',FontAngle='italic');
episodeTxt = uicontrol("Style","text","String",'Episodi:',FontSize=25,Position=[1200 550 150 60],ForegroundColor=[0 0 0.5],FontWeight='bold',FontAngle='italic');
recordTxt = uicontrol("Style","text","String",'Record:',FontSize=25,Position=[1200 650 150 60],ForegroundColor=[0 0 0.5],FontWeight='bold',FontAngle='italic');


B1 = uicontrol("Style","pushbutton",String='7',FontSize=20,Position=[1200,380,170,135]);
B2 = uicontrol("Style","pushbutton",String='1000',FontSize=20,Position=[1200,240,170,135]);
B3 = uicontrol("Style","pushbutton",String='5000',FontSize=20,Position=[1200,100,170,135]);
B4 = uicontrol("Style","pushbutton",String='500',FontSize=20,Position=[1400,380,170,135]);
B5 = uicontrol("Style","pushbutton",String='2500',FontSize=20,Position=[1400,240,170,135]);
B6 = uicontrol("Style","pushbutton",String='10000',FontSize=20,Position=[1400,100,170,135]);

B1.Callback = @playCallback;
B2.Callback = @playCallback;
B3.Callback = @playCallback;
B4.Callback = @playCallback;
B5.Callback = @playCallback;
B6.Callback = @playCallback;
%playGame(load('save1k.mat').Q,snake,t);

record = 0;
match = 0;

function playCallback(src,event)
    global episodes matches;
    Q = load(['save',src.String,'.mat']).Q;
    episodes.String = src.String;
    %matches.String = '0';
    playGame(Q);
    src.Value = false;
end

function playGame(Q)
    map = [0 0 0; 0 0.7 0;0 0.9 0; 1 0 0];
    img = imagesc(zeros(32));
    colormap(map);
    axis("off","square");
    global score match matches record records;
    point = 0;
    match = match +1;
    matches.String = num2str(match);
    snake = Snake;
    t = Board;
    snake.position = generateSnake(snake);
    snake.head = getHead(snake);
    state = t.State(t.apple,snake);

    while 1
        action = getAction(Q,state,snake);
        snake.position = doAction(snake,action,t.apple);
        snake.head = getHead(snake);
        new_state = t.State(t.apple,snake);
        state = new_state;
     
        if snake.head == t.apple
            t.apple = randi(32,1,2);
            point = point +1;
            score.String = num2str(point);
            if record <= point
                record = point;
                records.String = num2str(record);
            end
        end
    
        if any(find(snake.head == 0)) || any(find(snake.head == 33)) || isequal(intersect(snake.position(2:end,:),snake.head,'rows'),snake.head)
            snake.position = generateSnake(snake);
            snake.head = getHead(snake);
            t.apple = randi(32,1,2);
            point = 0;
            score.String = '0';
            match = match + 1;
            matches.String = num2str(match);
        end
        
        set(img, 'CData', t.GenerateBoard(t.size_b,snake.position,t.apple));
        drawnow;
        pause(0.05);
    end
end

function a = getAction(Q,S,snake)
    snake.dir = getDirection(snake);
    switch snake.dir
        case 1
            value = 2;
        case 2
            value = 1;
        case 3
            value = 4;
        case 4
            value = 3;
    end
        Q(:,value) = [];
        [~, a] = max(Q(S,:),[],"all");
        if a >= value
            a = a+1;
        end
end

function pos = doAction(snake,action,apple) 
    switch action
        case 1
            snake.head(1) = snake.head(1) - 1; 
        case 2
            snake.head(1) = snake.head(1) + 1; 
        case 3
            snake.head(2) = snake.head(2) - 1; 
        case 4
            snake.head(2) = snake.head(2) + 1; 
    end  
    pos = [snake.head; snake.position];
    if ~isequal(snake.head,apple)
        pos(end,:) = [];
    end
end