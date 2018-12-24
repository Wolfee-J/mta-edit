-- Functions --
functions.createEDF = function (name,x,y,z)
	if getResourceFromName('Objs') then
		if getResourceState ( getResourceFromName('Objs') ) == 'loaded'  then
			startResource(getResourceFromName('Objs'),true)
		end
		-- With Objs Support --
		local EDF = exports.Objs:JcreateObject(2995,x,y,z)
		local id = functions.generateElementID('EDF')
		setElementData(EDF,'mID',id)
		sSecession.Elements[id] = EDF
		functions.sendTableChanges('Elements')
		setElementData(EDF,'Edf',name)
		functions.client(client,'setSelected',EDF)
	else
		-- Without Objs Support --
		local EDF = createObject(2995,x,y,z)
		local id = functions.generateElementID('EDF')
		setElementData(EDF,'mID',id)
		sSecession.Elements[id] = EDF
		functions.sendTableChanges('Elements')
		setElementData(EDF,'Edf',name)
		functions.client(client,'setSelected',EDF)
	end
end