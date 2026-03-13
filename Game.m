clc
clear
close all

imax = 100; %quante partite per stampare i dati
dim = 1000; %quanti episodi di training
map = [0 0 0; 0 0.7 0;0 0.9 0; 1 0 0];
t = Board;
snake = Snake;
snake.position = generateSnake(snake);
snake.head = getHead(snake);
Q = load(['save',num2str(dim),'.mat']).Q;
state = t.State(t.apple,snake);
img = imagesc(t.GenerateBoard(t.size_b,snake.position,t.apple));
set(gca,'XColor','none','YColor','none');
axis("square");
colormap(map);
episodes = 1;
score = zeros(imax,1);
steps_no_food = 0;
smax = 300;

while episodes <= imax
    action = getAction(Q,state,snake);
    snake.position = doAction(snake,action,t.apple);
    snake.head = getHead(snake);
    new_state = t.State(t.apple,snake);
    state = new_state;
    steps_no_food = steps_no_food +1;
 
    if snake.head == t.apple
        t.apple = randi(32,1,2);
        score(episodes) = score(episodes) + 1;
        steps_no_food = 0;
    end

    if any(find(snake.head == 0)) || any(find(snake.head == t.size_b +1)) || isequal(intersect(snake.position(2:end,:),snake.head,'rows'),snake.head) || steps_no_food == smax
        snake.position = generateSnake(snake);
        snake.head = getHead(snake);
        t.apple = randi(32,1,2);
        disp([episodes,score(episodes)])
        episodes = episodes +1;
        steps_no_food = 0;
    end

    set(img, 'CData', t.GenerateBoard(t.size_b,snake.position,t.apple));
    drawnow;
    exportgraphics(gca,'snake.png',"Resolution",150);
    %pause(0.05);
end
plot(score)
xlabel('matches');
ylabel('score');
%exportgraphics(gca,['snake',num2str(dim),'.png'],"Resolution",150);
disp([mean(score) max(score) min(score)])

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