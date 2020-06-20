PaddleSelectionState = Class{__includes = BaseState}

function PaddleSelectionState:init()
    self.selectedSkin = 1
    self.paddle = Paddle(self.selectedSkin)
end

function PaddleSelectionState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('serve', {
            paddle = Paddle(self.selectedSkin),
            bricks = LevelMaker:createMap(1),
            level = START_CONFIGS.level,
            hearts = START_CONFIGS.hearts,
            score = START_CONFIGS.score,
            ball = Ball(math.random(7))
        })
    end

    if love.keyboard.wasPressed('left') then
        if self.selectedSkin == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.selectedSkin = self.selectedSkin - 1
            self.paddle = Paddle(self.selectedSkin)
        end
    elseif love.keyboard.wasPressed('right') then
        if self.selectedSkin == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.selectedSkin = self.selectedSkin + 1
            self.paddle = Paddle(self.selectedSkin)
        end
    end
end

function PaddleSelectionState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Select your paddle with left and right!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('(presse enter to continue)', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')

    self.paddle:render()

    if self.selectedSkin == 1 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end

    love.graphics.draw(
        gTextures['arrows'],
        gFrames['arrows'][1],
        120,
        VIRTUAL_HEIGHT - 38
    )
    love.graphics.setColor(1, 1, 1, 1)

    if self.selectedSkin == 4 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end

    love.graphics.draw(
        gTextures['arrows'],
        gFrames['arrows'][2],
        VIRTUAL_WIDTH - 24 - 120,
        VIRTUAL_HEIGHT - 38
    )
    love.graphics.setColor(1, 1, 1, 1)
end
