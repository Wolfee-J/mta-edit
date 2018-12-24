--// Client is just generic helpers, keep everything else confined to their own files please // --
--- Tables ---
Cached = {} -- Saved Information (Do not store elements)
vCache = {}
mSet = {} -- Allows easy setting of data, position, ect
mGet = {} -- Allows easy getting of data, position, ect
lSecession = {variables = {},cPicker = {},Selected = {},Descriptions = {}} -- Secession Information
sSecession = {Elements = {}} -- Shared Information (Do not store elements)
functions = {} -- General functions, stored in tables for organizational purposes
mRender = {} -- Functions that are called onClientRender Secound
fRender = {} -- Functions that are called onClientRender First
lRender = {} -- Functions that are called onClientRender Last
preRender = {} -- Functions that are called onClientPreRender

-- Important note about functions ----------------------------------------------------------------------------------------
-- If the function is from a GUI element please use functions['name'] = function () instead of functions.name = function()
-- For readability and organizational purposes this helps identify helper functions from UI functions.
--------------------------------------------------------------------------------------------------------------------------



fadeCamera(true)
setPlayerHudComponentVisible('all',false)

-- lSecession (Local) --
functions.collectSecessionGarbage = function ()
	for i,v in pairs(lSecession) do
		if type(v) == 'Table' then
			if #v == 0 then
				lSecession[i] = nil
			end
		end
	end
end
setTimer ( functions.collectSecessionGarbage, 60000, 0)

-- sSecession (Shared) --
functions.fetchTableChange = function (index,content) -- Receives change(s) from server.
	sSecession[index] = content
end

functions.sendTableChanges = function (index) -- Sends change(s) to server.
	local lTable = sSecession[index] or {}
	functions.server('fetchTableChange',index,lTable) 
end

--- Functions ---
functions.server = function(...) -- Send command to server 'functions.server(function name,arguments)'
	triggerServerEvent ( "server", resourceRoot, ... )
end

functions.client = function(name,...) -- Receive command from server 
		if functions[name] then
		functions[name](...)
	end
end
addEvent( "client", true )
addEventHandler( "client", localPlayer, functions.client )

functions.render = function ()
	functions.guiPrep()
	for i,v in pairs(fRender) do
		v()
	end
	for i,v in pairs(mRender) do
		v()
	end
	functions.drawRightClickMenu()
	for i,v in pairs(lRender) do
		v()
	end
end
addEventHandler ( "onClientRender", root, functions.render )

functions.preRender = function ()
	for i,v in pairs(preRender) do
		v()
	end
end
addEventHandler ( "onClientPreRender", root, functions.preRender )

functions.splitString = function(str)
   if not str or type(str) ~= "string" then return false end

   local splitStr = {}
   for i=1,string.len(str) do
      local char = str:sub( i, i )
      table.insert( splitStr , char )
   end

   return splitStr 
end

functions.setSelected = function(element,noDeselect)
	functions.syncTransformationsC()
	if not noDeselect then
		for index,e in pairs(lSecession.Selected) do
			if element == e then
				table.remove(lSecession.Selected,index)
				setElementData(element,'Selected',nil)
				functions.RemoveElementFromSelection(element)
				if #lSecession.Selected == 0 then 
					lSecession.freeMovement = nil
				end
					functions.prepCustomization()
				return
			end
		end
	end
	table.insert(lSecession.Selected,element)
	setElementData(element,'Selected',true)
	functions.AddElementToSelection(element)
	functions.addUndo({'Position','Rotation','Selected'})
	functions.prepCustomization()
end

functions.isSelected = function(element)
	for i,elements in pairs(lSecession.Selected) do
		if elements == element then
			return true
		end
	end
end

functions.proccessLineOfSite = function (x,y,z,xa,ya,za)
	return processLineOfSight (	x, y, z, xa, ya, za,true,true,false,true,false,false,false,false,false,true)
end

fRender.findHighLightedElement = function()
	if getCameraTarget() == localPlayer then lSecession.highLightedElement = nil return end
	if not isCursorShowing() then
		local xa,ya,za = getWorldFromScreenPosition ( xSize/2, ySize/2, ((lSecession.variables['Depth'] or {})[1] or 200) )
		local x,y,z = getCameraMatrix()
		local hit, x, y, z, element,_,_,_,material,_,_,world,_,_,_,_,_,_,LOD = functions.proccessLineOfSite(x,y,z,xa,ya,za)
		if hit then
			if isElement(element) then
				lSecession.highLightedElement = element
			else
				lSecession.highLightedElement = nil
			end
		else
			lSecession.highLightedElement = nil
		end
	end
