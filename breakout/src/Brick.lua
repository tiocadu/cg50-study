Brick = Class{}

local paletteColors = {
  -- blue
  [1] = {
    ['r'] = 99/255,
    ['g'] = 155/255,
    ['b'] = 255/255
  },
  -- green
  [2] = {
    ['r'] = 106/255,
    ['g'] = 190/255,
    ['b'] = 47/255
  },
  -- red
  [3] = {
    ['r'] = 217/255,
    ['g'] = 87/255,
    ['b'] = 99/255
  },
  -- purple
  [4] = {
    ['r'] = 215/255,
    ['g'] = 123/255,
    ['b'] = 186/255
  },
  -- gold
  [5] = {
    ['r'] = 251/255,
    ['g'] = 242/255,
    ['b'] = 54/255
  }
}

-- we have 5 colors and 4 tiers of bricks for each color
-- color == (1, 5) and tier == (1, 4)
function Brick:init(x, y, color, tier)
  self.width = 32
  self.height = 16

  self.color = color or 1
  self.tier = tier or 1

  self.x = x
  self.y = y

  self.inPlay = true

  self.pSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
  self.pSystem:setParticleLifetime(0.5, 1)
  self.pSystem:setLinearAcceleration(-15, 0, 15, 80)
  self.pSystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()
  -- self.pSystem:setColors(255/255, 255/255, 255/255, 255/255, 255/255, 255/255, 255/255, 0/255)
  self.pSystem:setColors(
      paletteColors[self.color].r,
      paletteColors[self.color].g,
      paletteColors[self.color].b,
      55 * (self.tier + 1),
      paletteColors[self.color].r,
      paletteColors[self.color].g,
      paletteColors[self.color].b,
      0
  )
  self.pSystem:emit(64)

  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()

  if self.tier > 1 then
    if self.color > 1 then
      self.color = self.color - 1
    else
      self.tier = self.tier - 1
      self.color = 5
    end
  else
    if self.color > 1 then
      self.color = self.color - 1
    else
      self.inPlay = false
      gSounds['brick-hit-1']:play()
    end
  end
end

function Brick:update(dt)
  self.pSystem:update(dt)
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
  love.graphics.draw(self.pSystem, self.x + self.width/2, self.y + self.height/2)
end