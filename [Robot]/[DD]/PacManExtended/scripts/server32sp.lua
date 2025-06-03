-----------------------------------------------
-----------------------------------------------
----                                       ----
---- Made by [SKC]CsenaHUN & [SKC]MCvarial ----
----                                       ----
-----------------------------------------------
-----------------------------------------------

local models = {2052,2053,2054,2371,2372,2373}
local startTick = getTickCount()
local ghosts = {}
local timers = {}


---------
--Start--
---------
addEventHandler("onResourceStart",resourceRoot,
	function ()
		carshade01 = createObject(3458,-2281.69,2107,29,0,0,0)
		carshade02 = createObject(3458,-2281.69,2112,29,0,0,0)
		carshade03 = createObject(3458,-2321.69,2107,29,0,0,0)
		carshade04 = createObject(3458,-2321.69,2112,29,0,0,0)
		carshade05 = createObject(3458,-2354.29,2107,29,0,0,0)
		carshade06 = createObject(3458,-2354.29,2112,29,0,0,0)
		carshade07 = createObject(3458,-2394.29,2107,29,0,0,0)
		carshade08 = createObject(3458,-2394.29,2112,29,0,0,0)
		createGhosts()
	end
)

addEvent("onRaceStateChanging",true)
addEventHandler("onRaceStateChanging",root,
	function (newstate,oldstate)
		if newstate == "Running" and oldstate == "GridCountdown" then
			setTimer(destroyElement,20000,1,carshade01)
			setTimer(destroyElement,20000,1,carshade02)
			setTimer(destroyElement,20000,1,carshade03)
			setTimer(destroyElement,20000,1,carshade04)
			setTimer(destroyElement,20000,1,carshade05)
			setTimer(destroyElement,20000,1,carshade06)
			setTimer(destroyElement,20000,1,carshade07)
			setTimer(destroyElement,20000,1,carshade08)
			triggerClientEvent("onClientMapStart",resourceRoot)
			startGhosts()
		end
	end
)

----------------
--le junctions--
----------------
local junctions = {
	[1] = {x=-2257,y=1884,z=30,neighbours={2,7}},
	[2] = {x=-2293,y=1884,z=30,neighbours={1,3,8}},
	[3] = {x=-2329,y=1884,z=30,neighbours={2,10}},
	[4] = {x=-2347,y=1884,z=30,neighbours={5,11}},
	[5] = {x=-2383,y=1884,z=30,neighbours={4,6,13}},
	[6] = {x=-2419,y=1884,z=30,neighbours={5,14}},

	[7] = {x=-2257,y=1920,z=30,neighbours={1,8,15}},
	[8] = {x=-2293,y=1920,z=30,neighbours={2,7,9,16}},
	[9] = {x=-2311,y=1920,z=30,neighbours={8,10,17}},
	[10] = {x=-2329,y=1920,z=30,neighbours={3,9,11}},
	[11] = {x=-2347,y=1920,z=30,neighbours={4,10,12}},
	[12] = {x=-2365,y=1920,z=30,neighbours={11,13,20}},
	[13] = {x=-2383,y=1920,z=30,neighbours={5,12,14,21}},
	[14] = {x=-2419,y=1920,z=30,neighbours={6,13,22}},

	[15] = {x=-2257,y=1947,z=30,neighbours={7,16}},
	[16] = {x=-2293,y=1947,z=30,neighbours={8,15,29}},
	[17] = {x=-2311,y=1947,z=30,neighbours={9,18}},
	[18] = {x=-2329,y=1947,z=30,neighbours={17,24}},
	[19] = {x=-2347,y=1947,z=30,neighbours={20,26}},
	[20] = {x=-2365,y=1947,z=30,neighbours={12,19}},
	[21] = {x=-2383,y=1947,z=30,neighbours={13,22,32}},
	[22] = {x=-2419,y=1947,z=30,neighbours={14,21}},

	[23] = {x=-2311,y=1965,z=30,neighbours={24,30}},
	[24] = {x=-2329,y=1965,z=30,neighbours={18,23,26}},
	[25] = {x=-2338,y=1965,z=30,neighbours={24,26}},		--start
	[26] = {x=-2347,y=1965,z=30,neighbours={19,24,27}},
	[27] = {x=-2365,y=1965,z=30,neighbours={26,31}},

	[28] = {x=-2257,y=1992,z=30,neighbours={29}},
	[29] = {x=-2293,y=1992,z=30,neighbours={16,28,30,37}},
	[30] = {x=-2311,y=1992,z=30,neighbours={23,29,34}},
	[31] = {x=-2365,y=1992,z=30,neighbours={27,32,35}},
	[32] = {x=-2383,y=1992,z=30,neighbours={21,31,33,42}},
	[33] = {x=-2419,y=1992,z=30,neighbours={32}},

	[34] = {x=-2311,y=2010,z=30,neighbours={30,35,38}},
	[35] = {x=-2365,y=2010,z=30,neighbours={31,34,41}},

	[36] = {x=-2257,y=2037,z=30,neighbours={37,44}},
	[37] = {x=-2293,y=2037,z=30,neighbours={29,36,38}},
	[38] = {x=-2311,y=2037,z=30,neighbours={34,37,39}},
	[39] = {x=-2329,y=2037,z=30,neighbours={38,48}},
	[40] = {x=-2347,y=2037,z=30,neighbours={41,49}},
	[41] = {x=-2365,y=2037,z=30,neighbours={35,40,42}},
	[42] = {x=-2383,y=2037,z=30,neighbours={32,41,43}},
	[43] = {x=-2419,y=2037,z=30,neighbours={42,53}},

	[44] = {x=-2257,y=2055,z=30,neighbours={36,45}},
	[45] = {x=-2275,y=2055,z=30,neighbours={44,55}},
	[46] = {x=-2293,y=2055,z=30,neighbours={37,47,56}},
	[47] = {x=-2311,y=2055,z=30,neighbours={46,48,57}},
	[48] = {x=-2329,y=2055,z=30,neighbours={39,47,49}},
	[49] = {x=-2347,y=2055,z=30,neighbours={40,48,50}},
	[50] = {x=-2365,y=2055,z=30,neighbours={49,51,60}},
	[51] = {x=-2383,y=2055,z=30,neighbours={42,50,61}},
	[52] = {x=-2401,y=2055,z=30,neighbours={53,62}},
	[53] = {x=-2419,y=2055,z=30,neighbours={43,52}},

	[54] = {x=-2257,y=2082,z=30,neighbours={55,64}},
	[55] = {x=-2275,y=2082,z=30,neighbours={45,54,56}},
	[56] = {x=-2293,y=2082,z=30,neighbours={46,55}},
	[57] = {x=-2311,y=2082,z=30,neighbours={47,58}},
	[58] = {x=-2329,y=2082,z=30,neighbours={57,65}},
	[59] = {x=-2347,y=2082,z=30,neighbours={60,66}},
	[60] = {x=-2365,y=2082,z=30,neighbours={50,59}},
	[61] = {x=-2383,y=2082,z=30,neighbours={51,62}},
	[62] = {x=-2401,y=2082,z=30,neighbours={52,61,63}},
	[63] = {x=-2419,y=2082,z=30,neighbours={62,67}},

	[64] = {x=-2257,y=2100,z=30,neighbours={54,65}},
	[65] = {x=-2329,y=2100,z=30,neighbours={58,64,66}},
	[66] = {x=-2347,y=2100,z=30,neighbours={59,65,67}},
	[67] = {x=-2419,y=2100,z=30,neighbours={63,65}},

}


