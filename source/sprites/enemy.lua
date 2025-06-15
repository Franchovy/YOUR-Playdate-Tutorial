local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

local imagetableEnemy <const> = gfx.imagetable.new(assets.enemy)

-- local constants

local speedMovement <const> = 28
local durationMovement <const> = 1800
local durationMovementDelay <const> = 300

class("Enemy").extends(gfx.sprite)

Enemy.spawnRatePerTick = 0.008

function Enemy:init()
    Enemy.super.init(self, imagetableEnemy[1])

    self:setCollideRect(0, 0, self:getSize())

    -- Create animation loop

    self.animationLoop = gfx.animation.loop.new(500, imagetableEnemy)
end

function Enemy:destroy()
    Score.update(50)

    self:remove()
end

function Enemy:update()
    if self.animatorMovement then
        local pointDestination = self.animatorMovement:currentValue()

        self:moveTo(pointDestination.x, pointDestination.y)

        if self.animatorMovement:ended() then
            self.animatorMovement = nil
        end
    else
        -- Get the player
        local player = Player.getInstance()
        if player and not player:getHasDied() then
            -- Calculate path to player
            local xPlayer, yPlayer = player.x, player.y
            local angle = math.atan(yPlayer - self.y, xPlayer - self.x)
            local xTarget, yTarget = getRotationComponents(angle, speedMovement)

            -- Get difficulty value
            local valueDifficulty = Difficulty.getInstance():getValue()
            local durationAnimator = durationMovement / valueDifficulty
            local durationAnimatorDelay = durationMovementDelay / valueDifficulty

            -- Set the animator to target point
            self.animatorMovement = gfx.animator.new(durationAnimator, geo.point.new(self.x, self.y),
                geo.point.new(self.x + xTarget, self.y + yTarget), playdate.easingFunctions.outExpo,
                durationAnimatorDelay)
        end
    end

    -- Set the sprite image
    self:setImage(self.animationLoop:image())
end
