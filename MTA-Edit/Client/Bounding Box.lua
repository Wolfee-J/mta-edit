-- Table --
boundingBox = {}

-- Functions --

mRender.drawBounding = function ()
	boundingBox = {}
	if lSecession.variables['Boundries'][1] == 'Bounding' then
		for index,element in pairs(lSecession.Selected) do
			functions.boundingBox (element,true)
			boundingBox[element] = true
		end
		if not boundingBox[lSecession.highLightedElement] then
			functions.boundingBox (lSecession.highLightedElement)
		end
		if not boundingBox[selectedObjectHover] then
			functions.boundingBox (selectedObjectHover)
		end
	end
end


functions.boundingBox = function (element,selected)
	if element then
		local xa,ya,za,xb,yb,zb = getElementBoundingBox ( element )
		
		local xa = (xa or -0.5)
		local ya = (ya or -0.5)
		local za = (za or -0.5)
		local xb = (xb or 0.5)
		local yb = (yb or 0.5)
		local zb = (zb or 0.5)
		
		local xa = math.min(xa,-xa)
		local ya = math.min(ya,-ya)
		local za = math.min(za,-za)
		local xb = math.max(xb,-xb)
		local yb = math.max(yb,-yb)
		local zb = math.max(zb,-zb)
		
		if xa then
			local matrix = element.matrix
			if not matrix then return end
			if getElementType(element) == 'object' then
				local sX,sY,sZ = getObjectScale(element)	
				xa,ya,za,xb,yb,zb = xa*sX,ya*sY,za*sZ,xb*sX,yb*sY,zb*sZ
			end
			
			local m1 = matrix:transformPosition(Vector3(xa,ya,za)) 		-- Top front left
			local m2 = matrix:transformPosition(Vector3(-xa,ya,za))		-- Top front right
			local m3 = matrix:transformPosition(Vector3(xa,-ya,za)) 	-- Top rear left
			local m4 = matrix:transformPosition(Vector3(-xa,-ya,za)) 	-- Top rear right
			
			local m5 = matrix:transformPosition(Vector3(-xb,-yb,zb))    -- Bottom front left
			local m6 = matrix:transformPosition(Vector3(xb,-yb,zb)) 	-- Bottom front right
			local m7 = matrix:transformPosition(Vector3(-xb,yb,zb)) 	-- Bottom rear left
			local m8 = matrix:transformPosition(Vector3(xb,yb,zb)) 	 	-- Bottom rear right
			
			local x1,y1,z1 = m1.x,m1.y,m1.z
			local x2,y2,z2 = m2.x,m2.y,m2.z
			local x3,y3,z3 = m3.x,m3.y,m3.z
			local x4,y4,z4 = m4.x,m4.y,m4.z
			
			local x5,y5,z5 = m5.x,m5.y,m5.z
			local x6,y6,z6 = m6.x,m6.y,m6.z
			local x7,y7,z7 = m7.x,m7.y,m7.z
			local x8,y8,z8 = m8.x,m8.y,m8.z
			
			local cColor = nil
			
			if selected then
				cColor = tocolor ( 255, 0, 0, 230 )
			end

			if (element == lSecession.highLightedElement) then
				cColor = tocolor ( 255, 180, 0, 230 )
			end

			if selected and (element == lSecession.highLightedElement) then
				cColor = tocolor ( 0, 0, 255, 230 )
			end
			
			if (element == selectedObjectHover) then
				cColor = tocolor ( 255, 100, 0, 230 )
			end
			
			if selected and (element == selectedObjectHover) then
				cColor = tocolor ( 255, 50, 0, 230 )
			end


			dxDrawLine3D ( x1,y1,z1,x2,y2,z2,cColor, 3) -- TFL -> TFR
			dxDrawLine3D ( x1,y1,z1,x5,y5,z5,cColor, 3) -- TFL -> BFL
			dxDrawLine3D ( x1,y1,z1,x3,y3,z3,cColor, 3) -- TFL -> TRL

			dxDrawLine3D ( x2,y2,z2,x4,y4,z4,cColor, 3) -- TFR -> TRR
			dxDrawLine3D ( x2,y2,z2,x6,y6,z6,cColor, 3) -- TFR -> BFR

			dxDrawLine3D ( x4,y4,z4,x3,y3,z3,cColor, 3) -- TRR -> TRL
			dxDrawLine3D ( x4,y4,z4,x8,y8,z8,cColor, 3) -- TRR -> BRR

			dxDrawLine3D ( x7,y7,z7,x3,y3,z3,cColor, 3) -- BRL -> TRL
			dxDrawLine3D ( x7,y7,z7,x5,y5,z5,cColor, 3) -- BRL -> BFL
			dxDrawLine3D ( x7,y7,z7,x8,y8,z8,cColor, 3) -- BRL -> BRR

			dxDrawLine3D ( x6,y6,z6,x8,y8,z8,cColor, 3) -- BFR -> BRR
			dxDrawLine3D ( x6,y6,z6,x5,y5,z5,cColor, 3) -- BFR -> BRR
		end
	end
end