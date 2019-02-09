-- Tables --
sFunctions.pickup = {}
sOrdering.pickup = {}

-- Functions --
functions.getPickUpAmountorModel = function(pickup)
	if (getPickUpType(pickup) == 0 or getPickUpType(pickup) == 1) then
		return getPickupAmount(pickup)
	else
		return getPickupWeapon(pickup)
	end
end

sFunctions.create.pickup = function (pickup)
	local x,y,z = getElementPosition(pickup)
	local pType = getPickUpType(pickup)
	local pAmount = functions.getPickUpAmountorModel(pickup)
	local pRespawnInterval = getPickupRespawnInterval(pickup)
	
	if pType == 2 then
		return 'local pickup = createPickup('..x..','..y..','..z..','..pType..','..pAmount..','..pRespawnInterval..','..getPickupAmmo(pickup)..')'
	else
		return 'local pickup = createPickup('..x..','..y..','..z..','..pType..','..pAmount..','..pRespawnInterval..')'
	end
end

table.insert(sOrdering.pickup,'type')
sFunctions.pickup.type = function (pickup)
	local pType = getPickupType(pickup)
	if pType == 0 then
		return 'health'
	elseif pType == 1 then
		return 'armor'
	elseif pType == 2 then
		return getPickupWeapon(pickup)
	end
end

table.insert(sOrdering.pickup,'amount')
sFunctions.pickup.amount = function (pickup)
	if getPickupType(pickup) == 3 then
		return getPickupAmmo(pickup)
	else
		return getPickupAmount(pickup)
	end
end

table.insert(sOrdering.pickup,'respawn')
sFunctions.pickup.respawn = function(pickup)
	return getPickupRespawnInterval(pickup)
end
