local checkpointsPos = {
	{ x = -1377.6098, y = -589.5136, z = 1056.5729 }, -- 1
	{ x = -1431.1766, y = -588.3124, z = 1054.5120 },
	{ x = -1516.8740, y = -635.0942, z = 1050.2751 },
	{ x = -1500.6779, y = -719.0175, z = 1051.6433 },
	{ x = -1387.5020, y = -743.1501, z = 1051.0165 },
	{ x = -1295.5396, y = -705.3506, z = 1055.2552 },
	{ x = -1365.3123, y = -666.0998, z = 1055.0581 },
	{ x = -1486.5000, y = -636.4586, z = 1052.2252 },
	{ x = -1447.8599, y = -690.3426, z = 1052.8342 },
	{ x = -1389.9077, y = -720.9943, z = 1055.1191 },
	{ x = -1370.6849, y = -687.8977, z = 1053.7834 },
	{ x = -1399.1357, y = -635.8359, z = 1051.0432 },
	{ x = -1308.6388, y = -649.4201, z = 1054.9724 },
	{ x = -1354.3584, y = -590.5628, z = 1055.4529 } -- 14
}  

local CHECKPOINT_RADIUS = 13

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
			if currentPosition > #checkpointsPos then
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
			setElementInterior(v, 4)
		end
	end
	
	for _, v in pairs(getElementsByType("blip")) do
		local r, g, b, a = getBlipColor(v)
		if r == 0 and g == 0 and b == 0 then
			setBlipVisibleDistance(v, 0)
		end
	end
end )

-- Music handler
addEventHandler("onClientResourceStop", resourceRoot, function()
	setInteriorSoundsEnabled(false)
end )

-- Respawn handler 
addEventHandler("onClientVehicleEnter", root, function(ped, seat)
	if ped == localPlayer then currentPosition = 1 end
end )

addCommandHandler("togglemusic", function() setInteriorSoundsEnabled(not getInteriorSoundsEnabled()) end)
bindKey("m","down", "togglemusic")

