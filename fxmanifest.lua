fx_version 'cerulean'
game 'gta5'

description 'Staff Duty system for FiveM'
version '1.0'
author 'Ultra Code'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/**.lua',
}

server_scripts {
    'server/**.lua',
}

dependencies {
    'ox_lib',
    'community_bridge',
}

lua54 'yes'
usperimental_fxv2_oal 'yes'


