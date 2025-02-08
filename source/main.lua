import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/animation"

import "assets"
import "extensions"
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
local human = Human()

-- Create Sprite Lists

Bullet.createSpriteList()

-- Init Function

local function init()
    player:setParticlesSprite(particles)
    player:setHumanSprite(human)

    showMenu()
end

function gameStart()
    hideMenu()

    gfx.sprite.removeAll()

    player:add()
    particles:add()
    --enemySpawner:start()

    Grid.initialize()
    Score.reset()
end

function gameEnd()
    showMenu()

    player:remove()
    particles:remove()
    enemySpawner:stop()
end

-- Update Function

function playdate.update()
    enemySpawner:update()

    sprite.update()
    playdate.timer.updateTimers()

    fontDefault:drawTextAligned(tostring(Score.read()), 390, 8, kTextAlignment.right)

    if isMenuShowing() and playdate.buttonJustPressed(playdate.kButtonA) then
        gameStart()
    end

    if not isMenuShowing() and player:getHasDied() then
        gameEnd()
    end

    local timerHumanLostRemainingSeconds = player:getTimerHumanLostRemainingSeconds()
    if timerHumanLostRemainingSeconds then
        fontDefault:drawTextAligned(tostring(timerHumanLostRemainingSeconds), 200, 120, kTextAlignment.center)
    end
end

-- Game Start

init()
