Paddle = Class{}

function Paddle:init(skin)
  self.x = VIRTUAL_WIDTH / 2 - 32
  self.y = VIRTUAL_HEIGHT - 32

  self.dx = 0

  -- initial size of the paddle
  self.width = 64
  self.height = 16

  -- uset to controll paddle color
  self.skin = skin

  -- used to controll paddle size
  self.size = 2
end

function Paddle:reset()
  self.x = VIRTUAL_WIDTH / 2 - 32
  self.y = VIRTUAL_HEIGHT - 32

  self.dx = 0
end

function Paddle:update(dt)
  if love.keyboard.isDown('left') then
    self.dx = - PADDLE_SPEED
  elseif love.keyboard.isDown('right') then
    self.dx = PADDLE_SPEED
  else
    self.dx = 0
  end

  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx * dt)
  elseif self.dx > 0 then
    self.x = math.min(self.x + self.dx * dt, VIRTUAL_WIDTH - self.width)
  end
end

function Paddle:render()
  love.graphics.draw(
    gTextures['main'],
    gFrames['paddles'][(self.skin -1) * 4 + self.size],
    self.x,
    self.y
  )
end
