---@type table<string, string[]>
local offDutyStaff = {}

---@type string[]
local dutyGroups = Config.dutyGroups

---@type string[]
local trackedIdentifierTypes = Config.trackedIdentifierTypes

---@type string[]
local dutyKeyPriority = Config.dutyKeyPriority

---@param src number
---@param outfitName string
local function ApplyOutfit(src, outfitName)
    local ped = GetPlayerPed(src)
    if ped == 0 then return end

    local outfit = Config.Outfits[outfitName]
    if not outfit then
        print(('Outfit "%s" does not exist.'):format(outfitName))
        return
    end

    if outfit.components then
        for i = 1, #outfit.components do
            local component = outfit.components[i]

            SetPedComponentVariation(
                ped,
                component.componentId,
                component.drawableId,
                component.textureId,
                component.paletteId or 0
            )
        end
    end

    if outfit.props then
        for i = 1, #outfit.props do
            local prop = outfit.props[i]

            if prop.drawableId == -1 then
                ClearPedProp(ped, prop.propId)
            else
                SetPedPropIndex(ped, prop.propId, prop.drawableId, prop.textureId, true)
            end
        end
    end
end

---@param value string
---@param prefix string
---@return boolean
local function formatGroupName(value, prefix)
    return value:sub(1, #prefix) == prefix
end

---@param src number
---@return string[]
local function getAceIdentifierPrincipals(src)
    local principals = {}

    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        for i = 1, #trackedIdentifierTypes do
            if formatGroupName(identifier, trackedIdentifierTypes[i]) then
                principals[#principals + 1] = ('identifier.%s'):format(identifier)
                break
            end
        end
    end

    return principals
end

---@param src number
---@return string?
local function getDutyKey(src)
    for i = 1, #dutyKeyPriority do
        local identifier = GetPlayerIdentifierByType(src, dutyKeyPriority[i])
        if identifier then
            return identifier
        end
    end
end

---@param group string
---@return string
local function groupToAce(group)
    return (group:gsub('group%.', ''))
end

---@param dutyKey string
---@return string[]
local function getStoredGroups(dutyKey)
    offDutyStaff[dutyKey] = offDutyStaff[dutyKey] or {}
    return offDutyStaff[dutyKey]
end

---@param dutyKey string
---@param group string
---@return boolean
local function hasStoredGroup(dutyKey, group)
    local groups = offDutyStaff[dutyKey]
    if not groups then return false end

    for i = 1, #groups do
        if groups[i] == group then
            return true
        end
    end

    return false
end

---@param dutyKey string
---@param group string
local function storeGroup(dutyKey, group)
    if hasStoredGroup(dutyKey, group) then
        return
    end

    local groups = getStoredGroups(dutyKey)
    groups[#groups + 1] = group
end

---@param dutyKey string
---@param group string
local function removeStoredGroup(dutyKey, group)
    local groups = offDutyStaff[dutyKey]
    if not groups then return end

    for i = #groups, 1, -1 do
        if groups[i] == group then
            table.remove(groups, i)
        end
    end

    if #groups == 0 then
        offDutyStaff[dutyKey] = nil
    end
end

---@param principals string[]
---@param group string
local function addGroupToPrincipals(principals, group)
    for i = 1, #principals do
        lib.addPrincipal(principals[i], group)
    end
end

---@param principals string[]
---@param group string
local function removeGroupFromPrincipals(principals, group)
    for i = 1, #principals do
        lib.removePrincipal(principals[i], group)
    end
end

---@param src number
local function ApplyIcon(src, group)
    
    local ped = GetPlayerPed(src)
    if ped == 0 then return end

    Entity(ped).state:set('UC-StaffDuty:Duty', {
        enabled = true,
        group = group
    }, true)
end

---@param src number
local function RemoveIcon(src)
    local ped = GetPlayerPed(src)
    if ped == 0 then return end

    Entity(ped).state:set('UC-StaffDuty:Duty', {
        enabled = false,
        group = nil
    }, true)
end

local function RemovePlayerEffects(src)
    SetPlayerInvincible(src, false)
    local ped = GetPlayerPed(src)
    Entity(ped).state:set('UC-StaffDuty:Effects', {
        alpha = 255,
        invincible = false,
        collision = true
    }, true)
end

local function ApplyPlayerEffects(src)
    SetPlayerInvincible(src, true)
    local ped = GetPlayerPed(src)
    Entity(ped).state:set('UC-StaffDuty:Effects', {
        alpha = 102,
        invincible = true,
        collision = false
    }, true)
end

---@param src number
---@param groups string[]
local function setOnDuty(src, groups)

    local dutyKey = getDutyKey(src)
    if not dutyKey then return end
    if not groups or #groups == 0 then return end

    local principals = getAceIdentifierPrincipals(src)
    if #principals == 0 then return end

    for i = 1, #groups do
        local group = groups[i]
        addGroupToPrincipals(principals, group)
        removeStoredGroup(dutyKey, group)
        ApplyOutfit(src,groupToAce(group))
        ApplyIcon(src, groupToAce(group))
        ApplyPlayerEffects(src)
    end
end


---@param src number
---@param groups string[]
local function setOffDuty(src, groups, keep)
    store = store or true
    local dutyKey = getDutyKey(src)
    if not dutyKey then return end
    if not groups or #groups == 0 then return end

    local principals = getAceIdentifierPrincipals(src)
    if #principals == 0 then return end

    for i = 1, #groups do
        local group = groups[i]
        local ace = groupToAce(group)

        if IsPlayerAceAllowed(src, ace) then
            storeGroup(dutyKey, group)
            
            if not keep then
                removeGroupFromPrincipals(principals, group)
            end
            TriggerClientEvent("illenium-appearance:client:reloadSkin", src)
            RemoveIcon(src)
            RemovePlayerEffects(src)
            return
        end
    end
end

---@param src number
local function removeDutyGroups(src)
    setOffDuty(src, dutyGroups)
end

---@param src number
local function addDutyGroups(src)
    local dutyKey = getDutyKey(src)
    if not dutyKey then return end

    local storedGroups = offDutyStaff[dutyKey]
    if not storedGroups or #storedGroups == 0 then return end

    local groupsToRestore = {}
    for i = 1, #storedGroups do
        groupsToRestore[i] = storedGroups[i]
    end

    setOnDuty(src, groupsToRestore)
end

---@param src number
local function initStaffState(src)
    removeDutyGroups(src)
end

---@param src number
---@return boolean
local function isAllowedToUseDuty(src)
    local dutyKey = getDutyKey(src)
    if not dutyKey then return false end

    if offDutyStaff[dutyKey] then
        return true
    end

    for i = 1, #dutyGroups do
        if IsPlayerAceAllowed(src, groupToAce(dutyGroups[i])) then
            return true
        end
    end

    return false
end

---@param src number
---@return boolean
local function isOffDuty(src)
    local dutyKey = getDutyKey(src)
    return dutyKey ~= nil and offDutyStaff[dutyKey] ~= nil
end

---@param src number
local function restoreStoredGroups(src)
    local dutyKey = getDutyKey(src)
    if not dutyKey then return end

    local groups = offDutyStaff[dutyKey]
    if not groups or #groups == 0 then return end

    local principals = getAceIdentifierPrincipals(src)
    if #principals == 0 then return end
    
    for i = 1, #groups do
        
        addGroupToPrincipals(principals, groups[i])
    end

    offDutyStaff[dutyKey] = nil
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    initStaffState(source)
end)

AddEventHandler('playerDropped', function()
    removeDutyGroups(source)
end)

AddEventHandler('onResourceStart', function(resourceName)
    
    
    
    if resourceName ~= GetCurrentResourceName() then return end
    for _, playerId in ipairs(GetPlayers()) do
        initStaffState(tonumber(playerId))
    end
    
    
    
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    for _, playerId in ipairs(GetPlayers()) do
        restoreStoredGroups(tonumber(playerId))
        if not isOffDuty(tonumber(playerId)) then
            setOffDuty(tonumber(playerId), dutyGroups, true)
        end
    end
end)

RegisterCommand('duty', function(source)
    if source == 0 then return end
    if not isAllowedToUseDuty(source) then return end

    if isOffDuty(source) then
        addDutyGroups(source)
        
        Notify(source, {
            title = 'Staff Duty',
            description = 'You are now on duty',
            type = 'success'
        })
    else
        removeDutyGroups(source)
        Notify(source, {
            title = 'Staff Duty',
            description = 'You are now off duty',
            type = 'error'
        })
    end

    
    
end, false)