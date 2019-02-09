-- Functions --
--arguments,x,y,w,h,arguments

functions.rightMenuSelection = function(name)
	rightMenuSelection = name
end

functions['Controls'] = function ()
	Cached.Controls = not Cached.Controls
end

functions['freeCam'] = function ()
	functions['Toggle Freecam']()
end


--#List
functions['list'] = function(arguments,x,y,w,h,side,depth,bounds,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	local arrow = functions.prepImage('arrow')
	local fade = (menus.open[arguments[2]]) and 100 or 0
	if arrow and bounds then
		local hover = functions.isCursorOnElement(x,y,w,h,'lists',arguments[2],arguments[2])
		dxDrawImage(x+(10*s),y+(width/2),width,width,arrow, 180+(menus.open[arguments[2]] and 90 or 0), 0, 0, tocolor(255, 255, 255, (230-(hover*80))*fadePercent),true)	
	end
	if bounds then
		dxDrawText(arguments[2], x+(10*s)+(width*2),y,x+w,y+h, tocolor(255, 255, 255, (220-fade)*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
	if menus.open[arguments[2]] then
		if side == 'rightClick' then
			functions.drawRCList(menus.rightClick.lists[arguments[2]],depth,(x+w+(1*s)),y,fadePercent)
		else
			functions.drawList(menus.right[rightMenuSelection].lists[arguments[2]],depth,fadePercent)
		end
	end
end

functions.lists = function (name)
	menus.open[name] = not menus.open[name]
end

--#Option
functions['Option'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	local arrow = functions.prepImage('arrow')
	local image = functions.prepImage(arguments[2])
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, 200*fadePercent),true)
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, 220*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		else
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s),y,x+w,y+h, tocolor(255, 255, 255, 220*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
	
	
	local left = functions.isCursorOnElement(x+(w/2),y+(width/2),width,width,'options',arguments[2]..'L',arguments[2],arguments[3],-1)
	dxDrawImage(x+(w/2),y+(width/2),width,width,arrow, 0, 0, 0, tocolor(255, 255, 255, (200-(left*60))*fadePercent),true)	
	local right = functions.isCursorOnElement((x+w)-(width*2),y+(width/2),width,width,'options',arguments[2]..'R',arguments[2],arguments[3],1)
	dxDrawImage((x+w)-(width*2),y+(width/2),width,width,arrow, 180, 0, 0, tocolor(255, 255, 255, (200-(right*60))*fadePercent),true)
	lSecession.variables[arguments[2]] = lSecession.variables[arguments[2]] or {arguments[3][1],1}
	local selected = lSecession.variables[arguments[2]][1]
	if selected then
		dxDrawText(functions.fetchTranslation(selected), x+(w/2)+width,y,(x+w)-(width*2),y+h, tocolor(255, 255, 255, 150*fadePercent), 1*s, "arial", "center", "center", false, false, true, false, false)
	end
end

functions.options = function (name,list,direction)
	if lSecession.variables[name] then
		local count = #list
		lSecession.variables[name] = lSecession.variables[name] or {list[1],1}
		local new = (lSecession.variables[name][2])+direction
		if new < 1 then
			lSecession.variables[name] = {list[count],count}
		elseif new > count then
			lSecession.variables[name] = {list[1],1}
		else
			lSecession.variables[name] = {list[new],new}
		end
	end
end

functions.setOption = function(name,list,option)
	for i,v in pairs(list) do
		if v == option then
			lSecession.variables[name] = {v,i}
		end
	end
end


--#Side Option 
functions['Side Option'] = function(arguments,x,y,w,h,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local division = w/(#arguments[3])
	for index,item in pairs(arguments[3]) do
		local image = functions.prepImage(item)
		if image then
			local start = (x+(division*(index))-h*2)
			local hover = functions.isCursorOnElement(start-(division/#arguments[3])-(0.5*s),y+(h/10),division-(3*s),h-(h/5),'soptions',item,arguments[2],item)
			local hover = ((lSecession.variables[arguments[2]] or {})[1] == item) and (-1.6) or hover
			dxDrawRectangle (start-(division/#arguments[3])-(0.5*s),y+(h/10),division-(3*s),h-(h/5), tocolor ( 255, 255, 255, (120-(hover*50))*fadePercent ),true )
			dxDrawImage(start,y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, 200*fadePercent),true)	
		end
	end
end

functions.soptions = function (name,new)
	lSecession.variables[name] = {new}
end

--#Color Picker
functions['Color Picker'] = function (arguments,x,y,w,h,side,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1

	local r,g,b = unpack(lSecession.variables[arguments[2]] or {255,255,255})

	local hover = functions.isCursorOnElement(x+(120*s),y, 80*s,h,'colors',arguments[2],arguments[2] )

	dxDrawRectangle(x+(120*s),y+(1*s), 80*s,h-(2*s), tocolor(r,g,b, (200-(hover*50))*fadePercent),true)

	dxDrawText(functions.fetchTranslation(arguments[2]), x+(20*s), y, x+(239*s), (y+h), tocolor(255, 255, 255, 200*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

functions['colors'] = function(name)
	if (lSecession.cPicker.Open == name) then
		lSecession.cPicker.Open = nil
	else
		lSecession.cPicker.Open = name
		lSecession.cPicker.y = 0
		lSecession.cPicker.x = 0
	end
end
addEvent ( "Color", true )

--#Check Box
functions['Check Box'] = function (arguments,x,y,w,h,side,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1

	local width = (h/1.7)
	local hover = functions.isCursorOnElement(x+(120*s),y+(width/2), width,width,'check',arguments[2],arguments[2],arguments[3] )

	dxDrawRectangle(x+(120*s),y+(h/2)-(width/2), width,width, tocolor(255,255,255, 200-(hover*50)),true)

	local check = functions.prepImage('Check')

	if (lSecession.variables[arguments[2]] or {})[1] then
	dxDrawImage(x+(120*s),y+(h/2)-(width/2), width,width,check, 0, 0, 0, tocolor(0, 0, 0, (200-(hover*20))*fadePercent),true)	
	end

	dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s), y, x+(239*s), (y+h), tocolor(255, 255, 255, 200*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

addEvent ( "Check Box Change", true )
functions['check'] = function(name,toggle)
	lSecession.variables[name] = lSecession.variables[name] or {false}
	lSecession.variables[name][1] = not lSecession.variables[name][1]
	triggerEvent ( 'Check Box Change', resourceRoot, name, lSecession.variables[name][1] )
	if toggle then
		for i,v in pairs(toggle) do
			if v[1] == 'Check Box' then
				if not (v[2] == name) then
					lSecession.variables[v[2]] = {}
				end
			end
		end
	end
end

--#Button
functions['Button'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage(arguments[3] or arguments[2])
	
	local hover = functions.isCursorOnElement(x,y,w,h,'buttons',arguments[2],arguments[3] or arguments[2],arguments[2] )
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*80))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		else
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(5*s),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*100))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
end

functions.buttons = function (tFunction,name)
	if functions[tFunction] then
		functions[tFunction](name)
	end
end

--#Removed World Model
functions['Restore Model'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage('Restore Model')
	
	local hover = functions.isCursorOnElement(x,y,w,h,'rwModel',(arguments[2]..':'..math.floor(arguments[3])..','..math.floor(arguments[3])..','..math.floor(arguments[5])),arguments[2],arguments[3],arguments[3],arguments[5] )
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)
		dxDrawText((arguments[2]..':'..math.floor(arguments[3])..','..math.floor(arguments[3])..','..math.floor(arguments[5])), x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*80))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		else
		dxDrawText((arguments[2]..':'..math.floor(arguments[3])..','..math.floor(arguments[3])..','..math.floor(arguments[5])), x+(5*s),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*100))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
end

functions.rwModel = function (name,x)
	functions.server('Restore World Element',(name..x))
end


--#reBind
functions['reBind'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	if type(arguments[4]) == 'table' then
		local ta = arguments[4]
		for i=1,#ta do
			local image = functions.prepImage(ta[i])
			local hover = functions.isCursorOnElement(x+(h*(i-1))+(h/5),y,h,h,'reBindButton',arguments[4][i],arguments[3],i )
			
			dxDrawImage(x+(h*(i-1))+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)
		end
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(h*(#ta))+(h/1.5),y,x+w,y+h, tocolor(255, 255, 255, (220)*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	else
		local image = functions.prepImage(arguments[4])
		local hover = functions.isCursorOnElement(x+(h/5),y,h,h,'reBindButton',arguments[4],arguments[3] )
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, (220)*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
end

functions.reBindButton = function (bindTable,index)
	if bindChange then return end
	if bindTable then
		if bindTable[1] == 's' then
			bindChange = {binds.sBinds[bindTable[2]],index}
		else
			bindChange = {binds.dBinds[bindTable[2]],index}
		end
	end
end

functions.onKey = function (button,press)
    if press and bindChange then
		if bindChange[1] then
			if bindChange[2] then
				bindChange[1][1][bindChange[2]] = button
			else
				bindChange[1][1] = button
			end
		end
		functions.refreshBinds()
		bindChange = nil
	end
end
	
addEventHandler( "onClientKey", root, functions.onKey)

--#EDF Creation
functions['EDF'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage(arguments[2])
	
	local hover = functions.isCursorOnElement(x,y,w,h,'Place EDF',arguments[2],arguments[2] )
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)	
	end
	
	dxDrawText(arguments[2], x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, 220*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

functions['Place EDF'] = function (edfType)
	local x,y,z = getWorldFromScreenPosition ( xSize/2, ySize/2, lSecession.variables['Depth'][1] )
	functions.server('createEDF',edfType,x,y,z)
end


--#Object Creation
functions['Object'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage('Object')
	
	local hover = functions.isCursorOnElement(x,y,w,h,'Place Object',arguments[3],arguments[2],arguments[3] )
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)	
	end
	
	dxDrawText(arguments[3], x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, 220*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

functions['Place Object'] = function (id,name)
	local x,y,z = getWorldFromScreenPosition ( xSize/2, ySize/2, lSecession.variables['Depth'][1] )
	functions.server('createObject',name,id,x,y,z)
end

--#Vehicle Creation
functions['Create Vehicle'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage('Create Vehicle')
	
	local hover = functions.isCursorOnElement(x,y,w,h,'Place Vehicle',arguments[3],arguments[2],arguments[3] )
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)	
	end
	
	dxDrawText(arguments[3], x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, 220*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

functions['Place Vehicle'] = function (id,name)
	local x,y,z = getWorldFromScreenPosition ( xSize/2, ySize/2, lSecession.variables['Depth'][1] )
	functions.server('createVehicle',name,id,x,y,z)
end
 
--#Favorite

functions.favorite = function (tabl)
	Cached.Favorited = Cached.Favorited or {}
	for i,v in pairs(menus.right[rightMenuSelection].lists['Favorites']) do
		if toJSON(v) == toJSON(tabl) then
			table.remove(menus.right[rightMenuSelection].lists['Favorites'], i)
			Cached.Favorited[tabl[2]] = nil
			return
		end
	end
	table.insert(menus.right[rightMenuSelection].lists['Favorites'],tabl)
	Cached.Favorited[tabl[2]] = true
end

----- EDF 



--#Camera (Special EDF things)
functions['Camera'] = function(arguments,x,y,w,h,side,_,_,fadePercent)
	local fadePercent = tonumber(fadePercent) or 1
	local width = h/2
	
	local image = functions.prepImage('camera')
	
	local hover = functions.isCursorOnElement(x,y,w,h,'setCamera',arguments[2],arguments[2])
	
	if image then
		dxDrawImage(x+(h/5),y,h,h,image, 0, 0, 0, tocolor(255, 255, 255, (200-(hover*50))*fadePercent),true)
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(10*s)+(h*1.2),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*80))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		else
		dxDrawText(functions.fetchTranslation(arguments[2]), x+(5*s),y,x+w,y+h, tocolor(255, 255, 255, (220-(hover*100))*fadePercent), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
end

functions.setCamera = function (name)
	Secession.variables[name] = {getCameraMatrix()}
end




