HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(enterParams)
    if enterParams and enterParams.newEntry then
        UpdateHighScoreTable(enterParams.newEntry)
        SaveHighScoreTable()
    end
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('start')
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    for i =1, 10 do
        love.graphics.printf(tostring(i) .. '.', 100, 50 + i * 15, VIRTUAL_WIDTH, 'left')
        love.graphics.printf(gHighScoreTable[i]['name'], 0, 50 + i * 15, VIRTUAL_WIDTH, 'center')
        love.graphics.printf(tostring(gHighScoreTable[i]['score']), -100, 50 + i * 15, VIRTUAL_WIDTH, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('press enter to return to main menu', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
end
