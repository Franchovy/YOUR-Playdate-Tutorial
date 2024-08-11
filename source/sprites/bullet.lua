local gfx <const> = playdate.graphics

-- Local Constants

local imageBullet <const> = gfx.image.new(assets.bullet)
local spriteListBulletCount <const> = 10

-- Local Variables

local spriteListBullet

class("Bullet").extends(gfx.sprite)

function Bullet.createSpriteList()
    spriteListBullet = table.create(spriteListBulletCount, 0)

    for _ = 1, spriteListBulletCount do
        table.insert(spriteListBullet, Bullet())
    end
end

function Bullet:init()
    Bullet.super.init(self, imageBullet)

    self.velocityX = 0
    self.velocityY = 0
end

function Bullet:destroy()
    -- Remove the bullet from the scene

    self:remove()

    -- Add the bullet back to the list

    table.insert(spriteListBullet, self)
end

function Bullet.spawn(posX, posY, velX, velY)
    -- Retrieve a bullet from the list

    local bullet = table.remove(spriteListBullet)

    -- Add bullet to the scene

    bullet:add()
    bullet:moveTo(posX, posY)
    bullet.velocityX = velX
    bullet.velocityY = velY

    bullet.destroyTimer = playdate.timer.new(1000, bullet.destroy, bullet)
end

function Bullet:update()
    -- Update position based on velocity
    self:moveBy(self.velocityX, self.velocityY)
end
