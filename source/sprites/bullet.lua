local gfx <const> = playdate.graphics

-- Local Constants

local imageBullet <const> = gfx.image.new(assets.bullet)
local spriteListBulletCount <const> = 25

-- Local Variables

local spriteListBullet

--- @class Bullet : playdate.graphics.sprite
Bullet = {}
class("Bullet").extends(gfx.sprite)

-- Static methods

function Bullet.createSpriteList()
    spriteListBullet = table.create(spriteListBulletCount, 0)

    for _ = 1, spriteListBulletCount do
        table.insert(spriteListBullet, Bullet())
    end
end

function Bullet.spawn(posX, posY, velX, velY, collidesWithGroups, image)
    -- Retrieve a bullet from the list

    local bullet = table.remove(spriteListBullet)

    -- Set image

    bullet:setImage(image or imageBullet)
    bullet:setCollideRect(0, 0, bullet:getSize())

    -- Set collision groups

    bullet:setCollidesWithGroups(collidesWithGroups)

    -- Add bullet to the scene

    bullet:add()
    bullet:moveTo(posX, posY)

    bullet.velocityX = velX
    bullet.velocityY = velY

    -- Set rotation

    local angle = math.atan(velY, velX)
    bullet:setRotation(math.deg(angle) + 90)

    bullet.destroyTimer = playdate.timer.new(4000, bullet.destroy, bullet)
end

-- Instance methods

function Bullet:init()
    Bullet.super.init(self, imageBullet)

    self.velocityX = 0
    self.velocityY = 0

    -- Collision config

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(COLLISION_GROUPS.Bullet)
    self:setCollidesWithGroups(COLLISION_GROUPS.Enemies)
end

function Bullet:collisionResponse(other)
    return gfx.sprite.kCollisionTypeOverlap
end

function Bullet:destroy()
    -- Remove the bullet from the scene

    self:remove()

    -- Add the bullet back to the list

    table.insert(spriteListBullet, self)

    -- Remove timer if exists

    if self.destroyTimer then
        self.destroyTimer:remove()
        self.destroyTimer = nil
    end
end

function Bullet:update()
    -- Update position based on velocity

    local _, _, collisions = self:moveWithCollisions(self.x + self.velocityX, self.y + self.velocityY)

    for _, collision in pairs(collisions) do
        local other = collision.other

        if other.onBulletCollision then
            other:onBulletCollision()
        end

        self:destroy()
    end
end
