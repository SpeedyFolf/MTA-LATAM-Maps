
local models = {


[7572] = { txd = "textures.txd", dff = "funboxramp1.dff",   col = "funboxramp1.col",   lod=2000 },
[7571] = { txd = "textures.txd", dff = "funboxramp2.dff",   col = "funboxramp2.col",   lod=2000 },
[7570] = { txd = "textures.txd", dff = "funboxramp3.dff",   col = "funboxramp3.col",   lod=2000 },
[7569] = { txd = "textures.txd", dff = "funboxtop.dff",     col = "funboxtop.col",     lod=2000 },

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