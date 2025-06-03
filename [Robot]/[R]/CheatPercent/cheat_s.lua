updateTimer = nil

function update()
	for _, players in ipairs(getElementsByType("player")) do
		if getPedOccupiedVehicle(players) then
			if getElementData(players, "changecar") ~= nil and getElementData(players, "changecar") ~= false and getElementData(players, "changecar") ~= 0 then 
				if getElementModel(getPedOccupiedVehicle(players)) ~= tonumber(getElementData(players, "changecar")) then
					local x, y, z = getElementPosition(getPedOccupiedVehicle(players))
					setElementPosition(getPedOccupiedVehicle(players), x, y, z + 2)
					
					setElementModel(getPedOccupiedVehicle(players), tonumber(getElementData(players, "changecar")))
					setElementData(players, "changecar", 0)
				end
			end
		end
	end
end

addEvent("onMapStarting", true)
addEventHandler("onMapStarting", resourceRoot, function()
	if isTimer(updateTimer) then killTimer(updateTimer) end
	updateTimer = setTimer(update, 50, 0)
	
	outputChatBox("#00FF00Enter #FF0000cheat codes #00FF00from original game to win the #FF0000race#00FF00!", root, 0, 246, 255, true)
	outputChatBox("#00FF00Chat is only available while spectating, enter spectate mode with #FF0000IWANTTOSPECTATE #00FF00cheat and press #FF0000B", root, 0, 246, 255, true)
	
	setTime(math.random(24), math.random(59))
	setWeather(math.random(15))
end )

addEvent("activateCheat", true)
addEventHandler("activateCheat", getRootElement(), function(cheat)
	if cheat == 5 or cheat == 6 then 
		setPedStat(source, 21, 999)
	
	-- Maximum muscle
	elseif cheat == 7 or cheat == 8 then
		setPedStat(source, 23, 999)
		
	-- Maximum sex appeal
	elseif cheat == 9 or cheat == 10 then
		setPedStat(source, 25, 999)
		
	-- Maximum sex appeal
	elseif cheat == 11 or cheat == 12 then
		setPedStat(source, 229, 999)
		setPedStat(source, 230, 999)
		setPedStat(source, 160, 999)
		
	-- Minimum fat and muscle
	elseif cheat == 13 or cheat == 14 then
		setPedStat(source, 21, 0)
		setPedStat(source, 23, 0)
	end
	
	if cheat % 2 == 0 then cheat = cheat - 1 end -- even cheat
	exports.achievements:updateObjective(source, "everyCheatActivated", cheat)
end )