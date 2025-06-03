local groveTexture = dxCreateTexture("grovea.png")
local shader, tech = dxCreateShader("shader.fx")
dxSetShaderValue(shader, "grove_texture", groveTexture)

local tagsPos = {
	{ 1525, 1549.890625, -1714.523438, 15.1015625, 0, 0, 89.50006634682406 },
	{ 1527, 1448.234375, -1755.898438, 14.5234375, 0, 0, -90.49988896656019 },
	{ 1530, 1332.132813, -1722.304688, 14.1875, 0, 0, 89.50006634682406 },
	{ 1531, 1724.734375, -1741.5, 14.1015625, 0, 0, -90.49988896656019 },
	{ 1531, 1767.210938, -1617.539063, 15.0390625, 0, 0, -109.434928102375 },
	{ 1531, 1799.132813, -1708.765625, 14.1015625, 0, 0, 179.5001234631798 },
	{ 1525, 1498.632813, -1207.351563, 24.6796875, 0, 0, -90.00538808462643 },
	{ 1530, 1732.734375, -963.078125, 41.4375, 0, 0, 7.573425771893532 },
	{ 1531, 1746.75, -1359.773438, 16.2109375, 0, 0, -90.00309873461087 },
	{ 1525, 1519.421875, -1010.945313, 24.609375, 0, 0, 179.9946291951539 },
	{ 1525, 1687.226563, -1239.125, 15.8125, 4.86331615200949e-13, -2.897803805259583e-05, -90.00003667567259 },
	{ 1525, 1783.96875, -2156.539063, 14.3125, 0, 0, 89.50006634682406 },
	{ 1527, 1574.710938, -2691.882813, 13.6015625, 0, 0, -0.4998578158075646 },
	{ 1530, 1118.90625, -2008.242188, 75.0234375, 0, 0, 122.5132657167925 },
	{ 1531, 1850.007813, -1876.835938, 14.359375, 0, 0, 89.50006634682406 },
	{ 1531, 1889.242188, -1982.507813, 15.7578125, 0, 0, -0.4999297482413931 },
	{ 1531, 1950.617188, -2034.398438, 14.09375, 0, 0, 179.5000342480359 },
	{ 1531, 1936.882813, -2134.90625, 14.21875, 0, 0, 89.49999905803733 },
	{ 1531, 1808.34375, -2092.265625, 14.21875, 0, 0, -179.0178693469345 },
	{ 1525, 1624.625, -2296.242188, 14.3125, 0, 0, 89.49999905803733 },
	{ 1527, 1071.140625, -1863.789063, 14.09375, 0, 0, -0.4998578158075646 },
	{ 1525, 2065.4375, -1897.234375, 13.609375, 0, 0, 89.50006634682406 },
	{ 1528, 2763, -2012.109375, 14.1328125, 0, 0, 179.5001234631798 },
	{ 1529, 2379.320313, -2166.21875, 24.9453125, 0, 0, 44.5000503486912 },
	{ 1525, 2134.328125, -2011.203125, 10.515625, 0, 0, 134.5000886445704 },
	{ 1527, 2392.359375, -1914.570313, 14.7421875, 0, 0, 89.50006634682406 },
	{ 1527, 2430.328125, -1997.90625, 14.7421875, 0, 0, 89.50006634682406 },
	{ 1527, 2587.320313, -2063.523438, 4.609375, 0, 0, 179.5001061751143 },
	{ 1524, 2704.195313, -1966.6875, 13.7578125, 0, 0, 179.5001061751143 },
	{ 1524, 2489.242188, -1959.070313, 13.7578125, 0, 0, -90.4998598223456 },
	{ 1531, 2273.898438, -2265.804688, 14.5625, 0, 0, 134.5000886445704 },
	{ 1531, 2173.59375, -2165.1875, 15.3046875, 0, 0, 134.5000886445704 },
	{ 1530, 2273.195313, -2529.117188, 8.515625, 0, 0, 179.5001234631798 },
	{ 1530, 2704.226563, -2144.304688, 11.8203125, 0, 0, 179.5001234631798 },
	{ 1528, 2794.53125, -1906.8125, 14.671875, 0, 0, -90.49988896656019 },
	{ 1528, 2812.9375, -1942.070313, 11.0625, 0, 0, 179.5001234631798 },
	{ 1528, 2874.5, -1909.382813, 8.390625, 0, 0, 179.5001234631798 },
	{ 1524, 1295.179688, -1465.21875, 10.28125, 0, 0, -90.49988896656019 },
	{ 1525, 1271.484375, -1662.320313, 20.25, 0, 0, 89.50008557948685 },
	{ 1529, 810.5703125, -1797.570313, 13.6171875, 0, 0, -135.499911774018 },
	{ 1529, 730.4453125, -1482.007813, 2.25, 0, 0, 90.50014117347384 },
	{ 1529, 947.484375, -1466.71875, 17.2421875, 0, 0, -179.9999066533236 },
	{ 1524, 482.625, -1761.585938, 5.9140625, 0, 0, 89.50006634682406 },
	{ 1529, 399.0078125, -2066.882813, 11.234375, 0, 0, 179.5001061751143 },
	{ 1529, 466.9765625, -1283.023438, 16.3203125, 0, 0, 33.47958667694666 },
	{ 1529, 583.4609375, -1502.109375, 16, 0, 0, 179.5001061751143 },
	{ 1529, 944.2734375, -985.8203125, 39.296875, 0, 0, -79.99200676268353 },
	{ 1529, 1072.90625, -1012.796875, 35.515625, 0, 0, -178.9593136082587 },
	{ 1529, 1206.25, -1162, 23.875, 0, 0, -179.6482885162542 },
	{ 1529, 1098.8125, -1292.546875, 17.140625, 0, 0, -0.0919042905976887 },
	{ 1524, 2046.40625, -1635.84375, 13.5859375, 0, 0, -0.4999671019154936 },
	{ 1524, 2066.429688, -1652.476563, 14.28125, 0, 0, 179.5000688242808 },
	{ 1524, 2102.195313, -1648.757813, 13.5859375, 0, 0, 0.3090551224484431 },
	{ 1524, 2162.78125, -1786.070313, 14.1875, 0, 0, 91.00015745764314 },
	{ 1524, 2034.398438, -1801.671875, 14.546875, 0, 0, 91.00015745764314 },
	{ 1524, 1910.164063, -1779.664063, 18.75, 0, 0, -88.99980731867434 },
	{ 1524, 1837.195313, -1814.1875, 4.3359375, 0, 0, -103.9997818750051 },
	{ 1524, 1837.664063, -1640.382813, 13.7578125, 0, 0, 1.000222941381992 },
	{ 1524, 1959.398438, -1577.757813, 13.7578125, 0, 0, -44.99976307553514 },
	{ 1524, 2074.179688, -1579.148438, 14.03125, 0, 0, 0.0002285839543141711 },
	{ 1527, 2182.234375, -1467.898438, 25.5546875, 0, 0, -89.49984515449357 },
	{ 1527, 2132.234375, -1258.09375, 24.0546875, 0, 0, 90.50018971917105 },
	{ 1527, 2233.953125, -1367.617188, 24.53125, 0, 0, -179.4998275379045 },
	{ 1527, 2224.765625, -1193.0625, 25.8359375, 0, 0, 90.19120017004613 },
	{ 1527, 2119.203125, -1196.617188, 24.6328125, 0, 0, -89.49984515449357 },
	{ 1525, 1974.085938, -1351.164063, 24.5625, 0, 0, 89.50006634682406 },
	{ 1525, 2093.757813, -1413.445313, 24.1171875, 0, 0, 90.50012175596083 },
	{ 1525, 1969.59375, -1289.695313, 24.5625, 0, 0, -0.4999671019154936 },
	{ 1525, 1966.945313, -1174.726563, 20.0390625, 0, 0, 89.50006634682406 },
	{ 1525, 1911.867188, -1064.398438, 25.1875, 0, 0, 179.5001061751143 },
	{ 1530, 2281.460938, -1118.960938, 27.0078125, 0, 0, -179.8775096628294 },
	{ 1530, 2239.78125, -999.75, 59.7578125, 0, 0, -127.4998503499093 },
	{ 1530, 2122.6875, -1060.898438, 25.390625, 0, 0, -32.99986559278296 },
	{ 1530, 2062.71875, -996.4609375, 48.265625, 0, 0, -15.49982848697541 },
	{ 1530, 2076.726563, -1071.132813, 27.609375, 0, 0, -36.9999157766275 },
	{ 1524, 2399.414063, -1552.03125, 28.75, 0, 0, -90.49988896656019 },
	{ 1524, 2353.539063, -1508.210938, 24.75, 0, 0, -0.4998578158075646 },
	{ 1524, 2394.101563, -1468.367188, 24.78125, 0, 0, 89.50018178514566 },
	{ 1530, 2841.367188, -1312.960938, 18.8203125, 0, 0, 101.5004033813439 },
	{ 1530, 2820.34375, -1190.976563, 25.671875, 0, 0, -90.49956878749371 },
	{ 1530, 2766.085938, -1197.140625, 69.0703125, 0, 0, 179.5004512967073 },
	{ 1530, 2756.007813, -1388.125, 39.4609375, 0, 0, -0.4995299573800915 },
	{ 1530, 2821.234375, -1465.09375, 16.5390625, 0, 0, -0.4995299573800915 },
	{ 1530, 2767.78125, -1621.1875, 11.234375, 0, 0, 179.5004340086401 },
	{ 1530, 2767.757813, -1819.945313, 12.2265625, 0, 0, 113.0004015052384 },
	{ 1530, 2667.890625, -1469.132813, 31.6796875, 0, 0, 179.5004340086401 },
	{ 1530, 2612.929688, -1390.773438, 35.4296875, 0, 0, 89.50049911631464 },
	{ 1530, 2536.21875, -1352.765625, 31.0859375, 0, 0, 179.5005433757525 },
	{ 1530, 2580.945313, -1274.09375, 46.59375, 0, 0, -0.4994926037084768 },
	{ 1530, 2603.15625, -1197.8125, 60.9921875, 0, 0, -93.49957040824705 },
	{ 1524, 2542.953125, -1363.242188, 31.765625, 0, 0, -0.4998578158075646 },
	{ 1525, 2462.265625, -1541.414063, 25.421875, 0, 0, 89.50014331965292 },
	{ 1527, 2522.460938, -1478.742188, 24.1640625, 0, 0, -0.4998578158075646 },
	{ 1525, 2346.515625, -1350.78125, 24.28125, 0, 0, 89.50014331965292 },
	{ 1527, 2322.453125, -1254.414063, 22.921875, 0, 0, 179.5001781020796 },
	{ 1525, 2273.015625, -1687.429688, 14.96875, 0, 0, 89.50014331965292 },
	{ 1525, 2422.90625, -1682.296875, 13.9921875, 0, 0, 0.00018396036784101 },
	{ 1530, 2576.820313, -1143.273438, 48.203125, 0, 0, 89.50039331979949 },
	{ 1530, 2621.507813, -1092.203125, 69.796875, 0, 0, 89.50039331979949 },
	{ 1530, 2797.921875, -1097.695313, 31.0625, 0, 0, -91.99965382101118 }
}

