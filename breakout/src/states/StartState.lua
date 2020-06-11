StartState = Class{__includes = BaseState}

local highlighted = 0

function StartState:update(dt)
  -- toggle highlighted option if we press vertical arrow keys
  if love.keyboard.wasPressed('up') then
    highlighted = (highlighted - 1) % 3
    gSounds['paddle-hit']:play()
  elseif  love.keyboard.wasPressed('down') then
    highlighted = (highlighted + 1) % 3
    gSounds['paddle-hit']:play()
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    if highlighted == 0 then
      gSounds['confirm']:play()
      gStateMachine:change('serve', {
        paddle = Paddle(1),
        bricks = LevelMaker:createMap(1),
        level = START_CONFIGS.level,
        hearts = START_CONFIGS.hearts,
        score = START_CONFIGS.score,
        ball = Ball(math.random(7))
      })
    elseif highlighted == 1 then
      gSounds['confirm']:play()
      gStateMachine:change('high-score')
    elseif highlighted == 2 then
      gSounds['confirm']:play()
      love.event.quit()
    end
  end

  -- only exit game from start screen
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function StartState:render()
  -- render game title
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('HELLO BREAKOUT', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  -- render menu options
  if highlighted == 0 then
    love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
  end
  love.graphics.printf('START', 0, VIRTUAL_HEIGHT/2 + 50, VIRTUAL_WIDTH, 'center')

  -- reset color
  love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

  if highlighted == 1 then
    love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
  end
  love.graphics.printf('HIGH SCORE', 0, VIRTUAL_HEIGHT/2 + 70, VIRTUAL_WIDTH, 'center')

  -- reset color
  love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

  if highlighted == 2 then
    love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
  end
  love.graphics.printf('QUIT', 0, VIRTUAL_HEIGHT/2 + 90, VIRTUAL_WIDTH, 'center')

  -- reset color before exit
  love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
end
