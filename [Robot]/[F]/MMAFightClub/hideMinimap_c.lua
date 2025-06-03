addEventHandler("onClientResourceStart", getRootElement(), function()
	setPlayerHudComponentVisible("radar", false)
end)

addEventHandler("onClientResourceStop", getRootElement(), function()
	setPlayerHudComponentVisible("radar", true)
end)