local tags = {} -- Data for each tag
for i = 1, 100 do tags[i] = 0 end 
local collectibles = {}
local overlays = {}
local oldAmmo = 10000

-- Texts
local text
local screenX, screenY = guiGetScreenSize()


function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    if type(scaleY) == "string" then
        scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY = scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX
    end
    local outlineX = (scaleX or 1) * (1.333333333333334 * (outline or 1))
    local outlineY = (scaleY or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top - outlineY, right - outlineX, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top - outlineY, right + outlineX, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top + outlineY, right - outlineX, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top + outlineY, right + outlineX, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top, right - outlineX, bottom, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top, right + outlineX, bottom, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outlineY, right, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outlineY, right, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create All Pickups
	for i = 1, #tagsPos do
		collectibles[i] = createObject(tagsPos[i][1], tagsPos[i][2], tagsPos[i][3], tagsPos[i][4], tagsPos[i][5], tagsPos[i][6], tagsPos[i][7])
	end	
	
	setElementData(localPlayer, "score", 0)
	setElementData(localPlayer, "soundTags", 0)
	
	setTimer(function()
		if getElementData(localPlayer, "race.checkpoint") and getElementData(localPlayer, "score") and getElementData(localPlayer, "race.checkpoint") < getElementData(localPlayer, "score") + 1 then
			for i = 1, (getElementData(localPlayer, "score") + 1 - getElementData(localPlayer, "race.checkpoint")) do
				local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
				if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
			end
		end
	end, 5000, 0)
end )

