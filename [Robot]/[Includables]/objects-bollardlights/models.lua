
local models = {

[7639] = { txd = "textures.txd", dff = "bollardlight1.dff", col = "bollardlight.col", lod=2000 },
[7638] = { txd = "textures.txd", dff = "bollardlight2.dff", col = "bollardlight.col", lod=2000 },
[7637] = { txd = "textures.txd", dff = "bollardlight3.dff", col = "bollardlight.col", lod=2000 },
[7609] = { txd = "textures.txd", dff = "bollardlight4.dff", col = "bollardlight.col", lod=2000 },
[7608] = { txd = "textures.txd", dff = "bollardlight5.dff", col = "bollardlight.col", lod=2000 },
[7607] = { txd = "textures.txd", dff = "bollardlight6.dff", col = "bollardlight.col", lod=2000 },
[7598] = { txd = "textures.txd", dff = "bollardlight7.dff", col = "bollardlight.col", lod=2000 },

}

function ReplaceTexture(modelId, texture)
	if texture then
		local txd = engineLoadTXD(texture)
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
		local dff = engineLoadDFF(modelData.dff, 0)
		if not dff then
			outputConsole(modelData.dff .." couldn't be loaded")
		else
			engineReplaceModel(dff, modelId)
		end
	end
	if modelData.col then
		local col = engineLoadCOL(modelData.col, modelId)
		if not col then
			outputConsole(modelData.col .." couldn't be loaded")
		else	
			engineReplaceCOL(col, modelId)
		end
	end	
	if modelData.lod then
		engineSetModelLODDistance(modelId, modelData.lod)
	end
end


addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function()
		for modelId,modelData in pairs(models) do
			if ReplaceTexture(modelId, modelData.txd) then
				ReplaceModel(modelId, modelData)
			end
		end
	end 
)