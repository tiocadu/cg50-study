GameOverState = Class{__includes = BaseState}

function GameOverState:init()
  self.score = 0
  self.newHighScore = false
  self.selectedChar = 1

  self.newEntryName = {'A', 'B', 'C'}
  -- table.insert(a, 1, 15) insert on table a the element 15 on position 1 (remember that tables start in index 1)
end

function GameOverState:enter(enterParams)
  self.score = enterParams.score

  if checkHighscore(self.score) then
    self.newHighScore = true
  end
end

function GameOverState:update(dt)
  if self.newHighScore then
      if love.keyboard.wasPressed('left') then
          gSounds['select']:play()
          self.selectedChar = self.selectedChar == 1 and 3 or self.selectedChar - 1
      elseif love.keyboard.wasPressed('right') then
          gSounds['select']:play()
          self.selectedChar = self.selectedChar == 3 and 1 or self.selectedChar + 1
      end

      if love.keyboard.wasPressed('up') then
          gSounds['select']:play()
          local oldCharCode = string.byte(self.newEntryName[self.selectedChar])
          local newCharCode = oldCharCode == 65 and 90 or oldCharCode - 1
          self:updateNameChar(self.selectedChar, string.char(newCharCode))
      elseif love.keyboard.wasPressed('down') then
          gSounds['select']:play()
          local oldCharCode = string.byte(self.newEntryName[self.selectedChar])
          local newCharCode = oldCharCode == 90 and 65 or oldCharCode + 1
          self:updateNameChar(self.selectedChar, string.char(newCharCode))
      end
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.newHighScore then
            gSounds['confirm']:play()
            gStateMachine:change('high-score')
        else
            gSounds['confirm']:play()
            gStateMachine:change('start')
        end
    elseif love.keyboard.wasPressed('escape') then
      gSounds['confirm']:play()
      gStateMachine:change('start')
  end
end

function GameOverState:updateNameChar(position, newChar)
  self.newEntryName[position] = newChar
end

function GameOverState:render()
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Game Over!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['large'])
  if self.newHighScore then
    love.graphics.printf('New High Score: ' .. self.score, 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Enter your name: ', 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('< ' .. concatNewEntryName(self.newEntryName) .. ' >', 0, VIRTUAL_HEIGHT/2 + 40, VIRTUAL_WIDTH, 'center')
    printSelector(self.selectedChar)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('press Enter to register your score', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('press esc to return to main menu', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
  else
    love.graphics.printf('Final Score: ' .. self.score, 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('press Enter to return to main menu', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
  end
end

function checkHighscore(score)
  for k, entry in pairs(gHighScoreTable) do
    if score >= entry.score then
      return true
    end
  end
  return false
end

function createNewEntry(name, score)
  return {
    name = name,
    score = score
  }
end

function concatNewEntryName(nameTable)
  local name = ''
  for i = 1, 3 do
    name = name .. nameTable[i]
  end
  return name
end

function printSelector(position)
  local selectorPosition = {'left', 'center', 'right'}
  love.graphics.printf('_', VIRTUAL_WIDTH/2 - 14, VIRTUAL_HEIGHT/2 + 45, 28, selectorPosition[position])
end
