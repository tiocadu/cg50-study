Brick = Class{}

-- we have 5 colors and 4 tiers of bricks for each color
-- color == (1, 5) and tier == (1, 4)
function Brick:init(x, y)
  self.width = 32
  self.height = 16

  self.color = math.random(1, 5)
  self.tier = math.random(1, 4)

  self.x = x
  self.y = y

  self.inPlay = true
end

function Brick:hit()
  gSounds['brick-hit-2']:play()

  self.inPlay = false
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(
      gTextures['main'],
      gFrames['bricks'][(self.color - 1) * 4 + self.tier],
      self.x,
      self.y
    )
  end
end