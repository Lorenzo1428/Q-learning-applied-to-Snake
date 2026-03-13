classdef Snake
    properties
        position;
        head;
        dir;
    end
    
    methods
        function position = generateSnake(~)
            r = 6 + randi(20);
            a = randi(12);
            if a <= 3
                position = [r r+1; r r+2];
            elseif a <= 6 && a > 3
               position = [r+1 r; r+2 r];
            elseif a <= 9 && a > 6
                position = [r-1 r; r-2 r];
            elseif a <=12 && a > 9
                position = [r r-1; r r-2];
            end       
        end
        function head = getHead(snake)
            head = [snake.position(1,1) snake.position(1,2)];
        end
        function dir = getDirection(snake)
            neck = [snake.position(2,1) snake.position(2,2)];
            if snake.head(1) < neck(1)
               dir = 1; %up
            end
            if snake.head(1) > neck(1) 
               dir = 2; %down
            end
            if snake.head(2) < neck(2)
                dir = 3; %left
            end
            if snake.head(2) > neck(2)
                dir = 4; %right
            end
        end
    end
end

