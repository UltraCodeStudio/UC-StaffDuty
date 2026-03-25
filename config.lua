Config = {}

test 


Config.EnableFloatingText = true
--These are your staff ace roles
Config.dutyGroups = {
    'group.god',
    'group.admin',
    'group.mod',
}

--What identifiers to check
Config.trackedIdentifierTypes = {
    'discord:',
    'steam:',
    'license:',
    'license2:',
    'fivem:',
}

--The order in which to check
Config.dutyKeyPriority = {
    'fivem',
    'license2',
    'license',
    'steam',
    'discord',
}

Config.Outfits = {
    god = {
        components = {
            { componentId = 3, drawableId = 15, textureId = 0, paletteId = 0 }, -- arms
            { componentId = 4, drawableId = 35, textureId = 0, paletteId = 0 }, -- pants
            { componentId = 6, drawableId = 25, textureId = 0, paletteId = 0 }, -- shoes
            { componentId = 8, drawableId = 58, textureId = 0, paletteId = 0 }, -- undershirt
            { componentId = 11, drawableId = 90, textureId = 0, paletteId = 0 }, -- torso
        },
        props = {
            { propId = 0, drawableId = 10, textureId = 0 }, -- hat
            { propId = 1, drawableId = -1, textureId = 0 }, -- glasses off
        }
    }
}