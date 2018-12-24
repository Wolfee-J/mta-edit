-- Functions --
functions.createObject = function (name,id,x,y,z)
	if getResourceFromName('Objs') then
		if getResourceState ( getResourceFromName('Objs') ) == 'loaded'  then
			startResource(getResourceFromName('Objs'),true)
		end
		-- With Objs Support --
		local object = exports.Objs:JcreateObject(name,x,y,z)
		local id = functions.generateElementID('Object')
		setElementData(object,'mID',id)
		sSecession.Elements[id] = object
		functions.client(client,'setSelected',object)
		functions.sendTableChanges('Elements')
	else
		-- Without Objs Support --
		local object = createObject(id,x,y,z)
		local id = functions.generateElementID('Object')
		setElementData(object,'mID',id)
		sSecession.Elements[id] = object
		functions.client(client,'setSelected',object)
		functions.sendTableChanges('Elements')
	end
end