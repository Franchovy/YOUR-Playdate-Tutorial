--- @class Grid
Grid = {}

local GRID_SIZE = 24

function Grid.toGrid(x, y)
    return x - (x % GRID_SIZE), y - (y % GRID_SIZE)
end
