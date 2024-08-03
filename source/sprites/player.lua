local gfx <const> = playdate.graphics

class("Player").extends(gfx.sprite)

local imageSpritePlayer = gfx.image.new(assets.ship)

local velocity = 0

function Player:init()
    Player.super.init(self, imageSpritePlayer)

    self:moveTo(300, 160)

    velocity = 0
end

function Player:setParticlesSprite(particlesSprite)
    self.particlesSprite = particlesSprite
end

local function getRotationComponents(rotationRadians, velocity)
    return velocity * math.cos(rotationRadians), velocity * math.sin(rotationRadians)
end

function Player:update()
    Player.super.update(self)

    -- Get Crank Position for rotating the sprite

    local crankPosition = playdate.getCrankPosition()
    local crankPositionRadians = math.rad(crankPosition)

    -- Set player rotation

    self:setRotation(crankPosition)

    -- Get A button state for accelerating or not

    local isAButtonPressed = playdate.buttonIsPressed(playdate.kButtonA)

    if isAButtonPressed then
        velocity = 5
    else
        velocity = 0
    end

    -- Get B button state for spawning bullet

    local isBButtonPressed = playdate.buttonJustPressed(playdate.kButtonB)

    if isBButtonPressed then
        local velX, velY = getRotationComponents(crankPositionRadians, 7.5)

        -- Spawn Bullet
        local bullet = Bullet()
        bullet:spawn(self.x, self.y, velX, velY)
    end

    -- Move the player according to crank rotation

    local vX, vY = getRotationComponents(crankPositionRadians, velocity)
    self:moveBy(vX, vY)

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

    if self.x < -10 then
        self:moveTo(410, self.y)
    elseif self.x > 410 then
        self:moveTo(-10, self.y)
    end

    if self.y < -10 then
        self:moveTo(self.x, 250)
    elseif self.y > 250 then
        self:moveTo(self.x, -10)
    end
end
