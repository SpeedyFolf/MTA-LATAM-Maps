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
	[13141] = 13341, -- cunte_roads58b => lodcunte_roads58b (countrye)
	[3330] = 3333, -- cxrf_brigleg => cxrf_lodbriglg (countn2)
	[18362] = 18418, -- cs_landbit_79 => cs_lodbit_79 (countryS)
	[12857] = 13387, -- ce_bridge02 => lodce_bridge02 (countrye)
	[9207] = 9468, -- land2_sfn01 => lod_land2_sfn01 (SFn)
	[4844] = 4957, -- beach1_las04 => lodch1_las05 (LAs)
	[12990] = 13483, -- sw_jetty => lodsw_jetty (countrye)
	[11448] = 11606, -- des_railbr_twr1 => des_railbra_lod (countryN)
	[18324] = 18602, -- cs_landbit_35 => lod_cs_landbit_35 (countryS)
	[9217] = 9449, -- land2_sfn16 => lod_land2_sfn16 (SFn)
	[4729] = 4754, -- billbrdlan2_01 => lodbillbrdlan2_01 (LAn2)
	[9900] = 9936, -- landshit_09_sfe => loda02 (SFe)
	[11495] = 11619, -- des_ranchjetty => des_ranchjetty_lod (countryN)
	[13237] = 13240, -- cuntehil03 => lodcuntehil03 (countrye)
	[3415] = 3423, -- ce_loghut1 => lodce_loghut02 (countrye)
	[11420] = 11630, -- con_lighth => con_lighth_lod (countryN)
	[13370] = 13471, -- cehllyhil03a => lodcehllyhil03a (countrye)
	[13156] = 13159, -- cunteground21 => lodcunteground21 (countrye)
}