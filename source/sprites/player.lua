local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

--- @class Player : playdate.graphics.sprite
Player = {}
class("Player").extends(gfx.sprite)

-- Static instance

local _instance

function Player.getInstance()
    return _instance
end

-- Assets

local imageSpritePlayer <const> = gfx.image.new(assets.ship)

-- Local constants

local slowdownPerFrame <const> = 0.2
local accelerationPerFrameMax <const> = 1.8
local speedBulletMax <const> = 13

-- Local/Static variables

local velocity = geo.vector2D.new(0, 0)

function Player:init()
    Player.super.init(self, imageSpritePlayer)

    _instance = self

    -- Collision config

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(COLLISION_GROUPS.Player)
    self:setCollidesWithGroups({ COLLISION_GROUPS.Enemies, COLLISION_GROUPS.Human })
    self.collisionResponse = gfx.sprite.kCollisionTypeOverlap
end

function Player:add()
    Player.super.add(self)

    self:moveTo(300, 160)
    self.hasDied = false
    self.disableUpdate = false

    velocity = geo.vector2D.new(0, 0)
end

function Player:setHumanSprite(humanSprite)
    self.spriteHuman = humanSprite
end

function Player:setParticlesSprite(particlesSprite)
    self.particlesSprite = particlesSprite
end

function Player:onTouchEnemy()
    if not self.spriteHuman then
        return
    end

    screenShake(800, 8)
    self.disableUpdate = true

    self.timerHumanEject = playdate.timer.new(1200, function()
        self.timerHumanEject = nil
        self.disableUpdate = false
    end)

    self.spriteHuman:add()
    self.spriteHuman:moveTo(self.x, self.y)

    local vX, vY = getRotationComponents(math.random() * 2 * math.pi, 1.5)
    self.spriteHuman:setVelocity(vX, vY)

    self.timerHumanLost = playdate.timer.new(5999, self.onDeath, self)
end

function Player:onTouchHuman()
    if self.timerHumanLost then
        self.timerHumanLost:remove()
        self.timerHumanLost = nil
    end

    self.spriteHuman:remove()
end

function Player:onDeath()
    if self.timerHumanLost then
        self.timerHumanLost:remove()
        self.timerHumanLost = nil
    end

    self.hasDied = true
end

function Player:getTimerHumanLostRemainingSeconds()
    if not self.timerHumanLost then
        return
    end

    return math.floor((self.timerHumanLost.duration - self.timerHumanLost.currentTime) / 1000)
end

function Player:getHasDied()
    return self.hasDied
end

function Player:update()
    Player.super.update(self)

    if self.disableUpdate then
        return
    end

    -- Get Crank Position for rotating the sprite

    local crankPosition = playdate.getCrankPosition()
    local crankPositionRadians = math.rad(crankPosition)

    -- Set player rotation

    self:setRotation(crankPosition)

    -- Get A button state for accelerating or not

    local isAButtonPressed = playdate.buttonIsPressed(playdate.kButtonA)

    -- Get B button state for spawning bullet

    local isBButtonPressed = playdate.buttonJustPressed(playdate.kButtonB)

    if isBButtonPressed then
        local velX, velY = getRotationComponents(crankPositionRadians, speedBulletMax)

        -- Spawn Bullet
        local _ = Bullet.spawn(self.x, self.y, velX, velY)
    end

    -- Calculate Velocity

    velocity = velocity * (1 - slowdownPerFrame)

    if isAButtonPressed then
        velocity = velocity + geo.vector2D.newPolar(accelerationPerFrameMax, crankPosition + 90)
    end

    -- Move & Collisions

    local _, _, collisions = self:moveWithCollisions(self.x + velocity.dx, self.y + velocity.dy)

    for _, collision in pairs(collisions) do
        if not self.timerHumanLost and collision.other:hasGroup(COLLISION_GROUPS.Enemies) then
            self:onTouchEnemy()
        end

        if not self.timerHumanEject and self.timerHumanLost and collision.other:hasGroup(COLLISION_GROUPS.Human) then
            self:onTouchHuman()
        end
    end

    -- Position the particles according to crank rotation

    if self.particlesSprite then
        -- Position the particles sprite behind the player

        local distanceFromCenter = -36
        local x, y = getRotationComponents(crankPositionRadians, distanceFromCenter)

        self.particlesSprite:moveTo(self.x + x, self.y + y)

        -- Rotate the particles sprite

        self.particlesSprite:setRotation(crankPosition)

        -- Set the particles sprite animation

        if isAButtonPressed then
            self.particlesSprite:startAnimation()
        else
            self.particlesSprite:endAnimation()
        end
    end

    -- Teleport the player across the screen if they leave the bounds

    self:handleScreenWrapping()
end
