-- Functions --
functions.getElementDescription = function(element)
	if getElementData(element,'Edf') then
		return (tostring(getElementData(element,'Edf'))..':'..(getElementData(element,'mID') or '')),functions.prepImage(getElementData(element,'Edf'))
	elseif getElementType(element) == 'object' then
		return (tostring(getElementID(element))..':'..(getElementData(element,'mID') or '')),functions.prepImage('Object')
	elseif getElementType(element) == 'vehicle' then
		return (tostring(getVehicleNameFromModel(getElementModel(element)))..':'..(getElementData(element,'mID') or '')),functions.prepImage('Create Vehicle')
	end
end

		
mRender.objectDescriptions = function ()

	local center = (xSize/2)
	
	if (#lSecession.Selected > 0) then
		
		local cleft = center-(152*s)
		local ccenter = center-(50*s)
		local cright = center+(52*s)
		local ctext = center-(205*s)
		
		dxDrawText ( 'Position',ctext, ySize-(77*s), cleft, ySize-(46*s), tocolor ( 255, 255, 255, 150	), 1.02, "arial",'center','center'	 )
		
		X,Y,Z = functions.getSelectedElementsCenter()
		
		functions['Number Box']({nil,'x',tocolor(0, 0, 0, 200),tocolor(255, 100, 100, 255),nil,true,nil,nil,'arial',1*s,math.floor(X*1000)/1000},cleft,ySize-(75*s), 100*s, 24*s,'center')
		functions['Number Box']({nil,'y',tocolor(0, 0, 0, 200),tocolor(100, 255, 100, 255),nil,true,nil,nil,'arial',1*s,math.floor(Y*1000)/1000},ccenter,ySize-(75*s), 100*s, 24*s,'center')
		functions['Number Box']({nil,'z',tocolor(0, 0, 0, 200),tocolor(100, 100, 255, 255),nil,true,nil,nil,'arial',1*s,math.floor(Z*1000)/1000},cright,ySize-(75*s), 100*s, 24*s,'center')
		
		if (#lSecession.Selected == 1) then
			Xr,Yr,Zr = getElementRotation(lSecession.Selected[1])
		else
			Xr,Yr,Zr = 0,0,0
		end
			
		if Xr and Yr and Zr then
			dxDrawText ( 'Rotation',ctext, ySize-(50*s), cleft, ySize-(20*s), tocolor ( 255, 255, 255, 150 ), 1.02, "arial",'center','center'	)
			functions['Number Box']({nil,'xr',tocolor(0, 0, 0, 200),tocolor(255, 100, 100, 255),nil,true,nil,nil,'arial',1*s,math.floor(Xr*1000)/1000},cleft,ySize-(50*s), 100*s, 24*s,'center')
			functions['Number Box']({nil,'yr',tocolor(0, 0, 0, 200),tocolor(100, 255, 100, 255),nil,true,nil,nil,'arial',1*s,math.floor(Yr*1000)/1000},ccenter,ySize-(50*s), 100*s, 24*s,'center')
			functions['Number Box']({nil,'zr',tocolor(0, 0, 0, 200),tocolor(100, 100, 255, 255),nil,true,nil,nil,'arial',1*s,math.floor(Zr*1000)/1000},cright,ySize-(50*s), 100*s, 24*s,'center')
		end
			
		if lSecession.freeMovement then
			dxDrawText ( 'Free Move Enabled',center, ySize-(114*s), center, ySize-(104*s), tocolor ( 255, 0, 0, 150	), 1.02, "arial",'center','center'	 )
		end
		
	end
	
	local element = lSecession.highLightedElement or lSecession.Selected[1]
	
	if element then
		local text,image = functions.getElementDescription(element)
					
		dxDrawText ( text,center, ySize-(104*s), center, ySize-(80*s), tocolor ( 255, 255, 255, 150	), 1.02, "arial",'center','center'	 )
		if image then
			dxDrawImage(center-(150*s),ySize-(106*s), 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 150), true)
			dxDrawImage(center+(120*s),ySize-(106*s), 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 150), true)
		end
	end
