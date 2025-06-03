addEvent("onClientNotifySpectate", true)
addEventHandler("onClientNotifySpectate", root, function(enabled)
	triggerClientEvent(source, "personSpectatored", source, enabled)
end)