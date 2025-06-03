
    addEventHandler("onClientResourceStart",resourceRoot,
       function ()
          for i,vehicle in ipairs (getElementsByType ("vehicle")) do
             if not getVehicleController (vehicle) then
                setVehicleOverrideLights (vehicle, 2)
                setVehicleEngineState (vehicle, true)
                setVehicleSirensOn (vehicle, true)
                setElementData (vehicle, "race.collideothers", 1)
             end
          end
       end
    )