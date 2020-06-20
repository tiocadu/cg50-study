-- generation of quads from sprite sheets

function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheet[sheetCounter] = love.graphics.newQuad(
                x * tileWidth,
                y * tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end

function table.slice(table, first, last, step)
    local sliced = {}

    for i = first or 1, last or #table, step or 1 do
        sliced[#sliced + 1] = table[i]
    end

    return sliced
end

function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- small
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        -- prepare for the next paddle
        x = 0
        y = y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        counter = counter + 1

        -- prepare for the next ball
        x = x + 8
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        counter = counter + 1

        -- prepare for the next ball
        x = x + 8
    end

    return quads
end

function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 20)
end

function CheckHighscore(score)
    for k, entry in pairs(gHighScoreTable) do
        if score >= entry.score then
            return true
        end
    end
    return false
end

function UpdateHighScoreTable(entry)
    local position = nil
    for k, item in pairs(gHighScoreTable) do
        if not position and entry.score >= item.score then
            position = k
        end
    end
    table.insert(gHighScoreTable, position, entry)
    gHighScoreTable = table.slice(gHighScoreTable, 1, 10)
end

function ConcatNewEntryName(nameTable)
    local name = ''
    for i = 1, 3 do
        name = name .. nameTable[i]
    end
    return name
end

function GetHighScoresFromFile()
    love.filesystem.setIdentity('breakout')
    -- uncomment next line to remove saved file
    -- love.filesystem.remove('breakout.lst')

    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 1, 10 do
            scores = scores .. 'AAA\n'
            scores = scores .. tostring(0) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    local name = true
    local currentName = nil
    local counter = 1

    local scores = {}

    for i = 1, 10 do
      scores[i] = {
        name = nil,
        score = nil
      }
    end

    for line in love.filesystem.lines('breakout.lst') do
      if name then
        scores[counter].name = string.sub(line, 1, 3)
      else
        scores[counter].score = tonumber(line)
        counter = counter + 1
      end

      name = not name
    end
    return scores
end

function SaveHighScoreTable()
    love.filesystem.setIdentity('breakout')

    local scores = ''
    for k, entry in pairs(gHighScoreTable) do
        scores = scores .. entry.name .. '\n'
        scores = scores .. tostring(entry.score) .. '\n'
    end

    love.filesystem.write('breakout.lst', scores)
end
