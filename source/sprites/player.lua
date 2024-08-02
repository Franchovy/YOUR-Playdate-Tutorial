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

function Player:update()
    Player.super.update(self)

    -- Get Crank Position for rotating the sprite

    local crankPosition = playdate.getCrankPosition()

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
        -- Spawn Bullet
        local bullet = Bullet()
        bullet:spawn(self.x, self.y, 5, 5)
    end

    -- Calculate the velocity using the crank angle

    local crankPositionRadians = math.rad(crankPosition)
    local vX, vY = velocity * math.cos(crankPositionRadians), velocity * math.sin(crankPositionRadians)

    if self.particlesSprite then
        -- Position the particles sprite behind the player

        local distanceFromCenter = -36

        local x = self.x + distanceFromCenter * math.cos(crankPositionRadians)
        local y = self.y + distanceFromCenter * math.sin(crankPositionRadians)

        self.particlesSprite:moveTo(x, y)

        -- Rotate the particles sprite

        self.particlesSprite:setRotation(crankPosition)

        -- Set the particles sprite animation

        if isAButtonPressed then
            self.particlesSprite:startAnimation()
        else
            self.particlesSprite:endAnimation()
        end
    end

    -- Move the player

    self:moveBy(vX, vY)

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
