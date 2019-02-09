-- Functions --


functions.getEDFSettings = function()
	return {list={},settings={}}
end

functions.getMetaSettings = function()
	local tempTable = {}
	tempTable.author = tostring((lSecession.variables['Author'] or {})[1])
	tempTable.description = tostring((lSecession.variables['Description'] or {})[1])
	tempTable.version = tostring((lSecession.variables['Version'] or {})[1])
	return tempTable
end

functions.Save = function()
	if (lSecession.variables['R-Name'] and lSecession.variables['Name']) and(not (lSecession.variables['R-Name'][1] == '') and not (lSecession.variables['Name'][1] == '')) then
		functions.server('saveMap',lSecession.variables['R-Name'][1],lSecession.variables['Name'][1],lSecession.variables['Map Type'][1],functions.getEDFSettings(),functions.getMetaSettings())
		functions.sendNotification('Map '..lSecession.variables['Name'][1]..lSecession.variables['Map Type'][1]..' saved to resource '..lSecession.variables['R-Name'][1]..'.')
	else
		functions.sendNotification('Please specify "R-Name" and "Name" (Under Meta) in settings','Settings')
	end
end