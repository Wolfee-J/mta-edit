-- Tables --
lSecession.elementMagnet = {}
lSecession.activatedMagnet = {}
lSecession.Magnets = {}
lSecession.elementPostions = {}
minDistance = ((tonumber(lSecession.variables['Magnets'][2])) * 2) 

-- Functions --

mRender.drawMagnets = function ()
	if functions.getSelected() and lSecession.eMagnets and lSecession.freeMovement and minDistance then
		local xb,yb,zb = getCameraMatrix()
		for i,v in pairs(functions.getAllElements(true,true)) do
			local m = lSecession.Magnets[v]
			if m then
				local xa,ya,za = getElementPosition(v)
				if (getDistanceBetweenPoints3D (xa,ya,za,xb,yb,zb) < 50) and m then
					for iA = 1,8 do
						if lSecession.activatedMagnet[v] and lSecession.activatedMagnet[v][iA] then
							dxDrawLine3D ( m[iA].x,m[iA].y,m[iA].z+0.05,m[iA].x,m[iA].y,m[iA].z-0.05,tocolor(255,50,50,150), 5,true)
						else
							dxDrawLine3D ( m[iA].x,m[iA].y,m[iA].z+0.05,m[iA].x,m[iA].y,m[iA].z-0.05,tocolor(50,50,255,150), 5)
						end
					end
				end
			end
		end
	end
end

functions.activateMagnets = function ()
	if lSecession.activatedMagnet.Connection and minDistance then
		local element = unpack(lSecession.activatedMagnet.Connection)
		if element then
			minDistance = ((tonumber(lSecession.variables['Magnets'][2])) * 2)
			
			functions.magnetTimer()
			functions.checkMagnets(element)
			
			local _,vector = unpack(lSecession.activatedMagnet.Connection)
			functions.addSelectedPosition(vector.x,vector.y,vector.z,'World')
		end
	end
end


functions.prepElementMagnets = function (element)
	if lSecession.freeMovement and lSecession.eMagnets and minDistance then
		local xa,ya,za,xb,yb,zb = getElementBoundingBox (element)
		if xa then
			local matrix = element.matrix
				
			if getElementType(element) == 'object' then
				local sX,sY,sZ = getObjectScale(element)	
				xa,ya,za,xb,yb,zb = xa*sX,ya*sY,za*sZ,xb*sX,yb*sY,zb*sZ
			end
		
			local tFL = matrix:transformPosition(Vector3(xa,ya,za)) -- Top front left
			local tFR = matrix:transformPosition(Vector3(-xa,ya,za)) -- Top front right
			local tRL = matrix:transformPosition(Vector3(xa,-ya,za)) -- Top rear left
			local tRR = matrix:transformPosition(Vector3(-xa,-ya,za)) -- Top rear right
			local bFL = matrix:transformPosition(Vector3(-xb,-yb,zb)) -- Bottom front left
			local bFR = matrix:transformPosition(Vector3(xb,-yb,zb)) -- Bottom front right
			local bRL = matrix:transformPosition(Vector3(-xb,yb,zb)) -- Bottom rear left
			local bRR = matrix:transformPosition(Vector3(xb,yb,zb)) -- Bottom rear right

			lSecession.Magnets[element] = {tFL,tFR,tRL,tRR,bFL,bFR,bRL,bRR}
		end
	end
end

functions.magnetTimer = function ()
	if functions.getSelected() and lSecession.eMagnets and lSecession.freeMovement and minDistance then
		for index,element in pairs(functions.getAllElements(true,true)) do
			local x,y,z = getElementPosition(element)
			lSecession.elementPostions[element] = lSecession.elementPostions[element] or {}
			if not (lSecession.elementPostions[1] == x) then
				functions.prepElementMagnets(element)
				lSecession.elementPostions[element] = {x,y,z}
			end
		end
	end
end

functions.checkMagnets = function (element)
    if lSecession.eMagnets and lSecession.Magnets[element] and isElementOnScreen ( element ) and lSecession.freeMovement and minDistance then
        local x,y,z = getElementPosition(element)
        local cx,cy,cz = getCameraMatrix()
        local sqrt = math.sqrt
        if getDistanceBetweenPoints3D(x,y,z,cx,cy,cz) < (lSecession.variables['Depth'][1]*2) then
            for mElement,mMagnets in pairs(lSecession.Magnets) do
                if (not functions.isSelected(mElement)) and isElement(mElement) and isElementOnScreen(mElement) then
                    local ex,ey,ez = getElementPosition(mElement)
					local dist = (getDistanceBetweenPoints3D(x,y,z,ex,ey,ez) + getElementRadius(mElement))
					if dist < minODistance then
						minODistance = (math.max(dist,(getElementRadius(mElement)-1)))
						if (getDistanceBetweenPoints3D(cx,cy,cz,ex,ey,ez) < (lSecession.variables['Depth'][1]*2)) then
							for i,v in pairs(mMagnets) do
								for ia,va in pairs(lSecession.Magnets[element]) do
									local distance = getDistanceBetweenPoints3D(va.x,va.y,va.z,v.x,v.y,v.z)
									if (distance < minDistance) then
										minDistance = distance
										lSecession.activatedMagnet[element] = {}
										lSecession.activatedMagnet[element][ia] = true
										lSecession.activatedMagnet[mElement] = {}
										lSecession.activatedMagnet[mElement][i] = true
										lSecession.activatedMagnet.Connection = {element,Vector3(v.x-va.x,v.y-va.y,v.z-va.z)}
									end
								end
							end
						end
					end
                end
            end
        end
    end
end

setTimer ( functions.magnetTimer, 1000, 0 )