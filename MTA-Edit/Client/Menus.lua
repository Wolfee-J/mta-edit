-- Screen Size --
xSize, ySize = guiGetScreenSize()

if xSize > 1919 then
	s = (1/1600)*xSize
else
	s = (1/1600)*xSize
end

uScale = tonumber(s)

-- Tables --
menus = {open = {},left = {items = {}},right = {items = {}},rightClick = {items = {},lists = {}},settings = {}}
Cached.Favorited = {}

--#Left Menu
menus.left.items[1] = {'Option','Speed',{'ZFixer','Slow as hell','Slowest','Slower','Slow','Normal','Fast','Faster','Faster Still','Fastest'}}
lSecession.variables['Speed'] = lSecession.variables['Speed'] or {'Normal',6}

menus.left.items[2] = {'Option','Boundries',{'None','Bounding','Highlight'}}
lSecession.variables['Boundries'] = lSecession.variables['Boundries'] or {'Bounding',2}

menus.left.items[3] = {'Space'}
menus.left.items[4] = {'Side Option','Mode',{'Movement','Rotation','Scale'}}
lSecession.variables['Mode'] = lSecession.variables['Mode'] or {'Movement'}

menus.left.items[5] = {'Option','Move Type',{'World','Local'}}
lSecession.variables['Move Type'] = lSecession.variables['Move Type'] or {'World',1}

menus.left.items[6] = {'Option','Magnets',{'Off','Low','Medium','High'}}
lSecession.variables['Magnets'] = lSecession.variables['Magnets'] or {'Off',1}

menus.left.items[7] = {'Option','Snap',{'Off',1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180}}
lSecession.variables['Snap'] = lSecession.variables['Snap'] or {'Off',1}

menus.left.items[8] = {'Option','Grid',{'Off',0.5,1,1.5,2,2.5}}
lSecession.variables['Grid'] = lSecession.variables['Grid'] or {'Off',1}

menus.left.items[9] = {'Option','Depth',{10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200}}
lSecession.variables['Depth'] = lSecession.variables['Depth'] or {50,5}

for _,item in pairs(menus.left.items) do
	if item[2] then
		vCache[item[2]] = true
	end
end


--#Right Menu
menus.right.items['Customize'] = {}
menus.right.items['New Element'] = {}
menus.right.items['Ped Editor'] = {}
menus.right.items['Settings'] = {}
menus.right.items['Load'] = {}

-- Settings --
lIndex = 0
scroll = 0
menus.settings.boarder = 16
menus.settings.width = 225
menus.settings.height = 24
menus.settings.maxItems = 15
menus.settings.listOffset = 5
menus.settings.startHeight = (33)*s


-- Generic Functions --
functions.guiPrep = function ()
	if toggle or hoverOveredElement then
		local fade = hoverFade[toggle or hoverOveredElement]
		hoverFade = {}
		hoverFade[toggle or hoverOveredElement] = fade
	else
		hoverFade = {}
	end
	
	hoverOveredElement = nil
	mHover = nil
	editOnScreen = nil
	lSecession.description = nil
end

hoverFade = {}

functions.isCursorOnElement = function ( posX, posY, width, height,f,name,... ) -- (x,y,w,h,function,arg1,arg2,arg3,...)
	if name then
		hoverFade[name] = hoverFade[name] or 0
		if isCursorShowing( ) then
			if rcmHover and not (name == 'RCM') then
				return 0
			end
			
			if not getKeyState('mouse1') then
				toggle = nil
			end
			
			if (toggle == name) then
				lSecession.description = {f,...}
				hoverFade[name] = math.min(hoverFade[name]+0.05,2)
				return hoverFade[name]
			elseif toggle then
				return 0 -- If you already selected something then to bad, nothing else will work; massive mistake I made with the old UI system.
			end
			
			
			local mouseX, mouseY = getCursorPosition( )
			local clientW, clientH = guiGetScreenSize( )
			local mouseX, mouseY = mouseX * clientW, mouseY * clientH
			if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
				mHover = true
				lSecession.description = {f,...}
				hoverOveredElement = name
				if getKeyState('mouse1') then
					if (not toggle) then
						if functions[f] then
							functions[f](...) -- When you click it'll trigger the function of the selected element.
						end
						toggle = name or true
						hoverFade[name] = math.min(hoverFade[name]+0.05,2)
						return hoverFade[name] -- Mouse 1 is held and the hovered item is selected
					end
				end
				if hoverFade[name] > 1 then
					hoverFade[name] = math.max(hoverFade[name]-0.05,1)
				elseif hoverFade[name] < 1 then
					hoverFade[name] = math.min(hoverFade[name]+0.05,1)
				end
				return hoverFade[name] -- Mouse is hovering over item, mouse is either not held or another thing is selected
			end
		end
		return 0 -- Mouse is neither hovering the element nor is mouse 1 held.
	end
	return 0 -- Nothing exists
