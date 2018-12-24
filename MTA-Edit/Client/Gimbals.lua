-- Tables --
Gimbals = {Circles = {}}
Gimbals.Size = 5
Gimbals.CircleSize = 5 -- You need to scale down the collision if you touch this!

lSecession.freeMove = {}

Gimbals.Circles[1] = createObject(3356,0,0,0)
Gimbals.Circles[2] = createObject(3356,0,0,0) 
Gimbals.Circles[3] = createObject(3356,0,0,0) 

-- Circles -- (Yeah I know)

engineReplaceModel ( engineLoadDFF ( "Content/Circle.dff" ), 3356 )
engineReplaceCOL( engineLoadCOL( "Content/Circle.col" ), 3356 )

functions.resetCircles = function()
	for i=1,3 do
		setElementPosition(Gimbals.Circles[i],10000,10000,10000)
		setElementAlpha(Gimbals.Circles[i],0)
		setElementData(Gimbals.Circles[i],'MapEditor',true)
	end
end
functions.resetCircles()


-- Generic Functions --
functions.getSelectedOffset = function(x,y,z) 
	if (lSecession.variables['Move Type'][1] == 'World') or (#lSecession.Selected > 1) then
		local xA,yA,zA = functions.getSelectedElementsCenter()
		local x,y,z = x+xA,y+yA,z+zA
		return x,y,z
	elseif lSecession.variables['Move Type'][1] == 'Local' then
		local element = lSecession.Selected[1]
		local newMatrix = (element.matrix:transformPosition(Vector3(x,y,z)))
		return newMatrix.x,newMatrix.y,newMatrix.z
	end
end

preRender.freeMove = function ()
	local f = lSecession.freeMove
	if (#lSecession.Selected > 0) and (lSecession.freeMovement) then
		local xA,yA,zA,xB,yB,zB = getCameraMatrix()
		local xC,yC,zC = functions.getSelectedElementsCenter()
		local hit, x,y,z,element = processLineOfSight ( xA,yA,zA,xB,yB,zB )

		if functions.isSelected(element) then
			f.X,f.Y,f.Z = (x or xC),(y or yC),(z or zC)
		else
			f.X,f.Y,f.Z = xC,yC,zC
		end

		f.Distance = f.Distance or getDistanceBetweenPoints3D(xA,yA,zA,f.X,f.Y,f.Z)

		local xA,yA,zA = getWorldFromScreenPosition ( xSize/2, ySize/2,f.Distance )


		if not ((xA == f.oX) and (yA == f.oY) and (yA == f.oZ)) then
			if isFreecamEnabled() then
				if f.oX then
					functions.addSelectedPosition(xA-f.oX,yA-f.oY,zA-f.oZ,'World')
				else
					f.Distance = nil
				end
			end
		end
		f.oX,f.oY,f.oZ = xA,yA,zA
	else
		f.oX,f.oY,f.oZ = nil,nil,nil
		f.Distance = nil
	end
end


functions.findHightLighted = function (tabl2)
	if toggle then
		return
	end
	
	if getKeyState('mouse1') then
		if (not mHover) then
			if lHover then
				toggle = 'lHover'
				return
			end
		else
			return
		end
		else
		if mHover then
			lHover = nil
			return
		end
	end
	
	lHover = nil
	
	if isCursorShowing() then
		local cx,cy = getCursorPosition()	
		local cx,cy = cx*xSize,cy*ySize
		local x,y = unpack(tabl2['Center'])
		minimal = 5
		for i,item in pairs(tabl2) do
			local xa,ya,_,xb,yb = unpack(item)
			if xa and ya then
				local distance = (functions.getDistanceBetweenPointAndSegment2D( cx, cy, (tonumber(xb) or x), (tonumber(yb) or y), xa, ya) or 6)
				if distance < minimal then
					minimal = distance
					lHover = i
				end
			end
		end
	end
end

-- Movement --
lRender.drawMovementGimbal = function()
	if lSecession.variables['Mode'][1] == 'Movement' then
		if (#lSecession.Selected > 0) then
			local tabl2 = {}
			local x,y,z = functions.getSelectedElementsCenter()		
			tabl2['Center'] = {getScreenFromWorldPosition(x,y,z,1000)}
			
			local xA,yA,zA = functions.getSelectedOffset(Gimbals.Size,0,0)
			tabl2['x'] = {getScreenFromWorldPosition(xA,yA,zA,1000)}
			dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(255,0,0,255), (lHover == 'x') and 10 or 5,(lHover == 'x'))
							
			local xA,yA,zA = functions.getSelectedOffset(0,Gimbals.Size,0)
			tabl2['y'] = {getScreenFromWorldPosition(xA,yA,zA,1000)}
			dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,255,0,255), (lHover == 'y') and 10 or 5,(lHover == 'y'))
			
			local xA,yA,zA = functions.getSelectedOffset(0,0,Gimbals.Size)
			tabl2['z'] = {getScreenFromWorldPosition(xA,yA,zA,1000)}
			dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,0,255,255), (lHover == 'z') and 10 or 5,(lHover == 'z'))
			functions.findHightLighted(tabl2)
			functions.proccessMovement(tabl2)
		end
	end
