fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'retro'
description 'Drug seller/dealer/buyer jobs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
client_scripts {
    '@es_extended/imports.lua',
    'client/speeches.lua',
    'client/main.lua',
}
server_scripts {
    'server/main.lua',
}

