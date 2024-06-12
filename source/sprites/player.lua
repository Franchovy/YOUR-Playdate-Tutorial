local gfx <const> = playdate.graphics

class("Player").extends(gfx.sprite)

local imageSpritePlayer = gfx.image.new("assets/ship")

local velocity = 0

function Player:init()
    Player.super.init(self, imageSpritePlayer)

    self:moveTo(300, 160)

    velocity = 0
end

function Player:update()
    Player.super.update(self)

    local crankPosition = playdate.getCrankPosition()
    self:setRotation(crankPosition)

    if playdate.buttonIsPressed(playdate.kButtonA) then
        velocity = 5
    else
        velocity = 0
    end

    local crankPositionRadians = math.rad(crankPosition)
    local vX, vY = velocity * math.cos(crankPositionRadians), velocity * math.sin(crankPositionRadians)

    self:moveBy(vX, vY)

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
