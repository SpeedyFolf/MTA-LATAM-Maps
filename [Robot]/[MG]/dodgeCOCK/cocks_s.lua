-- settings
local start = { x = 200, y = 4000, z = 100 }
local length = 13
local chickenZ = start.z - 1

local tileDimensions = { x = 9, y = 9 }
local spacing = { x = 0.2, y = 0.2 }

local xPoints = {}
local yPoints = {}

local chickens = {}

-- random setup that doesnt depend on rest of script
(function()
	local function shuffle(a)
		for i = #a, 2, -1 do
			local j = math.random(i)
			a[i], a[j] = a[j], a[i]
		end
	end

	for x = 0, length - 1 do
		xPoints[#xPoints + 1] = start.x + x * (tileDimensions.x + spacing.x)
	end
	for y = 0, length - 1 do
		yPoints[#yPoints + 1] = start.y + y * (tileDimensions.y + spacing.y)
	end

	local firstChicken

	for i, maybeChicken in ipairs(getElementsByType("object", mapRoot)) do
--		if i > 200 then -- remove hack for dealing with duplicate objects (hack required for editor)
			if getElementModel(maybeChicken) == 16776 and getElementData(maybeChicken, "id") ~= "object (des_cockbody) (1)" then
				chickens[#chickens + 1] = maybeChicken
			elseif getElementData(maybeChicken, "id") == "object (des_cockbody) (1)" then
				firstChicken = maybeChicken
--			end
		end
	end

	shuffle(chickens)
	table.insert(chickens, 1, firstChicken)
end)()

local startTime
local level = 0
local activePlayers = {}

local chickenIndex = 1
local berserkChickenIndex = 1
local gameState = 0
local gameStates = {
	{ time = 0, level = 0.5, chickens = 1, },
	{ time = 10, level = 0.75, chickens = 1, },
	{ time = 11, level = 0.75, chickens = 1, },
	{ time = 30, level = 1, chickens = 1, },
	{ time = 45, level = 1.2, chickens = 1, },
	{ time = 60, level = 1.4, chickens = 1, berserk = 1, },
	{ time = 75, level = 1.6, chickens = 1, },
	{ time = 90, level = 1.7, chickens = 1, berserk = 1, } ,
	{ time = 100, level = 1.8, chickens = 1, },
	{ time = 110, level = 2, chickens = 1, },
	{ time = 119, level = 0, },
	{ time = 122, level = 0, berserk = 2, },
	{ time = 123, level = 0, berserk = 2, },
	{ time = 124, level = 0, berserk = 2, },
	{ time = 125, level = 0, berserk = 2, },
	{ time = 126, level = 0.5, },
	{ time = 130, level = 0.7, },
	{ time = 140, level = 0.8, chickens = 2, berserk = 2, },
	{ time = 150, level = 0.9, chickens = 2, berserk = 2, },
	{ time = 160, level = 1, chickens = 2, berserk = 2, },
	{ time = 170, level = 1.1, },
	{ time = 180, level = 1.2, },
	{ time = 190, level = 1.3, },
	{ time = 200, level = 1.4, },
	{ time = 220, level = 1.5, },
	{ time = 240, level = 1.6, },
	{ time = 260, level = 1.7, },
	{ time = 280, level = 3, },
}

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", getRootElement(), function(state)
	if state == "Running" then
		for _, player in ipairs(getElementsByType("player")) do
			activePlayers[#activePlayers + 1] = player
		end

		startTime = getTickCount()
		setTimer(function()
			local elapsedSeconds = (getTickCount() - startTime) / 1000

			if gameState < #gameStates and gameStates[gameState + 1].time < elapsedSeconds then
				gameState = gameState + 1
				level = gameStates[gameState].level

				local numChickensSpawned = gameStates[gameState].chickens or 0

				-- chicken spawner
				for i = 1, numChickensSpawned do
					local pos = chickenIndex
					setTimer(function()
						enableChicken(chickens[pos])
					end, math.random() * 2000, 1)
					chickenIndex = chickenIndex + 1
				end

				local numChickensBerserk = gameStates[gameState].berserk or 0

				-- chicken berserker
				for i = 1, numChickensBerserk do
					local pos = berserkChickenIndex

					berserkChicken(chickens[pos])

					berserkChickenIndex = berserkChickenIndex + 1
				end

--				print("gs", gameState, "\nlevel", level, "\nspawn", numChickensSpawned, "\nzerk", numChickensBerserk)
			end
		end, 1000, 0)
	end
end)

addEvent("onPlayerWasted")
addEventHandler("onPlayerWasted", getRootElement(), function()
	for i, player in ipairs(activePlayers) do
		if player == source then
			table.remove(activePlayers, i)
			local time = math.floor(exports.race:getTimePassed() / 1000)
			triggerEvent("onPlayerFinish", source, 0 ,  -time * 60 * 1000)
			if time >= 180 then
				exports.achievements:triggerAchievement(source, "dodgecockEndurance")
			end
			break
		end
	end
end)

addEvent("onChickenHit", true)
addEventHandler("onChickenHit", getRootElement(), function(chicken)
	for i = 1, berserkChickenIndex - 1 do
		if chickens[i] == chicken then
			local veh = getPedOccupiedVehicle(source)
			if veh then
				blowVehicle(veh)
				break
			end
		end
	end
end)

local zerkMessageShown = false
local fimmy = {
	"S.: #E7D9B0İ cant dodh3 all chi9ck3ns",
	"#44BBEESpeedyFolf: #E7D9B0Yea, debugscript is still spamming errors",
	"Gberry: #E7D9B0cock 8=D~",
	"Gberry: #E7D9B0all my maps should be deleted from the server tbh",
	"#DF95E8Console: Update happening after this map",
	"#4E5768* #FFFFFFLance_Latifi #4E5768has left the game [Kicked]",
	"#4E5768* #FFFFFFDiscoordination #4E5768has left the game [Timed Out]",
	"#4E5768* #FFFFFFJoshimuz #4E5768has joined the game",
	"#4E5768* #FFFFFF[meow]marshall #4E5768has joined the game\n#FFFFFF[meow]marshall: #E7D9B0can we not play gimmicks\n#4E5768* #FFFFFF[meow]marshall. #4E5768has left the game [Quit]",
	"#4E5768* #FFFFFFracing_obscenities #4E5768has left the game [Banned]",
	"#4E5768* #FFFFFFmisterfolg #4E5768has joined the game",
	"#4E5768* #FFFFFFjelmar#FF6A0035 #4E5768is now known as #FFFFFFPlayer394",
	"#4E5768* #FFFFFF[meow]misterfolg #4E5768is now known as #FFFFFFmisterfolg",
	"#CC0000=CoX=Wuzi #E7D9B0has collected all #3F3F3FBlack #E7D9B0Hidden Packages. Well done!\n#CC0000=CoX=Wuzi #E7D9B0has collected every #3F3F3FBlack #E7D9B0Hidden Package in dodgeCOCK!",
	"Mawfeen: #E7D9B0frick",
	"rrrrrrr#FF0000: #E7D9B0wait ican finish!!!!",
	"#00FF21Next map set to Super FleischBerg© Autos (Collisions)",
	"#00FF21Next map set to CAT CUP - Kinetic Keep",
	"#00FF21Next map set to Getting Over It With BMX 2",
	"#00FF21[Achievements] JoshimuzFanGirl got an achievement: '#E7D9B0Thank God It's Fry-day#00FF21'.",
	"#00FF21[Achievements] #44BBEESpeedyFolf #00FF21got an achievement: '#E7D9B01000 Hours#00FF21'.",
	"#00FF21[Achievements] JoshimuzFanGirl got an achievement: '#E7D9B0Cock Torture#00FF21'.",
	"Whitepoplar: #E7D9B0cockadoodledoo\n#00FF21[Achievements] Whitepoplar got an achievement: '#E7D9B0Fowl Language#00FF21'.",
	"#00FF21Lilied has reached 2048!",
	"#E1AA5AYou've rated this map #00FF2110/10#D2A564.",
	"#00BFFFNew top time #1: [meow]suzuki, -233:-0.0-0 (-31:00.000)",
	"#00BFFFNew top time #12: HumanXoTHotovich, -179:-0.0-0 (-8:00.000)",
	"PatricioGuitar: #E7D9B0Jhon es mí papa y jugamos de la misma PC",
	"#FFA800login: You have been logged out",
	"[FVC]#FFD800AliBoz: #E7D9B0maybe",
	"dzons#E642B7qqt: #E7D9B0dosen't suzuki hold the wr for this?",
	"#A509E0Katacalysm: #E7D9B0time to dig out those BradyGames strategy guides",
	"#E7D9B0Johan has collected every #FF0000Red #E7D9B0Hidden Package in Cluckin' Bell!",
	"euno: #E7D9B0cheesers...",
	"euno: #E7D9B0stop finishing u rats",
	"Lance_Latifi: #E7D9B0angry birds: the movie",
	"#832BC6grapez: #E7D9B0cum at me",
	"#832BC6virexcadros: #E7D9B0f this map",
	"#17C61DDied early in a DD? Type /quit to save the server from your whinging. Thank you!",
	"Ugly: #E7D9B0wifi is shit",
	"Ugly: #E7D9B0johan pack it up bro",
	"JoshimuzFanGirl: #E7D9B0blista cockpat",
	"#4ED381Positron: #E7D9B0so much angriness today in chat",
	"virexcadros: #E7D9B099999999999999",
	"Discoordination: #E7D9B0I don't fucking care if player crying that I blocked him. I having fun out of it",
	"des_cockbody: #E7D9B0gl",
	"Boterklontje: #E7D9B0hell yeahhhh",
	"botsofs: #E7D9B0test 13",
	"jonathanavt: #E7D9B0i survived a double front flip but not the chicken",
};

function berserkChicken(chicken)
	local deathAura = createMarker(0, 0, 0, "corona", 10, 255, 0, 0)
	local deathBlip = createBlipAttachedTo(chicken, 0, 2, 255, 0, 0)
	attachElements(deathAura, chicken, 0, 0, 7)
	if not zerkMessageShown then
		outputChatBox("#ffffffchicken #ff0000ANGRY#ffffff!!! #ffffffdo NOT touch.", root, 255, 255, 255, true)
		setTimer(outputChatBox, math.random(5000, 25000), 1, fimmy[math.random(#fimmy)], getRootElement(), 255, 255, 255, true)
		zerkMessageShown = true
	end
	triggerClientEvent(getRootElement(), "playChickenSound", getRootElement(), "cluck")
end

function enableChicken(chicken)
	setElementCollisionsEnabled(chicken, true)
	triggerClientEvent(getRootElement(), "playChickenSound", getRootElement(), "cockadoodledoo")

	local function move(chicken)
		local baseSpeed = level / 50

		if baseSpeed == 0 then
			setTimer(function()
				move(chicken)
			end, 100, 1)
			return
		end

		-- 80% to 100% speed
		local speed = baseSpeed * (0.8 + 0.2 * math.random())

		local x, y, z = getElementPosition(chicken)
		local nx = xPoints[math.random(#xPoints)]
		local ny = yPoints[math.random(#yPoints)]


		if math.random() < 0.1 and #activePlayers > 0 then
			local player = activePlayers[math.random(#activePlayers)]
			if isElement(player) then
				local x, y = getElementPosition(player)
				nx = x
				ny = y
			end
		end

		local angle = math.atan2(ny - y, nx - x) * 180 / math.pi + 90

		rotateObject(chicken, speed, angle, function()
			local delay = getDistanceBetweenPoints3D(x, y, z, nx, ny, chickenZ) / speed
			moveObject(chicken, delay, nx, ny, chickenZ, 0, 0, 0, "InOutQuad")

			setTimer(function()
				move(chicken)
			end, delay, 1)
		end)
	end

	move(chicken)
end

function rotateObject(obj, speed, z2, cb)
	local rotateStart = getTickCount()

	local rx, ry, rz = getElementRotation(obj)

	-- assume only care about z rotation
	local zRot = (z2 - rz + 180) % 360 - 180
	local duration = math.abs(zRot / (speed * 5))

	local function _rotate()
		local elapsed = getTickCount() - rotateStart
		if elapsed < duration then
			setElementRotation(obj, rx, ry, rz + elapsed / duration * zRot)
			setTimer(function()
				_rotate()
			end, 5, 1)
		else
			cb()
		end
	end

	_rotate()
end
