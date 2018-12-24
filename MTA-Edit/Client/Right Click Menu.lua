-- Tables --
menus.rightClick.items = {}
lSecession.CoordinateCopy = {Position = {},Rotation = {}}

--# Undo
table.insert(menus.rightClick.items,{'Button','Undo',nil})

--# Redo
table.insert(menus.rightClick.items,{'Button','Redo',nil})

--# Copy Element
table.insert(menus.rightClick.items,{'Button','Copy Selected',nil,'getSelected'})

--# Delete Element
table.insert(menus.rightClick.items,{'Button','Delete Selected',nil,'getSelected'})

--# Coordiantes

table.insert(menus.rightClick.items,{'list','Copy or Paste Coordinates',nil,'getSelected'})
menus.rightClick.lists['Copy or Paste Coordinates'] = {}

table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Position','Copy Position','getSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy X','Copy Position','getSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Y','Copy Position','getSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Z','Copy Position','getSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Rotation','Copy Rotation','oneSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Xr','Copy Rotation','oneSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Yr','Copy Rotation','oneSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Copy Zr','Copy Rotation','oneSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Paste Position','Paste Position','getSelected'})
table.insert(menus.rightClick.lists['Copy or Paste Coordinates'],{'Button','Paste Rotation','Paste Rotation','getSelected'})

--# Coord Functions
functions['Copy Position'] = function (Name) 
	local x,y,z = functions.getSelectedElementsCenter()
	if Name == 'Copy Position' then
		lSecession.CoordinateCopy.Position = {x,y,z}
		setClipboard(x..','..y..','..z)
	elseif Name == 'Copy X' then
		lSecession.CoordinateCopy.Position = {x}
		setClipboard(x)
	elseif Name == 'Copy Y' then
		lSecession.CoordinateCopy.Position = {nil,y}
		setClipboard(y)
	elseif Name == 'Copy Z' then
		lSecession.CoordinateCopy.Position = {nil,nil,z}
		setClipboard(z)
	end
end

functions['Copy Rotation'] = function (Name)
	local x,y,z = getElementRotation(lSecession.Selected[1])
	if Name == 'Copy Rotation' then
		lSecession.CoordinateCopy.Rotation = {x,y,z}
		setClipboard(x..','..y..','..z)
	elseif Name == 'Copy Xr' then
		lSecession.CoordinateCopy.Rotation = {x}
		setClipboard(x)
	elseif Name == 'Copy Yr' then
		lSecession.CoordinateCopy.Rotation = {nil,y}
		setClipboard(y)
	elseif Name == 'Copy Zr' then
		lSecession.CoordinateCopy.Rotation = {nil,nil,z}
		setClipboard(z)
	end
end

functions['Paste Position'] = function (Name)
	local x,y,z = functions.getSelectedElementsCenter()
	local xa,ya,za = unpack(lSecession.CoordinateCopy.Position)
	if xa then
		local diffx = xa-x
		functions.addSelectedPosition(diffx,0,0,'World')
	end
	
	if ya then
		local diffy = ya-y
		functions.addSelectedPosition(0,diffy,0,'World')
	end
	
	if za  then
		local diffz = za-z
		functions.addSelectedPosition(0,0,diffz,'World')
	end
	lSecession.CoordinateCopy.Position = {}
end

functions['Paste Rotation'] = function (Name)
	local xr,yr,zr = unpack(lSecession.CoordinateCopy.Rotation)
	for i,element in pairs(lSecession.Selected) do
		if xr then
			local Xr,Yr,Zr = getElementRotation(element)
			setElementRotation(element,xr,Yr,Zr)
		end
		
		if yr then
			local Xr,Yr,Zr = getElementRotation(element)
			setElementRotation(element,Xr,yr,Zr)
		end
		
		if zr  then
			local Xr,Yr,Zr = getElementRotation(element)
			setElementRotation(element,Xr,Yr,zr)
		end
	end
	lSecession.CoordinateCopy.Rotation = {}
end

--# Select all 
table.insert(menus.rightClick.items,{'Button','Select All',nil})

functions['Select All'] = function ()
	for i,v in pairs(functions.getAllElements()) do
		functions.setSelected(v,true)
	end
end

table.insert(menus.rightClick.items,{'Button','Deselect All',nil})

functions['Deselect All'] = function ()
	local tabl = {}
	for i,element in pairs(lSecession.Selected) do
		table.insert(tabl,element)
	end
	for i,element in pairs(tabl) do
		functions.setSelected(element)
	end
	tabl = nil
	lSecession.Selected = {}
end



