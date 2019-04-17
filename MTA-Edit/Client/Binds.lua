-- Tables --
binds = {}
binds.sBinds = {} -- Static binds (You click and it executes once)
binds.dBinds = {} -- Dynamic binds (You click and it executes as you hold the key)
binds.toggled = {}
binds.xSize = {}
bindTypes = {'sBinds','dBinds'}

binds.settings = {}
binds.settings.size = 28
binds.settings.boarder = 16
binds.settings.start = (menus.settings.height+1)*(#menus.left.items+1)

-- Generic Functions --
functions.shouldShow = function (input)
	if functions[input] then
		return functions[input]()
	end
	return not (input == 1)
end

functions.staticBind = function (bind,func,tabl)
	if (isConsoleActive () or guiGetInputEnabled ( ) or isChatBoxInputActive() or bindChange) then return end
	if getKeyState(bind) then
		if not binds.toggled[bind] then
			if functions[func] then
				functions[func](bind,tabl)
			end
			binds.toggled[bind] = true
		end
	else
		binds.toggled[bind] = nil
	end
end

functions.dynamicBind = function (bind,func)
	if (isConsoleActive () or guiGetInputEnabled ( ) or isChatBoxInputActive() or bindChange) then return end
	if getKeyState(bind) then
		if functions[func] then
			functions[func](bind)
		end
	end
end

binds.totalxSize = 0

mRender.bindList = function ()
	if not Cached.Controls then
		-- binds.settings.boundsSize
		binds.NewtotalxSize = 0
		local size = binds.settings.size
		local xStart = (binds.settings.boarder*s)+(5*s)
		local yStart = (binds.settings.start*s)
		bIndex = 0
		for gIndex,bindType in pairs(bindTypes) do
			for index,bind in pairs(binds[bindType]) do
				bIndex = bIndex + 1
				--local index = (gIndex>1) and (#binds[bindTypes[1]]+index) or index
				local y = yStart + ((size+2.5)*bIndex)*s
				if functions.shouldShow(bind[3]) then
					dxDrawRectangle (binds.settings.boarder*s,y-(1*s),binds.totalxSize,(size+2)*s, tocolor ( 0, 0, 0, 150 ),true )
					binds.xSize[bIndex] = xStart - (2*s)
					if type(bind[1]) == 'table' then
						for indexa,key in pairs(bind[1]) do
							local image = functions.prepImage(key)
							local xS = ((functions.getImageSize(key)[1]/162)*size)*s
							local yS = ((functions.getImageSize(key)[2]/179)*size)*s
							dxDrawImage(binds.xSize[bIndex], y, xS, yS,image, 0, 0, 0, tocolor(240, 240, 240, 220-(getKeyState(key) and 30 or 0)), true)
							binds.xSize[bIndex] = binds.xSize[bIndex] + xS + (2*s)
							if bindType == 'sBinds' then
								functions.staticBind(key,bind[2],bind)
							else
								functions.dynamicBind(key,bind[2],bind)
							end
						end
					else
						local image = functions.prepImage(bind[1])
						local xS = ((functions.getImageSize(bind[1])[1]/162)*size)*s
						local yS = ((functions.getImageSize(bind[1])[2]/179)*size)*s
						dxDrawImage(binds.xSize[bIndex], y, xS, yS,image, 0, 0, 0, tocolor(240, 240, 240, 220-(getKeyState(bind[1]) and 30 or 0)), true)
						binds.xSize[bIndex] = binds.xSize[bIndex] + xS + (2*s)
						if bindType == 'sBinds' then
							functions.staticBind(bind[1],bind[2])
						else
							functions.dynamicBind(bind[1],bind[2])
						end
					end
					local count = ((type(bind[1]) == 'table') and #bind[1]) or 1
					local x = binds.xSize[bIndex]+(2*s)
					dxDrawText(functions.fetchTranslation(bind[2]),x,y,x,(y+(size*s)), tocolor(255, 255, 255, 220), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
					local width = dxGetTextWidth (bind[2],1.00*s, "default-bold")
					binds.NewtotalxSize = math.max((binds.NewtotalxSize),x+width)
				else
					bIndex = bIndex - 1
				end
			end
		end
	end
	binds.totalxSize = binds.NewtotalxSize
end

functions.onClientKey = function(key, press)
    if (press) and menuHover then 
        if key == 'mouse_wheel_up' then
			scroll = scroll - 5*s
		elseif key == 'mouse_wheel_down' then
			scroll = scroll + 5*s
		end
    end
end
addEventHandler("onClientKey", root, functions.onClientKey)

-- Functions --

functions.getHighLighted = function ()
	return lSecession.highLightedElement
end

functions.getSelectedOrHighlighted = function ()
	return lSecession.highLightedElement or (#lSecession.Selected > 0)
end

functions.getSelectedandGridEnabled = function()
	return ((#lSecession.Selected > 0) and (lSecession.variables['Grid'][2] > 1))
end

functions.getSelected = function ()
	return (#lSecession.Selected > 0)
end

functions.oneSelected = function ()
	return (#lSecession.Selected == 1)
end

functions.worldHighlighted = function ()
	return functions.findHighLightedWorldElement()
end


functions['Select Element'] = function ()
	if not isCursorShowing() then
		functions.setSelected(lSecession.highLightedElement)
	end
end
table.insert(binds.sBinds,{'mouse1','Select Element','getHighLighted'})


functions['Toggle Cursor'] = function ()
	showCursor(not isCursorShowing())
	if isCursorShowing() then
		functions.sendNotification('Cursor Enabled')
	else
		functions.sendNotification('Cursor Disabled')
	end
end
table.insert(binds.sBinds,{'q','Toggle Cursor'})

functions['Toggle Freecam'] = function ()
	Cached.freeCam = not Cached.freeCam
	if Cached.freeCam then
		local x,y,z,xa,ya,za = getCameraMatrix()
		setFreecamEnabled(x,y,z,xa,ya,za)
		setElementPosition(localPlayer,1000,100,100)
		setElementFrozen(localPlayer,true)
		functions.sendNotification('Freecam Enabled')
	else
		lSecession.freeMovement = nil
		local x,y,z = getCameraMatrix()
		setFreecamDisabled()
		setElementPosition(localPlayer,x,y,z)
		setCameraTarget(localPlayer)
		setElementFrozen(localPlayer,false)
		functions.sendNotification('Freecam Disabled')
	end
end
table.insert(binds.sBinds,{'e','Toggle Freecam'})

functions['Change Freecam Speed'] = function ()
	local list = menus.left.items[1][3]
	local new = lSecession.variables['Speed'][2]+1
	if new > #list then
		lSecession.variables['Speed'] = {list[1],1}
	else
		lSecession.variables['Speed'] = {list[new],new}
	end
	functions.sendNotification('Freecam speed set to '..list[1]..'.')
end
table.insert(binds.sBinds,{'f','Change Freecam Speed'})

functions['Toggle Freemove'] = function ()
	if Cached.freeCam then
		lSecession.freeMovement = not lSecession.freeMovement
		
		if not lSecession.freeMovement then
			functions.activateMagnets()
			functions.sendNotification('Freemove Enabled')
		else
			functions.sendNotification('Freemove Enabled')
		end
	end
end
table.insert(binds.sBinds,{'space','Toggle Freemove','getSelected'})

functions['Copy Selected'] = function (key,tabl)
	if (tabl and getKeyState(tabl[1][2])) or (not tabl) then
		if (tabl and getKeyState(tabl[1][1])) then
			local element,x,y,z = functions.findHoverElement2()
			if element then
				local vector = functions.getAlignment(element,x,y,z)
				functions.server('copyElement',element,vector.x,vector.y,vector.z)
			end
		else
			for i,element in pairs(lSecession.Selected) do
				functions.server('copyElement',element)
			end
		end
	end
end
table.insert(binds.sBinds,{{'lshift','c'},'Copy Selected','getSelectedOrHighlighted'})


functions['Toggle Magnets'] = function ()
	lSecession.eMagnets = not lSecession.eMagnets
	if lSecession.eMagnets then
		functions.sendNotification('Magnets Enabled')
	else	
		functions.sendNotification('Magnets Disabled')
	end
end
table.insert(binds.sBinds,{'m','Toggle Magnets','getSelected'})

functions['Delete Selected'] = function ()
	local tabl = {}
	for i,element in pairs(lSecession.Selected) do
		table.insert(tabl,element)
	end
	for i,element in pairs(tabl) do
		functions.setSelected(element)
		functions.server('deleteElement',element)
	end
	tabl = nil
	lSecession.Selected = {}
	lSecession.highLightedElement = nil
end
table.insert(binds.sBinds,{'delete','Delete Selected','getSelected'})

functions['Move Element'] = function (key)
	functions.proccessBindPosition(key)
end
table.insert(binds.dBinds,{{'arrow_u','arrow_d','arrow_l','arrow_r'},'Move Element','getSelected'})

functions['Snap to Grid'] = function (key)
	local x,y,z = functions.getSelectedElementsCenter()
	local newx,newy,newz,change = functions.getClosestSnap (x,y,z)
	if not(((x-newx)+(y-newy)+(z-newz)) == 0) then
		local changex,changey,changez= (newx-x),(newy-y),(newz-z)
		functions.addSelectedPosition(changex,changey,changez,'World')
		functions.sendNotification('Selected elements snapped to grid.')
		return
	end
end
table.insert(binds.dBinds,{'g','Snap to Grid','getSelectedandGridEnabled'})

functions['Delete World Element'] = function (key)
	functions.proccessBindPosition(key)
end
table.insert(binds.sBinds,{'2','Delete World','worldHighlighted'})

functions['Delete World'] = function()
	local id,x,y,z = functions.findHighLightedWorldElement()
	functions.server('Remove World Element',id,x,y,z)
end
