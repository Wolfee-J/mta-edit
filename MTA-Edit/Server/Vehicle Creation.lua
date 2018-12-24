-- Functions --
functions.createVehicle = function (name,id,x,y,z)
	--[[ << TBA vehicle streamer system (Will allow for modifying wheel.dat and streaming new vehicles on the go) >>
	if getResourceFromName('MTAStream') then
		if getResourceState ( getResourceFromName('MTAStream') ) == 'loaded'  then
			startResource(getResourceFromName('MTAStream'))
		end
		-- With MTAStream Support --
		local vehicle = exports.MTAStream:JcreateVehicle(name,x,y,z)
		local id = functions.generateElementID('Vehicle')
		setElementData(vehicle,'mID',id)
		sSecession.MTAStream[id] = vehicle
		functions.client(client,'setSelected',vehicle)
		functions.sendTableChanges('MTAStream')
		functions.sendTableChanges('Selected')
	else
		-- Without MTAStream Support --
	]]--
		local vehicle = createVehicle(id,x,y,z)
		setElementFrozen(vehicle,true)
		local id = functions.generateElementID('Vehicle')
		setElementData(vehicle,'mID',id)
		sSecession.Elements[id] = vehicle
		functions.client(client,'setSelected',vehicle)
		functions.sendTableChanges('Elements')
		functions.sendTableChanges('Selected')
	--end
end