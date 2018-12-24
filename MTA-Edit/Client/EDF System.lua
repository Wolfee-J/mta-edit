-- Tables --
table.insert(menus.right.items['New Element'],{'list','EDF Elements'})
lSecession.EDFSettings = {}

-- Functions --
functions.populateEDF = function (list)
menus.right['New Element'].lists['EDF Elements'] = {}
	for i,gamemode in pairs(list) do
		table.insert(menus.right['New Element'].lists['EDF Elements'],{'list',i})
		menus.right['New Element'].lists[i] = {}
		for index,v in pairs(gamemode) do		
			table.insert(menus.right['New Element'].lists[i],{'EDF',v[1],v[2]})
		end
	end
end

functions.getGameModes = function ()
	local list = {}
	for i,v in pairs(lSecession.Modes) do
		list[i] = (lSecession.variables[i] or {})[1]
	end
	return list
end

functions.refreshEDF = function ()
	local modes = functions.getGameModes()
	functions.server('List EDF',modes)
end


setTimer ( functions.refreshEDF, 10000, 0) -- Refreshes every 10 secounds.
functions.refreshEDF()


functions.onCheckChange = function ( check )
	if lSecession.Modes[check] then
		functions.refreshEDF()
	end
end

addEventHandler ( "Check Box Change", resourceRoot, functions.onCheckChange )


mRender.drawEDF = function()
	for i,v in pairs(getElementsByType('object')) do
		if getElementData(v,'Edf') then
			local x,y,z = getElementPosition(v)
			dxDrawMaterialLine3D(x,y,z+1.5,x,y,z+0.5,functions.prepImage(getElementData(v,'Edf')),1,tocolor(255,255,255,200))
		end
	end
end

functions.populateEDFSettings = function(sTable)
	lSecession.EDFSettings = {}
	for i,v in pairs(sTable) do
		lSecession.EDFSettings[i] = v
	end
end

functions.getEDFSettings = function()
	local settings = {}
	for i,v in pairs(lSecession.Selected) do
		if getElementData(v,'Edf') then
			settings[getElementData(v,'Edf')] = lSecession.EDFSettings[getElementData(v,'Edf')]
		end
	end
	return settings
end





