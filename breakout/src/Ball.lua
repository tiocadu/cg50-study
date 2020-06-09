Ball = Class{}

function Ball:init(skin)
  self.width = 8
  self.height = 8

  self.x = VIRTUAL_WIDTH/2 - 4
  self.y = VIRTUAL_HEIGHT - 42

  self.dx = math.random(-200, 200)
  self.dy = math.random(-50, -60)

  self.skin = skin
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH/2 - 4
  self.y = VIRTUAL_HEIGHT - 42

  self.dx = math.random(-200, 200)
  self.dy = math.random(-50, -60)
end

function Ball:collides(target)
  -- unsing AABB logic for collision
  if self.x > target.x + target.width or self.x + self.width < target.x then
      return false
  end

  if self.y > target.y + target.height or self.y + self.height < target.y then
      return false
  end

  return true
end

function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x <= 0 then
    self.x = 0
    self.dx = -self.dx

    gSounds['wall-hit']:play()
  end

  if self.x >= VIRTUAL_WIDTH - 8 then
    self.x = VIRTUAL_WIDTH - 8
    self.dx = -self.dx

    gSounds['wall-hit']:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = -self.dy

    gSounds['wall-hit']:play()
  end
end

function Ball:render()
  love.graphics.draw(
    gTextures['main'],
    gFrames['balls'][self.skin],
    self.x,
    self.y
  )
end