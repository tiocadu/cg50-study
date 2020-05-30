Score = Class{}

function Score:init(x, y)
    self.x = x
    self.y = y
    self.value = 0
end

function Score:reset()
    self.value = 0
end

function Score:update()
    self.value = self.value + 1
end

function Score:render()
    love.graphics.setFont(scoreFont)
    love.graphics.print(self.value, self.x, self.y)
end
