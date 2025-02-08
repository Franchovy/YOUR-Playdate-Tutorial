--- @class Grid
Grid = {}

local GRID_SIZE = 24

function Grid.toGrid(x, y)
    return x - (x % GRID_SIZE), y - (y % GRID_SIZE)
end

function Grid.toGridCentered(x, y)
    return Grid.toGrid(x + GRID_SIZE - 12, y + GRID_SIZE - 12)
end