---------------
--Wakka Wakka--
---------------
function createGhosts ()
	for i,model in pairs (models) do
		local ghost = createObject(model,2330+i*2,1965,31,0,0,0)
		setElementCollisionsEnabled(ghost,false)
		table.insert(ghosts,ghost)
	end
end

function startGhosts ()
	local junction = junctions[25]
	for i,ghost in pairs (ghosts) do 
		local target = junctions[junction.neighbours[math.random(1,#junction.neighbours)]]
		local distance = getDistanceBetweenPoints2D(junction.x,junction.y,target.x,target.y,0,0,findRotation(junction.x,junction.y,target.x,target.y)+180)
		moveObject(ghost,getSpeed(distance),target.x,target.y,target.z+1)
		timers[ghost] = setTimer(function () triggerEvent("onGhostReachTarget",root,ghost,target) end,getSpeed(distance),1)
	end
end

function getSpeed (distance)
	return distance*100 -- might do a speedup here
end

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end

addEvent("onGhostReachTarget")
addEventHandler("onGhostReachTarget",root,
	function (ghost,junction)
		local target = junctions[junction.neighbours[math.random(1,#junction.neighbours)]]
		local distance = getDistanceBetweenPoints2D(junction.x,junction.y,target.x,target.y)
		setElementRotation(ghost,0,0,findRotation(junction.x,junction.y,target.x,target.y)+180)
		moveObject(ghost,getSpeed(distance),target.x,target.y,target.z+1)
		timers[ghost] = setTimer(function () triggerEvent("onGhostReachTarget",root,ghost,target) end,getSpeed(distance),1)
	end
)

addEvent("onGhostKill",true)
addEventHandler("onGhostKill",root,
	function (ghost)
		if isTimer(timers[ghost]) then
			killTimer(timers[ghost])
		end
		setElementPosition(ghost,2338,1965,31)
		local junction = junctions[25]
		local target = junctions[junction.neighbours[math.random(1,#junction.neighbours)]]
		local distance = getDistanceBetweenPoints2D(junction.x,junction.y,target.x,target.y,0,0,findRotation(junction.x,junction.y,target.x,target.y)+180)
		moveObject(ghost,getSpeed(distance),target.x,target.y,target.z+1)
		timers[ghost] = setTimer(function () triggerEvent("onGhostReachTarget",root,ghost,target) end,getSpeed(distance),1)
	end
)

addEvent("onPlayerBecomeGhost",true)
addEventHandler("onPlayerBecomeGhost",root,
	function (ghost)
		if isTimer(timers[ghost]) then
			killTimer(timers[ghost])
		end
		attachElements(ghost,getPedOccupiedVehicle(source),0,0,0,0,0,180)
	end
)
