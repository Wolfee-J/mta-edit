-- Tables --

table.insert(menus.right.items['New Element'],{'list','Removed San Andreas Objects'})
menus.right['New Element'].lists['Removed San Andreas Objects'] = {}


-- Functions --
functions.refreshRemovedModellist = function(removedModels)
	menus.right['New Element'].lists['Removed San Andreas Objects'] = {}
	for i,v in pairs(removedModels) do
		local name,x,y,z = unpack(v)
		table.insert(menus.right['New Element'].lists['Removed San Andreas Objects'],{'Restore Model',name,x,y,z})
	end
end