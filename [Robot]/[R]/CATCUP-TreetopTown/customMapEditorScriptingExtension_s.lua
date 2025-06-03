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
	[3175] = 3347, -- sm_airstrm_med_ => lod_airstrm_med_ (countn2)
	[3828] = 3837, -- box_hse_05_sfxrf => lod_hse_05_sfxrf (SFs)
	[3830] = 3836, -- box_hse_08_sfxrf => lod_hse_08_sfxrf (SFs)
	[3842] = 3847, -- box_hse_14_sfxrf => lod_hse_14_sfxrf (SFs)
	[12857] = 13387, -- ce_bridge02 => lodce_bridge02 (countrye)
	[8550] = 8966, -- laconcha_lvs => lodoncha_lvs (vegasE)
	[3821] = 3832, -- box_hse_02_sfxrf => lod_hse_02_sfxrf (SFs)
	[3174] = 3346, -- sm_airstrm_sml_ => lod_airstrm_sml_ (countryN)
	[3827] = 3838, -- box_hse_07_sfxrf => lod_hse_07_sfxrf (SFs)
	[3829] = 3839, -- box_hse_04_sfxrf => lod_hse_04_sfxrf (SFs)
	[11495] = 11619, -- des_ranchjetty => des_ranchjetty_lod (countryN)
	[4729] = 4754, -- billbrdlan2_01 => lodbillbrdlan2_01 (LAn2)
	[3845] = 3846, -- box_hse_13_sfxrf => lod_hse_13_sfxrf (SFs)
	[11121] = 11068, -- roadssfse68 => lodroadssfse68 (SFSe)
	[3822] = 3833, -- box_hse_03_sfxrf => lod_hse_03_sfxrf (SFs)
	[4828] = 4942, -- lasairprt5 => lodairprt5 (LAs)
}