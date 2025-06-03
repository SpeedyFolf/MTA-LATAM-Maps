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
	[4645] = 4619, -- road14_lan2 => lodroad14_lan2 (LAn2)
	[5114] = 5254, -- beach1_las2 => lod_beach1las2 (LAs2)
	[17605] = 17719, -- lae2_roads10 => lodlae2_roads10 (LAe2)
	[17513] = 17734, -- lae2_ground04 => lod1bballblok1_lae (LAe2)
	[4646] = 4677, -- road13_lan2 => lodroad13_lan2 (LAn2)
	[12857] = 13387, -- ce_bridge02 => lodce_bridge02 (countrye)
	[17670] = 17786, -- lae2_roads66 => lodlae2_roads66 (LAe2)
	[6189] = 6191, -- gaz_pier1 => lodgaz_pier1 (LAw)
	[17502] = 17857, -- riverbridge2_lae => lodriverbridge2_lae (LAe2)
	[3651] = 3650, -- ganghous04_lax => lodganghous04_lax (LAe2)
	[16246] = 16493, -- se_bit_17 => lod_se_bit_17 (countn2)
	[17612] = 17716, -- lae2_roads88 => lod1roads32_lae01 (LAe2)
	[3620] = 3746, -- redockrane_las => lodredockrane_las (LAs2)
	[17613] = 17858, -- lae2_roads89 => lodlae2_roads89 (LAe2)
	[4702] = 4704, -- cpark03_lan2 => lodcpark03_lan2 (LAn2)
	[4241] = 4376, -- sbsbed4law2 => lodseabed002 (seabed)
	[5155] = 5161, -- dk_cargoshp05d => lodcargoshp05d (LAs2)
	[5458] = 5460, -- laemacpark01 => laelodpark01 (LAe)
	[17600] = 17832, -- lae2_roads05 => lodlae2_roads05 (LAe2)
	[17864] = 17870, -- comp_puchase => lodcomp_puchase (LAe2)
	[3649] = 3654, -- ganghous01_lax => lodganghous01_lax (LAe2)
	[4556] = 4615, -- sky4plaz1_lan => lodsky4plaz_lan (LAn2)
}