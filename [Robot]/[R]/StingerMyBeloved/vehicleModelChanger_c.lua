VEHICLE_ID = 602
TXD_FILE = "stinger.txd"
DFF_FILE = "stinger.dff"

addEventHandler('onClientResourceStart', resourceRoot, 
	function() 
		txd = engineLoadTXD ( TXD_FILE )
		engineImportTXD ( txd, VEHICLE_ID ) 
			
		dff = engineLoadDFF ( DFF_FILE, VEHICLE_ID ) 
		engineReplaceModel ( dff, VEHICLE_ID ) 
	end 
)