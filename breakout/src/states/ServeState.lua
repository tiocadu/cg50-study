ServeState = Class{__includes = BaseState}

function ServeState:enter(enterParams)
  self.bricks = enterParams.bricks
  self.paddle = enterParams.paddle
  self.hearts = enterParams.hearts
  self.level = enterParams.level
  self.score = enterParams.score
  self.ball = Ball(math.random(7))
end

function ServeState:update(dt)
  self.paddle:reset()

  if love.keyboard.wasPressed('space') then
      gSounds['paddle-hit']:play()
      gStateMachine:change('play', {
        paddle = self.paddle,
        bricks = self.bricks,
        hearts = self.hearts,
        level = self.level,
        score = self.score,
        ball = self.ball
      })
  end
end

function ServeState:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  self.paddle:render()
  self.ball:render()
  renderHearts(self.hearts)
  renderScore(self.score)

  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Level ' .. self.level, 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press SPACE to serve!', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end
