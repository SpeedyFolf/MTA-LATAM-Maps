--[[
-----------------
--Xerion&DEFcom--
-----------------

--inf
infobj01 = createObject (1337, -176.8, 2434.7, 73.1, 5.7160339355469, 17.587677001953, 246.68392944336)
setElementAlpha (infobj01, 0)
setElementCollisionsEnabled (infobj01, false)
infernus01 = createVehicle (411, -176.32421875, 2434.4833984375, 73.339401245117, 14.381103515625, 24.5654296875, 242.26501464844)
setVehiclePanelState (infernus01, 0, 3)
setVehiclePanelState (infernus01, 1, 3)
setVehiclePanelState (infernus01, 4, 3)
setVehiclePanelState (infernus01, 5, 3)
setVehicleOverrideLights (infernus01, 2)
setVehicleLightState (infernus01, 1, 1)
setVehicleEngineState (infernus01, true)
setVehicleDoorOpenRatio (infernus01, 0, 0.5)
setVehicleDoorOpenRatio (infernus01, 3, 0.5)
setElementHealth (infernus01, 300)
attachElements (infernus01, infobj01)

--xer
xerion = createPed (158, -175.39999389648, 2433, 72.8)
setElementCollisionsEnabled (xerion, false)
setElementRotation (xerion, 0, 0, 180)
setTimer (setPedAnimation, 2000, 1, xerion, "Car", "Fixn_Car_Loop", nil, true, true, true)

addEventHandler("onClientRender",getRootElement(),
function()
	xx, xy, xz = getElementPosition (xerion)
	px, py, pz = getElementPosition (getLocalPlayer())
	distance01 = getDistanceBetweenPoints3D (xx, xy, xz, px, py, pz)
	if distance01 <= 150 then
		local sx01,sy01 = getScreenFromWorldPosition (xx, xy, xz-0.5, 0.06)
		if not sx01 then return end
		local scale01 = 1/(0.3 * (distance01 / 150))
		dxDrawText ("Xerion", sx01, sy01 - 30, sx01, sy01 - 30, tocolor(255, 255, 255, 255), math.min (0.4*(150/distance01)*1.4,4), "default", "center", "bottom", false, false, false)
	end
end
)

--def
defcom = createPed (199, -175.4, 2432, 72.7)
setElementCollisionsEnabled (defcom, false)
setElementRotation (defcom, 0, 0, 0)
setTimer (setPedAnimation, 2000, 1, defcom, "PAULNMAC", "Piss_loop", nil, true, true, true)

--piss
pissobj01 = createObject (2052, -175.4, 2432, 72.7, 0, 0, 0)
setElementCollisionsEnabled (pissobj01, false)

addEventHandler("onClientRender",getRootElement(),
function()
	dx, dy, dz = getElementPosition (defcom)
	px, py, pz = getElementPosition (getLocalPlayer())
	distance02 = getDistanceBetweenPoints3D (dx, dy, dz, px, py, pz)
	if distance02 <= 150 then
		local sx02,sy02 = getScreenFromWorldPosition (dx, dy, dz+0.95, 0.06)
		if not sx02 then return end
		local scale02 = 1/(0.3 * (distance02 / 150))
		dxDrawText ("DEFcom", sx02, sy02 - 30, sx02, sy02 - 30, tocolor(255, 255, 255, 255), math.min (0.4*(150/distance02)*1.4,4), "default", "center", "bottom", false, false, false)
	end
end
)
]]--