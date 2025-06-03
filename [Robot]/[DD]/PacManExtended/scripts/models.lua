-----------------------------------------------
-----------------------------------------------
----                                       ----
---- Made by [SKC]CsenaHUN & [SKC]MCvarial ----
----                                       ----
-----------------------------------------------
-----------------------------------------------

models = {

[2052] = { txd = "ghost.txd", dff="ghost01blue.dff", col="ghost.col", lod=2000 },
[2053] = { txd = "ghost.txd", dff="ghost02red.dff", col="ghost.col", lod=2000 },
[2054] = { txd = "ghost.txd", dff="ghost03orange.dff", col="ghost.col", lod=2000 },
[2371] = { txd = "ghost.txd", dff="ghost04purple.dff", col="ghost.col", lod=2000 },
[2372] = { txd = "ghost.txd", dff="ghost05green.dff", col="ghost.col", lod=2000 },
[2373] = { txd = "ghost.txd", dff="ghost06yellow.dff", col="ghost.col", lod=2000 },

}

function ReplaceTexture(modelId, texture)
	if texture then
		local txd = engineLoadTXD("models/"..texture)
		if not txd then
			outputConsole(texture .." couldn't be loaded")
		else
			return engineImportTXD(txd, modelId)
		end
	end
	return false
end


function ReplaceModel(modelId, modelData)
	if modelData.dff then
		local dff = engineLoadDFF("models/"..modelData.dff, 0)
		if not dff then
			outputConsole(modelData.dff .." couldn't be loaded")
		else
			engineReplaceModel(dff, modelId)
		end
	end
	if modelData.lod then
		engineSetModelLODDistance(modelId, modelData.lod)
	end
end


addEventHandler("onClientResourceStart",resourceRoot, 
	function()
		for modelId,modelData in pairs(models) do
			if ReplaceTexture(modelId, modelData.txd) then
				ReplaceModel(modelId, modelData)
			end
		end
	end
)


addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		local restore = {2052, 2053, 2054, 2371, 2372, 2373}
		for index, model in pairs(restore) do
			engineRestoreModel(model)
			engineRestoreCOL(model)
		end
	end
)
