-- Tables --
sFunctions.water = {}
sOrdering.water = {}

-- Functions --
sFunctions.create.water = function (water)
	local tTable = {}
	for i=1,4 do
		local x,y,z = getWaterVertexPosition(water,i)
		tTable[i] = x..','..y..','..z
	end
	return 'local element = createWater('..table.concat(tTable,',')..')'
end

table.insert(sOrdering.water,'posX1')
sFunctions.water.posX1 = function (water)
	local x = getWaterVertexPosition(water,1)
	return x
end

table.insert(sOrdering.water,'posY1')
sFunctions.water.posY1 = function (water)
	local _,y = getWaterVertexPosition(water,1)
	return y
end

table.insert(sOrdering.water,'posZ1')
sFunctions.water.posZ1 = function (water)
	local _,_,z = getWaterVertexPosition(water,1)
	return z
end

table.insert(sOrdering.water,'posX2')
sFunctions.water.posX2 = function (water)
	local x = getWaterVertexPosition(water,2)
	return x
end

table.insert(sOrdering.water,'posY2')
sFunctions.water.posY2 = function (water)
	local _,y = getWaterVertexPosition(water,2)
	return y
end

table.insert(sOrdering.water,'posZ2')
sFunctions.water.posZ2 = function (water)
	local _,_,z = getWaterVertexPosition(water,2)
	return z
end

table.insert(sOrdering.water,'posX3')
sFunctions.water.posX3 = function (water)
	local x = getWaterVertexPosition(water,3)
	return x
end

table.insert(sOrdering.water,'posY3')
sFunctions.water.posY3 = function (water)
	local _,y = getWaterVertexPosition(water,3)
	return y
end

table.insert(sOrdering.water,'posZ3')
sFunctions.water.posZ3 = function (water)
	local _,_,z = getWaterVertexPosition(water,3)
	return z
end

table.insert(sOrdering.water,'posX4')
sFunctions.water.posX4 = function (water)
	local x = getWaterVertexPosition(water,4)
	return x
end

table.insert(sOrdering.water,'posY4')
sFunctions.water.posY4 = function (water)
	local _,y = getWaterVertexPosition(water,4)
	return y
end

table.insert(sOrdering.water,'posZ4')
sFunctions.water.posZ4 = function (water)
	local _,_,z = getWaterVertexPosition(water,4)
	return z
end



