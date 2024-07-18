import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "assets"
import "sprites"
import "menu"

local gfx <const> = playdate.graphics
local sprite <const> = gfx.sprite

local player = Player()
local particles = Particles()

local function init()
    player:add()
    particles:add()
    player:setParticlesSprite(particles)

    showMenu()

    playdate.timer.performAfterDelay(1000, function()
        -- start animation
        particles:startAnimation()
    end)

    playdate.timer.performAfterDelay(4000, function()
        -- end animation
        --particles:endAnimation()
    end)
end

function playdate.update()
    sprite.update()
    playdate.timer.updateTimers()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        hideMenu()
    end
end

init()
