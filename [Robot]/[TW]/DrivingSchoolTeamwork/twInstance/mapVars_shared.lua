-- Constants / Variables -- These values can be easily changed
-- ---------------------
-- ---------------------
GATE_HELPER_REUNION = "_GATE_HELPER_REUNION"			-- editor id for the first gate
GATE_FINISH_LINE = "_GATE_FINISH_LINE"					-- editor id for the second gate

MAIN_COURSE_CHECKPOINTS = 24								-- this is the amount of checkpoints on the main course. Enough people acquiring this amount will trigger checkpoints being rewarded to helpers and allowing the team to finish the race
PLAY_AREA = createColRectangle(-2096,-281,86,215)			-- bounding rectangle of the play area. Players leaving this area will be flagged as wanderers. 

HELPER_AREA = createColCuboid(-2096, -281, 0, 72, 205, 36)	-- if riders enter this area, they will get a prompt to respawn (eg. they fell off the track or wandered out of a shared area)

MARKER_TEAM_CONFIG = "_MARKER_TEAM_CONFIG"					-- the marker for changing teams, name in editor. Make sure it matches, make sure it exists.
MARKER_FIRST_GATE = "_MARKER_FIRST_GATE"					-- marker in front of first gate, name in editor, informing pass throughers and forcing checkpoint catchup
MARKER_SECOND_GATE = "_MARKER_SECOND_GATE"					-- marker in front of second gate, name in editor, informing to wait for the rest of your team

-- camera used for the initial cutscene
CAMERA_POSITION_X = -2057.5
CAMERA_POSITION_Y = -83.4
CAMERA_POSITION_Z = 43.7
CAMERA_TARGET_X = -2052.4
CAMERA_TARGET_Y = -97.7
CAMERA_TARGET_Z = 38.8

POSSIBLE_TEAMS = {		-- possible team names & base colors. This list will be shuffled.
	{name = "Road Markings", 						r = 255, 	g = 255, 	b = 255, 	hex = "#FFFFFF"}, --white
	{name = "Team Oil", 							r = 0, 		g = 0, 		b = 0, 		hex = "#000000"}, -- black
	{name = "Team Tail Light", 						r = 255, 	g = 0, 		b = 0, 		hex = "#FF0000"}, -- red
	{name = "Going Offroad", 						r = 0, 		g = 255, 	b = 0, 		hex = "#00FF00"}, -- green
	{name = "The Windshield Washers", 				r = 0, 		g = 0, 		b = 255, 	hex = "#0000FF"}, -- blue
	{name = "Team Xenon", 							r = 0, 		g = 255, 	b = 255, 	hex = "#00FFFF"}, -- cyan
	{name = "Lavender Freshened Car Interior", 		r = 255, 	g = 0, 		b = 255, 	hex = "#FF00FF"}, -- magenta
	{name = "Team Turn Signal", 					r = 255, 	g = 255, 	b = 0, 		hex = "#FFFF00"}, -- yellow
}