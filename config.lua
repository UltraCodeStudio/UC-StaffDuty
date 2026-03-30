Config = {}

Config.PermissionOrder = { -- The order of groups (biggest first)
    'god',
    'admin',
    'mod'
}

Config.RemovePermissions = true --Remove permissions when off duty
Config.EnableClothing = true -- Enables clothing swapping
Config.EnableGhosting = true --Enables Ghosting "Passive Mode" for on duty staff member
Config.EnableStaffText = true -- Puts text above on duty staff members heads

Config.Clothing = { -- Clothing to swap into for each group
    ["god"] = {
        components = {
            { component_id = 3, drawable = 32, texture = 0, palette = 0 },
            { component_id = 4, drawable = 321, texture = 0, palette = 0 },
            { component_id = 6, drawable = 32, texture = 0, palette = 0 },
            { component_id = 11, drawable = 10, texture = 0, palette = 0 },
        },
    },
    ["admin"] = {
        components = {
            { component_id = 3, drawable = 29, texture = 0, palette = 0 },
            { component_id = 4, drawable = 15, texture = 0, palette = 0 },
            { component_id = 6, drawable = 28, texture = 0, palette = 0 },
            { component_id = 11, drawable = 250, texture = 0, palette = 0 },
        },
    },
    ["mod"] = {
        components = {
            { component_id = 3, drawable = 44, texture = 0, palette = 0 },
            { component_id = 4, drawable = 15, texture = 0, palette = 0 },
            { component_id = 6, drawable = 28, texture = 0, palette = 0 },
            { component_id = 11, drawable = 250, texture = 0, palette = 0 },
        },
    },

}