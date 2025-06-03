-- FILE: customMapEditorScriptingExtension_s.lua
-- PURPOSE: Handle remove world objects (if present) and add lod models for custom objects (if enabled)
-- VERSION: 16/February/2025 , custom edit by LotsOfS

local resourceName = getResourceName(resource)

-- Makes removeWorldObject map entries and LODs work
local function onResourceStartOrStop(startedResource)
	local startEvent = eventName == "onResourceStart"
	local removeObjects = getElementsByType("removeWorldObject", source)

	for removeID = 1, #removeObjects do
		local objectElement = removeObjects[removeID]
		local objectModel = getElementData(objectElement, "model")
		local objectLODModel = getElementData(objectElement, "lodModel")
		local posX = getElementData(objectElement, "posX")
		local posY = getElementData(objectElement, "posY")
		local posZ = getElementData(objectElement, "posZ")
		local objectInterior = getElementData(objectElement, "interior") or 0
		local objectRadius = getElementData(objectElement, "radius")

		if startEvent then
			removeWorldModel(objectModel, objectRadius, posX, posY, posZ, objectInterior)
			removeWorldModel(objectLODModel, objectRadius, posX, posY, posZ, objectInterior)
		else
			restoreWorldModel(objectModel, objectRadius, posX, posY, posZ, objectInterior)
			restoreWorldModel(objectLODModel, objectRadius, posX, posY, posZ, objectInterior)
		end
	end

	if startEvent then
		local useLODs = get(resourceName..".useLODs")

		if useLODs then
			local objectsTable = getElementsByType("object", source)

			for objectID = 1, #objectsTable do
				local objectElement = objectsTable[objectID]
				local objectModel = getElementModel(objectElement)
				local lodModel = LOD_MAP[objectModel]

				if lodModel then
					local objectX, objectY, objectZ = getElementPosition(objectElement)
					local objectRX, objectRY, objectRZ = getElementRotation(objectElement)
					local objectInterior = getElementInterior(objectElement)
					local objectDimension = getElementDimension(objectElement)
					local objectAlpha = getElementAlpha(objectElement)
					local objectScale = getObjectScale(objectElement)
					
					local lodObject = createObject(lodModel, objectX, objectY, objectZ, objectRX, objectRY, objectRZ, true)
					
					if (lodObject) then
						setElementInterior(lodObject, objectInterior)
						setElementDimension(lodObject, objectDimension)
						setElementAlpha(lodObject, objectAlpha)
						setObjectScale(lodObject, objectScale)

						setElementParent(lodObject, objectElement)
						setLowLODElement(objectElement, lodObject)
					else
						iprint("[MapEditorScriptingExtension] failed to create lodObject " .. lodModel .. " for objectModel " .. objectModel)
					end	
				end
			end
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStartOrStop, false)
addEventHandler("onResourceStop", resourceRoot, onResourceStartOrStop, false)

-- MTA LOD Table [object] = [lodmodel] 
LOD_MAP = {
	[4327] = 4461, -- sbcn_seafloor08 => lodseabed093 (seabed)
	[4843] = 4931, -- beach1_las0fhy => lodch1_las0fhy01 (LAs)
	[8493] = 8977, -- pirtshp01_lvs => lodtshp01_lvs (vegasE)
	[9044] = 9048, -- pirateland05_lvs => lodateland05_lvs (vegasE)
	[9285] = 9462, -- land2_sfn04 => lod_land2_sfn04 (SFn)
	[9045] = 9049, -- pirateland04_lvs => lodateland04_lvs (vegasE)
	[12990] = 13483, -- sw_jetty => lodsw_jetty (countrye)
	[18231] = 18419, -- cs_landbit_81 => cs_lodbit_81 (countryS)
	[17100] = 17371, -- cuntwland26b => lodcuntw14 (countryw)
	[17117] = 17422, -- cuntwland48b => lodcuntw68 (countryw)
	[4729] = 4754, -- billbrdlan2_01 => lodbillbrdlan2_01 (LAn2)
	[16406] = 16755, -- desn2_weemineb => lod_weemineb (countn2)
	[4346] = 4531, -- sbvgssseafloor04 => lodseabeds04 (seabed)
	[4319] = 4453, -- sbcn_seafloor01 => lodseabed085 (seabed)
	[12857] = 13387, -- ce_bridge02 => lodce_bridge02 (countrye)
	[4329] = 4463, -- sbcn_seafloor10 => lodseabed095 (seabed)
}