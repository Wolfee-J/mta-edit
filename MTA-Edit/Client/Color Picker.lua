-- Tables --
HexChart = {A=true,B=true,C=true,D=true,F=true}

-- Helper Functions --
functions.hex2rgb = function(hex)
	if string.len(hex) == 7 then
		local hex = hex:gsub("#","")
		if(string.len(hex) == 3) then
			return tonumber("0x"..hex:sub(1,1)) * 17, tonumber("0x"..hex:sub(2,2)) * 17, tonumber("0x"..hex:sub(3,3)) * 17
		elseif(string.len(hex) == 6) then
			return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
		end
	end
end

functions.rgb2hex = function(r,g,b)
	local r = r or 0
	local g = g or 0
	local b = b or 0
	
	local hex_table = {[10] = 'A',[11] = 'B',[12] = 'C',[13] = 'D',[14] = 'E',[15] = 'F'}

	local r1 = math.floor(r / 16)
	local r2 = r - (16 * r1)
	local g1 = math.floor(g / 16)
	local g2 = g - (16 * g1)
	local b1 = math.floor(b / 16)
	local b2 = b - (16 * b1)

	if r1 > 9 then r1 = hex_table[r1] end
	if r2 > 9 then r2 = hex_table[r2] end
	if g1 > 9 then g1 = hex_table[g1] end
	if g2 > 9 then g2 = hex_table[g2] end
	if b1 > 9 then b1 = hex_table[b1] end
	if b2 > 9 then b2 = hex_table[b2] end

	if r1 and r2 and g1 and g2 and b1 and b2 then
		return "#" .. r1 .. r2 .. g1 .. g2 .. b1 .. b2
	end
end

functions.R = function (input,old)
	if tonumber(input) then
		local fix = math.min(input,255)
		functions.changeEdit('R',fix)
		functions.colorPickerEdit()
	else
		functions.changeEdit('R',old)
	end
end

functions.G = function (input,old)
	if tonumber(input) then
		local fix = math.floor(math.max(math.min(input,255),0))
		functions.changeEdit('G',fix)
		functions.colorPickerEdit()
	else
		functions.changeEdit('G',old)
	end
end

functions.B = function (input,old)
	if tonumber(input) then
		local fix = math.floor(math.max(math.min(input,255),0))
		functions.changeEdit('B',fix)
		functions.colorPickerEdit()
	else
		functions.changeEdit('B',old)
	end
end

functions.colorPickerEdit = function()
	local r,g,b = lSecession.variables['R'][1], lSecession.variables['G'][1], lSecession.variables['B'][1]
	lSecession.variables[lSecession.cPicker.Open][1] = r
	lSecession.variables[lSecession.cPicker.Open][2] = g
	lSecession.variables[lSecession.cPicker.Open][3] = b
	local hex = functions.rgb2hex(r,g,b)
	lSecession.variables[lSecession.cPicker.Open][7] = hex
end


