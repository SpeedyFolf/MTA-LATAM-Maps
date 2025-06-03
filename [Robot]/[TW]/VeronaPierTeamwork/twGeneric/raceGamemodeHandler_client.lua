local RACE_RESOURCE = getResourceDynamicElementRoot(getResourceFromName("race"))

function collectCheckpoints(target)
    local vehicle = getPedOccupiedVehicle(localPlayer)
    local checkpoint = getElementData(localPlayer, "race.checkpoint")
	if checkpoint then
		for i=checkpoint, target do
			local colshapes = getElementsByType("colshape", RACE_RESOURCE)
			if (#colshapes == 0) then
				outputConsole("[Teamwork] SOMETHING WENT HORRIBLY WRONNNNGGGGG")
				iprint("[Teamwork] SOMETHING WENT HORRIBLY WRONNNNGGGGG")
				break
			end
			triggerEvent("onClientColShapeHit", colshapes[#colshapes], vehicle, true)
		end
	end
end