-- Tables --
sFunctions.vehicle = {}
sOrdering.vehicle = {}

-- Functions --

sFunctions.create.vehicle = function (vehicle)
	local model = getElementModel(vehicle)
	local x,y,z = getElementPosition(vehicle)
	local xr,yr,zr = getElementRotation(vehicle)
	local plate = getVehiclePlateText(vehicle)
	local v1,v2 = getVehicleVariant(vehicle)
	return 'local element = createVehicle('..model..','..x..','..y..','..z..','..xr..','..yr..','..zr..',"'..plate..'",nil,'..v1..','..v2..')'
end

table.insert(sOrdering.vehicle,'model')
sFunctions.vehicle.model = function (vehicle)
	local model = getElementModel(vehicle)
	return model
end

table.insert(sOrdering.vehicle,'color')
sFunctions.vehicle.color = function (vehicle)
	local c1, c2, c3, c4 = getVehicleColor ( vehicle )    
	return (c1..','..c2..','..c3..','..c4),'setVehicleColor'
end

table.insert(sOrdering.vehicle,'upgrades')
sFunctions.vehicle.upgrades = function (vehicle,stype)
	local upgrades = getVehicleUpgrades ( vehicle )
	if (#upgrades) > 0 then
		if stype == '.map' then
			return table.concat(upgrades, ",")
		elseif sType == '.lua' then
			local tTable = {}
			for i,v in pairs(upgrades) do
				table.insert(tTable,'addVehicleUpgrade(element,'..v..')')
			end
			return table.concat(upgrades, "\n"),true,nil,nil,true
		end
	end
end

table.insert(sOrdering.vehicle,'plate')
sFunctions.vehicle.plate = function (vehicle)
	local plate = getVehiclePlateText ( vehicle )
	return plate
end

table.insert(sOrdering.vehicle,'turretX')
sFunctions.vehicle.turretX = function (vehicle)
	local turretX = getVehicleTurretPosition ( vehicle )
	if not (turretX == 0) then
		return turretX
	end
end

table.insert(sOrdering.vehicle,'turretY')
sFunctions.vehicle.turretY = function (vehicle)
	local _,turretY = getVehicleTurretPosition ( vehicle )
	if not (turretY == 0) then
		return turretY
	end
end

table.insert(sOrdering.vehicle,'turrent')
sFunctions.vehicle.turrent = function (vehicle)
	local turretX,turretY = getVehicleTurretPosition ( vehicle )
	if not ((turretY == 0) and (turretX == 0)) then
		return (turrentX..','..turrentY),'setVehicleTurretPosition'
	end
end

table.insert(sOrdering.vehicle,'health')
sFunctions.vehicle.health = function (vehicle)
	local health = getElementHealth ( vehicle )
	if not (health == 1000) then
		return health,'setElementHealth'
	end
end

table.insert(sOrdering.vehicle,'sirens')
sFunctions.vehicle.sirens = function (vehicle)
	local sirensToggled = getVehicleSirensOn ( vehicle )
	if sirensToggled then
		return tostring(sirensToggled),'setVehicleSirensOn'
	end
end

table.insert(sOrdering.vehicle,'landingGearDown')
sFunctions.vehicle.landingGearDown = function (vehicle)
	local landingGearDown = getVehicleLandingGearDown ( vehicle )
	if landingGearDown then
		return tostring(landingGearDown),'setVehicleLandingGearDown'
	end
end

table.insert(sOrdering.vehicle,'locked')
sFunctions.vehicle.locked = function (vehicle)
	local locked = isVehicleLocked ( vehicle )
	if locked then
		return tostring(locked),'setVehicleLocked'
	end
end