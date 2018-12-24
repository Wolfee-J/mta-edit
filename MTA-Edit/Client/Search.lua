-- Tables --
lSecession.searchTable = {}
lSecession.cache = {}

-- Functions --
functions.countString = function (text, search)
	if ( not text or not search ) then return false end
	
	return select ( 2, text:gsub ( search, "" ) );
end

lSecession.result = {}

functions.fetchTableItems = function(tTable,result,input,cache)
	for ia=1,#result do
		if result[ia][1] == "list" then	
			functions.fetchTableItems(tTable,(menus.right[rightMenuSelection].lists[result[ia][2]] or {}),input,cache)
		else
			for i,v in pairs(result[ia]) do
				if (i>1) then
					if (functions.countString(string.lower(tostring(v)),string.lower(tostring(input))) > 0) then
						if not cache[result[ia][2]] then
							table.insert(tTable,result[ia])
							cache[result[ia][2]] = true
						end
					end
				end
			end
		end
	end
end




functions.Search = function()
	local input = ((lSecession.variables['Search'] or {})[1])
	if not input then
		return
	end
	
	if not (input == '') then
		if lSecession.cache[rightMenuSelection] and lSecession.cache[rightMenuSelection][input] then
			lSecession.searchTable[rightMenuSelection] = (lSecession.cache[rightMenuSelection][input])
			return lSecession.cache[rightMenuSelection][input]
		else

			local result = ((menus.right.items or {})[rightMenuSelection] or {})
			local count = #result
			
			local cache = {}
			local tTable = {}
			
			for ia=1,count do
				if result[ia][1] == "list" then	
					functions.fetchTableItems(tTable,(menus.right[rightMenuSelection].lists[result[ia][2]] or {}),input,cache)
				else
					for i,v in pairs(result[i]) do
						if (i>1) then
							if (functions.countString(string.lower(tostring(v)),string.lower(tostring(input))) > 0) then
								if not cache[result[ia][2]] then
									table.insert(tTable,result[ia])
									cache[result[ia][2]] = true
								end
							end
						end
					end
				end
			end
			lSecession.cache[rightMenuSelection] = {}
			lSecession.cache[rightMenuSelection][tostring(input)] = tTable
			lSecession.searchTable[rightMenuSelection] = tTable
			return tTable
		end
	else
		lSecession.searchTable[rightMenuSelection] = nil
	end
end
