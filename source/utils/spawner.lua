local geo <const> = playdate.geometry

--- @class Spawner
Spawner = {}
class("Spawner").extends()

-- Static Methods

local spawners <const> = {}

function Spawner.startAll()
    for _, v in pairs(spawners) do
        v:start()
    end
end

function Spawner.stopAll()
    for _, v in pairs(spawners) do
        v:stop()
    end
end

function Spawner.updateAll()
    for _, v in pairs(spawners) do
        v:update()
    end
end

-- Instance Methods

function Spawner:init(spriteClass, spawnRatePerTick, difficulty)
    self.spriteClass = spriteClass
    self.spawnRatePerTick = spawnRatePerTick
    self.difficulty = difficulty

    self.isActive = false
    self.timeNextSpawn = 0

    table.insert(spawners, self)
end

function Spawner:start()
    self.isActive = true
end

function Spawner:stop()
    self.isActive = false
end

function Spawner:update()
    -- if spawner is not active, return
    if not self.isActive then
        return
    end

    -- check if sprite should be spawned
    if playdate.getCurrentTimeMilliseconds() > self.timeNextSpawn then
        -- Spawn sprite
        self:activate()

        -- Get current difficulty
        local difficulty = self.difficulty:getValue()

        -- Set next spawn time
        local r = math.max(math.min(math.random(), 0.8), 0.4)
        self.timeNextSpawn = playdate.getCurrentTimeMilliseconds() -
            math.log(r) / (self.spawnRatePerTick * difficulty / 30)
    end
end

function Spawner:activate()
    -- spawn sprite

    local sprite = self.spriteClass()

    -- get player
    local player = Player.getInstance()
    if not player then
        return
    end

    repeat
        -- Put sprite on screen
        sprite:moveTo(math.random(0, 400), math.random(0, 240))

        -- Check for safe distance from player, if not repeat.
    until geo.distanceToPoint(player.x, player.y, sprite.x, sprite.y) > 50

    -- Add sprite to screen
    sprite:add()
end
