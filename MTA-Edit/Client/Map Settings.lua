-- Tables --
lSecession.Modes = {}

-- Basic Settings --



table.insert(menus.right.items['Settings'],{'list','Map Settings'})
menus.right['Settings'].lists['Map Settings'] = {}


table.insert(menus.right['Settings'].lists['Map Settings'],{'Check Box','Show World'})
lSecession.variables['Show World'] = {true}


table.insert(menus.right['Settings'].lists['Map Settings'],{'Option','Map Type',{'.map','.lua','.JSP'}})
lSecession.variables['Map Type'] = lSecession.variables['Map Type'] or {'.map',1}

table.insert(menus.right['Settings'].lists['Map Settings'],{'Edit Box','R-Name'})

functions.checkBoxChangeSWM = function( name,toggle )
	if name == 'Show World' then
		if toggle then
			functions.server('Show SA Map')
		else
			functions.server('Hide SA Map')
		end
	end
end

addEventHandler ( "Check Box Change", root, functions.checkBoxChangeSWM )




-- Meta --
table.insert(menus.right['Settings'].lists['Map Settings'],{'list','Meta'})
menus.right['Settings'].lists['Meta'] = {}


table.insert(menus.right['Settings'].lists['Meta'],{'Edit Box','Name'})
table.insert(menus.right['Settings'].lists['Meta'],{'Edit Box','Description'})
table.insert(menus.right['Settings'].lists['Meta'],{'Edit Box','Author'})
table.insert(menus.right['Settings'].lists['Meta'],{'Number Box','Version'})

-- Game Modes --
table.insert(menus.right['Settings'].lists['Meta'],{'list','Game Modes'})
menus.right['Settings'].lists['Game Modes'] = {}

functions.populateModes = function (list)

menus.right['Settings'].lists['Game Modes'] = {}
lSecession.Modes = {}

	for i,v in pairs(list) do
		table.insert(menus.right['Settings'].lists['Game Modes'],{'Check Box',v})
		lSecession.Modes[v] = true
	end
end
setTimer ( functions.server, 30000, 0, 'List Gamemodes' ) -- Refreshes every 30 secounds.
functions.server('List Gamemodes')

