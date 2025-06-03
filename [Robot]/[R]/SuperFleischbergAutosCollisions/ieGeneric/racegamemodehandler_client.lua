local RACE_RESOURCE = getResourceDynamicElementRoot(getResourceFromName("race"))

g_totalCheckpointDisplay = 0

function collectCheckpoints(target)
    local vehicle = getPedOccupiedVehicle(localPlayer)
    local checkpoint = getElementData(localPlayer, "race.checkpoint")
	if checkpoint then
		for i=checkpoint, target do
			local colshapes = getElementsByType("colshape", RACE_RESOURCE)
			if (#colshapes == 0) then
				outputConsole("[FleischBerg Autos] SOMETHING WENT HORRIBLY WRONNNNGGGGG")
				iprint("[FleischBerg Autos] SOMETHING WENT HORRIBLY WRONNNNGGGGG")
				break
			end
			triggerEvent("onClientColShapeHit", colshapes[#colshapes], vehicle, true)
		end
	end
end

function finishRace()
	setCameraMatrix (-213.5, -453.5, 63.5, -118.0, -353.8, 0.5)
	collectCheckpoints(#getElementsByType("checkpoint"))
end
addEventHandler("finishRace", localPlayer, finishRace)

function updateCheckpointText()
	if (g_totalCheckpointDisplay == "disabled" or g_totalCheckpointDisplay == 0) then
		return
	end
	local success = exports.race:setCheckpointText((g_playerCurrentTarget - 1) .. ' / ' .. g_totalCheckpointDisplay)
	if (not success) then
		g_totalCheckpointDisplay = "disabled"
	end
end