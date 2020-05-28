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

    love.graphics.printf(
        'Hello World',
        0,
        VIRTUAL_HEIGHT / 2 -6,
        VIRTUAL_WIDTH,
        'center'
    )

    push:apply('end')
end
