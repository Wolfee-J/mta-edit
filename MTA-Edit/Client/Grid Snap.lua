-- Quick Mafs -- 

functions.getClosestSnap = function (x,y,z)
	if (lSecession.variables['Grid'][2] > 1) then
		local snap = lSecession.variables['Grid'][1]
		local xVar,yVar,zVar = math.floor(x/snap),math.floor(y/snap),math.floor(z/snap)
		local newx,newy,newz = (xVar*snap),(yVar*snap),(zVar*snap)
		return newx,newy,newz,true
	else
		return x,y,z
	end
end

mRender.drawGrid = function()
	if (#lSecession.Selected > 0) and (lSecession.variables['Grid'][2] > 1) then
		local snap = lSecession.variables['Grid'][1]
		local xa,ya,za = functions.getSelectedElementsCenter() 
		local x,y,z = functions.getClosestSnap(xa,ya,za)
		local amount = math.max((40/snap),40)
		local half = math.max(20*snap,20)
		for i=0,amount do
			local fade = ((i < (amount/2)) and ((amount/2)-((amount/2)-i)) or (amount-i))/amount
			local color = math.min(fade*3,1)
			local ix=i-(amount/2)
			local newx = x+(ix*snap)
			dxDrawLine3D ( newx,(y-half),z, newx,(y+half),z, tocolor ( 50, 50, 50, 255*color ), 1)
			
			local iy=i-(amount/2)
			local newy = y+(iy*snap)
			dxDrawLine3D ( (x-half),newy,z, (x+half),newy,z, tocolor ( 50, 50, 50, 255*color ), 1)
		end
	end
end
