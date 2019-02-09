-- Tables --
sFunctions.ped = {}
sOrdering.ped = {}

-- Functions --
sFunctions.create.createPed = function (ped)
	local model = getElementModel(ped)
	local x,y,z = getElementPosition(ped)
	local _,_,zr = getElementRotation(ped)

	return 'local element = createPed('..model..','..x..','..y..','..z..','..zr..')'
end

table.insert(sOrdering.ped,'model')
sFunctions.ped.model = function (ped)
	local model = getElementModel(ped)
	return model
end
