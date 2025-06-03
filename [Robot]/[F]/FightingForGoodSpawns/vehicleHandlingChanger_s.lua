function vhandling ( theVehicle )
    if getElementModel(theVehicle) == 509 then -------------- vehicle Id
        setVehicleHandling(theVehicle, "maxVelocity", 0.0)
        setVehicleHandling(theVehicle, "engineAcceleration", 0.00 )
    end
end
addEventHandler ( "onPlayerVehicleEnter", getRootElement(), vhandling )