end

functions.isCursorHoveringElement = function ( posX, posY, width, height) -- (x,y,w,h)
	if isCursorShowing( ) then
		
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			mHover = true
			return true
		end
	end
end


-- Left Menu --
menus.left.header = {{'Save','Undo','Redo'},{'Controls','freeCam','Preview'}}

mRender.drawLeftMenu = function ()
	--Header
	dxDrawRectangle (menus.settings.boarder*s,menus.settings.startHeight,menus.settings.width*s,menus.settings.height*s, tocolor ( 45, 45, 45, 150 ),true )
	
	for index,item in pairs(menus.left.header[1]) do
		local index = index-1
		local image = functions.prepImage(item)
		if image then
			local hover = functions.isCursorOnElement(((menus.settings.boarder)+(30*index))*s, menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s,item,item)
			local hover = ((Cached[item] and 2) or 0) + hover
			dxDrawImage ((((menus.settings.boarder)+(30*index))*s)+(5*s), menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s, image, 0, 0, 0,tocolor(255,255,255,225-(hover*50)),true)
		end
	end
	
	for index,item in pairs(menus.left.header[2]) do
		local image = functions.prepImage(item)
		if image then
			local hover = functions.isCursorOnElement(((menus.settings.boarder+menus.settings.width)-(30*index))*s, menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s,item,item)
			local hover = ((Cached[item] and 2) or 0) + hover
			dxDrawImage (((menus.settings.boarder+menus.settings.width)-(30*index))*s, menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s, image, 0, 0, 0 ,tocolor(255,255,255,225-(hover*50)),true)
		end
	end
	
	-- Content
	lMenuY = 0
	for index,item in pairs(menus.left.items or {}) do
		if type(item) == 'table' then
			local f = item[1] -- function
			if f == 'Space' then
				lMenuY = lMenuY - (menus.settings.height/1.2)*s
			end
			if functions[f] then
				dxDrawRectangle (menus.settings.boarder*s,menus.settings.startHeight+((menus.settings.height+1)*index)*s+lMenuY,menus.settings.width*s,menus.settings.height*s, tocolor ( 0, 0, 0, 150 ),true )
				functions[f](item,menus.settings.boarder*s,menus.settings.startHeight+((menus.settings.height+1)*index)*s+lMenuY,menus.settings.width*s,menus.settings.height*s,'left',index)
			end
		end
	end
end

-- Right Menu --
menus.right.header = {'Customize','New Element','Ped Editor','Settings','Load'}
rightMenuSelection = menus.right.header[2]

for i,v in pairs(menus.right.header) do
	menus.right[v] = {lists = {}}
	table.insert(menus.right.items[v],{'list','Favorites'})
	menus.right[v].lists['Favorites'] = (Cached.Favorites or {})[v] or {}
end


