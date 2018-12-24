-- Tables --
lSecession.VehicleLists = 
{'Motorbikes',
'Helicopters',
'4-Door',
'Emergency',
'Planes, Jets and Airlines',
'Trains',
'Boats',
'Lowriders',
'Trailers',
'SUVs and Wagons',
'Industrial',
'Other',
'Trucks',
'2-Door',
'Bicycles',
'Vans',
'RC Vehicles',
'Sports Cars'
}

table.insert(menus.right.items['New Element'],{'list','Vehicles'})
menus.right['New Element'].lists['Vehicles'] = {}

-- Functions --
for i,v in pairs(lSecession.VehicleLists) do
	local File =  fileOpen('lists/Vehicle Lists/'..v..'.list')   
	local Data =  fileRead(File, fileGetSize(File))
	local Proccessed = split(Data,10)
	fileClose (File)

	table.insert(menus.right['New Element'].lists['Vehicles'],{'list',v})
	menus.right['New Element'].lists[v] = {}
	
	for iA,vA in pairs(Proccessed) do
		local Ssplit = split(vA,',')
		table.insert(menus.right['New Element'].lists[v],{'Create Vehicle',Ssplit[1],Ssplit[2]})
	end
end