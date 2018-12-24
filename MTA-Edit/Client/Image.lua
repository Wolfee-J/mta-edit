-- Tables --
lSecession.images = {}
keyReplace = {}
keyReplace['.'] = 'dot'
-- Functions -- 

functions.findPath = function (path)
	if fileExists('Content/'..path..'.png') then
		return ('Content/'..path..'.png')
	elseif fileExists('Content/keys/'..path..'.png') then
		return ('Content/keys/'..path..'.png')
	elseif fileExists('Content/EDF/'..path..'.png') then
		return ('Content/EDF/'..path..'.png')
	end
end


functions.prepImage = function(path,mip)
	local path = keyReplace[path] or path
	if path then
		local path = functions.findPath(path)
		if path then
		if (not lSecession.images[path]) and fileExists(path) then
				lSecession.images[path] = {}
				local img = fileOpen(path)
				local pixels = fileRead(img, fileGetSize(img))
				fileClose(img)
				local x,y = dxGetPixelsSize(pixels)
				lSecession.images[path].scale = {x,y}
				lSecession.images[path].image = lSecession.images[path].image or dxCreateTexture(path,'dxt5',not mip,'clamp')--not mip
			end
			if fileExists(path) then
				return lSecession.images[path].image,lSecession.images[path].scale
			else
				return nil
			end
		end
	end
end

functions.getImageSize = function (path)
	local path = keyReplace[path] or path
	if path then
		local path = functions.findPath(path)
		return lSecession.images[path].scale
	end
end

functions.preloadImages = function(imageList) -- This receives the files from the server and ensures the map editor preloads every image.
	for index,image in pairs(imageList) do
		functions.prepImage(image)
	end
end
functions.server('initiatePreload')

-- MTA function replacements --
--local rectangle = functions.prepImage('Rectangle')
--function dxDrawRectangle(x,y,w,h,c,p) -- Default function broken for this with custom themes.
--dxDrawImage(x,y,w,h,rectangle, 0, 0, 0,c, p)
--end

function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... ) -- Well, I mean it should be a function yeah?.
	return dxDrawMaterialLine3D( x, y, z, x + width, y + height, z + tonumber( rotation or 0 ), material, height, color or 0xFFFFFFFF, ... )
end

