
local lapcps = 16

local zones = {
 [1] = "Variante del Rettifilo",
 [4] = "Curva Grande",
 [6] = "Variante della Roggia",
 [8] = "Curve di Lesmo",
 [9] = "Curve di Lesmo",
 [10] = "Curva del Serraglio",
 [11] = "Variante Ascari",
 [14] = "Curva Parabolica",
 [15] = "Rettifilo Tribune"
}

addEventHandler("onPlayerReachCheckpoint", root, 
	function(checkpointNum, time)
		local zone = nil
		
		while checkpointNum > lapcps do
			checkpointNum = checkpointNum - lapcps
		end
		
		if zones[checkpointNum] then
			triggerClientEvent(source, "onClientZoneChange", source, zones[checkpointNum], checkpointNum)
		end
	end
)