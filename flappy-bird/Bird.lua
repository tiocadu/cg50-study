Bird = Class{}

local GRAVITY = 20

function Bird:init(x, y, width, height)
    self.image = love.graphics.newImage('images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT /2) - (self.height / 2)

    self.dy = 0
end

function Bird:reset()
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT /2) - (self.height / 2)

    self.dy = 0
end

function Bird:update(dt)
    -- implements jump
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    -- implements gravity
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    if self.y + self.height >= VIRTUAL_HEIGHT - 16 then
        self.y = VIRTUAL_HEIGHT - self.height - 16
    elseif self.y <= 0 then
        self.y = 0
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
