import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/animation"

import "assets"
import "sprites"
import "menu"
import "utils"

-- Playdate Libraries

local gfx <const> = playdate.graphics
local sprite <const> = gfx.sprite

-- Get the default font

local fontDefault <const> = gfx.getFont()

-- Instantiate classes

local player = Player()
local particles = Particles()
local enemySpawner = Spawner(Enemy, Enemy.spawnRatePerTick)

-- Create Sprite Lists

Bullet.createSpriteList()

-- Init Function

local function init()
    showMenu()
end

function gameStart()
    hideMenu()

    player:add()
    particles:add()
    player:setParticlesSprite(particles)
    enemySpawner:start()
end

function gameEnd()
    showMenu()
end

-- Update Function

function playdate.update()
    enemySpawner:update()

    sprite.update()
    playdate.timer.updateTimers()

    fontDefault:drawTextAligned("" .. Score.read(), 390, 8, kTextAlignment.right)

    if isMenuShowing() and playdate.buttonJustPressed(playdate.kButtonA) then
        gameStart()
    end
end

-- Game Start

init()
