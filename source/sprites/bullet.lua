local gfx <const> = playdate.graphics

-- Local Constants

local imageBullet <const> = gfx.image.new(assets.bullet)

class("Bullet").extends(gfx.sprite)

function Bullet:init()
    Bullet.super.init(self, imageBullet)

    self.velocityX = 0
    self.velocityY = 0
end

function Bullet:spawn(posX, posY, velX, velY)
    self:add()
    self:moveTo(posX, posY)
    self.velocityX = velX
    self.velocityY = velY
end

function Bullet:update()
    -- Update position based on velocity
    self:moveBy(self.velocityX, self.velocityY)
end
