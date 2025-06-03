local screenX, screenY = guiGetScreenSize()
local width = 500
local height = 80

local wndPopup = nil
local tag = "uranus-gallardo"

addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function()
		wndPopup = guiCreateLabel(0, screenY-height, width, height, '', false) -- guiCreateLabel((screenX - width) / 2, screenY - height, width, height, '', false)
		guiSetAlpha(wndPopup, 0)
		guiSetFont(wndPopup, "sa-gothic")
		guiSetProperty(wndPopup, "HorizontalAlignment", "Centre")
		triggerEvent( "StartCustomVehicle", root, tag, 451 )
	end
)


addEventHandler("onClientPreRender", root,
	function( ticks )
		triggerEvent( "KeepCustomVehicle", root, tag )
	end
)


addEventHandler("onClientResourceStop", resourceRoot,
	function()
		triggerEvent( "StopCustomVehicle", root, tag )
	end
)




local c_DefaultPopupTimeout = 5000 --ms
local c_FadeDelta = .03 --alpha per frame
local c_MaxAlpha = .9

local function fadeIn(wnd)
	local function raiseAlpha()
		local newAlpha = guiGetAlpha(wnd) + c_FadeDelta
		if newAlpha <= c_MaxAlpha then
			guiSetAlpha(wnd, newAlpha)
		else
			removeEventHandler("onClientRender", root, raiseAlpha)
		end
	end
	guiSetAlpha(wnd, 0)
	removeEventHandler("onClientRender", root, lowerAlpha)
	addEventHandler("onClientRender", root, raiseAlpha)
end

function lowerAlpha()
	local wnd = wndPopup
	local newAlpha = guiGetAlpha(wnd) - c_FadeDelta
	if newAlpha >= 0 then
		guiSetAlpha(wnd, newAlpha)
	else
		removeEventHandler("onClientRender", root, lowerAlpha)
		guiSetText(wnd, "")
		guiSetAlpha(wnd, 0)
	end
end

local function fadeOut(wnd)
	addEventHandler("onClientRender", root, lowerAlpha)
end



addEvent("onClientZoneChange", true)
addEventHandler("onClientZoneChange", getLocalPlayer(), 
	function(zoneName, checkpointNum)
		outputGuiPopup(zoneName, 3500)
	end
)


function outputGuiPopup(text, timeout)
	guiSetText(wndPopup, text)

	fadeIn(wndPopup)
	setTimer(fadeOut, timeout or 5000, 1, wndPopup)
end
