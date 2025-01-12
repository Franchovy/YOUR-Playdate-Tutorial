local geo <const> = playdate.geometry

class("Spawner").extends()

function Spawner:init(spriteClass, spawnRatePerTick)
    self.spriteClass = spriteClass
    self.spawnRatePerTick = spawnRatePerTick

    self.isActive = false
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
    if math.random() < self.spawnRatePerTick then
        self:activate()
    end
end

function Spawner:activate()
    -- spawn sprite

    local sprite = self.spriteClass()

    -- get player
    local player = Player.instance
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
