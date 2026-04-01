---@type table<number, string>
local storedStaffAces = {} -- src -> permission
local storedStaffAppearance = {} -- src -> apperance


---@type string[]
local permissionOrder = Config.PermissionOrder

---@param group string
---@return string
local function formatGroupName(group)
    return ('group.%s'):format(group)
end

---@param src number
---@param permission string
---@return boolean
local function hasAceGroup(src, permission)
    if not src or not permission then
        return false
    end
    return IsPlayerAceAllowed(tostring(src), permission)
end


---@param permissions string[]
---@return string|nil
local function getBiggestPermission(permissions)
    for _, permission in pairs(permissionOrder) do
        for _, playerPermission in pairs(permissions) do
            if playerPermission == permission then
                return permission
            end
        end
    end

    return nil
end

---@param src number
---@return table|nil
local function getPlayerPermissions(src)
    local playerPermissions = {}
    for _, permission in pairs(permissionOrder) do
        if hasAceGroup(src, permission) then
            playerPermissions[#playerPermissions + 1] = permission
        end
    end
    return playerPermissions
end

---@param src number
local function removePerms(src)
    local permissions = getPlayerPermissions(src)

    if not permissions then
        storedStaffAces[src] = nil
        return
    end
    storedStaffAces[src] = getBiggestPermission(permissions)
    
    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        for _, group in pairs(permissions) do
            local principal = ('identifier.%s'):format(identifier)
            local group = formatGroupName(group)
            --print(('Removed %s from %s'):format(group, principal))
            lib.removePrincipal(principal, group)
        end
    end
end

local function drawIcon(src, state, group)
    local ped = GetPlayerPed(src)
    Entity(ped).state:set('staffDutyIcon', {
        enabled = state,
        group = group
    }, true)
    
end

local function givePerms(src)
    local permission = storedStaffAces[src]
    if not permission then return end
    local group = formatGroupName(permission)

    for _, identifier in pairs(GetPlayerIdentifiers(src)) do
        local principal = ('identifier.%s'):format(identifier)
        --print(('Restored %s for %s'):format(group, principal))
        lib.addPrincipal(principal, group)
    end
end
---@param src number
local function setOffDuty(src)
    Notify(src, "Duty", "You are now off duty", "success")
    storedStaffAces[src] = "onDuty"
    if Config.RemovePermissions then
        removePerms(src)
    end

    if Config.EnableClothing then
        TriggerClientEvent('UC-StaffDuty:Client:RestoreAppearance', src)
    end

    if Config.EnableGhosting then
        TriggerClientEvent('UC-StaffDuty:Client:SetGhosted', src, false)
    end

    if Config.EnableStaffText then 
        drawIcon(src, false)
    end

    
end

---@param src number
local function setOnDuty(src)
    Notify(src, "Duty", "You are now on duty", "error")
    
    if Config.RemovePermissions then
        givePerms(src)
    end
    
    if Config.EnableClothing then
        TriggerClientEvent('UC-StaffDuty:Client:SaveClothing', src)
        local permissions = getPlayerPermissions(src)
        local biggest = getBiggestPermission(permissions)
        local appearance = Config.Clothing[biggest or "mod"]
        TriggerClientEvent('UC-StaffDuty:Client:SetClothing', src, appearance)
    end

    if Config.EnableGhosting then
        TriggerClientEvent('UC-StaffDuty:Client:SetGhosted', src, true)
    end

    if Config.EnableStaffText then
        local group = getBiggestPermission(getPlayerPermissions(src)) or "Unknown"
        drawIcon(src, true, group)
    end

    storedStaffAces[src] = nil
end


local function hasAccess(src)
    if #getPlayerPermissions(src) ~= 0 then
        return true
    end
    if storedStaffAces[src] then
        return true
    end
    return false
end

lib.addCommand('duty', {
    help = 'Toggles admin duty',
}, function(source, args, raw)
    

    if not hasAccess(source) then Notify(source, "Duty", "No Access", "error") return end
    if storedStaffAces[source] ~= nil then
        setOnDuty(source)
    else
        setOffDuty(source)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for src, _ in pairs(storedStaffAces) do
        setOnDuty(src)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    for _, playerId in pairs(GetPlayers()) do
        setOffDuty(tonumber(playerId))
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    setOffDuty(src)
end)

AddEventHandler('playerDropped', function()
    local src = source
    storedStaffAces[src] = nil
end)
