
addEventHandler("onPlayerPickUpRacePickup", root,
	function( id, what )
		if what == "repair" then triggerClientEvent( source, "recharge", root ) end
	end
)