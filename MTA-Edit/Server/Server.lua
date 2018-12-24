--// Server is just generic helpers, keep everything else confined to their own files please // --
--- Tables ---
Cached = {} -- Saved Information (Do not store elements)
lSecession = {} -- Secession Information
sSecession = {Elements = {}} -- Shared Information (Do not store elements)
functions = {}

-- Cached (Saved) --
functions.saveCache = function ( )
	local info = toJSON(Cached)
	local newFile = fileCreate("Cache/settings.JSON")   
	if (newFile) then          
		fileWrite(newFile,info)
		fileClose(newFile)     
	end
end
addEventHandler( "onResourceStop", resourceRoot,functions.saveCache)

if fileExists('Cache/settings.JSON') then
	local file = fileOpen ('Cache/settings.JSON')
	local content = fileRead(file, fileGetSize(file))
	Cached = fromJSON(content) or {}
	fileClose(file)
end


-- lSecession (Local) --
functions.collectSecessionGarbage = function ()
	for i,v in pairs(lSecession) do
		if type(v) == 'Table' then
			if #v == 0 then
				lSecession[i] = nil
			end
		end
	end
end
setTimer ( functions.collectSecessionGarbage, 60000, 0)

-- sSecession (Shared) --
functions.fetchTableChange = function (index,changes) -- Receives change(s) from client.
	sSecession[index] = content
end

functions.sendTableChanges = function (index) -- Sends change(s) to client.
	local lTable = sSecession[index] or {}
	functions.client(root,'fetchTableChange',index,lTable)
end

--- Functions ---
functions.client = function(sendTo,...) -- Send command to server 'functions.server(function name,arguments)'
	triggerClientEvent ( "client", sendTo, ... )
end

functions.server = function(name,...) -- Receive command from client 
		if functions[name] then
		functions[name](...)
	end
end
addEvent( "server", true )
addEventHandler( "server", resourceRoot, functions.server )

functions.generateElementID = function (elementType)
	return (elementType..math.random(0,1000)..math.random(0,1000)..math.random(0,1000)..math.random(0,1000))
end