end

functions.proccessMovement = function (tabl)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local x,y = (x*xSize),(y*ySize)
		if getKeyState('mouse1') then
			if lHover then
				if (xSize - x) < 5 then
					setCursorPosition(5,y)
					OldX,OldY = 5,y
					return
				elseif x<5 then
					setCursorPosition(xSize-5,y)
					OldX,OldY = xSize-5,y
					return
				end
				local xa,ya = (tabl['Center'][1]),(tabl['Center'][2])
				if (not xa) or (not ya) then return end
				local newc = getDistanceBetweenPoints2D (xa,ya,x,y)
				local oldc = getDistanceBetweenPoints2D (xa,ya,OldX,OldY)
				local xb,yb = (tabl[lHover][1]),(tabl[lHover][2])
				if (not xb) or (not yb) then return end -- Causes issues when the line exits the screen space.
				local newh = getDistanceBetweenPoints2D (xb,yb,x,y)
				local oldh = getDistanceBetweenPoints2D (xb,yb,OldX,OldY)
				lDirection = nil
				if (newc>oldc) and (newh<oldh) then
					-- Twords H
					lDirection = 1
				elseif (newc<oldc) and (newh>oldh) then
					-- Twords C
					lDirection = -1
				elseif (newc>oldc) and (newh>oldh) then
					if (newc>newh) then
						-- Twords H
						lDirection = 1
					else
						-- Twords C
						lDirection = -1
					end
				elseif (newc>oldc) and (newh>oldh) and (newc>newh) then
					-- Twords H
					lDirection = 1
				else
					if (newc<newh) then
						-- Twords H
						lDirection = 1
					else
						-- Twords C
						lDirection = -1
					end
				end
			
				local xC,yC,zC = getCameraMatrix()
				local xD,yD,zD = functions.getSelectedElementsCenter()		
				local distance = getDistanceBetweenPoints3D (xC,yC,zC,xD,yD,zD)
				
				local Nx,Ny,Nz = getWorldFromScreenPosition ( x,y, distance )
				local Ox,Oy,Oz = getWorldFromScreenPosition ( OldX,OldY, distance )
				local movement = getDistanceBetweenPoints3D (Nx,Ny,Nz,Ox,Oy,Oz)*lDirection
				
				if lHover == 'x' then
					functions.addSelectedPosition(movement,0,0,lSecession.variables['Move Type'][1])
				elseif lHover == 'y' then
					functions.addSelectedPosition(0,movement,0,lSecession.variables['Move Type'][1])
				elseif lHover == 'z' then
					functions.addSelectedPosition(0,0,movement,lSecession.variables['Move Type'][1])
				end
			end
		end
	OldX,OldY = x,y
	end
end


-- Rotation --

