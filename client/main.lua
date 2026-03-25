

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
    SetTextOutline()

    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(screenX, screenY)
end

CreateThread(function()
    while true do
        if not Config.EnableFloatingText then break end
        local waitTime = 1000
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)

            if ped ~= 0 and DoesEntityExist(ped) then
                local staffData = Entity(ped).state['UC-StaffDuty']

                if staffData and staffData.enabled then
                    local coords = GetEntityCoords(ped)
                    local dist = #(myCoords - coords)

                    if dist < 20.0 then
                        waitTime = 0
                        DrawText3D(coords.x, coords.y, coords.z + 1.25, ('STAFF | %s'):format(staffData.group or 'Unknown'), 0.8)
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)