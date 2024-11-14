local gfx <const> = playdate.graphics

local spriteTitle = gfx.sprite.new()
local spriteButton = gfx.sprite.spriteWithText("Press A to start!", 400, 240)

local imageSpriteTitle = gfx.image.new(200, 120)

gfx.setFontFamily(gfx.getFont(gfx.font.kVariantBold))

gfx.pushContext(imageSpriteTitle)
gfx.drawTextAligned("Spaceship", 100, 60, kTextAlignment.center)
gfx.popContext()

spriteTitle:setImage(imageSpriteTitle:scaledImage(2))

spriteTitle:moveTo(200, 100)
spriteButton:moveTo(200, 170)

local _isMenuShowing = false

function showMenu()
    spriteTitle:add()
    spriteButton:add()

    _isMenuShowing = true
end

function hideMenu()
    spriteTitle:remove()
    spriteButton:remove()

    _isMenuShowing = false
end

function isMenuShowing()
    return _isMenuShowing
end
