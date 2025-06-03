
local models = {
	[1851] = { txd = "brianza.txd", dff="brianza_01.dff", col="brianza_01.col", lod=2000 },
	[1852] = { txd = "brianza.txd", dff="brianza_02.dff", col="brianza_02.col", lod=2000 },
	[1853] = { txd = "brianza.txd", dff="brianza_03.dff", col="brianza_03.col", lod=2000 },
	[1854] = { txd = "brianza.txd", dff="brianza_04.dff", col="brianza_04.col", lod=2000 },	
	[1855] = { txd = "brianza.txd", dff="brianza_05.dff", col="brianza_05.col", lod=2000 },	
	[1856] = { txd = "brianza.txd", dff="brianza_06.dff", col="brianza_06.col", lod=2000 },	
	[1857] = { txd = "brianza.txd", dff="brianza_07.dff", col="brianza_07.col", lod=2000 },	
	[1858] = { txd = "brianza.txd", dff="brianza_08.dff", col="brianza_08.col", lod=2000 },	
	[1859] = { txd = "brianza.txd", dff="brianza_09.dff", col="brianza_09.col", lod=2000 },	
	[1860] = { txd = "brianza.txd", dff="brianza_10.dff", col="brianza_10.col", lod=2000 },	
	[1861] = { txd = "brianza.txd", dff="brianza_11.dff", col="brianza_11.col", lod=2000 },	
	[1862] = { txd = "brianza.txd", dff="brianza_12.dff", col="brianza_12.col", lod=2000 },	
	[1863] = { txd = "brianza.txd", dff="brianza_13.dff", col="brianza_13.col", lod=2000 },	
	[1864] = { txd = "brianza.txd", dff="brianza_14.dff", col="brianza_14.col", lod=2000 },	
	[1865] = { txd = "brianza.txd", dff="brianza_15.dff", col="brianza_15.col", lod=2000 },	
	[1866] = { txd = "brianza.txd", dff="brianza_16.dff", col="brianza_16.col", lod=2000 },	
	[1867] = { txd = "brianza.txd", dff="brianza_17.dff", col="brianza_17.col", lod=2000 },	
	[1868] = { txd = "brianza.txd", dff="brianza_18.dff", col="brianza_18.col", lod=2000 },	
	[1869] = { txd = "brianza.txd", dff="brianza_19.dff", col="brianza_19.col", lod=2000 },	
	[1870] = { txd = "brianza.txd", dff="brianza_20.dff", col="brianza_20.col", lod=2000 },	
	[1871] = { txd = "brianza.txd", dff="brianza_21.dff", col="brianza_21.col", lod=2000 },	
	[1872] = { txd = "brianza.txd", dff="brianza_22.dff", col="brianza_22.col", lod=2000 },	
	[1873] = { txd = "brianza.txd", dff="brianza_23.dff", col="brianza_23.col", lod=2000 },	
	[1874] = { txd = "brianza.txd", dff="brianza_24.dff", col="brianza_24.col", lod=2000 },	
	[1875] = { txd = "brianza.txd", dff="brianza_25.dff", col="brianza_25.col", lod=2000 },	
	[1876] = { txd = "brianza.txd", dff="brianza_26.dff", col="brianza_26.col", lod=2000 },	
	[1877] = { txd = "brianza.txd", dff="brianza_27.dff", col="brianza_27.col", lod=2000 },		
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