local text, textColor

function drawBorderedText(text, borderSize, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height, width2+borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height+borderSize, width2, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height-borderSize, width2, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height, width2-borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height+borderSize, width2+borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height-borderSize, width2-borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height-borderSize, width2+borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height+borderSize, width2-borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
end

addEvent("showWinMessage", true)
addEventHandler("showWinMessage", getRootElement(), function(winText, color)
	text = winText
	textColor = color
end )

addEventHandler("onClientRender", root, function()
	if text then
		local width, height = guiGetScreenSize()
		drawBorderedText(text, 2, width*0.2, height*0.2, width*0.8, height*0.9, textColor, 5, "default", "center", "top", false, true, false, true)
	end
end )