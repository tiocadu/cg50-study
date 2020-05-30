-- gd50 from Harvard University
-- author: @tiocadu

-- instead of using a package manager, i'm going with local dependences
-- https://github.com/Ulydev/push/blob/master/push.lua
push = require 'libs/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

require 'Paddle'
require 'Ball'
require 'Score'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- setting virtual window. We'll use it with push to make it look more retro
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

COLLISION_CHECK_P1 = false
COLLISION_CHECK_P2 = false

function love.load()
    love.window.setTitle('Hello Pong!')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- setting RNG for the game
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('assets/font.ttf', 8)
    scoreFont = love.graphics.newFont('assets/font.ttf', 32)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- initial score values
    player1Score = Score(VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    player2Score = Score(VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

    -- initial Paddles
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- initial ball position
    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- game state
    gameState = 'start'
end

-- input controll
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

             -- initial ball position and velocity
            ball:reset()
        end
    end
end

function love.update(dt)
    -- player1 controls
    if love.keyboard.isDown('w') then
        player1.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player2 controls
    if love.keyboard.isDown('up') then
        player2.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- collision detection
    COLLISION_CHECK_P1 = ball:collides(player1) and true or false
    COLLISION_CHECK_P2 = ball:collides(player2) and true or false

    -- ball movement
    if gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- detect upper and lower boundaries
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end

        -- update score state
        if ball.x <= 0 then
            player2Score:update()
            ball:reset()
        end

        if ball.x >= VIRTUAL_WIDTH - 4 then
            player1Score:update()
            ball:reset()
        end

        ball:update(dt)
    end

    -- update paddles
    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:apply('start')

    -- setting bakcground color to gray
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- display game name
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong! ' .. gameState .. ' State', 0, 20, VIRTUAL_WIDTH, 'center')

    -- display score
    player1Score:render()
    player2Score:render()

    -- display paddles - right and left
    player1:render()
    player2:render()

    -- display ball
    ball:render()

    -- debug
    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print('Collision P1: ' .. tostring(COLLISION_CHECK_P1), 10, 20)
    love.graphics.print('Collision P2: ' .. tostring(COLLISION_CHECK_P2), 10, 30)
end
