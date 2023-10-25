fx_version('cerulean')
games({ 'gta5' })
lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server.lua",
}

shared_scripts {
    '@ox_lib/init.lua',
   -- "config.lua",
}
