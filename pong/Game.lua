require 'Score'

Game = Class{}

GAME_STATE = {
    START = 'start',
    SERVE = 'serve',
    PLAY = 'play',
    PAUSE = 'pause',
    END = 'end'
}

WIN_SCORE = 5

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

function Game:updateState()
    if self.state == GAME_STATE.START then
        self.state = GAME_STATE.SERVE
    elseif self.state == GAME_STATE.SERVE then
        self.state = GAME_STATE.PLAY
    elseif self.state == GAME_STATE.PLAY then
        self.state = GAME_STATE.PAUSE
    elseif self.state == GAME_STATE.PAUSE then
        self.state = GAME_STATE.PLAY
    elseif self.state == GAME_STATE.END then
        self:reset()
    end
end

function Game:updatePlayer1Score()
    self.player1Score:update()
    self.servingPlayer = 2
    self.state = GAME_STATE.SERVE
end

function Game:updatePlayer2Score()
    self.player2Score:update()
    self.servingPlayer = 1
    self.state = GAME_STATE.SERVE
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
        self.state = GAME_STATE.END
    elseif self.player2Score.value == WIN_SCORE then
        self.winner = 2
        self.state = GAME_STATE.END
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
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Player ' .. self.winner .. ' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to start new game!', 0, 26, VIRTUAL_WIDTH, 'center')
    end

    -- display score
    self.player1Score:render()
    self.player2Score:render()
end
