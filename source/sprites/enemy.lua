local gfx <const> = playdate.graphics

--- @class Enemy : AnimatedSprite
Enemy = {}
class("Enemy").extends(AnimatedSprite)

local scoreKill = 0
local target = nil

local timeLastTargetRefresh

function Enemy:init(imagetable)
    Enemy.super.init(self, imagetable)

    -- Collision Config

    self:setCollideRect(0, 0, imagetable[1]:getSize())
    self:setGroups(COLLISION_GROUPS.Enemies)
end

function Enemy:onBulletCollision()
    self:destroy()
end

function Enemy:destroy()
    local scoreKill = self:getScoreValue()

    Score.update(scoreKill)

    self:remove()
end

function Enemy:getScoreValue()
    return scoreKill
end

function Enemy:getTarget()
    return target
end

function Enemy:getTargetDirection()
    local target = self:getTarget()

    if target then
        -- Calculate angle towards target
        local distanceY = target.y - self.y
        local distanceX = target.x - self.x
        return math.atan(distanceY, distanceX), math.sqrt(distanceX ^ 2 + distanceY ^ 2)
    end

    return nil
end

function Enemy:update()
    Enemy.super.update(self)

    if not timeLastTargetRefresh or timeLastTargetRefresh < playdate.getCurrentTimeMilliseconds() then
        local player = Player.getInstance()

        if player and not player:getHasDied() then
            target = player
        else
            target = nil
        end

        timeLastTargetRefresh = playdate.getCurrentTimeMilliseconds()
    end
end
