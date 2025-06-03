function onClientResourceStartReplaceModels()
	local modelsToReplace = {
		{
			colFile = "collisions/bassguitar01.col", -- Chips -> Bass Electric Guitar (SAMP)
			txdFile = "textures/bassguitar01.txd", -- Chips -> Bass Electric Guitar (SAMP)
			dffFile = "models/bassguitar01.dff", -- Chips -> Bass Electric Guitar (SAMP)
			modelID = 1877, -- chip_stack02
			alphaTransparency = false,
			filteringEnabled = true,
		},
		{
			colFile = "collisions/flyingv01.col", -- Chips -> Flying V Electric Guitar (SAMP)
			txdFile = "textures/flyingv01.txd", -- Chips -> Flying V Electric Guitar (SAMP)
			dffFile = "models/flyingv01.dff", -- Chips -> Flying V Electric Guitar (SAMP)
			modelID = 1878, -- chip_stack03
			alphaTransparency = false,
			filteringEnabled = true,
		},
		{
			colFile = "collisions/warlock01.col", -- Chips -> B.C. Rich Warlock Electric Guitar (SAMP)
			txdFile = "textures/warlock01.txd", -- Chips -> B.C. Rich Warlock Electric Guitar (SAMP)
			dffFile = "models/warlock01.dff", -- Chips -> B.C. Rich Warlock Electric Guitar (SAMP)
			modelID = 1879, -- chip_stack04
			alphaTransparency = false,
			filteringEnabled = true,
		},
		{
			colFile = nil,
			txdFile = "textures/gay_xref.txd", -- Gay Pride Flag -> Bisexual Pride Flag (Custom)
			dffFile = nil,
			modelID = 3854, -- GAY_telgrphpole
			alphaTransparency = false,
			filteringEnabled = true,
		},
	}

	for assetID = 1, #modelsToReplace do
		local modelData = modelsToReplace[assetID]
		local modelCol = modelData.colFile
		local modelTxd = modelData.txdFile
		local modelDff = modelData.dffFile
		local modelID = modelData.modelID

		if (modelCol) then
			local colData = engineLoadCOL(modelCol)

			if (colData) then
				engineReplaceCOL(colData, modelID)
			end
		end

		if (modelTxd) then
			local filteringEnabled = modelData.filteringEnabled
			local txdData = engineLoadTXD(modelTxd, filteringEnabled)

			if (txdData) then
				engineImportTXD(txdData, modelID)
			end
		end

		if (modelDff) then
			local dffData = engineLoadDFF(modelDff)

			if (dffData) then
				local alphaTransparency = modelData.alphaTransparency
				
				engineReplaceModel(dffData, modelID, alphaTransparency)
			end
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStartReplaceModels)
