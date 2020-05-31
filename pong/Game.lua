require 'Score'

Game = Class{}

GAME_STATE = {
    START = 'start',
    SERVE = 'serve',
    PLAY = 'play',
    END = 'end'
}

WIN_SCORE = 1

function Game:init()
    self.state = GAME_STATE.START

    -- initial score values
    player1Score = Score(VIRTUAL_WIDTH/2 - 90, 10)
    player2Score = Score(VIRTUAL_WIDTH/2 + 70, 10)
end

function Game:reset()
    self.state = GAME_STATE.START
    player1Score:reset()
    player2Score:reset()
end

function Game:update(state)
    self.state = state
end

function Game:updatePlayer1Score()
    player1Score:update()
end

function Game:updatePlayer2Score()
    player2Score:update()
end

function Game:checkWinner()
    if player1Score.value == WIN_SCORE or player2Score.value == WIN_SCORE then
        return true
    end
    return false
end

function Game:render()
    love.graphics.setFont(smallFont)
    -- start
    -- Welcome to Pong!
    -- Press Enter to Begin

    -- serve
    -- Player 2's serve!
    -- Press Enter to serve!
    love.graphics.printf('Hello Pong! ' .. self.state .. ' State', 0, 16, VIRTUAL_WIDTH, 'center')
    -- love.graphics.printf('Hello Pong! ' .. self.state .. ' State', 0, 26, VIRTUAL_WIDTH, 'center')

    -- display score
    player1Score:render()
    player2Score:render()
end