functions.findHighLightedRotation = function ()
	if getKeyState('mouse1') then
		if (not mHover) then
			if cHover then
				toggle = 'lHover'
				return
			end
		else
			return
		end
	else
		if mHover then
			cHover = nil
			return
		end
	end
	
	cHover = nil
	
	if (functions.findHoverElement() == Gimbals.Circles[1]) then
		cHover = 'xr'
		_,cX,cY,cZ = functions.findHoverElement()
	elseif (functions.findHoverElement() == Gimbals.Circles[2]) then
		cHover = 'yr'
		_,cX,cY,cZ = functions.findHoverElement()
	elseif (functions.findHoverElement() == Gimbals.Circles[3]) then
		cHover = 'zr'
		_,cX,cY,cZ = functions.findHoverElement()
	else
		cHover = nil
	end
end

lRender.drawRotationGimbal = function () -- Well flip me over and call me sally; this may be the hardest thing I've done in a while.
	if lSecession.variables['Mode'][1] == 'Rotation' then
		if (#lSecession.Selected > 0) then
			local tabl2 = {}
			local x,y,z = functions.getSelectedElementsCenter()
			local c = functions.prepImage('circle',true)
			local cs = functions.prepImage('CircleSelected',true)		
			if isCursorShowing() then
				setElementPosition(Gimbals.Circles[1],x,y,z)
				setElementPosition(Gimbals.Circles[2],x,y,z)
				setElementPosition(Gimbals.Circles[3],x,y,z)
				functions.findHighLightedRotation()
			else
				cHover = nil
				functions.resetCircles()
			end
					
			local xA,yA,zA = functions.getSelectedOffset(0,Gimbals.CircleSize/2,0)
			local xB,yB,zB = functions.getSelectedOffset(0,-Gimbals.CircleSize/2,0)
			
			local fX,fY,fZ = functions.getSelectedOffset(Gimbals.CircleSize/2,0,0)
			local bX,bY,bZ = functions.getSelectedOffset(-Gimbals.CircleSize/2,0,0)
			
			local xC,yC,zC = functions.getSelectedOffset(Gimbals.CircleSize,0,0)
			local xD,yD,zD = functions.getSelectedOffset(-Gimbals.CircleSize,0,0)
			local xr,yr,zr = functions.findRotation3D(x,y,z,xC,yC,zC) 
			setElementRotation(Gimbals.Circles[1],xr-90,yr,zr)
			dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, (cHover == 'xr') and cs or c, Gimbals.CircleSize,tocolor(255,0,0,255),false,xC,yC,zC)			
			tabl2['xr'] = {fX,fY,fZ,bX,bY,bZ}
			
			local xA,yA,zA = functions.getSelectedOffset(Gimbals.CircleSize/2,0,0)
			local xB,yB,zB = functions.getSelectedOffset(-Gimbals.CircleSize/2,0,0)
			
			local fX,fY,fZ = functions.getSelectedOffset(0,Gimbals.CircleSize/2,0)
			local bX,bY,bZ = functions.getSelectedOffset(0,-Gimbals.CircleSize/2,0)
			
			local xC,yC,zC = functions.getSelectedOffset(0,Gimbals.CircleSize,0)
			local xD,yD,zD = functions.getSelectedOffset(0,-Gimbals.CircleSize,0)
			local xr,yr,zr = functions.findRotation3D(x,y,z,xC,yC,zC) 
			setElementRotation(Gimbals.Circles[2],xr-90,yr,zr)			
			dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, (cHover == 'yr') and cs or c, Gimbals.CircleSize,tocolor(0,255,0,255),false,xC,yC,zC)			
			tabl2['yr'] = {fX,fY,fZ,bX,bY,bZ}
			
			local tX,tY,tZ = functions.getSelectedOffset(Gimbals.CircleSize/2,0,0)
			local bX,bY,bZ = functions.getSelectedOffset(-Gimbals.CircleSize/2,0,0)
			
			local fX,fY,fZ = functions.getSelectedOffset(0,0,Gimbals.CircleSize/2)
			local bX,bY,bZ = functions.getSelectedOffset(0,0,-Gimbals.CircleSize/2)
			
			local xC,yC,zC = functions.getSelectedOffset(0,0,Gimbals.CircleSize)
			local xD,yD,zD = functions.getSelectedOffset(0,0,-Gimbals.CircleSize)
			local xr,yr,zr = functions.findRotation3D(x,y,z,xC,yC,zC) 
			setElementRotation(Gimbals.Circles[3],xr-90,yr,zr)
			dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, (cHover == 'zr') and cs or c, Gimbals.CircleSize,tocolor(0,0,255,255),false,xC,yC,zC)
			tabl2['zr'] = {fX,fY,fZ,bX,bY,bZ}
			
			functions.proccessRotation(tabl2)				
		end
	end
