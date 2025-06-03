local models = {1226, 1232, 1350, 1568, 1283, 1284,
		717, 792, 737, 669, 669, 708, 
		1229, 1375, 1233, 1258, 1349, 1211, 1300, 1285, 1286, 1287, 1288, 1289, 1216, 1234,  
		966, 968, 1468, 3852, 1257,
		3851}

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		setCameraMatrix(3000,3000,3000)
		for _,model in pairs(models) do
			removeWorldModel(model, 50000, 0, 0, 0)
		end
		setTimer(setCameraTarget,1000,1,getLocalPlayer())

	end
)

addEventHandler("onClientResourceStop",resourceRoot,
	function()
		setCameraMatrix(3000,3000,3000)
		for _,model in pairs(models) do
			restoreWorldModel(model, 50000, 0, 0, 0)
		end
		setTimer(setCameraTarget,1000,1,getLocalPlayer())
	end
)