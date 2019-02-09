-- Tables --
sFunctions.marker = {}
sOrdering.marker = {}

-- Functions --
sFunctions.create.marker = function (marker)
	local x,y,z = getElementPosition(marker)
	local mType = getMarkerType(marker)
	local mSize = getMarkerSize(marker)
	local r,g,b,a = getMarkerColor(marker)
	return 'local element = createMarker('..x..','..y..','..z..','..mType..','..Size..','..r..','..g..','..b..','..a..')'
end

table.insert(sOrdering.marker,'type')
sFunctions.marker.type = function (marker)
	local mType = getMarkerType(marker)
	return mType
end

table.insert(sOrdering.marker,'color')
sFunctions.marker.color = function (marker)
	local r,g,b,a = getMarkerColor(marker)
	return functions.rgb2hex(r,g,b,a)
end

