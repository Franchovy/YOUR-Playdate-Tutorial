local gfx <const> = playdate.graphics

--- @class Enemy : playdate.graphics.sprite
Enemy = {}
class("Enemy").extends(gfx.sprite)

local scoreKill = 0
local target = nil

local timeLastTargetRefresh

function Enemy:init(image)
    Enemy.super.init(self, image)

    -- Collision Config

    self:setCollideRect(0, 0, self:getSize())
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

function Enemy:update()
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
