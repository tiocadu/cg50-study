-- gd50 from Harvard University
-- author: @tiocadu

-- instead of using a package manager, i'm going with local dependence
-- https://github.com/Ulydev/push
push = require 'push/push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- setting virtual window. We'll use it with push to make it look more retro
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallFont = love.graphics.newFont('assets/font.ttf', 8)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- input controll
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    
    -- setting bakcground color to gray
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.rectangle('fill', 10, 30, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH -10, VIRTUAL_HEIGHT - 50, 5, 20)

    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    push:apply('end')
end
