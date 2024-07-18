local gfx <const> = playdate.graphics

local imageTable, message = gfx.imagetable.new(assets.particles)
assert(imageTable, message)

class("Particles").extends(gfx.sprite)

function Particles:init()
    Particles.super.init(self, imageTable[self.index])

    self:moveTo(200, 120)

    self.index = 1
end

function Particles:update()
    if self.index < #imageTable then
        self.index += 1
    else
        self.index = 1
    end

    self:setImage(imageTable[self.index])
end
