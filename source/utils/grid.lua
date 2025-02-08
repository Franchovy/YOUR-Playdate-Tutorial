--- @class Grid
Grid = {}
local _ = {}

local GRID_SIZE <const> = 24
local GRID_WIDTH <const> = math.ceil(playdate.display.getWidth() / GRID_SIZE)
local GRID_HEIGHT <const> = math.ceil(playdate.display.getHeight() / GRID_SIZE)

local grid = {}

Grid.size = GRID_SIZE

---@type playdate.pathfinder.graph | nil
local pathfindingGrid

function Grid.initialize()
    pathfindingGrid = playdate.pathfinder.graph.new2DGrid(GRID_WIDTH, GRID_HEIGHT, true)

    for i = 1, GRID_HEIGHT do
        table.insert(grid, {})

        for j = 1, GRID_WIDTH do
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

    -- Mark spot on grid
    grid[gridY][gridX] = 1

    -- Add connections to pathfinding alg

    assert(pathfindingGrid, "Pathfinding Grid is missing! Call Grid.initialize()")

    pathfindingGrid:removeNodeWithXY(gridX, gridY)
end

function Grid.removeAt(x, y)
    local gridX, gridY = Grid.getGridCoordinates(x, y)

    grid[gridY][gridX] = 0

    -- Add node to pathfinding grid

    assert(pathfindingGrid, "Pathfinding Grid is missing! Call Grid.initialize()")

    local connectedNodes = {
        pathfindingGrid:nodeWithXY(gridX - 1, gridY),     -- Center Left
        pathfindingGrid:nodeWithXY(gridX - 1, gridY - 1), -- Top Left
        pathfindingGrid:nodeWithXY(gridX, gridY - 1),     -- Top Center
        pathfindingGrid:nodeWithXY(gridX + 1, gridY - 1), -- Top Right
        pathfindingGrid:nodeWithXY(gridX + 1, gridY),     -- Center Right
        pathfindingGrid:nodeWithXY(gridX + 1, gridY + 1), -- Bottom Right
        pathfindingGrid:nodeWithXY(gridX, gridY + 1),     -- Bottom Center
        pathfindingGrid:nodeWithXY(gridX - 1, gridY + 1), -- Bottom Left
    }
    local weights = {
        10, -- Center Left
        14, -- Top Left
        10, -- Top Center
        14, -- Top Right
        10, -- Center Right
        14, -- Bottom Right
        10, -- Bottom Center
        14, -- Bottom Left
    }

    pathfindingGrid:addNewNode(_.getNodeId(gridX, gridY), gridX, gridY, connectedNodes, weights, true)
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
