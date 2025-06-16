local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

local imagetableEnemy <const> = assert(gfx.imagetable.new(assets.enemy))

-- local constants

local speedMovement <const> = 28
local durationMovement <const> = 1800
local durationMovementDelay <const> = 300

--- @class Jellyfish : Enemy
Jellyfish = {}
class("Jellyfish").extends(Enemy)

Jellyfish.spawnRatePerTick = 0.008

function Jellyfish:init()
    Jellyfish.super.init(self, imagetableEnemy[1])

    -- Create animation loop

    self.animationLoop = gfx.animation.loop.new(500, imagetableEnemy)
end

function Jellyfish:getScoreValue()
    return 40
end

function Jellyfish:update()
    Jellyfish.super.update(self)

    if self.animatorMovement then
        local pointDestination = self.animatorMovement:currentValue()

        self:moveTo(pointDestination.x, pointDestination.y)

        if self.animatorMovement:ended() then
            self.animatorMovement = nil
        end
    else
        -- Get the target
        local target = self:getTarget()

        if target then
            -- Calculate path to player
            local xTarget, yTarget = target.x, target.y
            local angle = math.atan(yTarget - self.y, xTarget - self.x)
            local xFinal, yFinal = getRotationComponents(angle, speedMovement)

            -- Get difficulty value
            local valueDifficulty = Difficulty.getInstance():getValue()
            local durationAnimator = durationMovement / valueDifficulty
            local durationAnimatorDelay = durationMovementDelay / valueDifficulty

            -- Set the animator to target point
            self.animatorMovement = gfx.animator.new(durationAnimator, geo.point.new(self.x, self.y),
                geo.point.new(self.x + xFinal, self.y + yFinal), playdate.easingFunctions.outExpo,
                durationAnimatorDelay)
        end
    end

    -- Set the sprite image
    self:setImage(self.animationLoop:image())
end
