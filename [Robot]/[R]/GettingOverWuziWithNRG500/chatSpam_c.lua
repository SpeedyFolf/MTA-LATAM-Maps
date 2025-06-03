function startText()
    outputChatBox("A playlist of the most difficult stunts can be found here: https://www.youtube.com/playlist?list=PL3clwkYrDWAJsCER-oEydEIio3BGpd-l9",255,255,255,true)
    outputChatBox("#E7D9B0Make sure to like and subscribe to Suzuki so he can afford better internet\nand upload videos in higher resolution",255,255,255,true)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),startText)
--addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()),startText)