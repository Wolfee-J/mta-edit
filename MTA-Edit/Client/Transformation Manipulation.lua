-- Functions --

--# addPosition
functions.addSelectedPosition = function(x,y,z,transitionType) -- World, Local
	functions.resetPositionText()
	minDistance = ((tonumber(lSecession.variables['Magnets'][2])) * 2)
	minODistance = 1000
	lSecession.activatedMagnet = {}
		
	for index,element in pairs(lSecession.Selected) do
		if transitionType == 'World' then
			local ex,ey,ez = getElementPosition(element)
			element.position = element.position + Vector3(x,y,z)
		elseif transitionType == 'Local' then
			local newPosition = element.matrix:transformPosition(Vector3(x,y,z))
			element.position = element.matrix:transformPosition(Vector3(x,y,z))
		end
		functions.prepElementMagnets(element)
		functions.checkMagnets(element)
	end
	functions.syncTransformations()
end

--# setPosition
functions.setSelectedPosition = function(x,y,z)
	functions.resetPositionText()
	for index,element in pairs(lSecession.Selected) do
		element.position = Vector3(x,y,z)
	end
	functions.syncTransformations()
end

--# addRotation
functions.addSelectedRotationSmoothly = function(xr,yr,zr,transitionType,change,nonQuaterion) -- World, Local
	functions.resetPositionText()
	if not rotationQue then
		local speed = (xr+yr+zr)/25
		rotationQue = {xr,yr,zr,transitionType,nonQuaterion,speed}
	end
end

functions.getDistance = function (A,B)
	if A > B then
		return A-B
	else
		return B-A
	end
end

mRender.SmoothlyRotate = function ()
	if rotationQue then
		local xr,yr,zr,transitionType,nonQuaterion,speed = unpack(rotationQue)
		if functions.getDistance(xr+yr+zr,0) > 0.1 then
			if (functions.getDistance(xr,0) > 0.1) then
				functions.addSelectedRotation(speed,0,0,transitionType,nonQuaterion)
				rotationQue = {xr-speed,yr,zr,transitionType,nonQuaterion,speed}
			elseif (functions.getDistance(yr,0) > 0.1) then
				functions.addSelectedRotation(0,speed,0,transitionType,nonQuaterion)
				rotationQue = {xr,yr-speed,zr,transitionType,nonQuaterion,speed}
			elseif (functions.getDistance(zr,0) > 0.1) then
				functions.addSelectedRotation(0,0,speed,transitionType,nonQuaterion)
				rotationQue = {xr,yr,zr-speed,transitionType,nonQuaterion,speed}
			end
		else
			rotationQue = nil
		end
	end
end

functions.addSelectedRotation = function(xr,yr,zr,transitionType,nonQuaterion) -- World, Local
	functions.resetPositionText()
	for index,element in pairs(lSecession.Selected) do
		if transitionType == 'Local' then
			ApplyElementRotation(element, xr,yr,zr)
		elseif transitionType == 'World' then
			local x,y,z = functions.getSelectedElementsCenter()
			functions.globalRotation(element,xr,yr,zr,x,y,z,(nonQuaterion))
		end
	end
	functions.syncTransformations()
end

-- # setRotation
functions.setSelectedRotation = function(xr,yr,zr)
	functions.resetPositionText()
	for index,element in pairs(lSecession.Selected) do
		element.rotation = Vector3(xr,yr,zr)
	end
	functions.syncTransformations()
end

--# addScale
functions.addSelectedScale = function(xs,ys,zs) -- World, Local
	for index,element in pairs(lSecession.Selected) do
		if getElementType(element) == 'object' then
			local x,y,z = getObjectScale(element)
			setObjectScale(element,xs+x,ys+y,zs+z)
		end
	end
	functions.syncTransformations()
end

-- # axisRotation
functions.globalRotation = function (element,xr,yr,zr,x,y,z,nonQuaterion) --// Function orignally by MyOnLake
	local vec = Vector3(x,y,z)
	local vec2 = Vector3(xr,yr,zr)

	local matrix = Matrix(vec, vec2)
	local matrix2 = Matrix(matrix:transformPosition(element.position-vec), matrix:getRotation()+element.matrix:getRotation())

    element:setPosition(matrix2:getPosition())
	
	if nonQuaterion and ((#lSecession.Selected) == 1) then
		element:setRotation(matrix2:getRotation())
	else
		ApplyElementRotation(element, xr,yr,zr, true)
	end
end

-- # getSelectedCenter
functions.getSelectedElementsCenter = function()
	elementExists = nil
	for i,v in pairs(lSecession.Selected) do
		if isElement(v) then
			elementExists = true
		end
	end
	if elementExists then
		local maxV = nil
		local minV = nil
		for index,element in pairs(lSecession.Selected) do
			sElement = element
			local x,y,z = getElementPosition(element)
			maxV = maxV or {x,y,z}
			minV = minV or {x,y,z}
			local minx,miny,minz = unpack(minV)
			local maxx,maxy,maxz = unpack(maxV)
			maxV = {math.max(maxx,x),math.max(maxy,y),math.max(maxz,z)}
			minV = {math.min(minx,x),math.min(miny,y),math.min(minz,z)}
		end
			local minx,miny,minz = unpack(minV or {})
			local maxx,maxy,maxz = unpack(maxV or {})
		
		if minx then
			return ((minx+maxx)/2),((miny+maxy)/2),((minz+maxz)/2)
			else
			return 0,0,0
		end
	else
		lSecession.Selected = {}
		return 0,0,0
	end
end

-- # Sync Transformations

functions.syncTransformations = function ()
	if isTimer(sTimer) then
		killTimer(sTimer)
	end
	sTimer = setTimer ( functions.syncTransformationsC, 500, 1 )
end

functions.syncTransformationsC = function ()
	functions.addUndo({'Position','Rotation'})
	for i,element in pairs(lSecession.Selected) do
		local x,y,z = getElementPosition(element)
		functions.getClosestSnap(x,y,z)
		setElementData(element,'Position',{x,y,z})
		local xr,yr,zr = getElementRotation(element)
		setElementData(element,'Rotation',{xr,yr,zr})
		if getElementType(element) == 'object' then
			local xs,ys,zs = getObjectScale(element)
			setElementData(element,'Scale',{xs,ys,zs})
		end
		functions.server('updateTransformation',element)
	end
end

functions.syncITransformationsC = function (element)
	local x,y,z = getElementPosition(element)
	setElementData(element,'Position',{x,y,z})
	local xr,yr,zr = getElementRotation(element)
	setElementData(element,'Rotation',{xr,yr,zr})
	if getElementType(element) == 'object' then
		local xs,ys,zs = getObjectScale(element)
		setElementData(element,'Scale',{xs,ys,zs})
	end
	functions.server('updateTransformation',element)
end





-- Add gimbals and crap.
