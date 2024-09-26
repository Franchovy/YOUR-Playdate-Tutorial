
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
        -- spawn sprite

        local sprite = self.spriteClass()

        -- Put sprite on screen
        sprite:moveTo(math.random(0, 400), math.random(0, 240))
        sprite:add()
    end
end