-- Basic Settings --

functions.getSetting = function(element,sType,setting)
	if element then
		if sType == 'data' then
			return getElementData(element,setting)
		else
			if mGet[sType] then
				return mGet[sType](element)
			end
		end
	end
end

functions.isSetting = function(sType,setting,expectedValue)
	for i,v in pairs(lSecession.Selected) do
		if (functions.getSetting(v,sType,setting)) then
			return true
		end
	end
end


functions.findSetting = function(sType,setting)
	value = functions.getSetting(lSecession.Selected[1],sType,setting)
	for i,v in pairs(lSecession.Selected) do
		if not (functions.getSetting(v,sType,setting) == value) then
			return ''
		end
	end
	return value
end

functions.getCompatableUpgrades = function()
	local upgrades = {}
	for i,v in pairs(lSecession.Selected) do
		if type(v) == 'vehicle' then
			for ia,va in pairs(getVehicleCompatibleUpgrades (v)) do
				upgrades[getVehicleUpgradeSlotName[va]] = upgrades[getVehicleUpgradeSlotName[va]] or {}
				upgrades[getVehicleUpgradeSlotName[va]][va] = true
			end
		end
	end
	return upgrades
end

-- FINISH UP ON A LATER DATE --

functions.prepCustomization = function ()
	menus.right.items['Customize'] = {}

	table.insert(menus.right.items['Customize'],{'Number Box','Interior'})
		lSecession.variables['Interior'] = {functions.findSetting('Interior')}
	table.insert(menus.right.items['Customize'],{'Number Box','Dimension'})
		lSecession.variables['Dimension'] = {functions.findSetting('Dimension')}
	table.insert(menus.right.items['Customize'],{'Check Box','Frozen'})
		lSecession.variables['Frozen'] = {functions.findSetting('Frozen')}
	table.insert(menus.right.items['Customize'],{'Check Box','Collidable'})
		lSecession.variables['Collidable'] = {functions.findSetting('Collidable')}
	table.insert(menus.right.items['Customize'],{'Number Box','Alpha'})
		lSecession.variables['Alpha'] = {functions.findSetting('Alpha')}

--[[ TODO ON LATER DATE, CANNOT FINISH BEFORE LAUNCH
	if functions.isSetting('data','Edf',true) then
		table.insert(menus.right.items['Customize'],{'list','EDF'})
		menus.right['Customize'].lists['EDF'] = {}  

		for name,content in pairs(functions.getEDFSettings()) do
			table.insert(menus.right['Customize'].lists['EDF'],{'list',name})
			menus.right['Customize'].lists[name] = {}  
			for i,v in pairs(content) do
				local sType = v.type
				local sName = v.name
				local sDefault = v.default
				
				if sType and sName and sDefault then
					
					if sType == 'boolean' then
						table.insert(menus.right['Customize'].lists[name],{'Check Box',sName})
						lSecession.variables[sName] = {(functions.findSetting('data',sName) == 2)}
					elseif sType == 'natural' then
						table.insert(menus.right['Customize'].lists[name],{'Number Box',sName,nil,nil,nil,nil,true,true})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'integer' then
						table.insert(menus.right['Customize'].lists[name],{'Number Box',sName,nil,nil,nil,nil,true})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'number' then
						table.insert(menus.right['Customize'].lists[name],{'Number Box',sName})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'string' then
						table.insert(menus.right['Customize'].lists[name],{'Edit Box',sName})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'color' then
						table.insert(menus.right['Customize'].lists[name],{'Color Picker',sName})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'camera' then
						table.insert(menus.right['Customize'].lists[name],{'Camera',sName})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'plate' then
						table.insert(menus.right['Customize'].lists[name],{'Edit Box',sName,nil,nil,nil,nil,true})
						lSecession.variables[sName] = {(functions.findSetting('data',sName))}
					elseif sType == 'vehiclecolors' then
						table.insert(menus.right['Customize'].lists[name],{'list',sName})
						menus.right['Customize'].lists[sName] = {}  
						local tabl = {}
						for ia=0,126 do
							tabl[ia+1] = ia
						end
						table.insert(menus.right['Customize'].lists['Vehicle Colors'],{'Option','Color1',tabl})
						table.insert(menus.right['Customize'].lists['Vehicle Colors'],{'Option','Color2',tabl})
						table.insert(menus.right['Customize'].lists['Vehicle Colors'],{'Option','Color3',tabl})
						table.insert(menus.right['Customize'].lists['Vehicle Colors'],{'Option','Color4',tabl})
					elseif sType == 'vehicleupgrades' then
						local upgrades = functions.getCompatableUpgrades() 
						if not (upgrades == {}) then
							table.insert(menus.right['Customize'].lists[name],{'list',sName})
							menus.right['Customize'].lists[sName] = {}  
							for ia,va in pairs(upgrades) do
								table.insert(menus.right['Customize'].lists[sName],{'list',ia})
								menus.right['Customize'].lists[ia] = {}  
								for ib,vb in pairs(va) do
									table.insert(menus.right['Customize'].lists[ia],{'Check Box',vb,menus.right['Customize'].lists[ia]})
								end
							end
						end
					elseif sType == 'colshapeType' then
						table.insert(menus.right['Customize'].lists[name],{'Option',sName,{"colcircle", "colcube", "colrectangle", "colsphere", "coltube"}})
					elseif sType == 'markerType' then
						table.insert(menus.right['Customize'].lists[name],{'Option',sName,{"arrow", "checkpoint", "corona", "cylinder", "ring"}})
					end
				end
			end
		end
	end
	]]--
	table.insert(menus.right.items['Customize'],{'list','Generic'})
end




