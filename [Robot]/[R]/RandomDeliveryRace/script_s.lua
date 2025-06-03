local sirens = {}

local file = fileOpen("objects.json")
local objectsList = fromJSON(fileRead(file, fileGetSize(file)))
fileClose(file)

addEvent("onPlayerReachCheckpoint") 
addEventHandler("onPlayerReachCheckpoint", getRootElement(), function(checkpoint)
	if not getPedOccupiedVehicle(source) then return end
	local vehicle = getPedOccupiedVehicle(source)
	
	if isElement(sirens[source]) then
		detachElements(sirens[source])
		setElementModel(sirens[source], objectsList[math.random(#objectsList)])
	else
		sirens[source] = createObject(objectsList[math.random(#objectsList)], 0, 0, 0)
	end
	
	triggerClientEvent(source, "calculateOffset", source)
end ) 

addEvent("getOffset", true)
addEventHandler("getOffset", getRootElement(), function(worldZ, z)
	attachElements(sirens[source], getPedOccupiedVehicle(source), 0, -2, worldZ - z, 90 ,0, 0)
end )

addEvent("updateOffsets", true)
addEventHandler("updateOffsets", getRootElement(), function(ObjZ, x, y, z)
	setElementAttachedOffsets(sirens[source], x, y, z + ObjZ)
	setElementCollisionsEnabled(sirens[source], false)
	setElementDoubleSided(sirens[source], true)
end )