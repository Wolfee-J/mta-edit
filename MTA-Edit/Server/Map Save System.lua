-- Tables --
elementList = {'vehicle','object','pickup','marker','blip','radararea','water','ped'} -- # Every Element
functions.save = {}
-- Functions --

-- # .map
functions.getMapLine = function(element,eType)
	local line = '<'..eType
	
	for i,vA in ipairs(sOrdering[eType]) do
		local v = sFunctions[eType][vA]
		local output,_,noMap = v(element)
		if output and (not noMap) then
			line = line..' '..vA..'="'..v(element)..'"'
		end
	end
	
	for i,vA in ipairs(sOrdering.generic) do
		local v = sFunctions.generic[vA]
		local output,_,noMap = v(element)
		if output and (not noMap) then
			line = line..' '..vA..'="'..v(element)..'"'
		end
	end
	return (line..'></'..eType..'>')
end

functions.save['.map'] = function (saveLocation,saveName,defintions)
	local mapTable = {}
	for i = 1,#elementList do
		local elementType = elementList[i]
		for index,element in pairs(getElementsByType(elementType)) do
			local line = functions.getMapLine(element,elementType)
			table.insert(mapTable,line)
		end
	end
	local mapFile = fileCreate(':'..saveLocation..'/'..saveName..'.map')
	if not (defintions == '') then
		fileWrite(mapFile, '<map edf:definitions="'..defintions..'">')
	else
		fileWrite(mapFile, '<map>')
	end
	
	for i,v in pairs(mapTable) do
		fileWrite(mapFile, '\n	'..v)
	end
	fileWrite(mapFile, "\n</map>")
	fileClose(mapFile)     
end

functions.getLuaLine = function(element,eType)
	local line = sFunctions.create[eType](element)..'\n'
	for i,vA in ipairs(sOrdering.generic) do
		local v = sFunctions.generic[vA]
		local output,lua,_,alt = v(element)
		if output and lua then
			line = line..lua..'('..'element,'..(alt or output)..')\n'
		end
	end
	for i,vA in ipairs(sOrdering[eType]) do
		local v = sFunctions[eType][vA]
		local output,lua,_,useRawOutput = v(element)
		if output and lua then
			if useRawOutput then
				line = line..output..'\n'
			else	
				line = line..lua..'('..'element,'..(alt or output)..')\n'
			end
		end
	end
	return line
end

-- # .lua
functions.save['.lua'] = function (saveFolder,saveName)
	local luaTable = {}
	for i = 1,#elementList do
		local elementType = elementList[i]
		for index,element in pairs(getElementsByType(elementType)) do
			local line = functions.getLuaLine(element,elementType)
			table.insert(luaTable,line)
		end
	end
	local luaFile = fileCreate(':'..saveFolder..'/'..saveName..'.lua')
	for i,v in pairs(luaTable) do
		fileWrite(luaFile, '\n'..v)
	end
	fileClose(luaFile)     
end


-- # .JSP
functions.save['.JSP'] = function (saveFolder,saveName)
	local jspFile = fileCreate(':'..saveFolder..'/'..saveName..'.JSP')
	fileWrite(jspFile, '0,0,0\n')
	for i,v in pairs(getElementsByType('object')) do
		local name = getElementID(v)
		local interior = getElementInterior(v)
		local dimension = getElementDimension(v)
		local x,y,z = getElementPosition(v)
		local xr,yr,zr = getElementRotation(v)
		fileWrite(jspFile,name..','..interior..','..dimension..','..x..','..y..','..z..','..xr..','..yr..','..zr..'\n')
	end
	fileClose(jspFile) 
end

-- # meta.xml
functions.proccessMeta = function (mapType,folderName,mapName,edfDefintions,metaDefintions) 
	local xml = fileExists(':'..folderName..'/meta.xml')
	if xml then
		local metaFile = xmlLoadFile (':'..folderName..'/meta.xml')
		metaChildren = {}
		if metaFile then
			local children = xmlNodeGetChildren(metaFile)
			for ia,va in pairs(children or {}) do
				local type = xmlNodeGetName (va)
				if not (type == 'info') then
					local information = xmlNodeGetAttributes(va)
					if not (information.src == mapName..mapType) then
						table.insert(metaChildren,{type,(information.type or 'server'),information.src})
					end
				end
			end		
			xmlUnloadFile(metaFile)
		end
	end
	functions.generateMeta(mapType,folderName,mapName,metaChildren,edfDefintions,metaDefintions)
end


functions.generateMeta = function (mapType,folderName,mapName,metaChildren,edfDefintions,metaDefintions)
	local metaFile = fileCreate (':'..folderName..'/meta.xml')
	fileWrite(metaFile,'<meta>')
	fileWrite(metaFile,'\n<info type="map" name="'..mapName..'"')
	
	if not (table.concat(edfDefintions.list,', ')) == '' then
		fileWrite(metaFile,' gamemodes="'..table.concat(edfDefintions.list,', ')..'"')
	end
	
	if not metaDefintions.author == '' then
		fileWrite(metaFile,' author="'..metaDefintions.author..'"')
	end
	
	if not metaDefintions.description == '' then
		fileWrite(metaFile,' description="'..metaDefintions.description..'"')
	end
	
	if not metaDefintions.version == '' then
		fileWrite(metaFile,' version="'..metaDefintions.version..'"')
	end
	
	fileWrite(metaFile,' />')
	 
	if mapType == '.map' then
		fileWrite(metaFile,'\n  <map src="'..mapName..mapType..'" />') 
		elseif mapType == '.lua' then
		fileWrite(metaFile,'\n  <script type="server" src="'..mapName..mapType..'" />') 
	end
	if #edfDefintions.settings > 0 then
		fileWrite(metaFile,'\n	<settings>')
		for i,v in pairs(edfDefintions.settings) do
			if v then
				if v[1] and v[2] then
					fileWrite(metaFile,'\n		<setting name="#'..v[1]..'" value="'..v[2]..'" />')
				end
			end
		end
		fileWrite(metaFile,'\n	</settings>')
	end
	for i,v in pairs(metaChildren or {}) do
		if v[1] and v[2] then
			fileWrite(metaFile,'\n  <'..v[1]..' type="'..v[2]..'" src="'..v[3]..'" />') 
		end
	end
	fileWrite(metaFile,'\n</meta>')
	
    fileClose(metaFile) 
end

functions.saveMap = function(folderName,mapName,mapType,edfDefintions,metaDefintions) -- Defintion list is dertermined by what EDF elements are placed. Place EDF elements to get access to settings related to them.
	local map = getResourceFromName ( folderName ) or createResource ( folderName )
	if map then
		functions.proccessMeta(mapType,folderName,mapName,edfDefintions,metaDefintions)
		functions.save[mapType](folderName,mapName,table.concat(edfDefintions.list,', '))
	end
end