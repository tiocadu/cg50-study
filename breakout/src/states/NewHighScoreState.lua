NewHighScoreState = Class{__includes = BaseState}

local blinkTimer = 0

function NewHighScoreState:init()
    self.score = 0
    self.selectedChar = 1

    self.newEntryName = {'A', 'B', 'C'}
end

function NewHighScoreState:enter(enterParams)
    self.score = enterParams.score
end

function NewHighScoreState:update(dt)
    blinkTimer = blinkTimer + dt
    if blinkTimer > 1.2 then
        blinkTimer = 0
    end

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

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('high-score', {
            newEntry = {
                name = ConcatNewEntryName(self.newEntryName),
                score = self.score
            }
        })
    end
end

function NewHighScoreState:updateNameChar(position, newChar)
    self.newEntryName[position] = newChar
end

function NewHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Congratulations!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('New High Score: ' .. self.score, 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Enter your name: ', 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('< ' .. ConcatNewEntryName(self.newEntryName) .. ' >', 0, VIRTUAL_HEIGHT/2 + 40, VIRTUAL_WIDTH, 'center')
    if blinkTimer < 0.75 then
      self:_renderCharSelector()
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('press Enter to register your score', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
end

function NewHighScoreState:_renderCharSelector()
    local selectorPosition = {'left', 'center', 'right'}
    love.graphics.printf('_', VIRTUAL_WIDTH/2 - 14, VIRTUAL_HEIGHT/2 + 45, 28, selectorPosition[self.selectedChar])
end
