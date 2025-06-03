local rerolls = 3
function outputClick(button, press)
	local keys = {}	
	for keyName, state in pairs(getBoundKeys("sub_mission")) do
		keys[keyName] = true
	end

    if keys[button] and press == true and rerolls > 0 then
        if (isPedDead(getLocalPlayer())) then
            outputChatBox("The deceased cannot reroll!", 255, 0, 0)
        else
            rerolls = rerolls - 1
            local rerollText = rerolls > 1 and "rerolls left" or (rerolls == 1 and "reroll left" or "rerolls left")
            outputChatBox("Rerolled your vehicle! " .. rerolls .. " " .. rerollText .. ".", 0, 255, 0)
            triggerServerEvent("playerClientClick", resourceRoot, getLocalPlayer())
        end
    end
end
addEventHandler("onClientKey", root, outputClick)

addEventHandler( "onClientResourceStart", getRootElement( ),
    function ( startedRes )
		local keyName = nil
		local keys = getBoundKeys("sub_mission")

		if not keys then
			keyName = "NOT BOUND"
		else
			keyName, _ = next(keys)
		end
		if not keyName then keyName = "NOT BOUND" end

        outputChatBox( "Unlucky checkpoint? You can reroll your vehicle up to three times by pressing "..keyName.." (sub_mission). Use them wisely!", 0, 255, 0 )
    end
);
