local gfx <const> = playdate.graphics

local imageTower <const> = assert(gfx.image.new(assets.tower))

--- @class Tower : playdate.graphics.sprite
Tower = {}
class("Tower").extends(gfx.sprite)

function Tower:init()
    Tower.super.init(self, imageTower)
end

function Tower:setGhost()
    self:setCollisionsEnabled(false)
end
