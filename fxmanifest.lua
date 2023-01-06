fx_version 'adamant'

game 'gta5'

lua54 'yes'

description 'Identification for ESX servers'
author 'druf0'

ui_page 'html/index.html'

dependencies {
    'es_extended',
    'esx_identity',
    'ox_lib'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'locales/*.lua',
    'server/*.lua'
}

client_scripts {
    'locales/*.lua',
    'client/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    '@es_extended/locale.lua',
    'config.lua'
}

files {
    'html/index.html',
    'html/styles.css',
    'html/scripts/*.js',
    'html/assets/images/*.png',
    'html/assets/font/BetterYesterday.otf'
}