end

functions.findHighLightedWorldElement = function()
	if not isCursorShowing() then
		local xa,ya,za = getWorldFromScreenPosition ( xSize/2, ySize/2, ((lSecession.variables['Depth'] or {})[1] or 200) )
		local x,y,z = getCameraMatrix()
		local hit, _,_,_, element,_,_,_,material,_,_,world,x,y,z,_,_,_,LOD = functions.proccessLineOfSite(x,y,z,xa,ya,za)
		if hit then
			if world then
				return world,x,y,z
			end
		end
	end
end

functions.findHoverElement = function()
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local x,y = (x*xSize),(y*ySize)
		local xa,ya,za = getWorldFromScreenPosition ( x, y, lSecession.variables['Depth'][1] )
		local x,y,z = getCameraMatrix()
		local hit, x, y, z, element,_,_,_,material,_,_,world,_,_,_,_,_,_,LOD = functions.proccessLineOfSite(x,y,z,xa,ya,za)
		if hit then
			if isElement(element) then
				return element ,x ,y ,z
			end
		end
	end
end

functions.findHoverElement2 = function()
	if not isCursorShowing() then
		local xa,ya,za = getWorldFromScreenPosition ( xSize/2, ySize/2, lSecession.variables['Depth'][1] )
		local x,y,z = getCameraMatrix()
		local hit, x, y, z, element,_,_,_,material,_,_,world,_,_,_,_,_,_,LOD = functions.proccessLineOfSite(x,y,z,xa,ya,za)
		if hit then
			if isElement(element) then
				return element ,x ,y ,z
			end
		end
	end
end


-- Math (MOVE TO MATH LIB)
functions.findRotation3D = function( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

functions.getDistanceBetweenPointAndSegment3D = function (pointX, pointY, pointZ, x1, y1, z1, x2, y2, z2) --// Credit to IIYAMA // --

	local A = pointX - x1 
	local B = pointY - y1
	local C = pointZ - z1

	local D = x2 - x1
	local E = y2 - y1
	local F = z2 - z1

	local point = A * D + B * E + C * F
	local lenSquare = D * D + E * E + F * F
	local parameter = point / lenSquare
 
	local shortestX
	local shortestY
	local shortestZ
 
	if parameter < 0 then
		shortestX = x1
    	shortestY = y1
		shortestZ = z1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
		shortestZ = z2

	else
		shortestX = x1 + parameter * D
		shortestY = y1 + parameter * E
		shortestZ = z1 + parameter * F
	end

	local distance = getDistanceBetweenPoints3D(pointX, pointY,pointZ, shortestX, shortestY,shortestZ)
 
	return distance
end

functions.getDistanceBetweenPointAndSegment2D = function(pointX, pointY, x1, y1, x2, y2)
	if tonumber(x1) and tonumber(y1) and tonumber(x2) and tonumber(y2) then
	local A = pointX - x1
	local B = pointY - y1
	local C = x2 - x1
	local D = y2 - y1

	local point = A * C + B * D
	local lenSquare = C * C + D * D
	local parameter = point / lenSquare

	local shortestX
	local shortestY

	if parameter < 0 then
		shortestX = x1
				shortestY = y1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
	else
		shortestX = x1 + parameter * C
		shortestY = y1 + parameter * D
	end
		if not (tostring(shortestX) == '-nan(ind)') then
			local distance = getDistanceBetweenPoints2D(pointX, pointY, shortestX, shortestY)

			return distance
		end
	end
	return 100
end

functions.findRotation3D = function( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

functions.findRotation = function( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

ElementTypes = {'object','vehicle','water','vehicle','pickup','marker','colshape'}
Ignore = {skybox_model = true}

functions.getAllElements = function(synced,onScreen)
local tab = {}
	for i,v in pairs(ElementTypes) do
		for ia,va in pairs(getElementsByType(v,root,synced)) do
			if getElementData(va,'mID') then
				if not Ignore[getElementID(va)] then -- // Check map has a skybox, this tends to mess it up.
					if onScreen then
						if isElementOnScreen(va) then
							table.insert(tab,va)
						end
					else
						table.insert(tab,va)
					end
				end
			end
		end
	end
	return tab
end