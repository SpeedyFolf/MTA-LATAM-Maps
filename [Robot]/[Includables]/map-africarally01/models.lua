local models = {

[4000] = { txd = "track.txd", dff="01.dff", col="01.col", lod=2000 },
[4001] = { txd = "track.txd", dff="02.dff", col="02.col", lod=2000 },
[4002] = { txd = "track.txd", dff="03.dff", col="03.col", lod=2000 },
[4003] = { txd = "track.txd", dff="04.dff", col="04.col", lod=2000 },
[4004] = { txd = "track.txd", dff="05.dff", col="05.col", lod=2000 },
[4005] = { txd = "track.txd", dff="06.dff", col="06.col", lod=2000 },
[4006] = { txd = "track.txd", dff="07.dff", col="07.col", lod=2000 },
[4007] = { txd = "track.txd", dff="08.dff", col="08.col", lod=2000 },
[4008] = { txd = "track.txd", dff="09.dff", col="09.col", lod=2000 },
[4009] = { txd = "track.txd", dff="10.dff", col="10.col", lod=2000 },
[4010] = { txd = "track.txd", dff="11.dff", col="11.col", lod=2000 },
[4011] = { txd = "track.txd", dff="12.dff", col="12.col", lod=2000 },
[4012] = { txd = "track.txd", dff="13.dff", col="13.col", lod=2000 },
[4013] = { txd = "track.txd", dff="14.dff", col="14.col", lod=2000 },
[4014] = { txd = "track.txd", dff="zebra.dff", col="zebra.col",  lod=2000 },


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
