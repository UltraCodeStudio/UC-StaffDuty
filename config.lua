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
            { component_id = 1, drawable = 129, texture = 0, palette = 0 }, -- mask
            { component_id = 3, drawable = 204, texture = 0, palette = 0 }, -- arms
            { component_id = 4, drawable = 197, texture = 0, palette = 0 }, -- pants
            { component_id = 6, drawable = 110, texture = 0, palette = 0 }, -- shoes
            { component_id = 8, drawable = 15, texture = 0, palette = 0 }, -- undershirt
            { component_id = 11, drawable = 533, texture = 0, palette = 0 }, -- jacket / torso 2
        },
    },
    ["admin"] = {
        components = {
            { component_id = 1, drawable = 129, texture = 0, palette = 0 }, -- mask
            { component_id = 3, drawable = 204, texture = 0, palette = 0 }, -- arms
            { component_id = 4, drawable = 197, texture = 0, palette = 0 }, -- pants
            { component_id = 6, drawable = 110, texture = 0, palette = 0 }, -- shoes
            { component_id = 8, drawable = 15, texture = 0, palette = 0 }, -- undershirt
            { component_id = 11, drawable = 533, texture = 0, palette = 0 }, -- jacket / torso 2
        },
    },
    ["mod"] = {
        components = {
            { component_id = 1, drawable = 129, texture = 0, palette = 0 }, -- mask
            { component_id = 3, drawable = 204, texture = 0, palette = 0 }, -- arms
            { component_id = 4, drawable = 197, texture = 0, palette = 0 }, -- pants
            { component_id = 6, drawable = 110, texture = 0, palette = 0 }, -- shoes
            { component_id = 8, drawable = 15, texture = 0, palette = 0 }, -- undershirt
            { component_id = 11, drawable = 533, texture = 0, palette = 0 }, -- jacket / torso 2
        },
    },

}