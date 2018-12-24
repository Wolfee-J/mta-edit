-- Functions --
functions.updateTransformation = function (element)
	if isElement(element) then
		if getElementData(element,'Position') then
			local x,y,z = unpack(getElementData(element,'Position'))
			element.position = Vector3(x,y,z)
		end
		if getElementData(element,'Rotation') then
			local xr,yr,zr = unpack(getElementData(element,'Rotation'))
			setElementRotation(element,xr,yr,zr)
		end
		if getElementData(element,'Scale') then
			if getElementType(element) == 'object' then
				local xs,ys,zs = unpack(getElementData(element,'Scale'))
				setObjectScale(element,xs,ys,zs)
			end
		end
	end
end