addEventHandler("onClientPlayerWeaponFire", root, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if source == localPlayer and weapon and weapon == 41 then
		local ammoSpend = oldAmmo - ammo
		oldAmmo = ammo
		
		for i, v in ipairs(tagsPos) do
			if getDistanceBetweenPoints3D(v[2], v[3], v[4], hitX, hitY, hitZ) < 1 and tags[i] < 255 then
				tags[i] = math.min(tags[i] + ammoSpend * 7.9, 255)
				
				-- Creation of overlay Grove tag
				if tags[i] > 210 then
					if not isElement(overlays[i]) then
						local matrix = getElementMatrix(collectibles[i])
						overlays[i] = createObject(1526, tagsPos[i][2]+matrix[1][1]*(-0.03), tagsPos[i][3]+matrix[1][2]*(-0.03), tagsPos[i][4], tagsPos[i][5], tagsPos[i][6], tagsPos[i][7])
						
						if getElementData(resourceRoot, "secretMode") ~= 10 then
							engineApplyShaderToWorldTexture(shader, "*", overlays[i])
						end
					end
					
					setElementAlpha(overlays[i], tags[i])
				end 
				
				if tags[i] > 229 and tags[i] < 237 then
					-- Tag completed 
					setElementData(localPlayer, "score", (getElementData(localPlayer, "score") or 0) + 1)
					text = true
					setTimer(function() text = false end, 6000, 1)
					setWorldSoundEnabled(0, false)
					
					local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
					if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
					
					setTimer(function() resetWorldSounds() end, 50, 1)
					triggerServerEvent("updateTags", localPlayer, i)
				elseif tags[i] == 255 then
					-- Blip sound
					setTimer(function() playSoundFrontEnd(43) end, 100, 1)
					setElementData(localPlayer, "soundTags", getElementData(localPlayer, "soundTags") + 1)
				end
				
				break
			end
		end
	end
end )

addEventHandler("onClientRender", root, function()
	if text then
		if getElementData(localPlayer, "score") < 100 then dxDrawBorderedText(2, "TAGS SPRAYED\n" ..getElementData(localPlayer, "score").. " OUT OF 100", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false)
		else dxDrawBorderedText(2, "ALL TAGS SPRAYED!", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false) end
	end
end )

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if source == localPlayer and getElementModel(vehicle) == 400 then oldAmmo = 10000 end
end )

addEventHandler("onClientPlayerChoke", localPlayer, function(weapon)
	if weapon == 41 then 
		setElementHealth(localPlayer, getElementHealth(localPlayer) + 2)
		cancelEvent() 
	end
end )