local gfx <const> = playdate.graphics

local imagetableEnemy <const> = gfx.imagetable.new(assets.enemy)

class("Enemy").extends(gfx.sprite)

function Enemy:init()
    Enemy.super.init(self, imagetableEnemy[1])

    -- Create animation loop

    self.animationLoop = gfx.animation.loop.new(500, imagetableEnemy)
end

function Enemy:update()
    -- Set the sprite image
    self:setImage(self.animationLoop:image())
end