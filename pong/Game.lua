require 'Score'

Game = Class{}

GAME_STATE = {
    START = 'start',
    SERVE = 'serve',
    PLAY = 'play',
    PAUSE = 'pause',
    END = 'end'
}

WIN_SCORE = 2

function Game:init()
    self.state = GAME_STATE.START

    -- initial score values
    self.player1Score = Score(VIRTUAL_WIDTH/2 - 100, 10)
    self.player2Score = Score(VIRTUAL_WIDTH/2 + 80, 10)

    self.servingPlayer = math.random(2)
    self.winner = nil
end

function Game:reset()
    self.state = GAME_STATE.START
    self.player1Score:reset()
    self.player2Score:reset()

    self.servingPlayer = math.random(2)
end

function Game:update(state)
    self.state = state
end

function Game:updatePlayer1Score()
    self.player1Score:update()
end

function Game:updatePlayer2Score()
    self.player2Score:update()
end

function Game:checkWinner()
    if self.player1Score.value == WIN_SCORE or self.player2Score.value == WIN_SCORE then
        return true
    end
    return false
end

function Game:setWinner()
    if self.player1Score.value == WIN_SCORE then
        self.winner = 1
    elseif self.player2Score.value == WIN_SCORE then
        self.winner = 2
    else
        self.winner = nil
    end
end

function Game:render()
    love.graphics.setFont(smallFont)

    if self.state == GAME_STATE.START then
        love.graphics.printf('Welcome to Pong!', 0, 16, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Begin!', 0, 26, VIRTUAL_WIDTH, 'center')
    elseif self.state == GAME_STATE.SERVE then
        love.graphics.printf('Player ' .. self.servingPlayer .. '\'s serve!', 0, 16, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 26, VIRTUAL_WIDTH, 'center')
    elseif self.state == GAME_STATE.PAUSE then
        love.graphics.printf('Game Paused!', 0, 16, VIRTUAL_WIDTH, 'center')
    elseif self.state == GAME_STATE.END then
        love.graphics.printf('Player ' .. self.winner .. ' wins! Congratulations!', 0, 16, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to start new game!', 0, 26, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Pong! ' .. self.state .. ' State', 0, 16, VIRTUAL_WIDTH, 'center')
    end

    -- display score
    self.player1Score:render()
    self.player2Score:render()
end
