GameOverState = Class{__includes = BaseState}

function GameOverState:enter(enterParams)
  self.score = enterParams.score
end

function GameOverState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      gSounds['select']:play()
      gStateMachine:change('start')
  end
end

function GameOverState:render()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Game Over!', 0, VIRTUAL_HEIGHT/2 - 20, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Final Score: ' .. self.score, 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press ENTER to Main screen ', 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
end
