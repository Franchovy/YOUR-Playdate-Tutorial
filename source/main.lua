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

-- Difficulty

local growthRate = 0.01
local exponent = 0.4
local gameStartTime
local difficulty = 1

function getDifficulty()
    if not gameStartTime then gameStartTime = playdate.getCurrentTimeMilliseconds() end

    local currentTime = playdate.getCurrentTimeMilliseconds() - gameStartTime
    return 1 + growthRate * currentTime ^ exponent
end

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
    enemySpawner:start()

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
    enemySpawner:update(difficulty)

    sprite.update()
    playdate.timer.updateTimers()

    difficulty = getDifficulty()
    print(difficulty)

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
