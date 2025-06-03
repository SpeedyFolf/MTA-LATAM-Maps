addEventHandler("onResourceStart", resourceRoot, function()
	setTimer(function()
		local found = false
		for _, v in ipairs(getElementsByType("player")) do
			local x, y, z = getElementPosition(v)
			if getDistanceBetweenPoints2D(x, y, 404.7, 2452.6) < 100 then
				setGarageOpen(45, true)
				found = true
				break
			end
		end
		if not found then setGarageOpen(45, false) end
	end, 2000, 0)
end )