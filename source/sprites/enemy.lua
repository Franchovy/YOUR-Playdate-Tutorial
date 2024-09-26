local gfx <const> = playdate.graphics

local imagetableEnemy <const> = gfx.imagetable.new(assets.enemy)

local speed <const> = 1

class("Enemy").extends(gfx.sprite)

Enemy.spawnRatePerTick = 0.01

function Enemy:init()
    Enemy.super.init(self, imagetableEnemy[1])

    self:setCollideRect(0, 0, self:getSize())

    -- Create animation loop

    self.animationLoop = gfx.animation.loop.new(500, imagetableEnemy)
end

function Enemy:destroy()
    self:remove()
end

function Enemy:update()
    -- Get the player
    local player = Player.instance
    if player then
        -- Calculate path to player
        local targetX, targetY = player.x, player.y
        local angle = math.atan(targetY - self.y, targetX - self.x)
        local x, y = getRotationComponents(angle, speed)

        -- Move to player
        self:moveBy(x, y)
    end

    -- Set the sprite image
    self:setImage(self.animationLoop:image())
end