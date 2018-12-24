-- Functions
functions.getDescriptionLanguage = function(name,language)
	local name = tostring(name)
	if name then
		if fileExists('Descriptions/'..language..'/'..name..'.txt') then
			return fileOpen('Descriptions/'..language..'/'..name..'.txt')
		end
		if fileExists('Descriptions/'..name..'.txt') then
			return fileOpen('Descriptions/'..name..'.txt')
		end
	end
end


functions.retreiveDescription = function (name,language)
	local file = functions.getDescriptionLanguage(name,language)
	if file then
		functions.client(client,'retreiveDescription',name,fileRead(file, fileGetSize(file)))
		fileClose(file)
	end
end

