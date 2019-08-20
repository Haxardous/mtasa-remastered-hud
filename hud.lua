-- commands: displayhud - toggles between showing and hiding the HUD.

local WeaponHaveMoreThanSingle = {
    [19] = true,
    [22] = true, [23] = true, [24] = true, [26] = true, [27] = true, [28] = true, [29] = true,
    [30] = true, [31] = true, [32] = true, [37] = true, [39] = true,
    [41] = true, [42] = true, [43] = true,
}

local WeaponHaveSingleAmmo = {
    [16] = true, [17] = true, [18] = true,
    [25] = true, 
    [33] = true, [34] = true, [35] = true, [36] = true, [38] = true,
}

local sWidth,sHeight = guiGetScreenSize()

local scale = 1
function getScale()
    if ( sWidth <= 640 ) and ( sHeight <= 480 ) then
        outputChatBox ( "WARNING: You are running on a low resolution.  Some GUI may be placed or appear incorrectly." )
    elseif ( sWidth <= 1024 ) and ( sHeight <= 768 ) then
        scale = 1.3
    elseif ( sWidth <= 1280 ) and ( sHeight <= 720 ) then
        scale = 1.3
    elseif ( sWidth <= 1366 ) and ( sHeight <= 768 ) then
        scale = 1.4
    elseif ( sWidth <= 1360 ) and ( sHeight <= 768 ) then
        scale = 1.4
    elseif ( sWidth <= 1600 ) and ( sHeight <= 900 ) then
        scale = 1.6
    elseif ( sWidth <= 1920 ) and ( sHeight <= 1080 ) then
        scale = 2
    end
end

addEventHandler('onClientResourceStart', resourceRoot, getScale)

