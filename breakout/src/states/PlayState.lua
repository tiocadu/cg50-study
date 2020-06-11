PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.paddle = Paddle()
  self.ball = Ball(math.random(7))

  self.bricks = {}

  self.score = 0
  self.hearts = 0

  self.level = 1

  self.paused = false
end

function PlayState:enter(enterParams)
  self.paddle = enterParams.paddle
  self.bricks = enterParams.bricks

  self.score = enterParams.score
  self.hearts = enterParams.hearts

  self.level = enterParams.level

  self.ball = enterParams.ball
end

function PlayState:update(dt)
  if self.paused then
    if love.keyboard.wasPressed('space') then
      self.paused = false
      gSounds['pause']:play()
      gSounds['music']:play()
    else
      return
    end
  elseif love.keyboard.wasPressed('space') then
    self.paused = true
    gSounds['pause']:play()
    gSounds['music']:pause()
    return
  end

  self.paddle:update(dt)
  self.ball:update(dt)

  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = - self.ball.dy

    -- implements bounce depending where the ball hits the paddle
    if self.ball.x < self.paddle.x + self.paddle.width/2 and self.paddle.dx < 0 then
      self.ball.dx = -50 - 4 * (self.paddle.x + self.paddle.width/2 - self.ball.x)
    elseif self.ball.x > self.paddle.x + self.paddle.width/2 and self.paddle.dx > 0 then
      self.ball.dx = 50 + 4 * (self.ball.x - self.paddle.x + self.paddle.width/2)
    end


    gSounds['paddle-hit']:play()
  end

  for k, brick in pairs(self.bricks) do
    brick:update(dt)

    if brick.inPlay and self.ball:collides(brick) then
      brick:hit()
      self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 25)

      -- ball position after collision with bricks
      if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
        self.ball.dx = - self.ball.dx
        self.ball.x = brick.x - self.ball.width
      elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
        self.ball.dx = - self.ball.dx
        self.ball.x = brick.x + brick.width
      elseif self.ball.y < brick.y then
        self.ball.dy = - self.ball.dy
        self.ball.y = brick.y - self.ball.height
      else
        self.ball.dy = - self.ball.dy
        self.ball.y = brick.y + brick.height
      end

      self.ball.dy = self.ball.dy * 1.02
    end
  end

  if self.ball.y >= VIRTUAL_HEIGHT - self.ball.height then
    gSounds['hurt']:play()
    self.hearts = self.hearts - 1

    if self.hearts <= 0 then
      gSounds['score']:play()
      if CheckHighscore(self.score) then
        gSounds['victory']:play()
        gStateMachine:change('new-high-score', {
          score = self.score
        })
      else
        gStateMachine:change('game-over', {
          score = self.score
        })
      end
    else
      gStateMachine:change('serve', {
        paddle = self.paddle,
        bricks = self.bricks,
        hearts = self.hearts,
        score = self.score,
        level = self.level,
        ball = self.ball
      })
    end
  end

  if checkWinCondition(self.bricks) then
    gSounds['victory']:play()
    self.level = self.level + 1
    gStateMachine:change('serve', {
      paddle = self.paddle,
      bricks = LevelMaker:createMap(self.level),
      hearts = self.hearts,
      score = self.score,
      level = self.level,
      ball = self.ball
    })
  end
end

function checkWinCondition(bricks)
  for k, brick in pairs(bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end

function PlayState:render()
  for k, brick in pairs(self.bricks) do
      brick:render()
  end

  self.paddle:render()
  self.ball:render()

  renderHearts(self.hearts)
  renderScore(self.score)

  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
  end
end
