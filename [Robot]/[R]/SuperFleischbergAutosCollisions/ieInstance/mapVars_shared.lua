-- Generic

MARKER_EXPORT = getElementByID("_MARKER_EXPORT_PARK")

RECORDS_DATABASE_NAME = ":/mapSuperFleischbergAutosCollisionsRecords.db"
SAVEGAME_DATABASE_NAME = ":/mapSuperFleischbergAutosCollisionsSavedGame.db"

POLL_DURATION_IN_SECONDS = 28
CHEATING_THRESHOLD_IN_MS = 5000
SPAWN_DELAY_IN_MS = 2000
HALT_DELIVERY_TIMER_IN_MS = 5000

SPAWN_TRAINS_DERAILED = true
PLAY_GO_SOUND = true

MAX_Z = 1000 -- Ignore deliveries that have a Z coordinate higher than this

function customExportRequirements()
	return true
end