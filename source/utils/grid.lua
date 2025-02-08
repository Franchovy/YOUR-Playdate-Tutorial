--- @class Grid
Grid = {}
local _ = {}

local GRID_SIZE <const> = 24
local GRID_WIDTH <const> = math.ceil(playdate.display.getWidth() / GRID_SIZE)
local GRID_HEIGHT <const> = math.ceil(playdate.display.getHeight() / GRID_SIZE)

local grid = {}

Grid.size = GRID_SIZE

function Grid.initialize()
    for i = 1, GRID_WIDTH do
        table.insert(grid, {})

        for j = 1, GRID_HEIGHT do
            table.insert(grid[i], 0)
        end
    end
end

function Grid.getGridPosition(x, y)
    return x - (x % GRID_SIZE), y - (y % GRID_SIZE)
end

function Grid.getGridPositionCentered(x, y)
    return Grid.getGridPosition(x + GRID_SIZE - 12, y + GRID_SIZE - 12)
end

function Grid.getGridCoordinates(x, y)
    local gridX, gridY = Grid.getGridPosition(x, y)
    return gridX / 24, gridY / 24
end

function Grid.addAt(x, y)
    local gridX, gridY = Grid.getGridCoordinates(x, y)

    if gridX < 1 or gridX > GRID_WIDTH or gridY < 1 or gridY > GRID_HEIGHT then
        return
    end

    grid[gridX][gridY] = 1
end

function Grid.removeAt(x, y)
    local gridX, gridY = Grid.getGridCoordinates(x, y)

    grid[gridX][gridY] = 0
end

function Grid.print()
    local separatorString = _.getSeparatorString(#grid[1])

    print(separatorString)

    for _, row in ipairs(grid) do
        local str = ""

        for _, i in ipairs(row) do
            str = str .. " " .. tostring(i)
        end

        print(str)
    end

    print(separatorString)
end

function _.getSeparatorString(length)
    local str = ""
    for _ = 1, length do
        str = str .. " -"
    end
    return str
end
