-- Tables --
sFunctions.blip = {}
sOrdering.blip = {}

-- Functions --

sFunctions.create.blip = function (blip)
	local x,y,z = getElementPosition(blip)
	local icon = getBlipIcon(blip)
	local size = getBlipSize(blip)
	local r,g,b,a = getBlipColor(blip)
	local ordering = getBlipOrdering(blip)
	local visibleDistance = getBlipVisibleDistance(blip)
	
	return 'local element = createVehicle('..x..','..y..','..z..','..icon..','..size..','..r..','..g..','..b..','..a..','..ordering..','..visibleDistance..')'
end

table.insert(sOrdering.blip,'icon')
sFunctions.blip.icon = function (blip)
	local icon = getBlipIcon(blip)
	return icon,'setBlipIcon'
end

table.insert(sOrdering.blip,'color')
sFunctions.blip.color = function (blip)
	local r,g,b,a = getBlipColor(blip)
	return functions.rgb2hex(r,g,b,a),'setBlipColor',nil,r..','..g..','..b..','..a
end

table.insert(sOrdering.blip,'ordering')
sFunctions.blip.ordering = function (blip)
	local ordering = getBlipOrdering(blip)
	return ordering,'setBlipOrdering'
end