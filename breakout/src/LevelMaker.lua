LevelMaker = Class{}

function LevelMaker:createMap(level)
  local bricks = {}

  local numRows = math.random(1, 5)
  local numCols = math.random(7, 13)

  local shouldSkipRows = math.random(2) == 1 and true or false
  local shouldSkipBlocks = math.random(2) == 1 and true or false

  for y = 1, numRows do
    local colColor = math.min(math.random(1, 5), level)
    local tierColor = math.min(math.random(1, 4), math.floor(level/5) % 5 + 1)

    if  not (shouldSkipRows and y % 2 == 0) then
      for x = 1, numCols do
        if  not (shouldSkipBlocks and x % 2 == 0) then
          b = Brick(
            (x - 1) * 32 + (VIRTUAL_WIDTH - (numCols * 32))/2,
            y * 16,
            colColor,
            tierColor
          )
          table.insert(bricks, b)
        end
      end
    end
  end

  return bricks
end
