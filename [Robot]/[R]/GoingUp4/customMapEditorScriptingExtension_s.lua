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
	[6917] = 7180, -- vgsnrailroad25 => lodnrailroad25 (vegasN)
	[8947] = 8958, -- vgelkup => lodelockup_01 (vegasE)
	[9584] = 9620, -- freight_sfw31 => lodight_sfw31 (SFw)
	[9585] = 9619, -- freight_sfw33 => lodight_sfw33 (SFw)
	[4016] = 4026, -- fighotbase_lan => lodhotbase_lan (LAn)
	[3445] = 3546, -- vegasxrexhse08 => lodasxrexhse08 (vegasW)
	[5017] = 4969, -- lastripx1_las => lodtripx1_las (LAs)
	[16385] = 16617, -- desh2_weefact2_ => lod_cn2_weefact2_ (countn2)
	[3446] = 3547, -- vegasxrexhse10 => lodasxrexhse10 (vegasW)
	[16326] = 16595, -- des_byoffice => lod_byoffice (countn2)
	[16327] = 16596, -- des_bycontowr => lod_bycontowr (countn2)
	[4019] = 4025, -- newbuildsm01 => lodbuildsm01 (LAn)
	[6928] = 6936, -- vegasplant03 => lodasplant03 (vegasN)
	[8333] = 8280, -- stadium02_lvs => loddium02_lvs (vegasS)
	[3449] = 3535, -- vegashsenew1 => lodashsenew1 (vegasW)
	[6930] = 6938, -- vegasplant05 => lodasplant05 (vegasN)
	[791] = 785, -- vbg_fir_copse => lod_vbg_fir_co (countrye)
	[3704] = 3705, -- barrio6a_lae2 => lodbarrio6a_lae2 (LAe2)
	[4141] = 4181, -- hotelexterior1_lan => lodelexterior1_lan (LAn)
	[6364] = 6365, -- sunset07_law2 => lodset07_law2 (LAw2)
	[7191] = 7195, -- vegasnnewfence2b => lodasnnewfence2b (vegasN)
	[4718] = 4719, -- gm_build4_lan2 => lodgm_build4_lan2 (LAn2)
	[16358] = 16688, -- des_ebrigroad07 => lod_des_ebrigroad07 (countn2)
	[8148] = 8273, -- vgsselecfence02 => lodselecfence02 (vegasS)
	[12931] = 13048, -- ce_brewery => lodce_brewery (countrye)
	[8489] = 8700, -- flamingo01_lvs => lodmingo01_lvs (vegasE)
	[7392] = 7342, -- vegcandysign1 => lodcandysign1 (vegasN)
	[16118] = 16717, -- des_rockgp2_05 => lod_rockgp2_05 (countn2)
	[3776] = 3777, -- ci_bstage => lodbstage01 (LaWn)
	[9735] = 9802, -- road_sfw53 => lodroads_sfw48 (SFw)
	[17511] = 17512, -- gwforum1_lae => lodgwforum1_lae (LAe2)
	[10789] = 11281, -- xenonroof_sfse => lod_garage2sfse (SFSe)
	[8504] = 8926, -- shop10_lvs => lodp10_lvs (vegasE)
	[4602] = 4580, -- laskyscrap4_lan => lodkyscrap4_lan (LAn2)
	[4569] = 4627, -- stolenbuilds05 => lodstolenbuilds05 (LAn2)
	[4603] = 4581, -- sky4plaz2_lan => lod4plaz2_lan (LAn2)
	[12953] = 13255, -- sw_blockbit01 => lod05sw_blockbit01 (countrye)
	[9907] = 9935, -- monolith_sfe => lodolith_ground (SFe)
	[7240] = 7241, -- vrockcafehtl => lodckcafehtl (vegasN)
	[16480] = 16482, -- ftcarson_sign => lod_ftcarson_sig (countn2)
	[4002] = 4024, -- lacityhall2_lan => lodityhall2_lan (LAn)
	[5180] = 5206, -- nwspltbild2_las2 => lodpltbild2_las2 (LAs2)
	[17098] = 17376, -- cuntwland24b => lodcuntw19 (countryw)
	[10425] = 10520, -- temphotel1_sfs => lod_sfs059 (SFs)
	[3620] = 3746, -- redockrane_las => lodredockrane_las (LAs2)
	[5183] = 5205, -- nwspltbild1_las2 => lodpltbild1_las2 (LAs2)
	[6962] = 7131, -- vgsnwedchap1 => lodnwedchap1 (vegasN)
	[7344] = 7345, -- vgsn_pipeworks => lodn_pipeworks (vegasN)
	[12847] = 13224, -- sprunk_fact => sprunk_fact_lod (countrye)
	[10308] = 10157, -- yet_another_sfe2 => lod_another_sfe2 (SFe)
	[4550] = 4561, -- librtow1_lan => lodrtow1_lan (LAn2)
	[4857] = 4979, -- snpedmtsp1_las => lodedmtsp1_las01 (LAs)
	[7347] = 7346, -- vgsn_pipeworks01 => lodn_pipeworks01 (vegasN)
	[10948] = 11021, -- skyscrapper_sfs => lod_sfs010 (SFSe)
	[8409] = 8415, -- gnhotel01_lvs => lodotel01_lvs (vegasE)
	[5126] = 5304, -- dockcranescale0 => loddockcranescale (LAs2)
	[10063] = 10059, -- aprtmnts02_sfe => loda38 (SFe)
	[17131] = 17411, -- cuntwland66b => lodcuntw56 (countryw)
	[12859] = 13193, -- sw_cont03 => sw_cont03_lod (countrye)
	[12861] = 13195, -- sw_cont05 => sw_cont05_lod (countrye)
	[10196] = 10239, -- hotelbits_sfe01 => lodelbits_sfe01 (SFe)
	[8201] = 8239, -- stadium_lvs => loddium_lvs (vegasS)
	[3989] = 4137, -- bonaplazagr_lan => lodbonaplazagr_lan (LAn)
	[4570] = 4578, -- stolenbuilds08 => lodlenbuilds08 (LAn2)
	[17538] = 17932, -- powerstat1_lae2 => lod1powerstat1_lae (LAe2)
	[10412] = 10521, -- poshotel1_sfs => lod_sfs060 (SFs)
	[9824] = 9826, -- diner_sfw => loder_sfw (SFw)
	[4564] = 4579, -- laskyscrap2_lan => lodkyscrap2_lan (LAn2)
	[10954] = 11049, -- stadium_sfse => lod_sfs049 (SFSe)
	[4013] = 4065, -- bonavenbase_lan => lodavenbase_lan (LAn)
	[8657] = 8997, -- shbbyhswall10_lvs => lodbyhswall10_lvs (vegasE)
	[16613] = 16614, -- des_bigtelescope => lod_bigtelescope (countn2)
	[7488] = 7705, -- vgncarpark1 => lodcarpark1 (vegasW)
	[3444] = 3537, -- shabbyhouse02_lvs => lodbbyhouse02_lvs (vegasE)
}