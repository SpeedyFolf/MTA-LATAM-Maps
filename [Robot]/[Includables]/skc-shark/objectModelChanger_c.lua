addEventHandler("onClientResourceStart", resourceRoot,
	function()
		txd = engineLoadTXD("skcShark.txd")
		engineImportTXD(txd, 1608)
		dff = engineLoadDFF("skcShark.dff", 1608)
		engineReplaceModel(dff, 1608)
end
)
