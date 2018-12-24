-- Tables --
lSecession.dxEdit = {}

-- Functions --
guiSetInputMode ( 'no_binds_when_editing' )

functions['Edit Box'] = function (arguments,x,y,w,h,side)
	
	local boxColor = arguments[3]
	local textColor = arguments[4]
	local name = arguments[2]
	local noText = arguments[6]
	local limit = arguments[7]
	local text = (lSecession.variables[name] or {''})[1] or ''
	
	if lSecession.dxEdit.selected == name then
		editOnScreen = true
		if noText then
			lSecession[name] = lSecession[name] or guiCreateEdit (x,y,w,h,text,false)
			guiSetPosition (lSecession[name],x,y, false )
		else
			lSecession[name] = lSecession[name] or guiCreateEdit (x+(80*s),y,w-(80*s),h,text,false)
			guiSetPosition (lSecession[name],x+(80*s),y, false )
		end
		if limit then
			guiSetProperty ( lSecession[name] , 'MaxTextLength', limit)
		end
		guiSetAlpha (lSecession[name],0)
		lSecession.variables[name] = {guiGetText(lSecession[name])}
		else
		if isElement(lSecession[name]) then
			destroyElement(lSecession[name])
			lSecession[name] = nil
		end
	end
	
	if not noText then
		dxDrawText (name,x+(10*s),y,x+(80*s),h+y, textColor or tocolor(255,255,255,200), 1, "default-bold",'left','center',nil,nil,true  )
		local eHover = functions.isCursorOnElement(x+(80*s),y,w-(90*s),h,'editbox',name,name )
		dxDrawRectangle(x+(80*s),y+(1*s),w-(85*s),h-(2*s), boxColor or tocolor(255,255,255,150-(eHover*20)), true)
		dxDrawText (text,x+(88*s),y,w+x-(10*s),h+y, textColor or tocolor(0,0,0,200), 1, "default",'left','center',true,nil,true  )
	else
		local eHover = functions.isCursorOnElement(x,y,w,h,'editbox',name,name )
		dxDrawRectangle(x,y,w,h, boxColor or tocolor(255,255,255,150-(eHover*20)), true)
		dxDrawText (text,x+(8*s),y,w+x,h+y, textColor or tocolor(0,0,0,200), 1, "default",'left','center',nil,nil,true  )
	end
	return text
end

functions['Number Box'] = function (arguments,x,y,w,h,boxColor,textColor)
	
	local name = arguments[2]
	local boxColor	= arguments[3]
	local textColor = arguments[4]
	local noText = arguments[6]
	local whole = arguments[7]
	local positive = arguments[8]
	local font = arguments[9] or 'default'
	local scale = arguments[10] or (1*s)
	
	local text = (lSecession.variables[name] or {})[1] or arguments[11]
	
	if lSecession.dxEdit.selected == name then
		editOnScreen = true
		if noText then
			lSecession[name] = lSecession[name] or guiCreateEdit (x,y,w,h,text or '',false)
			guiSetPosition (lSecession[name],x,y, false )
		else
			lSecession[name] = lSecession[name] or guiCreateEdit (x+(80*s),y,w-(80*s),h,text or '',false)
			guiSetPosition (lSecession[name],x+(80*s),y, false )
		end
		guiSetAlpha (lSecession[name],0 )
		
		lSecession.variables[name] = {guiGetText(lSecession[name])}
		else
		if isElement(lSecession[name]) then
			destroyElement(lSecession[name])
			lSecession[name] = nil
		end
	end
	
	lSecession.dxEdit[name] = {numberOnly = true}
	
	if whole then
		local new = math.floor(tonumber(text))
		if not (text == new) then
		functions.changeEdit(name,new)
		end
	end
	
	if positive then
		local new = math.max(tonumber(text),-tonumber(text))
		if not (text == new) then
		functions.changeEdit(name,new)
		end
	end
	
	
	if not noText then
		dxDrawText (name,x+(10*s),y,x+(80*s),h+y, textColor or tocolor(255,255,255,200), 1, "default-bold",'left','center',nil,nil,true )
		local eHover = functions.isCursorOnElement(x+(80*s),y,w-(80*s),h,'editbox',name,name )
		dxDrawRectangle(x+(80*s),y+(1*s),w-(85*s),h-(2*s), boxColor or tocolor(255,255,255,150-(eHover*20)), true)
		dxDrawText (text or '',x+(88*s),y,w+x-(10*s),h+y, textColor or tocolor(0,0,0,200), scale, font,'left','center',true,nil,true  )
	else
		local eHover = functions.isCursorOnElement(x,y,w,h,'editbox',name,name )
		dxDrawRectangle(x,y,w,h, boxColor or tocolor(255,255,255,150-(eHover*20)), true)
		dxDrawText (text or '',x+(8*s),y,w+x,h+y, textColor or tocolor(0,0,0,200), scale, font,'left','center',nil,nil,true  )
	end
	return text
