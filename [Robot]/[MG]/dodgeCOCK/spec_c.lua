local spectating = false

function cam1()
	triggerEvent("onClientCall_race", root, "Spectate.stop", "auto")
	-- dont call moveplayeraway because it also carries over to other maps
	-- surely a random falling car won't mess with anything??
	-- triggerEvent("onClientCall_race", root, "MovePlayerAway.start")
	setCameraMatrix(200 - 35, 4000 - 35, 150, 255.2, 4055.2, 100)
end

function cam2()
	triggerEvent("onClientCall_race", root, "Spectate.stop", "auto")
	setCameraMatrix(310.4 + 35, 4000 - 35, 150, 255.2, 4055.2, 100)
end

function cam3()
	triggerEvent("onClientCall_race", root, "Spectate.stop", "auto")
	setCameraMatrix(200 - 35, 4110.4 + 35, 150, 255.2, 4055.2, 100)
end

function cam4()
	triggerEvent("onClientCall_race", root, "Spectate.stop", "auto")
	setCameraMatrix(310.4 + 35, 4110.4 + 35, 150, 255.2, 4055.2, 100)
end

addEvent("personSpectatored", true)
addEventHandler("personSpectatored", localPlayer, function(enabled)
	if enabled then
		spectating = true
		bindKey(1, "down", cam1)
		bindKey(2, "down", cam2)
		bindKey(3, "down", cam3)
		bindKey(4, "down", cam4)
		bindKey("b", "down", function()
			triggerEvent("onClientCall_race", root, "Spectate.start", "auto")
		end)
	end

	-- shouldnt be able to unspectate because no respawns
end)

addEventHandler("onClientRender", root, function()
	local screenWidth, screenHeight = guiGetScreenSize()

	if spectating then
		dxDrawBorderedText(0.5, "press 1-4 to view the arena, b to return to spectating", 0, screenHeight - 20,  screenWidth, screenHeight, tocolor(210, 210, 210, 255), 1.2, "arial", "center", "top", false, false, false, true)
	end
end)