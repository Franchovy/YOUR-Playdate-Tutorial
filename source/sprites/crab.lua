local gfx <const> = playdate.graphics

--- @class Crab : playdate.graphics.sprite
Crab = {}
class("Crab").extends(gfx.sprite)

function Crab:init()
    Crab.super.init(self)
end
