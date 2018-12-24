-- Tables --
lSecession.ObjectLists = 
{
'Alpha and Non Collidable',
'Nighttime Objects',
'Beach and Sea',
'buildings',
'Car parts',
'Weapon Models',
'industrial',
'interior objects',
'land masses',
'miscellaneous',
'nature',
'structures',
'transportation',
'Wires and Cables'
}

table.insert(menus.right.items['New Element'],{'list','San Andreas Objects'})
menus.right['New Element'].lists['San Andreas Objects'] = {}

-- Functions --
for i,v in pairs(lSecession.ObjectLists) do
	local File =  fileOpen('lists/Object Lists/'..v..'.list')   
	local Data =  fileRead(File, fileGetSize(File))
	local Proccessed = split(Data,10)
	fileClose (File)
	
	table.insert(menus.right['New Element'].lists['San Andreas Objects'],{'list',v})
	menus.right['New Element'].lists[v] = {}
	
	Parent = nil
	for iA,vA in pairs(Proccessed) do
		if vA:sub( 1, 1 ) == '#' then
				Parent = string.gsub(vA,'#','')
				table.insert(menus.right['New Element'].lists[v],{'list',Parent})
				menus.right['New Element'].lists[Parent] = {}
			else
			local oSplit = split(vA,',')
			if Parent then

				table.insert(menus.right['New Element'].lists[Parent],{'Object',oSplit[1],oSplit[2],split(oSplit[3] or '','#')})
			else

				table.insert(menus.right['New Element'].lists[v],{'Object',oSplit[1],oSplit[2],split(oSplit[3] or '','#')})
			end
		end
	end
end