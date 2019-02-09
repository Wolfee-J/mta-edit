-- Tables --
lSecession.Notifications = {}

-- Functions --
functions.sendNotification = function (notification,image)
	if tostring(notification) then
		outputConsole (tostring(notification))
		table.insert(lSecession.Notifications,{tostring(notification),math.random(100,100000),100,nil,image})
	end
end

mRender.drawNotifications = function()
	for i,v in ipairs(lSecession.Notifications) do
		v[3] = v[3]-0.5
		
		v[4] = v[4] or i
		if i > v[4] then
			v[4] = math.min(v[4]+0.1,i)
		elseif i < v[4] then
			v[4] = math.max(v[4]-0.1,i)
		end
		
		local i = v[4]
		
		local va = math.min(v[3],30)
		local alpha = (math.max(va)/30)
		local width = math.max(((dxGetTextWidth (v[1],1,'default-bold' ))*1.5),300*s)
		dxDrawRectangle ((xSize/2)-(width/2), ((29*s)*i), width, (28*s),tocolor(0,0,0,150*alpha))
		if v[5] then
			dxDrawImage ( (xSize/2)+((dxGetTextWidth (v[1],1,'default-bold' ))/2), ((29*s)*i)+(4*s), (20*s), (20*s), functions.prepImage(v[5]), 0, 0, 0,tocolor(230,230,230,230*alpha) )
			dxDrawText(v[1], (xSize/2)-(width/2)-(15*s), ((29*s)*i), (xSize/2)+(width/2), ((29*s)*(i+1)), tocolor(255, 255, 255, 150*alpha), 1, "default-bold", "center", "center", false, false, false, true, false)
		else
			dxDrawText(v[1], (xSize/2)-(width/2), ((29*s)*i), (xSize/2)+(width/2), ((29*s)*(i+1)), tocolor(255, 255, 255, 150*alpha), 1, "default-bold", "center", "center", false, false, false, true, false)
		end
		if alpha < 0.1 then
			table.remove(lSecession.Notifications,i)
		end
	end
end

functions.receiveVersion = function(version)
	functions.sendNotification('MTA-Edit, Version - '..version)
end

functions.server('sendVersion')