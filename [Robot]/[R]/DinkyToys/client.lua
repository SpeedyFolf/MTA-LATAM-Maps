	

    local exceptions = {
            [13647] = true,
            [6959] = true,
            [11433] = true,
            [8661] = true,
            [8664] = true,
            [3246] = true,
            [4848] = true,
            [4022] = true,
            [16096] = true,
            [8171] = true,
            [4199] = true,
            [12925] = true,
            [972] = true,
            [8355] = true,
            [7912] = true,
            [3498] = true,
            [4826] = true,
            [9131] = true,
            [8558] = true,
            [1277] = true,
            [11547] = true,
            [1225] = true,
            [3571] = true,
            [1655] = true,
            [9834] = true,
            [9241] = true,
            [8947] = true
    }
     
    addEventHandler("onClientResourceStart",resourceRoot,
            function()
                    for i,object in ipairs (getElementsByType("object")) do
                            local model = getElementModel(object)
                            if not exceptions[model] then
                                    local x,y,z = getElementPosition(object)
                                    local a,b,c = getElementRotation(object)
                                    local lodobject = createObject(model,x,y,z,a,b,c,true)
                                    setElementDimension(lodobject,getElementDimension(object))
                                    setObjectScale(lodobject,getObjectScale(object))
                                    setLowLODElement(object,lodobject)
                                    engineSetModelLODDistance(model,300)
                            end
                    end
            end
    )

