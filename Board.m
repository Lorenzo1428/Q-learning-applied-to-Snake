classdef Board
    properties
        size_b = 32;
        apple = [15 20];
        reward;
        state
    end
    
    methods
        function T = GenerateBoard(~,size_b,pos,apple)
            T = zeros(size_b);
            T(apple(1),apple(2)) = 3;
            T(pos(1,1),pos(1,2)) = 2;
            for i = 2:size(pos,1)
                T(pos(i,1),pos(i,2)) = 1;
            end
        end

        function state = State(~,apple,snake) %(up,down,,sx,dx, a.dxdown,a.sxup,a.sxdown,a.dxup, d.up,d.down,d.r,d.l)
            S = false(1,12);
            snake.dir = getDirection(snake);
            %posizione relativa di snake  
            if snake.dir == 1
               S(1) = true;
            end
            if snake.dir == 2
               S(2) = true;
            end
            if snake.dir == 3
               S(3) = true;
            end
            if snake.dir == 4
               S(4) = true;
            end 
            %posizione della mela rispetto a snake
            if apple(1)  <= snake.head(1) %&& apple(2) >= snake.head(2)   
               S(5) = true;
            end
            if apple(1)  >= snake.head(1) %&& apple(2) <= snake.head(2)   
               S(6) = true;
            end
            if apple(2)  <= snake.head(2) %&& apple(1) <= snake.head(1)   
               S(7) = true;
            end
            if apple(2)  >= snake.head(2) %&& apple(1) >= snake.head(1)   
               S(8) = true;
            end
            %se vicino ad un pericolo
            if snake.head(1) == 1 || isequal(intersect(snake.position(2:end,:),[snake.head(1)-1, snake.head(2)],'rows'),[snake.head(1)-1, snake.head(2)]) %pericolo up
               S(9) = true;
            end
            if snake.head(1) == 32 || isequal(intersect(snake.position(2:end,:),[snake.head(1)+1, snake.head(2)],'rows'),[snake.head(1)+1, snake.head(2)])%down
               S(10) = true; 
            end
            if snake.head(2) == 1 || isequal(intersect(snake.position(2:end,:),[snake.head(1), snake.head(2)-1],'rows'),[snake.head(1), snake.head(2)-1]) %sx
               S(11) = true;
            end
            if snake.head(2) == 32 || isequal(intersect(snake.position(2:end,:),[snake.head(1), snake.head(2)+1],'rows'),[snake.head(1), snake.head(2)+1]) %dx
               S(12) = true;
            end
            s = num2str(S);
            s(isspace(s)) = '';
            state = bin2dec(s);
        end
    end
end

