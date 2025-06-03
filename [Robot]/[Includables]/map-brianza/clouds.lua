local oldState = getCloudsEnabled()

setCloudsEnabled ( false )

addEventHandler( "onClientResourceStop", resourceRoot,
    function ( _ )
        setCloudsEnabled(oldState)
    end
);