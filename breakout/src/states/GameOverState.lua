GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.score = 0
end

function GameOverState:enter(enterParams)
    self.score = enterParams.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('start')
    elseif love.keyboard.wasPressed('escape') then
        gSounds['confirm']:play()
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Game Over!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Final Score: ' .. self.score, 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('press Enter to return to main menu', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
end
