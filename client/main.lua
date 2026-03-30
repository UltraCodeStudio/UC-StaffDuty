local storedApp = nil

RegisterNetEvent('UC-StaffDuty:Client:SaveClothing', function(clothingData)
    storedApp = GetAppearance(PlayerPedId())
end)

RegisterNetEvent('UC-StaffDuty:Client:SetClothing', function(clothingData)
    SetClothing(clothingData)
end)

RegisterNetEvent('UC-StaffDuty:Client:RestoreAppearance', function()
    RestoreAppearance(storedApp)
end)

RegisterNetEvent('UC-StaffDuty:Client:SetGhosted', function(state)
    SetLocalPlayerAsGhost(state)
end)

local function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)
    local scale = (1 / dist) * scale
    local fov = (1 / GetGameplayCamFov()) * 100
    local finalScale = scale * fov
    if onScreen then
        SetTextScale(0.0 * finalScale, 0.55 * finalScale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local staffPeds = {}

CreateThread(function()
    while Config.EnableStaffText do
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local newCache = {}
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if ped ~= 0 and DoesEntityExist(ped) then
                local coords = GetEntityCoords(ped)
                local dist = #(myCoords - coords)
                if dist < 25.0 then
                    local staffData = Entity(ped).state['staffDutyIcon']
                    
                    if staffData and staffData.enabled then
                        newCache[ped] = {
                            group = string.upper(staffData.group or 'Unknown'),
                            offset = 1.25
                        }
                    end
                end
            end
        end
        staffPeds = newCache
        Wait(1000)
    end
    staffPeds = {}
end)

CreateThread(function()
    while Config.EnableStaffText do
        local sleep = 500
        local hasDrawn = false
        for ped, data in pairs(staffPeds) do
            if DoesEntityExist(ped) then
                local coords = GetEntityCoords(ped)
                DrawText3D(
                    coords.x,
                    coords.y,
                    coords.z + data.offset,
                    ('STAFF | %s'):format(data.group),
                    2.8
                )
                hasDrawn = true
            else
                staffPeds[ped] = nil
            end
        end
        if hasDrawn then
            sleep = 4
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    RestoreAppearance(storedApp)
    SetLocalPlayerAsGhost(false)
end)
