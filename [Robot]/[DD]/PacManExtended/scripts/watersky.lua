------------------------------
------------------------------
--Water&Sky By [SKC]CsenaHUN--
------------------------------
------------------------------

-----------------
--Water Colours--
-----------------

wr = 0		--Red
wg = 127	--Green
wb = 255	--Blue
wa = 0		--Alpha (visibility)

---------------
--Sky Colours--
---------------

str = 0			--skytopRed
stg = 0			--skytopGreen
stb = 0          	--skytopBlue
sbr = 0			--skybottomRed
sbg = 0			--skybottomGreen
sbb = 0			--skybottomBlue

function thaResourceStarting( )
	setWaterColor ( wr, wg, wb, wa ) --water
	setSkyGradient ( str, stg, stb, sbr, sbg, sbb ) --sky
	setCloudsEnabled ( false ) --clouds
end
addEventHandler("onClientResourceStart", resourceRoot, thaResourceStarting)
