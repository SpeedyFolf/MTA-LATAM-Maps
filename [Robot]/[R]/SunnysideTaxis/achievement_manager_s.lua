addEvent("newFareCompleted", true)
addEventHandler("newFareCompleted", getRootElement(), function(destinationName)
	exports.achievements:updateObjective(source, "sunnysideEveryDest", destinationName)
	exports.achievements:triggerAchievement(source, "sunnyside1000Fares", nil)
end )

addEvent("newTaxiPurchase", true)
addEventHandler("newTaxiPurchase", getRootElement(), function(currentCarID, carUnlocked)
	exports.achievements:updateObjective(source, "sunnysideEveryCar", carUnlocked)
	exports.achievements:triggerAchievement(source, "sunnysideAnyCar", nil)
	
	if carUnlocked and carUnlocked ~= (currentCarID + 1) then
		exports.achievements:triggerAchievement(source, "sunnysideSkipCar", nil)
	end
end )

addEvent("sunnysideFixed", true)
addEventHandler("sunnysideFixed", getRootElement(), function(currentCarID, carUnlocked)
	exports.achievements:triggerAchievement(source, "sunnysideFixCar", nil)
end )