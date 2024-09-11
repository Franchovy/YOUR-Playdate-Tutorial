local gfx <const> = playdate.graphics

local imagetableEnemy <const> = gfx.imagetable.new(assets.enemy)

class("Enemy").extends(gfx.sprite)

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
    -- Set the sprite image
    self:setImage(self.animationLoop:image())
end