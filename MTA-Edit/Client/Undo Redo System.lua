-- Table --
lSecession.undo = {}
lSecession.redo = {}

-- Function --

functions.addUndo = function(types,fromRedo)
	if (#lSecession.undo) > 50 then
		table.remove(lSecession.redo,1)
	end
	if not fromRedo then
		lSecession.redo = {}
	end
	local tempTable = {{types}}
	for i,element in pairs(lSecession.Selected) do
		if type(types) == 'table' then
			for index,t in pairs(types) do
				if mGet[t] then
					table.insert(tempTable,{element,t,{mGet[t](element,true)}})
				end
			end
		else
			if mGet[types] then
				table.insert(tempTable,{element,types,{mGet[types](element,true)}})
			end
		end
	end
	if (#tempTable > 1) then
	table.insert(lSecession.undo,tempTable)
	end
end

functions.addRedo = function(types)
	if (#lSecession.redo) > 50 then
		table.remove(lSecession.redo,1)
	end
	local tempTable = {{types}}
	for i,element in pairs(lSecession.Selected) do
		if type(types) == 'table' then
			for index,t in pairs(types) do
				if mGet[t] then
					table.insert(tempTable,{element,t,{mGet[t](element,true)}})
				end
			end
		else
			if mGet[types] then
				table.insert(tempTable,{element,types,{mGet[types](element,true)}})
			end
		end
	end
	if (#tempTable > 1) then
		table.insert(lSecession.redo,tempTable)
	end
end

functions.Undo = function()
	local tempTable = (lSecession.undo[#lSecession.undo])
	if tempTable then
		lSecession.undo[#lSecession.undo] = nil
		local types = tempTable[1][1]
		functions.addRedo(types)
		for i,v in pairs(tempTable) do
			if v[2] then
				local element = v[1]
				local type = v[2]
				local value = v[3]
				if value then
					if mSet[type] then
						mSet[type](element,unpack(value))
					end
				end
			end
		end
	end
end

functions.Redo = function()
	local tempTable = (lSecession.redo[#lSecession.redo])
	if tempTable then
		lSecession.redo[#lSecession.redo] = nil
		local types = tempTable[1][1]
		functions.addUndo(types,true)
		for i,v in pairs(tempTable) do
			if v[2] then
				local element = v[1]
				local type = v[2]
				local value = v[3]
				if mSet[type] then
					mSet[type](element,unpack(value))
				end
			end
		end
	end
end