mRender.drawRightMenu = function ()
	--Header
	local headercount = #menus.right.header
	local division = (menus.settings.width-(20*s))/headercount
	
	dxDrawRectangle (xSize - ((menus.settings.boarder+menus.settings.width)*s),menus.settings.startHeight,menus.settings.width*s,menus.settings.height*s, tocolor ( 45, 45, 45, 150 ),true )
	
	for index,item in pairs(menus.right.header) do
		local image = functions.prepImage(item)
		if image then
			local hover = functions.isCursorOnElement( xSize - ((menus.settings.boarder+menus.settings.width)*s)+(((division*index)-(division/1.5))*s)+(5*s), menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s,'rightMenuSelection',item,item)
			local hover = (rightMenuSelection == item) and 2 or hover
			dxDrawImage ( xSize - ((menus.settings.boarder+menus.settings.width)*s)+(((division*index)-(division/1.5))*s)+(5*s), menus.settings.startHeight, menus.settings.height*s, menus.settings.height*s, image, 0, 0, 0 ,tocolor(255,255,255,225-(hover*50)),true)
		end
	end
	
	rightIndent = 0
	scrollAmount = 0
	rHeight = (((menus.settings.height+0.95)*(math.min(lIndex,menus.settings.maxItems)+1))*s)+menus.settings.startHeight
	
	
	if lIndex > menus.settings.maxItems then
		local height = ((menus.settings.height+0.95)*menus.settings.maxItems)
		dxDrawRectangle ( xSize-(menus.settings.boarder+(9*s)), menus.settings.startHeight+((menus.settings.height+0.95)*s), 9*s, height*s, tocolor ( 15, 15, 15, 120 ),true )
		local fix = (menus.settings.maxItems/lIndex)*height
		scroll = math.min(math.max(scroll,0),height-fix)
		local total = (scroll/(height-fix))
		scrollAmount = (math.floor((lIndex-menus.settings.maxItems)*total))
		local hover = functions.isCursorOnElement(xSize-(menus.settings.boarder+(9*s)), menus.settings.startHeight+((menus.settings.height+0.5)*s)+scroll, 16*s, fix*s,'scrollBar','scrollBarRight')
		dxDrawRectangle ( xSize-(menus.settings.boarder+(9*s)), menus.settings.startHeight+((menus.settings.height+0.95)*s)+scroll, 9*s, fix*s, tocolor ( 170, 170, 170, 120-(hover*20) ),true )
		rightIndent = (10*s) -- Adds bar for the scroll bar and throws a 25 pixel indentation to the right side.
		
		menuHover = functions.isCursorHoveringElement((xSize - ((menus.settings.boarder+menus.settings.width)*s)), menus.settings.startHeight, menus.settings.width*s, height*s)
	else
		menuHover = nil
	end
	

	if (toggle == 'scrollBarRight') then
		local _,y = getCursorPosition ( )
		local y = y*xSize
		if oldy then
			change = (y-oldy)/2
			scroll = scroll+change
		end
		oldy = y
	else
		oldy = nil
	end
	
	functions['Edit Box']({'','Search',nil,nil,nil,true},(xSize - ((menus.settings.boarder+menus.settings.width)*s)),(menus.settings.startHeight+((menus.settings.height+1))*s),((menus.settings.width*s)-rightIndent),(menus.settings.height*s),'right')
	
	--Content
	lIndex = 1 -- For lists, simply add the list count to this.
	
	for index,item in pairs(functions.Search() or (menus.right.items or {})[rightMenuSelection] or {}) do
		lIndex = lIndex + 1
		if type(item) == 'table' then
			local f = item[1] -- function
			if functions[f] then
				local index = (lIndex-scrollAmount)
				if (index < (menus.settings.maxItems+1) and ((index > 0) )) or (f == 'list') then
					local x,y,w,h = (xSize - ((menus.settings.boarder+menus.settings.width)*s)),(menus.settings.startHeight+((menus.settings.height+1)*(index))*s),((menus.settings.width*s)-rightIndent),(menus.settings.height*s)
					if (index > 1) and (index < (menus.settings.maxItems+1)) then
						dxDrawRectangle (x,y,w,h, tocolor ( 0, 0, 0, 150 ),true )
						if not (item[2] == 'Favorites') then
							local favorited = (Cached.Favorited or {})[item[2]] and 100 or 5
							local hover = functions.isCursorOnElement(x-(h*1.2),y,h,h,'favorite','F'..item[2],item )
							dxDrawImage(x-(h*1.2),y,h,h,functions.prepImage('Favorite'), 0, 0, 0, tocolor(255, 255, 255, (hover*100)+favorited),true)
						end						
					end
					functions[f](item,x,y,w,h,'right',1,(index > 1) and (index < (menus.settings.maxItems+1)))
				end
			end
		end
	end
end

