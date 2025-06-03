local checkpointsPos = {
	{ x = -1398.3552, y = -197.2079, z = 1043.1188 }, -- 1
	{ x = -1398.9879, y = -188.7892, z = 1043.2023 },
	{ x = -1465.9392, y = -134.0836, z = 1046.0107 },
	{ x = -1530.1384, y = -193.3988, z = 1050.7562 },
	{ x = -1415.6857, y = -274.1765, z = 1051.1486 },
	{ x = -1305.1776, y = -143.5283, z = 1050.1254 },
	{ x = -1302.7737, y = -268.6358, z = 1048.4873 },
	{ x = -1398.3552, y = -197.2079, z = 1043.1188 } -- 8
}

local CHECKPOINT_RADIUS = 10

local currentPosition = 1
local checkpoint

function playRandomSFX()
	if math.random(3) == 1 then playSFX("script", 6, 1, false)
	else playSFX("script", 171, math.random(0, 5), false) end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Music 
	setInteriorSoundsEnabled(false)
	outputChatBox("Press M to turn stadium music ON/OFF")
	
	-- Create checkpoints
	checkpoint = createColSphere(checkpointsPos[currentPosition].x, checkpointsPos[currentPosition].y, checkpointsPos[currentPosition].z, CHECKPOINT_RADIUS)
	
	addEventHandler("onClientColShapeHit", root, function(element, dim)
		if source == checkpoint and element and getElementType(element) == "vehicle" and getVehicleOccupant(element) and getVehicleOccupant(element) == localPlayer then
			playRandomSFX()
			
			-- Destroy old checkpoint and update progress
			destroyElement(checkpoint)
			currentPosition = currentPosition + 1
			if currentPosition > 8 then
				-- New lap
				currentPosition = 1
				
				local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
				if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], getPedOccupiedVehicle(localPlayer)) end
			end
			
			-- Create new checkpoint
			checkpoint = createColSphere(checkpointsPos[currentPosition].x, checkpointsPos[currentPosition].y, checkpointsPos[currentPosition].z, CHECKPOINT_RADIUS)
		end
	end )
end )

-- Interior handler
addEventHandler("onClientPreRender", root, function()
	local list = { "spawnpoint", "vehicle", "player", "ped" }
	for _, type in ipairs(list) do
		for _, v in ipairs(getElementsByType(type, getResourceDynamicElementRoot(getResourceFromName("race")))) do
			setElementInterior(v, 7)
		end
	end
	
	for _, v in pairs(getElementsByType("blip")) do
		local r, g, b, a = getBlipColor(v)
		if r == 0 and g == 0 and b == 0 then
			setBlipVisibleDistance(v, 0)
		end
	end
end )

-- Respawn handler 
addEventHandler("onClientVehicleEnter", root, function(ped, seat)
	if ped == localPlayer then currentPosition = 1 end
end )

addCommandHandler("togglemusic", function() setInteriorSoundsEnabled(not getInteriorSoundsEnabled()) end)
bindKey("m","down", "togglemusic")
