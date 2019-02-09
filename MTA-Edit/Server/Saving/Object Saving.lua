-- Tables --
sFunctions.object = {}
sOrdering.object = {}

-- Functions --
sFunctions.create.object = function (object)
	local model = getElementModel(object)
	local x,y,z = getElementPosition(object)
	local xr,yr,zr = getElementRotation(object)

	return 'local element = createObject('..model..','..x..','..y..','..z..','..xr..','..yr..','..zr..')'
end

table.insert(sOrdering.object,'model')
sFunctions.object.model = function (object)
	local model = getElementModel(object)
	return model
end

table.insert(sOrdering.object,'scaleX')
sFunctions.object.scaleX = function (object)
	local xScale = getObjectScale(object)
	if not (xScale == 1) then
		return xScale
	end
end

table.insert(sOrdering.object,'scaleY')
sFunctions.object.scaleY = function (object)
	local _,yScale = getObjectScale(object)
	if not (yScale == 1) then
		return yScale
	end
end

table.insert(sOrdering.object,'scaleZ')
sFunctions.object.scaleZ = function (object)
	local _,_,zScale = getObjectScale(object)
	if not (zScale == 1) then
		return zScale
	end
end

table.insert(sOrdering.object,'scale')
sFunctions.object.scale = function (object)
	local xScale,yScale,zScale = getObjectScale(object)
	if not ((xScale == 1) and (yScale == 1)  and (zScale == 1)) then
		return xScale..','..yScale..','..zScale,'setObjectScale','.lua'
	end
end