end

functions['x'] = function (_,_,value)
	local x = (lSecession.variables['x'] or {})[1]
	if x and value then
		local difference = x-X
		functions.addSelectedPosition (difference,0,0,lSecession.variables['Move Type'][1])
	end
end

functions['y'] = function (_,_,value)
	local y = (lSecession.variables['y'] or {})[1]
	if y and value then
		local difference = y-Y
		functions.addSelectedPosition (0,difference,0,lSecession.variables['Move Type'][1])
	end
end

functions['z'] = function (_,_,value)
	local z = (lSecession.variables['z'] or {})[1]
	if z and value then
		local difference = z-Z
		functions.addSelectedPosition (0,0,difference,lSecession.variables['Move Type'][1])
	end
end

functions['xr'] = function (_,_,value)
	local xr = (lSecession.variables['xr'] or {})[1]
	if xr and value then
		local difference = xr-Xr
		functions.addSelectedRotation (difference,0,0,lSecession.variables['Move Type'][1],true)
	end
end

functions['yr'] = function (_,_,value)
	local yr = (lSecession.variables['yr'] or {})[1]
	if yr and value then
		local difference = yr-Yr
		functions.addSelectedRotation (0,difference,0,lSecession.variables['Move Type'][1],true)
	end
end

functions['zr'] = function (_,_,value)
	local zr = (lSecession.variables['zr'] or {})[1]
	if zr then
		local difference = zr-Zr
		functions.addSelectedRotation (0,0,difference,lSecession.variables['Move Type'][1],true)
	end
end




functions.resetPositionText = function ()
	lSecession.variables['x'] = nil
	lSecession.variables['y'] = nil
	lSecession.variables['z'] = nil
	lSecession.variables['xr'] = nil
	lSecession.variables['yr'] = nil
	lSecession.variables['zr'] = nil
end


mRender.selectedObjects = function ()
	selectedObjectHover = nil
	local yStart = ySize-(25*(#lSecession.Selected+1.5))*s
	noAdditonal = false
	for i,v in pairs(lSecession.Selected) do 
		local y = (yStart) + ((25)*i)*s
		
		local text,image = functions.getElementDescription(v)
	
		dxDrawRectangle (xSize-(270*s),y,250*s,24*s, tocolor ( 0, 0, 0, 150 ),true )
		
		dxDrawText ( text,(xSize-(240*s)),y,(xSize-(270*s))+(250*s),y+(24*s), tocolor ( 255, 255, 255, 150	), 1.02, "arial",'left','center'	 )
		if image then
			
			local hover = functions.isCursorOnElement(xSize-(270*s),y, 24*s, 24*s,'setSelected',v,v )
			if hover>0 then
				selectedObjectHover = v
			end
			
			if lSecession.highLightedElement == v then
				noAdditonal = true
				dxDrawImage(xSize-(270*s),y, 24*s, 24*s,image, 0, 0, 0, tocolor(100, 100, 255, 150-(hover*50)), true)
			else
				dxDrawImage(xSize-(270*s),y, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 100, 100, 150-(hover*50)), true)
			end
		end
	end
	if (not noAdditonal) and lSecession.highLightedElement then
		local y = (yStart)
		
		local text,image = functions.getElementDescription(lSecession.highLightedElement)
	
		dxDrawRectangle (xSize-(270*s),y,250*s,24*s, tocolor ( 0, 0, 0, 150 ),true )
		
		dxDrawText ( text,(xSize-(240*s)),y,(xSize-(270*s))+(250*s),y+(24*s), tocolor ( 255, 255, 255, 150	), 1.02, "arial",'left','center')
		
		local hover = functions.isCursorOnElement(xSize-(270*s),y, 24*s, 24*s,'setSelected',lSecession.highLightedElement,lSecession.highLightedElement )
		if hover>0 then
			selectedObjectHover = lSecession.highLightedElement
		end
			
		if image then
			dxDrawImage(xSize-(270*s),y, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 200, 100, 150-(hover*50)), true)
		end
	end
end
