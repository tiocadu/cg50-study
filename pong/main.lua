-- gd50 from Harvard University
-- author: @tiocadu

-- instead of using a package manager, i'm going with local dependences
-- https://github.com/Ulydev/push/blob/master/push.lua
push = require 'libs/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- setting virtual window. We'll use it with push to make it look more retro
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
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
    player1Score = 0
    player2Score = 0

    -- paddle positions on Y axis
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

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

             -- initial ball position
            ball:reset()

            -- ball velocity
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end
    end
end

function love.update(dt)

    -- player1 controls
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player2 controls
    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    -- ball movement
    if gameState == 'play' then
        ball:update(dt)
    end

end

function love.draw()
    push:apply('start')

    -- setting bakcground color to gray
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- display game name
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong! ' .. gameState .. ' State', 0, 20, VIRTUAL_WIDTH, 'center')

    -- display score
    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

    -- display paddles - right and left
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH -10, player2Y, 5, 20)

    -- display ball
    ball:render()

    push:apply('end')
end
