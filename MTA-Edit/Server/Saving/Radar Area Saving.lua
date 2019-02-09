-- Tables --
sFunctions.radararea = {}
sOrdering.radararea = {}

-- Functions --

sFunctions.create.radararea = function (radararea)
	local x,y,z = getElementPosition(radararea)
	local sizeX,sizeY = getRadarAreaSize(radararea)
	local r,g,b,a = getRadarAreaColor(radararea)

	return 'local element = createRadarArea('..model..','..x..','..y..','..z..','..sizeX..','..sizeY..','..r..','..g..','..b..','..a..')'
end

table.insert(sOrdering.radararea,'sizeX')
sFunctions.radararea.sizeX = function (radararea)
	local sX = getRadarAreaSize(radararea)
	return sX
end

table.insert(sOrdering.radararea,'sizeY')
sFunctions.radararea.sizeY = function (radararea)
	local _,sY = getRadarAreaSize(radararea)
	return sY
end

table.insert(sOrdering.radararea,'color')
sFunctions.radararea.color = function (radararea)
	local r,g,b,a = getRadarAreaColor(radararea)
	return functions.rgb2hex(r,g,b,a)
end

