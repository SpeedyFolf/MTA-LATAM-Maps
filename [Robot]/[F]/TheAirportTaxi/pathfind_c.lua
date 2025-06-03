-- Path finding
vehicleNodes = {}
carIDs = {}
footNodes = {}

function getAreaID(x, y)
	return math.floor((y + 3000) / 750) * 8 + math.floor((x + 3000) / 750)
end

function getNodeByID(nodeID)
	local areaID = math.floor(nodeID / 65536)
	if areaID <= 63 and areaID >= 0 then
		return vehicleNodes[areaID][nodeID]
	end
end

function findNodePosition(x, y, z)
	local startNode = -1
	local distance = 10000
	local areaID = getAreaID(x, y)
	for j, row in pairs(vehicleNodes[areaID]) do
		local distanceNodes = getDistanceBetweenPoints3D(x, y, z, row.x, row.y, row.z)
		if distance > distanceNodes then
			distance = distanceNodes
			startNode = row
		end
	end
	return startNode
end

function getPath(startX, startY, startZ, goalX, goalY, goalZ)
	local startNode = findNodePosition(startX, startY, startZ)
	local goalNode = findNodePosition(goalX, goalY, goalZ)
	
	local usedNodes = {}
	usedNodes[startNode.id] = true

	local currentNodes = {}
	local ways = {}
	
	-- Initialization
	for id, distance in pairs(startNode.neighbours) do
		usedNodes[id] = true
		
		currentNodes[id] = distance
		ways[id] = { startNode.id }
	end
	
	while true do
		local bestNode = -1
		local distance = 10000
	
		for currentId, currentDist in pairs(currentNodes) do
			if currentDist < distance then
				bestNode = currentId
				distance = currentDist
				
				if math.random(2) == 1 then break end
			end
		end
		
		-- Fallback
		if bestNode == -1 then return false end
		if goalNode.id == bestNode then
			local zuMalen = bestNode
			local waypoints = {}
			
			while tonumber(zuMalen) do
				--createBlip(getNodeByID(zuMalen).x, getNodeByID(zuMalen).y, getNodeByID(zuMalen).z)
				table.insert(waypoints, {
					x = getNodeByID(zuMalen).x,
					y = getNodeByID(zuMalen).y,
					z = getNodeByID(zuMalen).z
				})	
				zuMalen = ways[zuMalen]
			end
			
			return waypoints
		end
		
		for neighborID, neighborDist in pairs(getNodeByID(bestNode).neighbours) do
			if not usedNodes[neighborID] then
				ways[neighborID] = bestNode
				currentNodes[neighborID] = distance + neighborDist
				usedNodes[neighborID] = true
			end
		end
		
		currentNodes[bestNode] = nil
	end
end

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function isVehicleReversing(theVehicle)
    local getMatrix = getElementMatrix (theVehicle)
    local getVelocity = Vector3 (getElementVelocity(theVehicle))
    local getVectorDirection = (getVelocity.x * getMatrix[2][1]) + (getVelocity.y * getMatrix[2][2]) + (getVelocity.z * getMatrix[2][3])
    if (getVectorDirection < 0) then
        return true
    end
    return false
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Load Nodes File	
	local file = fileOpen("nodes.json", true)
	local contents = fileRead(file, fileGetSize(file))
	fileClose(file)
	local vehicleNodesTMP = fromJSON(contents)
	
	file = fileOpen("foot_nodes.json", true)
	footNodes = fromJSON(fileRead(file, fileGetSize(file)))
	fileClose(file)
	
	-- Load crazy taxi
	engineImportTXD(engineLoadTXD("savanna.txd"), 567)
	engineReplaceModel(engineLoadDFF("savanna.dff"), 567)

	-- Convert
	for index, data in pairs(vehicleNodesTMP) do
		vehicleNodes[tonumber(index)] = {}
		for nodeIndex, nodeData in pairs(vehicleNodesTMP[index]) do
			local convertedNodeData = {}
			convertedNodeData.id = nodeData.id
			convertedNodeData.type = nodeData.type
			convertedNodeData.x = nodeData.x
			convertedNodeData.y = nodeData.y
			convertedNodeData.z = nodeData.z
			convertedNodeData.neighbours = {}
			
			for nodeDataIndex, nDist in pairs(nodeData.neighbours) do
				convertedNodeData.neighbours[tonumber(nodeDataIndex)] = nDist
			end
			
			vehicleNodes[tonumber(index)][tonumber(nodeIndex)] = convertedNodeData
		end
	end

	-- Store car nodes
	for _, areaData in pairs(vehicleNodes) do
		for nodeID, nodeData in pairs(areaData) do
			if nodeData.type == 0 then 
				table.insert(carIDs, nodeID) 
			end
		end
	end
end )