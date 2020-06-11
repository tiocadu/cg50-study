-- gd50 from Harvard University
-- author: @tiocadu

require 'src/Dependencies'

DEBUG = true

function love.load()
    love.window.setTitle('Hello Breakout!')

    -- setting filter to not blur images when scaling window
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- setting RNG
    math.randomseed(os.time())

    -- setting fonts
    gFonts = {
      ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
      ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
      ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }

    love.graphics.setFont(gFonts['small'])

    -- setting graphics
    gTextures = {
      ['background'] = love.graphics.newImage('graphics/background.png'),
      ['main'] = love.graphics.newImage('graphics/breakout.png'),
      ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
      ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
      ['particle'] = love.graphics.newImage('graphics/particle.png'),
    }

    gFrames = {
      ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
      ['balls'] = GenerateQuadsBalls(gTextures['main']),
      ['bricks'] = GenerateQuadsBricks(gTextures['main']),
      ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = true,
      vsync = true
    })

    gSounds = {
      ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
      ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
      ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
      ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
      ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
      ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
      ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
      ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
      ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
      ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
      ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
      ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    }

    -- game states
    -- 1. 'start' - press Enter to start the game
    -- 2. 'paddle-select' - choose the color for the paddle
    -- 3. 'serve' - waiting for a key press to serve the ball
    -- 4. 'play' - the ball is moving and bouncing
    -- 5. 'victory' - current level is over with a victory jingle
    -- 6. 'game-over' - display score and allow restart
    gStateMachine = StateMachine {
      ['start'] = function() return StartState() end,
      ['serve'] = function() return ServeState() end,
      ['play'] = function() return PlayState() end,
      ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')
    gSounds['music']:setVolume(0.3)
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- auxiliary table to pass pressed keys outside love.keypressed method
    love.keyboard.keysPressed = {}
  end

  -- input controll
  function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
  end

  function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
    -- coordinates (0, 0)
    0, 0,
    -- no rotation
    0,
    -- scale factors so it fills the screen
    VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    -- debug
    if DEBUG == true then
        displayFPS()
    end

    push:finish()
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  end
  return false
end

function renderHearts(hearts)
    for i = 1, 3 do
        if i <= hearts then
            love.graphics.draw(
                gTextures['hearts'],
                gFrames['hearts'][1],
                VIRTUAL_WIDTH - 95 + (i -1) * 10 + 1,
                4
            )
        else
            love.graphics.draw(
                gTextures['hearts'],
                gFrames['hearts'][2],
                VIRTUAL_WIDTH - 95 + (i -1) * 10 + 1,
                4
            )
        end
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), -10, 5, VIRTUAL_WIDTH, 'right')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.resize(w, h)
    push:resize(w, h)
end
