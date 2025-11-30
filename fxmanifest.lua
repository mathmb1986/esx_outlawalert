fx_version 'cerulean'
game 'gta5'

description 'ESX Outlaw Alert'

version '2.0.1'


-- NUI
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}