end

functions.proccessRotation = function (tabl)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local x,y = (x*xSize),(y*ySize)
		if getKeyState('mouse1') then
			if cHover then
				if (xSize - x) < 5 then
					setCursorPosition(5,y)
					oldr = nil
					return
				elseif x<5 then
					setCursorPosition(xSize-5,y)
					oldr = nil
					return
				end
				
				local frontx,fronty,frontz,backx,backy,backz = unpack(tabl[cHover])
				local cx,cy,cz = getCameraMatrix()
				direction = 1
				if getDistanceBetweenPoints3D(frontx,fronty,frontz,cx,cy,cz) < getDistanceBetweenPoints3D(backx,backy,backz,cx,cy,cz) then
					direction = -1
				end
				
				local xa,ya,za = functions.getSelectedElementsCenter()
				local xb,yb = getScreenFromWorldPosition(xa,ya,za,100)
				local rotation = functions.findRotation(x,y,xb,yb)
				local change = (rotation - (oldr or rotation))*direction

				if (lSecession.variables['Snap'][1] == 'Off') then
					if cHover == 'xr' then
						functions.addSelectedRotation(change,0,0,lSecession.variables['Move Type'][1])
					elseif cHover == 'yr' then
						functions.addSelectedRotation(0,change,0,lSecession.variables['Move Type'][1])
					elseif cHover == 'zr' then
						functions.addSelectedRotation(0,0,change,lSecession.variables['Move Type'][1])
					end
				else
					if (change > 1) or (change < -1) then
						if cHover == 'xr' then
							functions.addSelectedRotationSmoothly(lSecession.variables['Snap'][1]*((change > 1) and 1 or -1),0,0,lSecession.variables['Move Type'][1])
						elseif cHover == 'yr' then
							functions.addSelectedRotationSmoothly(0,lSecession.variables['Snap'][1]*((change > 1) and 1 or -1),0,lSecession.variables['Move Type'][1])
						elseif cHover == 'zr' then
							functions.addSelectedRotationSmoothly(0,0,lSecession.variables['Snap'][1]*((change > 1) and 1 or -1),lSecession.variables['Move Type'][1])
						end
					end
				end
				oldr = rotation
			end
		else
			oldr = nil
		end
	end
