-- Tables --
highlightRT = dxCreateRenderTarget( xSize,ySize, true )
highLightShaders = {}
shaderApplied = {}

--highLightShaders['Global'] = {255, 50, 0}
highLightShaders['Hover'] = {255, 180, 0}
highLightShaders['Selected'] = {255,0,0} 
highLightShaders['Hover Selected'] = {0, 0, 255}

highLightShaders['List Hover'] = {255, 100, 0}
highLightShaders['Selected List Hover'] = {255, 50, 0}



-- Functions --

functions.createShaders = function ()
	 for i,v in pairs(highLightShaders) do
		local r,g,b = unpack(v)
		
		local highLightShader = dxCreateShader( "Content/selectorCol.fx", 1, 0, true )
		dxSetShaderValue(highLightShader, "secondRT", highlightRT)
		dxSetShaderValue(highLightShader, "sColorizePed",r/255,g/255,b/255,1)
		
		local postHighLightShader = dxCreateShader( "Content/Highlight.fx", 1, 0, true )
		dxSetShaderValue(postHighLightShader, "sRes", xSize,ySize)
		dxSetShaderValue(postHighLightShader, "sTex0", highlightRT)
		highLightShaders[i] = {highLightShader,postHighLightShader}
	 end
end
functions.createShaders ()


functions.AddElementToSelection = function(element,selectionType)
	if isElement(element) then
		functions.RemoveElementFromSelection(element)
		shaderApplied[element] = true
		if (selectionType == 'Hover') and getElementData(element,'Selected') then
		engineApplyShaderToWorldTexture( highLightShaders['Hover Selected'][1], "*", element )
		elseif (selectionType == 'List Hover') and getElementData(element,'Selected') then
		engineApplyShaderToWorldTexture( highLightShaders['Selected List Hover'][1], "*", element )
		else
		engineApplyShaderToWorldTexture( highLightShaders[selectionType or 'Selected'][1], "*", element )
		end
	end
end

functions.RemoveElementFromSelection = function(element)
	shaderApplied[element] = nil
	for i,v in pairs(highLightShaders) do
		if isElement(element) then
			engineRemoveShaderFromWorldTexture( v[1], "*", element )
		end
	end
end

functions.processElements = function ()
	for i,v in pairs(shaderApplied) do
		functions.RemoveElementFromSelection(i)
	end
	if lSecession.variables['Boundries'][1] == 'Highlight' then
		for i,v in pairs(lSecession.Selected) do
			functions.AddElementToSelection(v)
		end
		if lSecession.highLightedElement then
			functions.AddElementToSelection(lSecession.highLightedElement,'Hover')
		end
		if selectedObjectHover then
			functions.AddElementToSelection(selectedObjectHover,'List Hover')
		end
	end
end
setTimer(functions.processElements,50,0)

functions.onClientHUDRenderFunction = function()
	if lSecession.variables['Boundries'][1] == 'Highlight' then
		for i,v in pairs(highLightShaders) do
			dxDrawImage( 0, 0, xSize,ySize, v[2] )
		end
		dxSetRenderTarget( highlightRT, true )
		dxSetRenderTarget()
	end
end

addEventHandler( "onClientHUDRender", root, functions.onClientHUDRenderFunction )
