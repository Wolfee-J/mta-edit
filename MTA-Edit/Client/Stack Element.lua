-- Functions --

functions.getAlignment = function(element,x,y,z)

	local xa,ya,za,xb,yb,zb = getElementBoundingBox ( element )
	if xa then

		local matrix = element.matrix
		
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
		
		--
		local A = m1 -- Top Front left
		local B = m7 -- Bottom Rear Left
		local disXf = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m3 -- Top rear left
		local B = m5 -- Bottom front left
		local disXf = (disXf+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m2 -- Top Front right
		local B = m8 -- Bottom Rear right
		local disXr = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m4 -- Top rear right
		local B = m6 -- Bottom front right
		local disXr = (disXr+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		--
		local A = m1 -- Top Front left
		local B = m6 -- Bottom Front Right
		local disYf = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m2 -- Top Front right
		local B = m5 -- Bottom front left
		local disYf = (disYf+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m3 -- Top Rear left
		local B = m8 -- Bottom Rear Right
		local disYr = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m4 -- Top Rear right
		local B = m7 -- Bottom Rear left
		local disYr = (disYr+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		--
		local A = m1 -- Top Front left
		local B = m4 -- Top Rear Right
		local disZf = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m3 -- Top Rear Left
		local B = m2 -- Top Front Right
		local disZf = (disZf+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m5 -- Bottom Front left
		local B = m8 -- Bottom Rear Right
		local disZr = functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m7 -- Bottom Rear Left
		local B = m6 -- Bottom Front Right
		local disZr = (disZr+functions.getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		local minDis = math.min(disXf,disXr,disYf,disYr,disZf,disZr)
		
		if minDis == disXr then
			return (matrix:transformPosition(Vector3(xb-xa,0,0)))
		elseif minDis == disXf then
			return (matrix:transformPosition(Vector3(xa-xb,0,0)))
		elseif minDis == disYr then
			return (matrix:transformPosition(Vector3(0,yb-ya,0)))
		elseif minDis == disYf then
			return (matrix:transformPosition(Vector3(0,ya-yb,0)))
		elseif minDis == disZr then
			return (matrix:transformPosition(Vector3(0,0,zb-za)))
		elseif minDis == disZf then
			return (matrix:transformPosition(Vector3(0,0,za-zb)))
		end
	end
end

