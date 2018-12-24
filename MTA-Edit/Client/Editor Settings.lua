-- Basic Settings --
table.insert(menus.right.items['Settings'],{'list','Editor Settings'})
menus.right['Settings'].lists['Editor Settings'] = {}


-- Freecam --
table.insert(menus.right['Settings'].lists['Editor Settings'],{'list','Free cam'})
menus.right['Settings'].lists['Free cam'] = {}

table.insert(menus.right['Settings'].lists['Free cam'],{'Option','Sensativity',{'Slow','Medium','Normal','Fast','Fastest'}})
lSecession.variables['Sensativity'] = lSecession.variables['Sensativity'] or {'Normal',3}

table.insert(menus.right['Settings'].lists['Free cam'],{'Option','Field Of View',{70,90,100,110}})
lSecession.variables['Field Of View'] = lSecession.variables['Field Of View'] or {90,2}

-- Binds --
table.insert(menus.right['Settings'].lists['Editor Settings'],{'list','Binds'})

functions.refreshBinds = function ()
	menus.right['Settings'].lists['Binds'] = {}

	for i,v in pairs(binds.sBinds) do
		table.insert(menus.right['Settings'].lists['Binds'],{'reBind',v[2],{'s',i},v[1]})
	end

	for i,v in pairs(binds.dBinds) do
		table.insert(menus.right['Settings'].lists['Binds'],{'reBind',v[2],{'d',i},v[1]})
	end
end
functions.refreshBinds()

-- UI --
table.insert(menus.right['Settings'].lists['Editor Settings'],{'list','UI'})
menus.right['Settings'].lists['UI'] = {}


table.insert(menus.right['Settings'].lists['UI'],{'Option','UI Scale',{'50%','60%','70%','80%','90%','100%','110%','120%','130%','140%','150%','160%','170%','180%','190%','200%'}})
lSecession.variables['UI Scale'] = {'100%',6}

mRender.scale = function()
	s = uScale * ((lSecession.variables['UI Scale'][2]+4)/10)
end

-- Movement --
table.insert(menus.right['Settings'].lists['Editor Settings'],{'list','Movement'})
menus.right['Settings'].lists['Movement'] = {}

table.insert(menus.right['Settings'].lists['Movement'],{'Option','Arrow Movement',{'50%','60%','70%','80%','90%','100%','110%','120%','130%','140%','150%'}})
lSecession.variables['Arrow Movement'] = {'100%',6}

