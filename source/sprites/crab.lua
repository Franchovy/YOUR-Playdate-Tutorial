local gfx <const> = playdate.graphics

local imagetableCrab <const> = assert(gfx.imagetable.new(assets.crab))

local speedMovement <const> = 1

local ANIMATION_STATES <const> = {
    Moving = 'moving',
    Shooting = 'shooting'
}

--- @class Crab : Enemy
Crab = {}
class("Crab").extends(Enemy)

Crab.spawnRatePerTick = 0.001

function Crab:init()
    Crab.super.init(self, imagetableCrab)

    self:addState(ANIMATION_STATES.Moving, 1, 2, { tickStep = 16 }).asDefault()
    self:addState(ANIMATION_STATES.Shooting, 3, 5, { tickStep = 32, onFrameChangedEvent = Crab.onShootFrameChanged })

    self:playAnimation()
end

function Crab:onShootFrameChanged()
    if self._currentFrame == 5 then
        -- Shoot the bullet
        print("HAAAAAA!!!!")
    end
end

function Crab:update()
    Crab.super.update(self)

    local target = self:getTarget()

    if target then
        -- Calculate path to player
        local xTarget, yTarget = target.x, target.y
        local angle = math.atan(yTarget - self.y, xTarget - self.x)
        local xMovement, yMovement = getRotationComponents(angle, speedMovement)

        local distanceToPlayer = math.sqrt((yTarget - self.y) ^ 2 + (xTarget - self.x) ^ 2)
        if distanceToPlayer > 100 then
            -- Move to player
            self:moveBy(xMovement, yMovement)

            self:changeState(ANIMATION_STATES.Moving)
        else
            self:changeState(ANIMATION_STATES.Shooting)
        end

        -- Rotate self
        local angleDegrees = math.deg(angle)
        self:setRotation(angleDegrees + 90)
    end
end
