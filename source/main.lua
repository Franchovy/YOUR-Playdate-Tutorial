import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"

import "assets"
import "sprites"
import "menu"

-- Playdate Libraries

local gfx <const> = playdate.graphics
local sprite <const> = gfx.sprite

-- Instantiate classes

local player = Player()
local particles = Particles()

-- Create Sprite Lists

Bullet.createSpriteList()

-- Init Function

local function init()
    player:add()
    particles:add()
    player:setParticlesSprite(particles)

    showMenu()
end

-- Update Function

function playdate.update()
    sprite.update()
    playdate.timer.updateTimers()

    if playdate.buttonJustPressed(playdate.kButtonA) then
        hideMenu()
    end
end

-- Game Start

init()
