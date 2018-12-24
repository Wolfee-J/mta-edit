-- Functions --

functions['List EDF'] = function (list)
	local edfTable = {}
	local edfSettings = {}
	for resource,index in pairs(list) do
		local EDF = getResourceInfo(getResourceFromName(resource),'edf:definition')
		if EDF then
			local xml = fileExists(':'..resource..'/'..EDF)
			if xml then
				local edfXML = xmlLoadFile (':'..resource..'/'..EDF)
				edfTable[resource] = {}
				if edfXML then
					local children = xmlNodeGetChildren(edfXML)
					for i,v in pairs(children) do
						if xmlNodeGetName(v) == 'element' then
							local a = xmlNodeGetAttributes(v)
							local name = a.name
							local fname = a.friendlyname
							edfSettings[name] = edfSettings[name] or {}
							local settings = xmlNodeGetChildren(v)
							table.insert(edfTable[resource],{name,fname})
							for i,v in pairs(settings) do
								table.insert(edfSettings[name],xmlNodeGetAttributes(v))
							end
						end
					end
					xmlUnloadFile(edfXML)
				end
			end
		end
	end
	functions.client(client,'populateEDF',edfTable)
	functions.client(client,'populateEDFSettings',edfSettings)
end



functions['List Gamemodes'] = function ()
local gTable = {}
	for i,v in pairs(getResources ()) do
		local type = getResourceInfo (v,'type') 
		if type == 'gamemode' then
			table.insert(gTable,getResourceName(v))
		end
	end
	functions.client(client,'populateModes',gTable)
end