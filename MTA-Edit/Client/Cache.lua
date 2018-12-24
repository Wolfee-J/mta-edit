-- Functions --
functions.saveCache = function ( )
	local newFile = fileCreate("Cache/settings.JSON")   
	for i,v in pairs(vCache) do
		Cached[i] = lSecession.variables[i]
	end
	
	Cached.Favorites = {}
	for i,v in pairs(menus.right.header) do
		Cached.Favorites[v] = menus.right[v].lists['Favorites']
	end
	
	Cached.sBinds = {}
	for i,v in pairs(binds.sBinds) do
		table.insert(Cached.sBinds,{i,v[1]})
	end
	Cached.dBinds = {}
	for i,v in pairs(binds.dBinds) do
		table.insert(Cached.dBinds,{i,v[1]})
	end
	
	
	if Cached.freeCam then
		local x,y,z = getCameraMatrix()
		setFreecamDisabled()
		setElementPosition(localPlayer,x,y,z)
		setCameraTarget(localPlayer)
	end
	Cached.freeCam = nil
	
	local info = toJSON(Cached)
	
	if (newFile) then          
		fileWrite(newFile,info)
		fileClose(newFile)     
	end
end
addEventHandler( "onClientResourceStop", resourceRoot,functions.saveCache)


if fileExists('Cache/settings.JSON') then
	local file = fileOpen ('Cache/settings.JSON')
	local content = fileRead(file, fileGetSize(file))
	Cached = fromJSON(content) or {}
	fileClose(file)
	for i,v in pairs(vCache) do
		lSecession.variables[i] = Cached[i]
	end
	
	if Cached.freeCam then
		Cached.freeCam = nil
	end
	for i,v in pairs(Cached.Favorites) do
		menus.right[i].lists['Favorites'] = v
	end
	
	if Cached.sBinds then
		for i,v in pairs(Cached.sBinds) do
			if v then
				binds.sBinds[v[1]][1] = v[2]
			end
		end
		for i,v in pairs(Cached.dBinds) do
			if v then
				binds.dBinds[v[1]][1] = v[2]
			end
		end
		functions.refreshBinds()
	end
end