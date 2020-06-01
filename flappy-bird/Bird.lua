Bird = Class{}

local GRAVITY = 20

function Bird:init(x, y, width, height)
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT /2) - (self.height / 2)

    self.dy = 4
end

function Bird:reset()
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT /2) - (self.height / 2)

    self.dy = 4
end

function Bird:update(dt)
    -- implements gravity
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy * dt
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
