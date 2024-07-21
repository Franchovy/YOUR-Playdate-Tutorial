local gfx <const> = playdate.graphics

local imageTable, message = gfx.imagetable.new(assets.particles)
assert(imageTable, message)

-- Animation States

local animationStates <const> = {
    pre = 1,
    loop = 2,
    post = 3,
    none = 0
}

local animationIndexes <const> = {
    [animationStates.pre] = { 1, 10 },
    [animationStates.loop] = { 11, 33 },
    [animationStates.post] = { 34, 44 }
}

--

class("Particles").extends(gfx.sprite)

function Particles:init()
    Particles.super.init(self, imageTable[self.index])

    self:moveTo(200, 120)

    self.index = 1

    self.state = animationStates.none
end

function Particles:startAnimation()
    if self.state == animationStates.pre or self.state == animationStates.loop then
        return
    end

    self.state = animationStates.pre
end

function Particles:endAnimation()
    if self.state == animationStates.post or self.state == animationStates.none then
        return
    end

    self.state = animationStates.post
end

function Particles:update()
    if self.state == animationStates.none then
        return
    end

    local indexStart, indexEnd = table.unpack(animationIndexes[self.state])

    -- Change state based on state and index

    if self.state == animationStates.pre and self.index == indexEnd then
        self.state = animationStates.loop
    end

    if self.state == animationStates.post and self.index == indexEnd then
        self.state = animationStates.none
    end

    -- Loop through image table

    if self.index < indexStart or self.index > indexEnd then
        self.index = indexStart
    else
        self.index += 1
    end

    self:setImage(imageTable[self.index])
end
