-- Function converts time in milliseconds into time in format MM:SS.MS
function convertToRaceTime(time)
	if time ~= nil then
		local m = math.floor(time / 1000 / 60)
		local s = math.floor((time / 1000) - m*60)
		local ms = math.floor(time - (m*60+s)*1000)
		
		if m < 1 then m = ""
		else m = m.. ":" end
		if s < 10 and m ~= "" then s = "0" ..s end
		if ms < 10 then ms = "00" ..ms
		elseif ms < 100 and ms > 9 then ms = "0" ..ms end
		
		return m.. "" ..s.. "." ..ms
	end
end

function getRatingColor(rating)
	local r, g = -5.1*(rating^2) + 25.5*rating + 255, -5.1*(rating^2) + 76.5*rating
	r, g = r > 255 and 255 or math.floor(r+0.5), g > 255 and 255 or math.floor(g+0.5)
	return {r,g,0}
end

function getRatingColorAsHex(rating)
	local r, g = unpack(getRatingColor(rating))
	return "#"..string.format("%02X", r)..string.format("%02X", g).."00"
end