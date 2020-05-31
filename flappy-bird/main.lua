-- gd50 from Harvard University
-- author: @tiocadu

-- instead of using a package manager, i'm going with local dependences
-- https://github.com/Ulydev/push/blob/master/push.lua
push = require 'libs/push'

-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

DEBUG = true

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- setting virtual window.
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background.png')
local ground = love.graphics.newImage('images/ground.png')


function love.load()
    love.window.setTitle('Hello Flappy Bird!')

    -- setting filter to not blur images when scaling window
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('assets/font.ttf', 8)

    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

-- input controll
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        -- game:updateState()
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    -- debug
    if DEBUG == true then
        displayFPS()
    end

    push:finish()
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.resize(w, h)
    push:resize(w, h)
end
