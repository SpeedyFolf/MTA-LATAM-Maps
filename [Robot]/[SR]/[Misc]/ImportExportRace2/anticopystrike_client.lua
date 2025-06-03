addEventHandler("onClientResourceStart", getRootElement(), function()	
	setInteriorSoundsEnabled(false)
end )

addEventHandler("onClientResourceStop", getRootElement(), function()
	setInteriorSoundsEnabled(true)
end )
