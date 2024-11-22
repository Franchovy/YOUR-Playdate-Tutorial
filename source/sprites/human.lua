local gfx <const> = playdate.graphics

-- Imagetable assets
local imageTableBubble = assert(gfx.imagetable.new(assets.bubble))
local imageTableHuman = assert(gfx.imagetable.new(assets.human))

--- @class Human : playdate.graphics.sprite
Human = {}
class("Human").extends(gfx.sprite)

function Human:init()
    Human.super.init(self)

    self:setSize(52, 52)
    self:setCollideRect(10, 10, 32, 32)

    self.animationLoopBubble = gfx.animation.loop.new(400, imageTableBubble, true)
    self.animationLoopHuman = gfx.animation.loop.new(100, imageTableHuman, true)
end

function Human:draw(x, y, width, height)
    self.animationLoopBubble:draw(0, 0)
    self.animationLoopHuman:draw(10, 10)
end

function Human:setVelocity(vX, vY)
    self.vX = vX
    self.vY = vY
end

function Human:update()
    Human.super.update(self)

    self:moveBy(self.vX, self.vY)

    self:markDirty()

    self:handleScreenWrapping()
end