functions.drawList = function (list,depth) -- Used for drop down lists.
	local displacement = (menus.settings.listOffset*depth)*s
	for index,item in pairs(list or {}) do
		lIndex = lIndex + 1
		if type(item) == 'table' then
			local f = item[1] -- function
			if functions[f] then
			local index = (lIndex-scrollAmount)
				if ((index < (menus.settings.maxItems+1)) and (index > 1)) or (f == 'list') then
					local x,y,w,h = (xSize - ((menus.settings.boarder+menus.settings.width)*s) + displacement),(menus.settings.startHeight+((menus.settings.height+1)*index)*s),((menus.settings.width*s)-displacement-rightIndent),(menus.settings.height*s)
					if (index > 1) and (index < (menus.settings.maxItems+1)) then
						dxDrawRectangle (x,y,w,h, tocolor ( 0, 0, 0, 150-(depth*20) ),true )
						local favorited = (Cached.Favorited or {})[item[2]] and 100 or 5
						local hover = functions.isCursorOnElement(x-(h*1.2),y,h,h,'favorite','F'..item[2],item )
						dxDrawImage(x-(h*1.2),y,h,h,functions.prepImage('Favorite'), 0, 0, 0, tocolor(255, 255, 255, (hover*100)+favorited),true)	
					end
					functions[f](item,x,y,w,h,'right',depth+1,(index > 1) and (index < (menus.settings.maxItems+1)))
				end
			end
		end
	end
end

-- Right Click Menu --
rightClickMenuFade = 0 
currentRightClickMenu = nil
functions.drawRightClickMenu = function () -- Only shows when you right click
	rcmHover = nil
	if rightClickMenu or (rightClickMenuFade > 0) then
		if rightClickMenu then
			currentRightClickMenu = rightClickMenu
			rightClickMenuFade = math.min(rightClickMenuFade + 0.1,1)
		else
			rightClickMenuFade = math.max(rightClickMenuFade - 0.1,0)
		end
		
		local x,y = unpack(currentRightClickMenu)
		
		dxDrawRectangle (x,y,menus.settings.width*s,menus.settings.height*s, tocolor ( 45, 45, 45, 150*rightClickMenuFade ),true )
		dxDrawText(functions.fetchTranslation('Options'),x+(10*s),y,(menus.settings.width*s)+x,(menus.settings.height*s)+y, tocolor(255, 255, 255, 220*rightClickMenuFade), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		
		if isCursorShowing() then
			local xa,ya = getCursorPosition ( )
			local cx,cy = (xa*xSize),(ya*ySize)

			if functions.isCursorOnElement(x,y,menus.settings.width*s,menus.settings.height*s,nil,'RCM') > 0 then
				rcmHover = true
				if getKeyState('mouse1') then
					rcOldx = rcOldx or cx
					rcOldy = rcOldy or cy
					local differencex = cx-rcOldx
					local differencey = cy-rcOldy
					currentRightClickMenu[1] = currentRightClickMenu[1] + (differencex)
					currentRightClickMenu[2] = currentRightClickMenu[2] + (differencey)
				end
				else
				rcmHover = nil
			end
			rcOldx = cx
			rcOldy = cy
		end
		
		--Content
		rcIndex = 0
		for index,item in pairs(menus.rightClick.items or {}) do
			if type(item) == 'table' then
				local f = item[1] -- function
				if functions.shouldShow(item[4]) then
					if functions[f] then
						rcIndex = rcIndex + 1
						local index = (rcIndex)
						dxDrawRectangle (x,y+(((menus.settings.height+1)*index)*s),menus.settings.width*s,menus.settings.height*s, tocolor ( 0, 0, 0, 150*rightClickMenuFade ),true )
						functions[f](item,x,y+(((menus.settings.height+1)*index)*s),menus.settings.width*s,menus.settings.height*s,'rightClick',1,true,rightClickMenuFade)
					end
				end
			end
		end
	end
end

functions.onRightClick = function( button, state, x, y )
	if (button == 'right') and (state == 'down') then
		if rightClickMenu then
			rightClickMenu = nil
		else
			rightClickMenu = {x,y}
		end
	end
	if (button == 'left') and (state == 'down') then
		if not hoverOveredElement then
			rightClickMenu = nil
		end
	end
end
addEventHandler ( "onClientClick", root, functions.onRightClick )


functions.drawRCList = function (list,depth,x,y) -- Used for drop down lists.
	for index,item in pairs(list or {}) do
		if type(item) == 'table' then
			local f = item[1] -- function
			if functions[f] then
				local index = (index-1)
				dxDrawRectangle (x,y+(((menus.settings.height+1)*index)*s),menus.settings.width*s,menus.settings.height*s, tocolor ( 0, 0, 0, 150 ),true )
				functions[f](item,x,y+(((menus.settings.height+1)*index)*s),menus.settings.width*s,menus.settings.height*s,'rightClick',1,true)
			end
		end
	end
end




-- See Menu Functions.lua for the misc UI functions and helper functions. -- 

