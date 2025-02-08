local gfx <const> = playdate.graphics

local imagetableTower <const> = assert(gfx.imagetable.new(assets.tower))

--- @class Tower : playdate.graphics.sprite
Tower = {}
class("Tower").extends(gfx.sprite)

function Tower:init()
    Tower.super.init(self, imagetableTower[1])
end

function Tower:setGhost()
    self:setCollisionsEnabled(false)
    self:setImage(imagetableTower[2])
end
