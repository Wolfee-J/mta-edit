-- Tables --
sFunctions = {} -- Saving functions
sFunctions.generic = {}
sFunctions.create = {}
sOrdering = {}
sOrdering.generic = {}

-- Functions --
table.insert(sOrdering.generic,'posX')
sFunctions.generic.posX = function (element)
	local x = getElementPosition(element)
	if not (x == 0) then
		return x
	end
end

table.insert(sOrdering.generic,'posY')
sFunctions.generic.posY = function (element)
	local _,y = getElementPosition(element)
	if not (y == 0) then
		return y
	end
end

table.insert(sOrdering.generic,'posZ')
sFunctions.generic.posZ = function (element)
	local _,_,z = getElementPosition(element)
	if not (z == 0) then
		return z
	end
end

table.insert(sOrdering.generic,'rotX')
sFunctions.generic.rotX = function (element)
	local xr = getElementRotation(element)
	if not (xr == 0) then
		return xr
	end
end

table.insert(sOrdering.generic,'rotY')
sFunctions.generic.rotY = function (element)
	local _,yr = getElementRotation(element)
	if not (yr == 0) then
		return yr
	end
end

table.insert(sOrdering.generic,'rotZ')
sFunctions.generic.rotZ = function (element)
	local _,_,zr = getElementRotation(element)
	if not (zr == 0) then
		return zr
	end
end

table.insert(sOrdering.generic,'interior')
sFunctions.generic.interior = function (element)
	local interior = getElementInterior(element)
	if not (interior == 0) then
		return interior,'setElementInterior'
	end
end

table.insert(sOrdering.generic,'dimension')
sFunctions.generic.dimension = function (element)
	local dimension = getElementDimension(element)
	if not (dimension == 0) then
		return dimension,'setElementDimension'
	end
end

table.insert(sOrdering.generic,'frozen')
sFunctions.generic.frozen = function (element)
	local frozen = isElementFrozen(element)
	if frozen then
		return tostring(frozen),'setElementFrozen'
	end
end

table.insert(sOrdering.generic,'collisions')
sFunctions.generic.collisions = function (element)
	local collidable = getElementCollisionsEnabled(element)
	if not collidable then
		return tostring(collidable),'setElementCollisionsEnabled'
	end
end

table.insert(sOrdering.generic,'alpha')
sFunctions.generic.alpha = function (element)
	local alpha = getElementAlpha(element)
	if not (alpha == 255) then
		return tostring(alpha),'setElementAlpha'
	end
end