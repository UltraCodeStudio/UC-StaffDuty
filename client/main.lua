

---@param x number
---@param y number
---@param z number
---@param text string
---@param scale number?
local function DrawText3D(x, y, z, text, scale)
    local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    scale = scale or 0.35
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextCentre(true)
    SetTextColour(255, 0, 0, 255)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(screenX, screenY)
end

---@type table<number, { group: string, offset: number }>
local staffPeds = {}
CreateThread(function()
    while Config.EnableFloatingText do
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local newCache = {}
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if ped ~= 0 and DoesEntityExist(ped) then
                local coords = GetEntityCoords(ped)
                local dist = #(myCoords - coords)
                if dist < 25.0 then
                    local staffData = Entity(ped).state['UC-StaffDuty:Duty']
                    if staffData and staffData.enabled then
                        newCache[ped] = {
                            group = staffData.group or 'Unknown',
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
    while Config.EnableFloatingText do
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
                    0.8
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

AddStateBagChangeHandler("UC-StaffDuty:Effects", nil, function(bagName, key, value) 
    
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end
    SetEntityInvincible(entity, value.invincible)
    TaskSetBlockingOfNonTemporaryEvents(entity, value.invincible)
    SetPedCanRagdoll(entity, value.invincible)
    SetEntityCanBeDamaged(entity, value.invincible)
    SetEveryoneIgnorePlayer(entity, value.invincible)
    SetPoliceIgnorePlayer(entity, value.invincible)
    SetLocalPlayerAsGhost(value.invincible)
    NetworkSetEntityGhostedWithOwner(entity, value.invincible)
end)