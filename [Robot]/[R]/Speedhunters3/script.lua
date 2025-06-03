--Settings: 1: red, 2, yellow, 3 green, 4 blue, 5 pink
number = 4

addEventHandler("onClientResourceStart",resourceRoot,
	function ()

		dff = engineLoadDFF ('carshowwin_sfsx.dff', 0) 
		engineReplaceModel (dff, 3851)

	end
)

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		local shader = dxCreateShader ("shader.fx")

		if not shader then
			return outputChatBox ( "Could not create shader. Please use debugscript 3" )
		end
		
		local texture = dxCreateTexture ("images/image"..number..".png","dxt5")
		dxSetShaderValue (shader, "Tex", texture)
		engineApplyShaderToWorldTexture (shader, "ws_carshowwin1")
		engineSetModelLODDistance (3851, 100)
	end
)