local gfx <const> = playdate.graphics

local imagetableCrab <const> = assert(gfx.imagetable.new(assets.crab))
local imageBullet <const> = assert(gfx.image.new(assets.bulletCrab))

local speedMovement1 <const> = 3
local speedMovement2 <const> = 1
local speedBullet <const> = 7

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
        local angleTarget = self:getTargetDirection()
        local velX, velY = getRotationComponents(angleTarget, speedBullet)

        Bullet.spawn(self.x, self.y, velX, velY, COLLISION_GROUPS.Player, imageBullet)
    end
end

function Crab:update()
    Crab.super.update(self)

    local angleTarget, distanceToTarget = self:getTargetDirection()

    if not angleTarget then
        return
    end

    if Player:getInstance():getIsHumanMissing() then
        if distanceToTarget > 16 then
            -- Behavior 1:  Chase player and slow them down
            local xMovement, yMovement = getRotationComponents(angleTarget, speedMovement1)

            self:changeState(ANIMATION_STATES.Moving)
            self:moveBy(xMovement, yMovement)
        end
    else
        -- Behavior 2: Stalk player and shoot them

        -- Calculate movement towards target
        local xMovement, yMovement = getRotationComponents(angleTarget, speedMovement2)

        if distanceToTarget > 100 then
            -- Move to player
            self:moveBy(xMovement, yMovement)

            self:changeState(ANIMATION_STATES.Moving)
        else
            self:changeState(ANIMATION_STATES.Shooting)
        end
    end

    -- Rotate self
    local angleDegrees = math.deg(angleTarget)
    self:setRotation(angleDegrees + 90)
end
