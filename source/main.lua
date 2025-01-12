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

-- Instantiate sprites

local player = Player()
local particles = Particles()
local human = Human()

-- Instantiate utility classes
local difficulty = Difficulty(0.01, 0.4)
local enemySpawner = Spawner(Enemy, Enemy.spawnRatePerTick, difficulty)

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
    enemySpawner:start()
    difficulty:restart()

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
    -- Update classes

    difficulty:update()
    enemySpawner:update()
    sprite.update()
    playdate.timer.updateTimers()

    -- Drawing and scene logic

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
