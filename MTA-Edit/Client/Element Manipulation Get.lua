-- Functions (mGet) --

mGet.Position = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Position') then
				local x,y,z = unpack(getElementData(element,'Position'))
				return x,y,z
			end
		end
		local x,y,z = getElementPosition(element)
		return x,y,z
	end
	return true
end

mGet.Rotation = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Rotation') then
				local xr,yr,zr = unpack(getElementData(element,'Rotation'))
				return xr,yr,zr
			end
		end
		local xr,yr,zr = getElementRotation(element)
		return xr,yr,zr
	end
	return true
end

mGet.Interior = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Interior') then
				local interior = (getElementData(element,'Interior'))
				return interior
			end
		end
		local interior = getElementInterior(element)
		return interior
	end
	return true
end

mGet.Dimension = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Dimension') then
				local dimension = (getElementData(element,'Dimension'))
				return dimension
			end
		end
		local dimension = getElementDimension(element)
		return dimension
	end
	return true
end

mGet.Frozen = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Frozen') then
				local frozen = (getElementData(element,'Frozen') == 2)
				return frozen
			end
		end
		local frozen = isElementFrozen(element)
		return frozen
	end
	return true
end

mGet.Collidable = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Collidable') then
				local collidable = (getElementData(element,'Collidable') == 2)
				return collidable
			end
		end
		local collidable = getElementCollisionsEnabled(element)
		return collidable
	end
	return true
end

mGet.Alpha = function(element,useElementData)
	if element then
		if useElementData then
			if getElementData(element,'Alpha') then
				local alpha = (getElementData(element,'Alpha'))
				return alpha
			end
		end
		local alpha = getElementAlpha(element)
		return alpha
	end
	return true
end

