-- Functions --
functions.copyElement = function(element,x,y,z,children)
	local xA,yA,zA = getElementPosition(element)
	local x,y,z = x or xA,y or yA,z or zA
	local xr,yr,zr = getElementRotation(element)
	local type = getElementType ( element)  
	local data = getAllElementData ( element )
	local id = getElementID(element)
	if type == 'object' then
		local model = getElementModel(element)
		local xs,ys,zs = getObjectScale(element)
		newElement = createObject(model,0,0,0)
		setObjectScale(newElement,xs,ys,zs)
	elseif type == 'ped' then
		local model = getElementModel(element)
		newElement = createPed ( model, 0,0,0)
	elseif type == 'vehicle' then
		local model = getElementModel(element)
		newElement = createVehicle(model,0,0,0)
		local handling = getVehicleHandling (element)
		local color = {getVehicleColor (element, true )}
		local upgrades = getVehicleUpgrades ( element )
		for i,v in pairs(handling) do 
			setVehicleHandling (newElement,i,v) 
		end
		for i,v in pairs(upgrades) do
			addVehicleUpgrade ( newElement,v)
		end
		setVehicleColor(newElement,unpack(color))
	elseif type == 'pickup' then
		local model = getElementModel(element)
		local pType = getPickupType ( element )  
		if pType == 0 then
		local amount = getPickupAmount (element)    
		local respawn = getPickupRespawnInterval (element )
		newElement = createPickup ( 0,0,0, pType,amount,respawn )    
		elseif pType == 1 then
		local amount = getPickupAmount (element)    
		local respawn = getPickupRespawnInterval (element )
		newElement = createPickup ( 0,0,0, pType,amount,respawn )    
		elseif pType == 2 then
		local amount = getPickupAmmo ( element )     
		local respawn = getPickupRespawnInterval (element )
		local weapon = getPickupWeapon (element )     
		newElement = createPickup ( 0,0,0, pType,weapon,respawn,amount )    
		elseif pType == 3 then 
		local respawn = getPickupRespawnInterval (element ) 
		newElement = createPickup ( 0,0,0, pType,model,respawn )    
		end
	end
	setElementID(newElement,id)
	setElementPosition(newElement,x,y,z)
	setElementRotation(newElement,xr,yr,zr)
	local id = functions.generateElementID(type)
		
	for i,v in pairs(data) do
		setElementData(newElement,i,v)
	end
	setElementData(newElement,'mID',id)
	setElementData(newElement,'Selected',false)
end

functions.deleteElement = function (element)
	destroyElement(element)
end
