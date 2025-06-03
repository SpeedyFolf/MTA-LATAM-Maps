
local models = {

[7568] = { txd = "textures.txd", dff = "islandbase1.dff",      col = "islandbase1.col",      lod=2000 },
[7567] = { txd = "textures.txd", dff = "mbridge150m1.dff",     col = "mbridge150m1.col",     lod=2000 },
[7566] = { txd = "textures.txd", dff = "mbridge150m2.dff",     col = "mbridge150m2.col",     lod=2000 },
[7565] = { txd = "textures.txd", dff = "mbridge150m3.dff",     col = "mbridge150m3.col",     lod=2000 },
[7564] = { txd = "textures.txd", dff = "mbridge150m4.dff",     col = "mbridge150m4.col",     lod=2000 },
[7563] = { txd = "textures.txd", dff = "mbridgeramp1.dff",     col = "mbridgeramp1.col",     lod=2000 },
[7562] = { txd = "textures.txd", dff = "mroad150m.dff",        col = "mroad150m.col",        lod=2000 },
[7543] = { txd = "textures.txd", dff = "mroad40m.dff",         col = "mroad40m.col",         lod=2000 },
[7542] = { txd = "textures.txd", dff = "mroadb45t15degl.dff",  col = "mroadb45t15degl.col",  lod=2000 },
[7541] = { txd = "textures.txd", dff = "mroadb45t15degr.dff",  col = "mroadb45t15degr.col",  lod=2000 },
[7087] = { txd = "textures.txd", dff = "mroadbend15deg1.dff",  col = "mroadbend15deg1.col",  lod=2000 },
[7086] = { txd = "textures.txd", dff = "mroadbend15deg2.dff",  col = "mroadbend15deg2.col",  lod=2000 },
[7085] = { txd = "textures.txd", dff = "mroadbend15deg3.dff",  col = "mroadbend15deg3.col",  lod=2000 },
[7084] = { txd = "textures.txd", dff = "mroadbend15deg4.dff",  col = "mroadbend15deg4.col",  lod=2000 },
[7083] = { txd = "textures.txd", dff = "mroadbend180deg1.dff", col = "mroadbend180deg1.col", lod=2000 },
[7082] = { txd = "textures.txd", dff = "mroadbend45deg.dff",   col = "mroadbend45deg.col",   lod=2000 },
[7081] = { txd = "textures.txd", dff = "mroadhelix1.dff",      col = "mroadhelix1.col",      lod=2000 },
[7080] = { txd = "textures.txd", dff = "mroadloop1.dff",       col = "mroadloop1.col",       lod=2000 },
[7079] = { txd = "textures.txd", dff = "mroadtwist15degl.dff", col = "mroadtwist15degl.col", lod=2000 },
[7078] = { txd = "textures.txd", dff = "mroadtwist15degr.dff", col = "mroadtwist15degr.col", lod=2000 },
[7077] = { txd = "textures.txd", dff = "volcano.dff",          col = "volcano.col",          lod=2000 },

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