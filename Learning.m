clc
clear
close all

t = Board;
imax = 1000;
smax = 100;
snake = Snake;
snake.position = generateSnake(snake);
snake.head = getHead(snake);
episodes = 1;
gamesteps = 2;
alpha = 0.01;
gamma = 0.95;
eps = 1;
eps_discount = 0.9992;
eps_min = 0.001;

%img = imagesc(t.GenerateBoard(t.size_b,snake.position,t.apple));

Q = zeros(4095,4);
state = t.State(t.apple,snake);
dist = getDist(snake.head, t.apple);
exp_return = zeros(imax,1);
new_return = zeros(imax,1);
steps_without_food = 0;
tic
while episodes < imax
    action = getAction(Q,state,snake,eps);
    snake.position = doAction(snake,action,t.apple);
    snake.head = getHead(snake);
    new_dist = getDist(snake.head, t.apple);
    R = getReward(snake, dist, new_dist, steps_without_food,smax);
    exp_return(episodes) = exp_return(episodes) + R*(R>0);
    new_return(episodes,gamesteps) = R*(R>0) + new_return(episodes,gamesteps-1); %serve per stampare le traiettorie
    new_state = t.State(t.apple,snake);
    Q(state,action) = (1-alpha)*Q(state,action) + alpha*(R + gamma*max(Q(new_state,:),[],"all"));
    state = new_state;
    dist = new_dist;
    steps_without_food = steps_without_food + 1;
    gamesteps = gamesteps +1;
 
    if snake.head == t.apple
        steps_without_food = 0;
        t.apple = randi(32,1,2);
        while isequal(intersect(snake.position,t.apple),t.apple)
            t.apple = randi(32,1,2);
        end
    end
    if any(find(snake.head == 0)) || any(find(snake.head == t.size_b +1)) || isequal(intersect(snake.position(2:end,:),snake.head,'rows'),snake.head) || steps_without_food == smax
        snake.position = generateSnake(snake);
        snake.head = getHead(snake);
        t.apple = randi(32,1,2);
        episodes = episodes +1
        gamesteps = 2;
        steps_without_food = 0;
        %learning_rate = 1/episodes;
        eps = max(eps*eps_discount,eps_min);
        %{
        if mod(episodes,5000) == 0      
        plot(exp_return);
        xlim([0,episodes]); 
        xlabel('episodes');
        ylabel('return');
        drawnow;
        %exportgraphics(gca,['return', num2str(episodes),'.png'],"Resolution",150);
        disp(episodes);
        save(['save',num2str(episodes),'.mat'],'Q');
        end
        %}
    end
    %set(img, 'CData', t.GenerateBoard(t.size_b,snake.position,t.apple));
    %drawnow;
    %pause(0.02);
end
toc
%exportgraphics(gca,['return', num2str(episodes),'.png'],"Resolution",300);
%save(['save',num2str(episodes),'.mat'],'Q');

plot(exp_return); %questo per il grafico del return in funzione delle partite
xlabel('episodes');
ylabel('return');

%new_return(new_return == 0) = nan;
%plot(new_return'); %questo perl'insieme dei return in funzione delle mosse in una singola partita
%xlabel('mosse');
%ylabel('return');

function a = getAction(Q,S,snake,eps)
    snake.dir = getDirection(snake);
    switch snake.dir
        case 1 %up
            value = 2;
        case 2 %down
            value = 1;
        case 3 %left
            value = 4;
        case 4 %right
            value = 3;
    end
    if rand < eps
        a = [1 2 3 4];
        a(value) = [];
        a = a(randi(3));
    else
        Q(:,value) = [];
        [~, a] = max(Q(S,:),[],"all");
        if a >= value
            a = a+1;
        end
    end
end

function pos = doAction(snake,action,apple)  % 1 = left, 2 = right, 3 = up, 4 = down
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

function dist = getDist(head, apple)
    dist = norm(apple-head,inf);
    %dist = sqrt((apple(1)-head(1))^2 + (apple(2)-head(2))^2);
end

function R = getReward(snake, dist, new_dist, steps, smax)
    if any(find(snake.head == 0)) || any(find(snake.head == 33))
        R = -200;
    elseif isequal(intersect(snake.position(2:end,:),snake.head,'rows'),snake.head)
        R = -500;
    elseif new_dist < dist
        R = 4;
    elseif new_dist == 0
        R = 7;
    elseif steps == smax
        R = -200;
    else 
        R = -50;
    end
end