mRender.colorPicker = function ()
	if lSecession.cPicker.Open then
		local cPname = lSecession.cPicker.Open
		
		lSecession.cPicker.start = (xSize-(550*s))
		
		local xa,ya = lSecession.cPicker.x,lSecession.cPicker.y

		local start = lSecession.cPicker.start
		
		lSecession.variables[cPname] = lSecession.variables[cPname] or {255,255,255,nil,nil,nil,'#FFFFFF',true,255,255,255}

		local r,g,b,x,y,slider,hex,_,cr,cg,cb = unpack(lSecession.variables[cPname])
		local arrow = lSecession.cPicker.arrow
		local cParrow = functions.isCursorOnElement(xa+start+(256*s), ya+39*s, 12*s, 12*s,'cpicker','Arrow','Arrow')
		local cPclose = functions.isCursorOnElement(xa+start+(277*s), ya+39*s, 12*s, 12*s,'cpicker','Close','Close')

		dxDrawRectangle(xa+start, ya+33*s,304*s, 24*s, tocolor(45, 45, 45, 150), false)
		dxDrawText(functions.fetchTranslation(cPname), xa+start+(10*s), ya+33*s, xa+start+(304*s), ya+57*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, true, false, false, false)
		dxDrawImage(xa+start+(256*s), ya+39*s, 12*s, 12*s,functions.prepImage('arrow'), arrow and -90 or 0, 0, 0, tocolor(255, 255, 255,200-(cParrow*50)), true)
		dxDrawImage(xa+start+(277*s), ya+39*s, 12*s, 12*s,functions.prepImage('close'), 0, 0, 0, tocolor(255, 255, 255,200-(cPclose*50)), true)

		
		if not arrow then

			dxDrawRectangle(xa+start, ya+58*s, 304*s, 202*s, tocolor(0, 0, 0, 141), false)
			

			--[[
			##Maybe do hex editing in the future, to much work to complete before beta. (Needs it's own edit box)
			lSecession.variables['Hex'] = lSecession.variables['Hex'] or {hex}
			functions['Number Box']({nil,'Hex',nil,nil,6,true},start+(236)*s, 222*s, 61*s, 24*s)
			]]--
			dxDrawRectangle(xa+start+(236)*s, ya+222*s, (61*s), (24*s), tocolor(255,255,255,200), false)
			dxDrawText (hex,xa+(start+(239)*s),ya+222*s,xa+(61*s)+start+(236)*s,ya+(24*s)+(222*s), tocolor(0,0,0,200), 1, "default",'left','center' )
		
			lSecession.variables['R'] = lSecession.variables['R'] or {math.floor(r)}
			functions['Number Box']({nil,'R',nil,nil,6,true},xa+start+(234*s), ya+62*s, 61*s, 24*s)
			lSecession.variables['G'] = lSecession.variables['G'] or {math.floor(g)}
			functions['Number Box']({nil,'G',nil,nil,6,true},xa+start+(234*s), ya+92*s, 61*s, 24*s)
			lSecession.variables['B'] = lSecession.variables['B'] or {math.floor(b)}
			functions['Number Box']({nil,'B',nil,nil,6,true},xa+start+(234*s), ya+122*s, 61*s, 24*s)
			
			dxDrawRectangle(xa+start+(234*s), ya+152*s, 61*s, 24*s, tocolor(r,g,b, 255), false)

			sv = functions.prepImage('sv')
			dxDrawRectangle(xa+start+(5*s), ya+63*s, 193*s, 193*s, tocolor(cr,cg,cb,200), false)
			dxDrawImage(xa+start+(5*s), ya+63*s, 193*s, 193*s, sv, 0, 0, 0, tocolor(255, 255, 255, 255), true)

			h = functions.prepImage('hv')
			dxDrawImage(xa+start+(201*s), ya+62*s, 25*s, 194*s, h, 0, 0, 0, tocolor(255, 255, 255, 255), true)
			if slider then
				dxDrawImage(xa+start+(196*s), ya+slider-(6.25*s), 35*s, 12.5*s,functions.prepImage('cursor'), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end
			if x then
				dxDrawImage(xa+x-(6.25*s),ya+y-(6.25*s), 12.5*s, 12.5*s,functions.prepImage('cursor2'), 0, 0, 0, tocolor(255, 255, 255, 255), true)
			end
		end
		else
		lSecession.variables['R'] = nil
		lSecession.variables['G'] = nil
		lSecession.variables['B'] = nil
		if (lSecession.dxEdit.selected == 'R') or (lSecession.dxEdit.selected == 'B') or (lSecession.dxEdit.selected == 'C') then
			destroyElement(lSecession['R'] or lSecession['B'] or lSecession['G'])
			lSecession['R'] = nil
			lSecession['B'] = nil
			lSecession['G'] = nil
			lSecession.dxEdit.selected = nil
		end
	end
end

functions.cpicker = function(name)
	if name == 'Arrow' then
		lSecession.cPicker.arrow = not lSecession.cPicker.arrow
	elseif name == 'Close' then
		lSecession.cPicker.Open = nil
	end
end


functions.colorPickerTrigger = function( _,_,x, y,_,_,_,ignoreBar,click )
	local xa,ya = (lSecession.cPicker.x or 0),(lSecession.cPicker.y or 0)

	if lSecession.cPicker.Open then
		
		if functions.isCursorOnElement(xa+lSecession.cPicker.start, ya+(33*s), 304*s, 24*s,nil,'CPT') > 0 then
			if getKeyState('mouse1') then
				cOldx = cOldx or x
				cOldy = cOldy or y
				local differencex = x-cOldx
				local differencey = y-cOldy
				lSecession.cPicker.x = lSecession.cPicker.x + (differencex)
				lSecession.cPicker.y = lSecession.cPicker.y + (differencey)
			end
		end
		
		
		if SelectedA then
			SelectedA = getKeyState('mouse1')
		end

		if SelectedB then
			SelectedB = getKeyState('mouse1')
		end
		if not lSecession.cPicker.arrow then
			if getKeyState('mouse1') then

				if (not ignoreBar) and (not SelectedB) then
					if ((functions.isCursorOnElement(xa+lSecession.cPicker.start+(201*s), ya, 25*s, 300*s,nil,'CPA') > 0) and ((not SelectedB) or ignore)) or (toggle == 'CPA') then
						SelectedA = true
						
						local y = y-ya
						local x = x-xa
						
						local total = (256/(194*s))
						local offset = (y-(62*s))*total
						local r,g,b,a = dxGetPixelColor(dxGetTexturePixels(h),0,offset)

						if r then
							lSecession.variables[lSecession.cPicker.Open][9] = r
							lSecession.variables[lSecession.cPicker.Open][10] = g
							lSecession.variables[lSecession.cPicker.Open][11] = b
							lSecession.variables[lSecession.cPicker.Open][6] = y
						

							local _,_,_,xA,yA = unpack(lSecession.variables[lSecession.cPicker.Open])
							if tonumber(xA) then
								functions.colorPickerTrigger ( nil,nil,xA, yA,nil,nil,nil,true)
							end
						end
					end
				end

				if (((ignoreBar) or (functions.isCursorOnElement(xa+lSecession.cPicker.start+(5*s), ya+(63*s), 193*s, 193*s,nil,'CPB')) > 0) and ((not SelectedA) or ignoreBar)) or (toggle == 'CPB') then
					SelectedB = not ignoreBar
					
					local y = y-ya
					local x = x-xa
					
					local totalx,totaly = (256/(193*s)),(256/(193*s))
					local offsetx,offsety = (x-(lSecession.cPicker.start+(5*s)))*totalx,(y-(62*s))*totaly
					local r,g,b,a = dxGetPixelColor(dxGetTexturePixels(sv),offsetx,offsety)
					if r then
						local ab = 255-a
						local r,g,b = (r/255)*a,(g/255)*a,(b/255)*a
						local tabl = lSecession.variables[lSecession.cPicker.Open]
						local rA,gA,bA = tabl[9],tabl[10],tabl[11]
						local ra,ga,ba = (rA/255)*ab ,(gA/255)*ab ,(bA/255)*ab
						local hex = functions.rgb2hex(math.floor(ra),math.floor(ga),math.floor(ba))
						lSecession.variables[lSecession.cPicker.Open][1] = ra+r
						lSecession.variables[lSecession.cPicker.Open][2] = ga+g
						lSecession.variables[lSecession.cPicker.Open][3] = ba+b
						lSecession.variables[lSecession.cPicker.Open][4] = x
						lSecession.variables[lSecession.cPicker.Open][5] = y
						lSecession.variables[lSecession.cPicker.Open][7] = hex
					end
				end
				--functions.colorPickerChange (lSecession.cPicker.Open,lSecession.variables[lSecession.cPicker.Open])
			end
		end
	end
	if lSecession.variables[lSecession.cPicker.Open] then
		local rA,gA,bA = unpack(lSecession.variables[lSecession.cPicker.Open])
		functions.changeEdit('R',math.floor(rA))
		functions.changeEdit('G',math.floor(gA))
		functions.changeEdit('B',math.floor(bA))
	end
	cOldx = x
	cOldy = y
end

addEventHandler( "onClientCursorMove", getRootElement( ),functions.colorPickerTrigger)

