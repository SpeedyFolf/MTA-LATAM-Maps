--
-- common.lua
--   Common setting for server and client
--
-- Ripped from race
--

function isServer()		return triggerClientEvent ~= nil	end
function isClient()		return triggerServerEvent ~= nil	end


_TESTING = false             -- Any user can issue test commands

-- Server & Client:
--	root = getRoot()
--	resource = getThisResource()
--	resourceRoot = getResourceRootElement(getThisResource())

-- Client only:
if isClient() then
--	guiRoot = getResourceGUIElement(getThisResource())
	g_Me = getLocalPlayer()
end


---------------------------------------------------------------------------
-- Math extentions
---------------------------------------------------------------------------
function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end

function math.unlerp(from,to,pos)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end


function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.wrap(low,value,high)
    while value > high do
        value = value - (high-low)
    end
    while value < low do
        value = value + (high-low)
    end
    return value
end

function math.wrapdifference(low,value,other,high)
    return math.wrap(low,value-other,high)+other
end

-- curve is { {x1, y1}, {x2, y2}, {x3, y3} ... }
function math.evalCurve( curve, input )
	-- First value
	if input<curve[1][1] then
		return curve[1][2]
	end
	-- Interp value
	for idx=2,#curve do
		if input<curve[idx][1] then
			local x1 = curve[idx-1][1]
			local y1 = curve[idx-1][2]
			local x2 = curve[idx][1]
			local y2 = curve[idx][2]
			-- Find pos between input points
			local alpha = (input - x1)/(x2 - x1);
			-- Map to output points
			return math.lerp(y1,y2,alpha)
		end
	end
	-- Last value
	return curve[#curve][2]
end

function math.round ( value )
	return math.floor ( value + 0.5 )
end

---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Misc functions
---------------------------------------------------------------------------
function getSecondCount()
 	return getTickCount() * 0.001
end

-- remove color coding from string
function removeColorCoding ( name )
	return type(name)=='string' and string.gsub ( name, '#%x%x%x%x%x%x', '' ) or name
end

-- getPlayerName with color coding removed
_getPlayerName = getPlayerName
function getPlayerName ( player )
	return removeColorCoding ( _getPlayerName ( player ) )
end
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Camera functions
---------------------------------------------------------------------------
function getCameraRot()
	local px, py, pz, lx, ly, lz = getCameraMatrix()
	local rotz = math.atan2 ( ( lx - px ), ( ly - py ) )
 	local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
 	return math.deg(rotx), 180, -math.deg(rotz)
end
---------------------------------------------------------------------------



---------------------------------------------------------------------------
-- Table extentions
---------------------------------------------------------------------------
function table.map(t, callback, ...)
	for k,v in ipairs(t) do
		t[k] = callback(v, ...)
	end
	return t
end

function table.maptry(t, callback, ...)
	for k,v in pairs(t) do
		t[k] = callback(v, ...)
		if not t[k] then
			return false
		end
	end
	return t
end

function table.find(t, ...)
	local args = { ... }
	if #args == 0 then
		for k,v in pairs(t) do
			if v then
				return k
			end
		end
		return false
	end
	
	local value = table.remove(args)
	if value == '[nil]' then
		value = nil
	end
	for k,v in pairs(t) do
		for i,index in ipairs(args) do
			if type(index) == 'function' then
				v = index(v)
			else
				if index == '[last]' then
					index = #v
				end
				v = v[index]
			end
		end
		if v == value then
			return k
		end
	end
	return false
end

function table.merge(t1, t2)
	local l = #t1
	for i,v in ipairs(t2) do
		t1[l+i] = v
	end
	return t1
end

function table.removevalue(t, val)
	for i,v in ipairs(t) do
		if v == val then
			table.remove(t, i)
			return i
		end
	end
	return false
end

function table.deletevalue(t, val)
	for k,v in pairs(t) do
		if v == val then
			t[k] = nil
			return k
		end
	end
	return false
end

function table.deepcopy(t)
	local known = {}
	local function _deepcopy(t)
		local result = {}
		for k,v in pairs(t) do
			if type(v) == 'table' then
				if not known[v] then
					known[v] = _deepcopy(v)
				end
				result[k] = known[v]
			else
				result[k] = v
			end
		end
		return result
	end
	return _deepcopy(t)
end

function table.random(t)
	return t[math.random(#t)]
end

function table.dump(t, caption, depth)
	if not depth then
		depth = 1
	end
	if depth == 1 and caption then
		outputConsole(caption .. ':')
	end
	if not t then
		outputConsole('Table is nil')
	elseif type(t) ~= 'table' then
		outputConsole('Argument passed is of type ' .. type(t))
		local str = tostring(t)
		if str then
			outputConsole(str)
		end
	else
		local braceIndent = string.rep('  ', depth-1)
		local fieldIndent = braceIndent .. '  '
		outputConsole(braceIndent .. '{')
		for k,v in pairs(t) do
			if type(v) == 'table' and k ~= 'siblings' and k ~= 'parent' then
				outputConsole(fieldIndent .. tostring(k) .. ' = ')
				table.dump(v, nil, depth+1)
			else
				outputConsole(fieldIndent .. tostring(k) .. ' = ' .. tostring(v))
			end
		end
		outputConsole(braceIndent .. '}')
	end
end


function table.filter(t, callback, cmpval)
	if cmpval == nil then
		cmpval = true
	end
	for k,v in pairs(t) do
		if callback(v) ~= cmpval then
			t[k] = nil
		end
	end
	return t
end

function table.create(keys, vals)
	local result = {}
	if type(vals) == 'table' then
		for i,k in ipairs(keys) do
			result[k] = vals[i]
		end
	else
		for i,k in ipairs(keys) do
			result[k] = vals
		end
	end
	return result
end

function table.each(t, index, callback, ...)
	local args = { ... }
	if type(index) == 'function' then
		table.insert(args, 1, callback)
		callback = index
		index = false
	end
	for k,v in pairs(t) do
		callback(index and v[index] or v, unpack(args))
	end
	return t
end

function table.insertUnique(t,val)
	if not table.find(t, val) then
		table.insert(t,val)
	end
end

function table.popLast(t,val)
	if #t==0 then
		return false
	end
	local last = t[#t]
	table.remove(t)
	return last
end
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Timer - Wraps a standard timer
---------------------------------------------------------------------------
Timer = {}
Timer.__index = Timer
Timer.instances = {}

-- Create a Timer instance
function Timer:create()
    local id = #Timer.instances + 1
    Timer.instances[id] = setmetatable(
        {
            id = id,
            timer = nil,      -- Actual timer
        },
        self
    )
    return Timer.instances[id]
end

-- Destroy a Timer instance
function Timer:destroy()
    self:killTimer()
    Timer.instances[self.id] = nil
    self.id = 0
end

-- Check if timer is valid
function Timer:isActive()
    return self.timer ~= nil
end

-- killTimer
function Timer:killTimer()
    if self.timer then
        killTimer( self.timer )
        self.timer = nil
    end
end

-- setTimer
function Timer:setTimer( theFunction, timeInterval, timesToExecute, ... )
    self:killTimer()
    self.fn = theFunction
    self.count = timesToExecute
    self.args = { ... }
    self.timer = setTimer( function() self:handleFunctionCall() end, timeInterval, timesToExecute )
end

function Timer:handleFunctionCall()
    -- Delete reference to timer if there are no more repeats
    if self.count > 0 then
        self.count = self.count - 1
        if self.count == 0 then
            self.timer = nil
        end
    end
    self.fn(unpack(self.args))
end

---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Version checks
---------------------------------------------------------------------------
function isVersion10()
	return getVersion().number == 256
end
function isVersion101Compatible()
	return getVersion().number >= 257
end
function isVersion102Compatible()
	return getVersion().number >= 258
end
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Others
---------------------------------------------------------------------------
-- Element description for debugging
function getElementDesc(element)
	local bHasPlayerName = false
	local status = "[" .. tostring( getElementType(element) ) .. ":"

	if getElementType(element)=="player" then
		status = status .. getPlayerName(element)
		bHasPlayerName = true
	end
	if getElementType(element)=="vehicle" then
		local player = getVehicleController(element)
		if player then
			status = status .. "controller-" .. getPlayerName(player)
			bHasPlayerName = true
		end
	end
	if not bHasPlayerName then
		status = status .. string.gsub(tostring(element),".* 0*","0")
	end
	return status .. "]"
end

-- Modulo with more useful sign handling
function rem( a, b )
	local result = a - b * math.floor( a / b )
	if result >= b then
		result = result - b
	end
	return result
end


-- Rotations from a vehicle matrix
function getMatrixRotation( matrix )

	local Right = { x = matrix[1][1], y = matrix[1][2], z = matrix[1][3] }
	local Fwd	= { x = matrix[2][1], y = matrix[2][2], z = matrix[2][3] }
	local Up	= { x = matrix[3][1], y = matrix[3][2], z = matrix[3][3] }

	local rz = math.atan2( Fwd.y, Fwd.x )
	local rx = math.asin( Fwd.z )
	local ry = -math.atan2( Right.z, Up.z)

	-- Convert to degrees and ensure 0-360
	rx = rem( rx * (360/6.28), 360 )
	ry = rem( ry * (360/6.28), 360 )
	rz = rem( rz * (360/6.28) - 90, 360 )

	return rx, ry, rz
end


---------------------------------------------------------------------------
function msToTimeStr(ms)
	if not ms then
		return ''
	end
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	return minutes .. ':' .. seconds .. ':' .. centiseconds
end


---------------------------------------------------------------------------
-- Vector3D
---------------------------------------------------------------------------
Vector3D = {
	new = function(self, _x, _y, _z)
		local newVector = { x = _x or 0.0, y = _y or 0.0, z = _z or 0.0 }
		return setmetatable(newVector, { __index = Vector3D })
	end,

	Copy = function(self)
		return Vector3D:new(self.x, self.y, self.z)
	end,

	Normalize = function(self)
		local mod = self:Length()
		self.x = self.x / mod
		self.y = self.y / mod
		self.z = self.z / mod
	end,

	Dot = function(self, V)
		return self.x * V.x + self.y * V.y + self.z * V.z
	end,

	Length = function(self)
		return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	end,

	AddV = function(self, V)
		return Vector3D:new(self.x + V.x, self.y + V.y, self.z + V.z)
	end,

	SubV = function(self, V)
		return Vector3D:new(self.x - V.x, self.y - V.y, self.z - V.z)
	end,

	CrossV = function(self, V)
		return Vector3D:new(self.y * V.z - self.z * V.y,
							self.z * V.x - self.x * V.z,
							self.x * V.y - self.y * V.z)
	end,

	Mul = function(self, n)
		return Vector3D:new(self.x * n, self.y * n, self.z * n)
	end,

	Div = function(self, n)
		return Vector3D:new(self.x / n, self.y / n, self.z / n)
	end,
}
---------------------------------------------------------------------------


---------------------------------------------------------------------------
--
-- gets
--
---------------------------------------------------------------------------

-- get string or default
function getString(var,default)
    local result = get(var)
    if not result then
        return default
    end
    return tostring(result)
end

-- get number or default
function getNumber(var,default)
    local result = get(var)
    if not result then
        return default
    end
    return tonumber(result)
end

-- get true or false or default
function getBool(var,default)
    local result = get(var)
    if not result then
        return default
    end
    return result == 'true'
end



---------------------------------------------------------------------------
--
-- sets
--
---------------------------------------------------------------------------

-- set string
function setString(var,value)
	set( var, tostring(value) )
end

-- set number
function setNumber(var,value)
	set( var, tostring(value) )
end

-- set true or false
function setBool(var,value)
	set( var, tostring(value) )
end


---------------------------------------------------------------------------
-- Logging
---------------------------------------------------------------------------
if isClient() then
	function outputDebugStringServer(msg)
		triggerServerEvent( "onPlayerDebugString", resourceRoot, getPlayerName(g_Me) .. " " .. msg )
	end
else
	addEvent("onPlayerDebugString", true)
	addEventHandler("onPlayerDebugString", resourceRoot,
		function(msg)
			outputDebugStringServer( msg )
		end
	)
	function outputDebugStringServer(msg)
		local t = tostring(getTickCount())
		outputDebugString( "divint " .. t .. ": " .. msg )
	end
end

function outputDebugString2( msg, force )
	if _TESTING or force then
		outputDebugStringServer(msg)
	end
end


---------------------------------------------------------------------------
-- ACL
---------------------------------------------------------------------------
function isPlayerInACLGroup(player, groupNames)
	local account = getPlayerAccount(player)
	if not account then
		return false
	end
	local accountName = getAccountName(account)
	for _,name in ipairs(split(groupNames,string.byte(','))) do
		local group = aclGetGroup(name)
		if group then
			for i,obj in ipairs(aclGroupListObjects(group)) do
				if obj == 'user.' .. accountName or obj == 'user.*' then
					return true
				end
			end
		end
	end
	return false
end
