--- @class Difficulty
Difficulty = {}
class("Difficulty").extends()

function Difficulty:init(growthRate, exponent)
    Difficulty.super.init(self)

    self.growthRate = growthRate
    self.exponent = exponent

    self:restart()
end

function Difficulty:restart()
    self.value = 1
    self.startTime = playdate.getCurrentTimeMilliseconds()
end

function Difficulty:update()
    local currentTime = playdate.getCurrentTimeMilliseconds() - self.startTime
    self.value = 1 + self.growthRate * currentTime ^ self.exponent
end

function Difficulty:getValue()
    return self.value
end