function getPedMaxHealth(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxHealth' [Expected ped/player at argument 1, got " .. tostring(ped) .. "]")
    local stat = getPedStat(ped, 24)
    local maxhealth = 100 + (stat - 569) / 4.31
    return math.max(1, maxhealth)
end

local weaponImages = {}
for i = 0, 45 do
    weaponImages[i] = "icons/".. i ..".png"
end

local function disableHud() 
    setPlayerHudComponentVisible( "all", false)
    setPlayerHudComponentVisible( "radar", true)
    setPlayerHudComponentVisible( "crosshair", true)
end
    
local function enableHud() 
    setPlayerHudComponentVisible( "all", true)
end

addEventHandler("onClientResourceStart", resourceRoot, disableHud)
addEventHandler("onClientPlayerJoin", resourceRoot, disableHud)
addEventHandler("onClientResourceStop", resourceRoot, enableHud)

function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

local weaponImageDisplay = {posX = sWidth*1542/1920, posY = sHeight*100/1080, width = sWidth*126/1920, height = sHeight*126/1080, color = 0xFFFEFEFE}
local ammoDisplay = {posX = sWidth*1542/1920, posY = sHeight*202/1080, width = sWidth*1657/1920, height = sHeight*220/1080, color = 0xFFBBD6FF, scale = 1.40}
local clockDisplay = {posX = sWidth*1679/1920, posY = sHeight*150/1080, width = sWidth*1782/1920, height = sHeight*168/1080, color = 0xFFFFFFFF}
local moneyDisplay = {posX = sWidth*1552/1920, posY = sHeight*262/1080, width = sWidth*1788/1920, height = sHeight*302/1080, green = 0xFF246100, red = 0xFFFF0000} 

-- showing new hud
function displayHUD()
    -- data collection
    local isPlayerHavingWeapon = getPedWeapon(localPlayer)
    local hour, minute = getTime()
    local hour = string.format("%02d", hour)
    local minute = string.format("%02d", minute)
    local ammo = getPedTotalAmmo(getLocalPlayer())-getPedAmmoInClip(getLocalPlayer())
    local ammoClip = getPedAmmoInClip(localPlayer)
    -- data formatting
    local healthWidth = (tonumber(string.format("%6.0f", getElementHealth(localPlayer))) / getPedMaxHealth(localPlayer)) * 200
    local armorFormatted = string.format("%6.0f", getPedArmor(localPlayer))
    local armorWidth = (tonumber(string.format("%6.0f", getPedArmor(localPlayer))) / 100) * 100
    local moneyFormatted = string.format("%08d", getPlayerMoney())
    
    -- Weapon Image
    if isPlayerHavingWeapon then
        dxDrawImage(weaponImageDisplay["posX"], weaponImageDisplay["posY"], weaponImageDisplay["width"], weaponImageDisplay["height"], weaponImages[isPlayerHavingWeapon], 0, 0, 0, weaponImageDisplay["color"], false)
    end
    
    -- Weapon Ammo (multiple shots)
    if WeaponHaveMoreThanSingle[isPlayerHavingWeapon] then
        dxDrawBorderedText(0.9, ammoClip .."/".. ammo, ammoDisplay["posX"], ammoDisplay["posY"], ammoDisplay["width"], ammoDisplay["height"], ammoDisplay["color"], ammoDisplay["scale"], "default-bold", "center", "center", false, false, false, false, false)
    end

    -- Weapon Ammo (single shots)
    if WeaponHaveSingleAmmo[isPlayerHavingWeapon] then
        dxDrawBorderedText(0.9, "".. ammo, ammoDisplay["posX"], ammoDisplay["posY"], ammoDisplay["width"], ammoDisplay["height"], ammoDisplay["color"], ammoDisplay["scale"], "default-bold", "center", "center", false, false, false, false, false)
    end

    -- clock display
    dxDrawBorderedText(2, hour ..":".. minute, clockDisplay["posX"], clockDisplay["posY"], clockDisplay["width"], clockDisplay["height"], clockDisplay["color"], scale, "pricedown", "left", "center", false, false, false, false, false)

    -- health bar display
    dxDrawRectangle(sWidth*1580/1920, sHeight*228/1080, sWidth*208/1920, sHeight*21/1080, tocolor(3, 0, 0, 254), false) -- health bar
    dxDrawRectangle(sWidth*1584/1920, sHeight*232/1080, sWidth*healthWidth/1920, sHeight*13/1080, tocolor(223, 0, 0, 254), false) -- health
    dxDrawRectangle(sWidth*1584/1920, sHeight*232/1080, sWidth*200/1920, sHeight*13/1080, tocolor(223, 0, 0, 150), false) -- health shadow

    -- armor bar display
    if getPedArmor(localPlayer) > 0 then
        dxDrawRectangle(sWidth*1680/1920, sHeight*190/1080, sWidth*108/1920, sHeight*21/1080, tocolor(3, 0, 0, 254), false) -- armor bar
        dxDrawRectangle(sWidth*1684/1920, sHeight*194/1080, sWidth*100/1920, sHeight*13/1080, tocolor(230, 249, 249, 150), false) -- armor shadow
        dxDrawRectangle(sWidth*1684/1920, sHeight*194/1080, sWidth*armorWidth/1920, sHeight*13/1080, tocolor(254, 249, 249, 255), false) -- armor
    end

    -- money display
    if getPlayerMoney() < 0 then
        dxDrawBorderedText(1.9, "$".. moneyFormatted, moneyDisplay["posX"], moneyDisplay["posY"], moneyDisplay["width"], moneyDisplay["height"], moneyDisplay["red"], scale, "pricedown", "center", "center", false, false, false, false, false)
    else
        dxDrawBorderedText(1.9, "$".. moneyFormatted, moneyDisplay["posX"], moneyDisplay["posY"], moneyDisplay["width"], moneyDisplay["height"], moneyDisplay["green"], scale, "pricedown", "center", "center", false, false, false, false, false)
    end
end
addEventHandler("onClientRender", root, displayHUD)

-- Show HUD command 
isHUDShown = false;
addCommandHandler("displayhud", function()  
    if not (isHUDShown) then    
        isHUDShown = true;  
        removeEventHandler("onClientRender", root, displayHUD)  
    else
        isHUDShown = false;
        addEventHandler("onClientRender", root, displayHUD)
    end
end)