end
-- Scale --
lRender.drawScaleGimbal = function()
	if lSecession.variables['Mode'][1] == 'Scale' then
		if (#lSecession.Selected > 0) then
			local x,y,z = functions.getSelectedElementsCenter()		
			local tabl = {}
			tabl['Center'] = {getScreenFromWorldPosition(x,y,z,1000)}
			
			local xX,yX,zX = functions.getSelectedOffset(Gimbals.Size/1.5,0,0)
			local xxX,xxY = getScreenFromWorldPosition(xX,yX,zX,1000)
			local xY,yY,zY = functions.getSelectedOffset(0,Gimbals.Size/1.5,0)
			local yyX,yyY = getScreenFromWorldPosition(xY,yY,zY,1000)
			local xZ,yZ,zZ = functions.getSelectedOffset(0,0,Gimbals.Size/1.5)
			local zzX,zzY = getScreenFromWorldPosition(xZ,yZ,zZ,1000)
			tabl['xz'] = {zzX,zzY,nil,xxX,xxY}
			tabl['yz'] = {zzX,zzY,nil,yyX,yyY}
			tabl['xy'] = {yyX,yyY,nil,xxX,xxY}
			
			dxDrawLine3D (xZ,yZ,zZ,xX,yX,zX,tocolor(255,0,255,255), (lHover == 'xz') and 10 or 5)
			dxDrawLine3D (xZ,yZ,zZ,xY,yY,zY,tocolor(0,255,255,255), (lHover == 'yz') and 10 or 5)
			dxDrawLine3D (xX,yX,zX,xY,yY,zY,tocolor(255,255,0,255), (lHover == 'xy') and 10 or 5)
			
			local xX,yX,zX = functions.getSelectedOffset(Gimbals.Size,0,0)
			tabl['x'] = {getScreenFromWorldPosition(xX,yX,zX,1000)}
			dxDrawLine3D (x,y,z,xX,yX,zX,tocolor(255,0,0,255), (lHover == 'x') and 10 or 5)
			
			local xY,yY,zY = functions.getSelectedOffset(0,Gimbals.Size,0)
			tabl['y'] = {getScreenFromWorldPosition(xY,yY,zY,1000)}
			dxDrawLine3D (x,y,z,xY,yY,zY,tocolor(0,255,0,255), (lHover == 'y') and 10 or 5)
							
			local xZ,yZ,zZ = functions.getSelectedOffset(0,0,Gimbals.Size)
			tabl['z'] = {getScreenFromWorldPosition(xZ,yZ,zZ,1000)}
			dxDrawLine3D (x,y,z,xZ,yZ,zZ,tocolor(0,0,255,255), (lHover == 'z') and 10 or 5)
			functions.findHightLighted(tabl)
			functions.proccessScaling(tabl)
		end
	end
end

functions.proccessScaling = function (tabl)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local x,y = (x*xSize),(y*ySize)
		if getKeyState('mouse1') then
			if lHover then
				if (xSize - x) < 5 then
					setCursorPosition(5,y)
					OldX,OldY = 5,y
					return
				elseif x<5 then
					setCursorPosition(xSize-5,y)
					OldX,OldY = xSize-5,y
					return
				end
				local xa,ya = (tabl['Center'][1]),(tabl['Center'][2])
				local newc = getDistanceBetweenPoints2D (xa,ya,x,y)
				local oldc = getDistanceBetweenPoints2D (xa,ya,OldX,OldY)
				local xb,yb = (tabl[lHover][1]),(tabl[lHover][2])
				local newh = getDistanceBetweenPoints2D (xb,yb,x,y)
				local oldh = getDistanceBetweenPoints2D (xb,yb,OldX,OldY)
				lDirection = nil
				if (newc>oldc) and (newh<oldh) then
					-- Twords H
					lDirection = 1
				elseif (newc<oldc) and (newh>oldh) then
					-- Twords C
					lDirection = -1
				elseif (newc>oldc) and (newh>oldh) then
					if (newc>newh) then
						-- Twords H
						lDirection = 1
					else
						-- Twords C
						lDirection = -1
					end
				elseif (newc>oldc) and (newh>oldh) and (newc>newh) then
					-- Twords H
					lDirection = 1
				else
					if (newc<newh) then
						-- Twords H
						lDirection = 1
					else
						-- Twords C
						lDirection = -1
					end
				end
				local xC,yC,zC = getCameraMatrix()
				local xD,yD,zD = functions.getSelectedElementsCenter()		
				local distance = getDistanceBetweenPoints3D (xC,yC,zC,xD,yD,zD)
				
				local Nx,Ny,Nz = getWorldFromScreenPosition ( x,y, distance )
				local Ox,Oy,Oz = getWorldFromScreenPosition ( OldX,OldY, distance )
				local movement = getDistanceBetweenPoints3D (Nx,Ny,Nz,Ox,Oy,Oz)*lDirection
				
				if lHover == 'x' then
					functions.addSelectedScale(movement,0,0)
				elseif lHover == 'y' then
					functions.addSelectedScale(0,movement,0)
				elseif lHover == 'z' then
					functions.addSelectedScale(0,0,movement)
				elseif lHover == 'xz' then
					functions.addSelectedScale(movement,0,movement)
				elseif lHover == 'yz' then
					functions.addSelectedScale(0,movement,movement)
				elseif lHover == 'xy' then
					functions.addSelectedScale(movement,movement,0)
				end
			end
		end
		OldX,OldY = x,y
	end
end


-- Misc External --

functions.getCameraOffset = function (x,y,z)
	local element = getCamera()
	local newMatrix = (element.matrix:transformPosition(Vector3(x,y,z)))
	return newMatrix.x,newMatrix.y,newMatrix.z
end

functions.proccessBindPosition = function (key)
	local x,y,z = getCameraMatrix()
	
	local positions = {}
	
	positions['F'] = {functions.getSelectedOffset(20,0,0)} -- Front
	positions['Re'] = {functions.getSelectedOffset(-20,0,0)} -- Rear
	
	positions['L'] = {functions.getSelectedOffset(0,-20,0)} -- Left
	positions['R'] = {functions.getSelectedOffset(0,20,0)} -- Right
	
	positions['T'] = {functions.getSelectedOffset(0,0,20)} -- Top
	positions['B'] = {functions.getSelectedOffset(0,0,-20)} -- Bottom
	
	local cameraPositions = {}
	
	cameraPositions['T'] = {functions.getCameraOffset(0,-10,5)} -- Top
	cameraPositions['B'] = {functions.getCameraOffset(0,-10,-5)} -- Bottom

	cameraPositions['L'] = {functions.getCameraOffset(-5,-10,0)} -- Top
	cameraPositions['R'] = {functions.getCameraOffset(5,-10,0)} -- Bottom
	
	local distancesb = {min = 10000}
	for i,v in pairs(positions) do
		distancesb[i] = 0
		for ia,va in pairs(cameraPositions) do
			local x,y,z = unpack(v)
			local xa,ya,za = unpack(va)
			distancesb[i] = (distancesb[i] + getDistanceBetweenPoints3D (x,y,z,xa,ya,za))/2
		end
		distancesb.min = math.min(distancesb.min,distancesb[i])
		if distancesb.min == distancesb[i] then
			ignore = i
		end
	end
	
	
	local minal = {}
	local distances = {}
	for i,v in pairs(cameraPositions) do -- For some reason this crap's inverted.
		distances[i] = {}
		distances[i].minimal = 1000
		for ia,va in pairs(positions) do
			if not (ignore == ia) then
				local x,y,z = unpack(v)
				local xa,ya,za = unpack(va)
				distances[i][ia] = getDistanceBetweenPoints3D (x,y,z,xa,ya,za)
				distances[i].minimal = math.min(distances[i][ia],distances[i].minimal)
			end
		end
	end

	--24
	local order = {}
	if distancesb.min == distancesb['T'] then
		if distances['T'].minimal == distances['T']['F'] then
			order = {'x','y'}--
		elseif distances['T'].minimal == distances['T']['Re'] then
			order = {'-x','-y'}--
		elseif distances['T'].minimal == distances['T']['L'] then
			order = {'-y','x'}--
		elseif distances['T'].minimal == distances['T']['R'] then
			order = {'y','-x'}--
		end
	elseif distancesb.min == distancesb['F'] then
		if distances['T'].minimal == distances['T']['T'] then
			order = {'z','-y','T'}--
		elseif distances['T'].minimal == distances['T']['B'] then
			order = {'-z','y','B'}
		elseif distances['T'].minimal == distances['T']['L'] then
			order = {'-y','-z','L'}
		elseif distances['T'].minimal == distances['T']['R'] then
			order = {'y','z','R'}
		end
	elseif distancesb.min == distancesb['R'] then
		if distances['T'].minimal == distances['T']['T'] then
			order = {'z','x','T'}--
		elseif distances['T'].minimal == distances['T']['B'] then
			order = {'-z','-x','B'}--
		elseif distances['T'].minimal == distances['T']['F'] then
			order = {'x','-z','F'}
		elseif distances['T'].minimal == distances['T']['Re'] then
			order = {'-x','z','Re'}
		end
	elseif distancesb.min == distancesb['L'] then
		if distances['T'].minimal == distances['T']['T'] then
			order = {'z','-x','T'}--
		elseif distances['T'].minimal == distances['T']['B'] then
			order = {'-z','x','B'}
		elseif distances['T'].minimal == distances['T']['F'] then
			order = {'x','z','F'}
		elseif distances['T'].minimal == distances['T']['Re'] then
			order = {'-x','-z','Re'}
		end
	elseif distancesb.min == distancesb['Re'] then
		if distances['T'].minimal == distances['T']['T'] then
			order = {'z','y','T'}--
		elseif distances['T'].minimal == distances['T']['B'] then
			order = {'-z','-y','B'}
		elseif distances['T'].minimal == distances['T']['L'] then
			order = {'-y','z','L'}
		elseif distances['T'].minimal == distances['T']['R'] then
			order = {'y','-z','R'}
		end
	elseif distancesb.min == distancesb['B'] then
		if distances['T'].minimal == distances['T']['F'] then
			order = {'x','-y'}--
		elseif distances['T'].minimal == distances['T']['Re'] then
			order = {'-x','y'}--
		elseif distances['T'].minimal == distances['T']['L'] then
			order = {'-y','-x'}--
		elseif distances['T'].minimal == distances['T']['R'] then
			order = {'y','x'}--
		end
	end
	
	if key == 'arrow_u' then
		local ordial = 1*((lSecession.variables['Arrow Movement'][2]+4)/10)
		local direction = order[1]
		if direction == 'z' then
			functions.addSelectedPosition(0,0,0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == '-z' then
			functions.addSelectedPosition(0,0,-0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == 'x' then
			functions.addSelectedPosition(0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == '-x' then
			functions.addSelectedPosition(-0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == 'y' then
			functions.addSelectedPosition(0,0.01*ordial,0,lSecession.variables['Move Type'][1])
		elseif direction == '-y' then
			functions.addSelectedPosition(0,-0.01*ordial,0,lSecession.variables['Move Type'][1])
		end
	elseif key == 'arrow_d' then
		local ordial = -1*((lSecession.variables['Arrow Movement'][2]+4)/10)
		local direction = order[1]
		if direction == 'z' then
			functions.addSelectedPosition(0,0,0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == '-z' then
			functions.addSelectedPosition(0,0,-0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == 'x' then
			functions.addSelectedPosition(0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == '-x' then
			functions.addSelectedPosition(-0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == 'y' then
			functions.addSelectedPosition(0,0.01*ordial,0,lSecession.variables['Move Type'][1])
		elseif direction == '-y' then
			functions.addSelectedPosition(0,-0.01*ordial,0,lSecession.variables['Move Type'][1])
		end
	elseif key == 'arrow_l' then
		local ordial = 1*((lSecession.variables['Arrow Movement'][2]+4)/10)
		local direction = order[2]
		if direction == 'z' then
			functions.addSelectedPosition(0,0,0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == '-z' then
			functions.addSelectedPosition(0,0,-0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == 'x' then
			functions.addSelectedPosition(0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == '-x' then
			functions.addSelectedPosition(-0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == 'y' then
			functions.addSelectedPosition(0,0.01*ordial,0,lSecession.variables['Move Type'][1])
		elseif direction == '-y' then
			functions.addSelectedPosition(0,-0.01*ordial,0,lSecession.variables['Move Type'][1])
		end
	else
		local ordial = -1*((lSecession.variables['Arrow Movement'][2]+4)/10)
		local direction = order[2]
		if direction == 'z' then
			functions.addSelectedPosition(0,0,0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == '-z' then
			functions.addSelectedPosition(0,0,-0.01*ordial,lSecession.variables['Move Type'][1])
		elseif direction == 'x' then
			functions.addSelectedPosition(0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == '-x' then
			functions.addSelectedPosition(-0.01*ordial,0,0,lSecession.variables['Move Type'][1])
		elseif direction == 'y' then
			functions.addSelectedPosition(0,0.01*ordial,0,lSecession.variables['Move Type'][1])
		elseif direction == '-y' then
			functions.addSelectedPosition(0,-0.01*ordial,0,lSecession.variables['Move Type'][1])
		end
	end
end



