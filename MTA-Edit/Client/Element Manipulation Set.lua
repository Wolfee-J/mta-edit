-- Functions (mSet) --

mSet.Position = function (element,x,y,z)
	setElementPosition(element,x,y,z)
	functions.syncITransformationsC(element) -- Force element transformation to update server side. (Sync Individual Transformations)
end

mSet.Rotation = function (element,xr,yr,zr)
	setElementRotation(element,xr,yr,zr)
	functions.syncITransformationsC(element)
end


