--[[
*Remastered HUD by Haxardous/Axa
*7/18/2019
*Version: r1.0.0
*Discord: Axa#7286/260124112452583446
]]

-- hiding old hud
local WeaponShouldBeShownIfAmmo = {}
WeaponShouldBeShownIfAmmo[16] = true
WeaponShouldBeShownIfAmmo[17] = true
WeaponShouldBeShownIfAmmo[18] = true
WeaponShouldBeShownIfAmmo[19] = true
WeaponShouldBeShownIfAmmo[22] = true
WeaponShouldBeShownIfAmmo[23] = true
WeaponShouldBeShownIfAmmo[24] = true
WeaponShouldBeShownIfAmmo[25] = true
WeaponShouldBeShownIfAmmo[26] = true
WeaponShouldBeShownIfAmmo[27] = true
WeaponShouldBeShownIfAmmo[28] = true
WeaponShouldBeShownIfAmmo[29] = true
WeaponShouldBeShownIfAmmo[30] = true
WeaponShouldBeShownIfAmmo[31] = true
WeaponShouldBeShownIfAmmo[32] = true
WeaponShouldBeShownIfAmmo[33] = true
WeaponShouldBeShownIfAmmo[34] = true
WeaponShouldBeShownIfAmmo[35] = true
WeaponShouldBeShownIfAmmo[36] = true
WeaponShouldBeShownIfAmmo[37] = true
WeaponShouldBeShownIfAmmo[38] = true
WeaponShouldBeShownIfAmmo[39] = true
WeaponShouldBeShownIfAmmo[41] = true
WeaponShouldBeShownIfAmmo[42] = true
WeaponShouldBeShownIfAmmo[43] = true

local screenWidth, screenHeight = guiGetScreenSize() 

function shudnotvisible() 
setPlayerHudComponentVisible( "all", false)
setPlayerHudComponentVisible( "radar", true)
setPlayerHudComponentVisible( "crosshair", true)
end

function shudvisible() 
setPlayerHudComponentVisible( "all", true)
end

addEventHandler("onClientResourceStart", root, shudnotvisible)
addEventHandler("onClientPlayerJoin", root, shudnotvisible)
addEventHandler("onClientResourceStop", root, shudvisible)

local weaponImages = {}
for i = 0, 45 do
    weaponImages[i] = "icons/".. i ..".png"
end

-- showing new hud
function displayHUD()
        local weaponType = getPlayerWeapon(localPlayer)
        local g_pmoney = getPlayerMoney()
        local g_timehour, g_timeminute = getTime()
        local g_playerHealth = getElementHealth(localPlayer)
        local g_armor = getPedArmor(localPlayer)
        local g_playerhealthcorrect = string.format("%6.0f", g_playerHealth)
        local g_playerarmorcorrect = string.format("%6.0f", g_armor)
        local g_playerhealthwidth = (g_playerhealthcorrect / 100) * 200
        local g_playerarmorwidth =  (g_playerarmorcorrect / 100) * 211
 --       local ammo = getPedAmmoInClip(localPlayer)
        local allammo = getPedTotalAmmo(localPlayer)
        local g_ammo = (allammo)
        g_playerHealth = string.format("%6.0f", g_playerHealth)
        g_timeminute = string.format("%02d", g_timeminute)
        g_pmoney = string.format("%08d", g_pmoney)

        if weaponType then
            dxDrawImage(1555, 100, 126, 126, weaponImages[weaponType], 0, 0, 0, 0xFFFEFEFE, false)
        end
        dxDrawText(g_timehour ..":".. g_timeminute, 1690 - 4, 150 - 4, 1782 - 4, 168 - 4, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText(g_timehour ..":".. g_timeminute, 1690 + 4, 150 - 4, 1782 + 4, 168 - 4, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText(g_timehour ..":".. g_timeminute, 1690 - 4, 150 + 4, 1782 - 4, 168 + 4, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText(g_timehour ..":".. g_timeminute, 1690 + 4, 150 + 4, 1782 + 4, 168 + 4, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
        dxDrawText(g_timehour ..":".. g_timeminute, 1690, 150, 1782, 168, tocolor(255, 255, 255, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
        
        dxDrawRectangle(1608-28, 224, 208, 24, tocolor(3, 0, 0, 254), false) -- health bar
        dxDrawRectangle(1612-28, 228, g_playerhealthwidth, 16, tocolor(223, 0, 0, 254), false) -- health
        dxDrawRectangle(1612-28, 228, 200, 16, tocolor(223, 0, 0, 150), false) -- health shadow
        if g_armor <= 0 then
        else
        dxDrawRectangle(1608+72, 190, 108, 24, tocolor(3, 0, 0, 254), false) -- armor bar
        dxDrawRectangle(1612+72, 194, 100, 16, tocolor(230, 249, 249, 150), false) -- armor shadow
        dxDrawRectangle(1612+72, 194, g_armor, 16, tocolor(254, 249, 249, 255), false) -- armor

        if WeaponShouldBeShownIfAmmo[getPedWeapon(localPlayer)] then

        dxDrawText(g_ammo, 1572 - 1, 202 - 1, 1657 - 1, 220 - 1, tocolor(0, 0, 0, 255), 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(g_ammo, 1572 + 1, 202 - 1, 1657 + 1, 220 - 1, tocolor(0, 0, 0, 255), 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(g_ammo, 1572 - 1, 202 + 1, 1657 - 1, 220 + 1, tocolor(0, 0, 0, 255), 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(g_ammo, 1572 + 1, 202 + 1, 1657 + 1, 220 + 1, tocolor(0, 0, 0, 255), 1.40, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText(g_ammo, 1572, 202, 1657, 220, tocolor(187, 214, 254, 254), 1.40, "default-bold", "center", "center", false, false, false, false, false)
        end
        end
        if g_pmoney <=tostring(0) then
            dxDrawText("$".. g_pmoney, 1552 - 4, 262 - 4, 1788 - 4, 302 - 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 + 4, 262 - 4, 1788 + 4, 302 - 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 - 4, 262 + 4, 1788 - 4, 302 + 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 + 4, 262 + 4, 1788 + 4, 302 + 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552, 262, 1788, 302, tocolor(255, 0, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            else
            dxDrawText("$".. g_pmoney, 1552 - 4, 262 - 4, 1788 - 4, 302 - 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 + 4, 262 - 4, 1788 + 4, 302 - 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 - 4, 262 + 4, 1788 - 4, 302 + 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552 + 4, 262 + 4, 1788 + 4, 302 + 4, tocolor(0, 1, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
            dxDrawText("$".. g_pmoney, 1552, 262, 1788, 302, tocolor(36, 97, 0, 254), 2.00, "pricedown", "center", "center", false, false, false, false, false)
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
