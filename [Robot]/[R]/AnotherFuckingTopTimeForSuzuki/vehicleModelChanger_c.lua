VEHICLE_ID = 461
TXD_FILE = "pcj600.txd"
DFF_FILE = "pcj600.dff"

addEventHandler('onClientResourceStart', resourceRoot, 
	function() 
		txd = engineLoadTXD ( TXD_FILE )
		engineImportTXD ( txd, VEHICLE_ID ) 
			
		dff = engineLoadDFF ( DFF_FILE, VEHICLE_ID ) 
		engineReplaceModel ( dff, VEHICLE_ID ) 
	end 
)