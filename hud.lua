--[[
--Contribution Credits:
Commands List:
displayhud - toggles between showing and hiding the HUD.
]]--

local WeaponShouldBeShownIfAmmo = {
    [16] = true, [17] = true, [18] = true, [19] = true,
    [22] = true, [23] = true, [24] = true, [25] = true, [26] = true, [27] = true, [28] = true, [29] = true,
    [30] = true, [31] = true, [32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [37] = true, [38] = true, [39] = true,
    [41] = true, [42] = true, [43] = true,
}

local screenWidth, screenHeight = guiGetScreenSize()

local scale = 1
function getScale()
    if ( screenWidth <= 640 ) and ( screenHeight <= 480 ) then
        outputChatBox ( "WARNING: You are running on a low resolution.  Some GUI may be placed or appear incorrectly." )
    elseif ( screenWidth <= 1024 ) and ( screenHeight <= 768 ) then
        scale = 1.3
    elseif ( screenWidth <= 1280 ) and ( screenHeight <= 720 ) then
        scale = 1.3
    elseif ( screenWidth <= 1366 ) and ( screenHeight <= 768 ) then
        scale = 1.4
    elseif ( screenWidth <= 1360 ) and ( screenHeight <= 768 ) then
        scale = 1.4
    elseif ( screenWidth <= 1600 ) and ( screenHeight <= 900 ) then
        scale = 1.6
    elseif ( screenWidth <= 1920 ) and ( screenHeight <= 1080 ) then
        scale = 2
    end
end

addEventHandler('onClientResourceStart', resourceRoot, getScale)

function getPedMaxHealth(ped)
    -- Output an error and stop executing the function if the argument is not valid
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxHealth' [Expected ped/player at argument 1, got " .. tostring(ped) .. "]")
    -- Grab his player health stat.
    local stat = getPedStat(ped, 24)
    -- Do a linear interpolation to get how many health a ped can have.
    local maxhealth = 100 + (stat - 569) / 4.31
    -- Return the max health. Make sure it can't be below 1
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

addEventHandler("onClientResourceStart", root, disableHud)
addEventHandler("onClientPlayerJoin", root, disableHud)
addEventHandler("onClientResourceStop", root, enableHud)

-- showing new hud
function displayHUD()
    --hud 
    local sWidth,sHeight = guiGetScreenSize()

    -- data collection
    local weaponType = getPedWeapon(localPlayer)
    local money = getPlayerMoney()
    local hour, minute = getTime()
    local health = getElementHealth(localPlayer)
    local armor = getPedArmor(localPlayer)
    local ammo = getPedTotalAmmo(localPlayer)
    local ammoClip = getPedAmmoInClip(localPlayer)
    -- data formatting
    local healthFormatted = string.format("%6.0f", health)
    local healthWidth = (tonumber(healthFormatted) / getPedMaxHealth(localPlayer)) * 200
    local armorFormatted = string.format("%6.0f", armor)
    local armorWidth = (tonumber(armorFormatted) / 100) * 211
    local moneyFormatted = string.format("%08d", money)
    minute = string.format("%02d", minute)

    if weaponType then
        dxDrawImage(sWidth*1555/1920, sHeight*100/1080, sWidth*126/1920, sHeight*126/1080, weaponImages[weaponType], 0, 0, 0, 0xFFFEFEFE, false)
    end

    dxDrawText(hour ..":".. minute, sWidth*1686/1920, sHeight*146/1080, sWidth*1778/1920, sHeight*164/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText(hour ..":".. minute, sWidth*1694/1920, sHeight*146/1080, sWidth*1786/1920, sHeight*164/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText(hour ..":".. minute, sWidth*1686/1920, sHeight*154/1080, sWidth*1778/1920, sHeight*172/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText(hour ..":".. minute, sWidth*1694/1920, sHeight*154/1080, sWidth*1786/1920, sHeight*172/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
    dxDrawText(hour ..":".. minute, sWidth*1690/1920, sHeight*150/1080, sWidth*1782/1920, sHeight*168/1080, 0xFFFFFFFF, scale, "pricedown", "center", "center", false, false, false, false, false)

    dxDrawRectangle(sWidth*1580/1920, sHeight*224/1080, sWidth*208/1920, sHeight*24/1080, tocolor(3, 0, 0, 254), false) -- health bar
    dxDrawRectangle(sWidth*1584/1920, sHeight*228/1080, sWidth*healthWidth/1920, sHeight*16/1080, tocolor(223, 0, 0, 254), false) -- health
    dxDrawRectangle(sWidth*1584/1920, sHeight*228/1080, sWidth*200/1920, sHeight*16/1080, tocolor(223, 0, 0, 150), false) -- health shadow

    if armor > 0 then
        dxDrawRectangle(sWidth*1680/1920, sHeight*190/1080, sWidth*108/1920, sHeight*24/1080, tocolor(3, 0, 0, 254), false) -- armor bar
        dxDrawRectangle(sWidth*1684/1920, sHeight*194/1080, sWidth*100/1920, sHeight*16/1080, tocolor(230, 249, 249, 150), false) -- armor shadow
        dxDrawRectangle(sWidth*1684/1920, sHeight*194/1080, sWidth*armor/1920, sHeight*16/1080, tocolor(254, 249, 249, 255), false) -- armor
    end

    if WeaponShouldBeShownIfAmmo[weaponType] then
        dxDrawText(ammoClip .."/".. ammo, sWidth*1571/1920, sHeight*201/1080, sWidth*1656/1920, sHeight*219/1080, 0xFF000000, 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(ammoClip .."/".. ammo, sWidth*1573/1920, sHeight*201/1080, sWidth*1658/1920, sHeight*219/1080, 0xFF000000, 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(ammoClip .."/".. ammo, sWidth*1571/1920, sHeight*203/1080, sWidth*1656/1920, sHeight*221/1080, 0xFF000000, 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(ammoClip .."/".. ammo, sWidth*1573/1920, sHeight*203/1080, sWidth*1658/1920, sHeight*221/1080, 0xFF000000, 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(ammoClip .."/".. ammo, sWidth*1572/1920, sHeight*202/1080, sWidth*1657/1920, sHeight*220/1080, 0xFFBBD6FF, 1.40, "default-bold", "center", "center", false, false, false, false, false)
    end

    if money < 0 then
        dxDrawText("$".. moneyFormatted, sWidth*1548/1920, sHeight*258/1080, sWidth*1784/1920, sHeight*298/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1556/1920, sHeight*258/1080, sWidth*1792/1920, sHeight*298/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1548/1920, sHeight*266/1080, sWidth*1784/1920, sHeight*306/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1556/1920, sHeight*266/1080, sWidth*1792/1920, sHeight*306/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1552/1920, sHeight*262/1080, sWidth*1788/1920, sHeight*302/1080, 0xFFFF0000, scale, "pricedown", "center", "center", false, false, false, false, false)
    else
        dxDrawText("$".. moneyFormatted, sWidth*1548/1920, sHeight*258/1080, sWidth*1784/1920, sHeight*298/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1556/1920, sHeight*258/1080, sWidth*1792/1920, sHeight*298/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1548/1920, sHeight*266/1080, sWidth*1784/1920, sHeight*306/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1556/1920, sHeight*266/1080, sWidth*1792/1920, sHeight*306/1080, 0xFF000000, scale, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText("$".. moneyFormatted, sWidth*1552/1920, sHeight*262/1080, sWidth*1788/1920, sHeight*302/1080, 0xFF246100, scale, "pricedown", "center", "center", false, false, false, false, false)
    end
end
addEventHandler("onClientRender", root, displayHUD)

isHUDShown = false;
addCommandHandler("displayhud", function()  
    if not (isHUDShown) then    
        isHUDShown = true;  
        removeEventHandler("onClientRender", root, displayHUD)  
    else
        isHUDShown = false;
        addEventHandler("onClientRender", root, displayHUD)
    end
end
)
