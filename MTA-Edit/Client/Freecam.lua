-- functions --
mRender.drawCrosshair = function ()

	local size = 50*s

	local sizea = (((getKeyState('mouse1') and 40 or 50) - getFreecamSpeed()/80)- (lSecession.highLightedElement and 5 or 0))*s
	
	local x = (xSize-size)/2
	local y = (ySize-size)/2

	local xa = (xSize-sizea)/2
	local ya = (ySize-sizea)/2

	local image = functions.prepImage('Crosshair')
	local center = functions.prepImage('Crosshair_C')

	if (not isCursorShowing()) and Cached.freeCam then
		local bColor = lSecession.freeMovement  and 0 or 255
		dxDrawImage(xa,ya,sizea,sizea,image, 0, 0, 0, tocolor(255,bColor,bColor,150),true)
		dxDrawImage(x,y,size,size,center, 0, 0, 0, tocolor(0, 0, 0, 150), true)
	end
end