end

functions.editbox = function (name)
	lSecession.dxEdit.selected = name
end


functions.onClick = function ( button,state )
	if ( button == 'left') and state then
		if not (editOnScreen) then
			if functions[lSecession.dxEdit.selected] then
				functions[lSecession.dxEdit.selected](_,_,true)
			end
			lSecession.dxEdit.selected = nil
		end
	end
end
addEventHandler ( "onClientClick", getRootElement(), functions.onClick )

allowedOperators = {}
allowedOperators['-'] = true
allowedOperators['+'] = true
allowedOperators['*'] = true
allowedOperators['/'] = true
allowedOperators['x'] = true
allowedOperators['.'] = true
allowedOperators['^'] = true

functions.solveString = function(input)

	local stg = tostring(input)
	for v in pairs(allowedOperators) do
		local splt = split (stg,v)
		local A = tonumber(splt[1])
		local B = tonumber(splt[2])

		if A and B then
			if v == '+' then
				return tostring(A+B)
			elseif v == '*' then
				return tostring(A*B)
			elseif v == '-' then
				return tostring(A-B)
			elseif v == '/' then
				return tostring(A/B)
			elseif v == '^' then
				return tostring(A^B)
			end
		end
	end
	return input
end

functions.onChange = function ()
	local name = lSecession.dxEdit.selected
	local current = guiGetText(source)
	if lSecession[name] == source then
		if lSecession.dxEdit[name] then
			if lSecession.dxEdit[name].numberOnly then
				local stringc = guiGetText(source)
				local lastEntered = stringc:sub( string.len(stringc), string.len(stringc) )
				if not (tonumber(lastEntered) or allowedOperators[lastEntered]) then
					local tabl = functions.splitString(stringc)
					tabl[string.len(stringc)] = nil 
					local newstring = table.concat(tabl)
					guiSetText(source,newstring)
					lSecession.variables[name] = {newstring}
					if lastEntered == '=' then
						local newstring = functions.solveString(newstring)
						guiSetText(source,newstring)
						lSecession.variables[name] = {newstring}
						if functions[name] then	
							functions[name](guiGetText(source),current,true)
							return
						end
					end
				end
			end
		end
	end
	if functions[name] then	
		functions[name](guiGetText(source),current)
	end
end


functions.changeEdit = function (name,new)
	removeEventHandler("onClientGUIChanged", resourceRoot, functions.onChange)
	if lSecession[name] then
		guiSetText(lSecession[name],new)
	end
	lSecession.variables[name] = {new}
	addEventHandler("onClientGUIChanged", resourceRoot, functions.onChange)
end


addEventHandler("onClientGUIChanged", resourceRoot, functions.onChange)



functions.onClientKey2 = function(key, press)
    if (press) then 
		if key == 'enter' then
			if functions[lSecession.dxEdit.selected] then
				functions[lSecession.dxEdit.selected](_,_,true)
			end
			lSecession.dxEdit.selected = nil
		end
    end
end
addEventHandler("onClientKey", root, functions.onClientKey2)

