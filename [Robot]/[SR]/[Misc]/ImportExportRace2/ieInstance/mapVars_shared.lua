-- Generic

MARKER_EXPORT = getElementByID("_MARKER_EXPORT_PARK")

RECORDS_DATABASE_NAME = ":/mapImportExportRace2Records.db"
SAVEGAME_DATABASE_NAME = ":/mapImportExportRace2SavedGame.db"

POLL_DURATION_IN_SECONDS = 10
CHEATING_THRESHOLD_IN_MS = 5000
SPAWN_DELAY_IN_MS = 0
HALT_DELIVERY_TIMER_IN_MS = 5000

SPAWN_TRAINS_DERAILED = true
PLAY_GO_SOUND = false

MAX_Z = 100 -- Ignore deliveries that have a Z coordinate higher than this

function customExportRequirements()
	local spawncars = {
		[438] = true, -- cabbie
		[420] = true, -- taxi
		[522] = true, -- nrg500
		[589] = true, -- club
		[507] = true, -- elegant
		[558] = true, -- uranus
		[504] = true, -- bloodring
		[586] = true  -- wayfarer
	}
	if (spawncars[getElementModel(getPedOccupiedVehicle(localPlayer))]) then
		return false
	end
	return true
end