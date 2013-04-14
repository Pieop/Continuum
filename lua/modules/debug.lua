function debugger( calling_ply,command,args )
	local variable_name = strjoin(" ", args)
	variable_name = variable_name:gsub("|", "\"")
	msg("Running debug with "..variable_name)
	local success, callback
	local p = variable_name:gsub("\".-\"", "")
	if(p:find("return") == nil) then
		success, callback = pcall(RunString, "function evaluateLua() return "..variable_name.." end")
	else
		success, callback = pcall(RunString, "function evaluateLua() "..variable_name.." end")
	end
	if(not success) then
		msg("Datatype: [error]")
		msg("Compilation error: "..callback)
		return
	end
	local success, callback = pcall(evaluateLua)
	if(not success) then
		msg("Datatype: [error]")
		msg("Runtime error: "..callback)
		return
	end
	local luaevalh = callback
	msg("Datatype: "..type(luaevalh))
	if type( luaevalh ) == "nil" then
		msg("Null value (void)")
	elseif type( luaevalh ) == "boolean" then
		msg("Value: "..tostring(luaevalh))
	elseif type( luaevalh ) == "number" then
		msg("Value: "..tostring(luaevalh))
	elseif type( luaevalh ) == "string" then
		msg("Value: ".."\""..luaevalh.."\"")
	elseif type( luaevalh ) == "function" then
		local funcinfo = debug.getinfo(luaevalh)
		--linedefined, lastlinedefined, short_src
		if(funcinfo.short_src == '[C]') then
			msg("C Function")
		else
			msg(funcinfo.short_src .. ":"..funcinfo.linedefined)
		end
	elseif type( luaevalh ) == "thread" then
		msg(tostring(luaevalh))
	elseif type( luaevalh ) == "table" then
		printTable(luaevalh)
	else
		printTable(getmetatable(luaevalh))
	end
	
	
end
function tryDebugger(calling_ply,command,args)
	if(aimbotv2Mode == AIMBOT_ERROR) then
		return
	end
	local status, err = pcall(debugger, calling_ply,command,args)
	if(not status) then
		LogError(err)
	end
end
--Put three options in the autocomplete list - Red, green, and blue.
function getAutoCompleteOptions(commandName,args)
	local current = strjoin("",args):sub(2)
	local options = { }
	local globals = _G
    local validOptions = { }
    
	options = addTo(options, "", _G, -1, current)
	if(options ~= nil) then
		for key,val in pairs(options) do
			if(val:starts(current)) then
				table.insert(validOptions, "hacks_lua "..val)
			end
		end
	end
	table.sort(validOptions, function(a, b) return a < b end)
	return validOptions
end
function addTo(options, evaluateCode, value, depth, target)
	if(evaluateCode == "_G" or value == nil or depth > 4 ) then
		return
	end
	if type( value ) == "nil" or type( value ) == "boolean" or type( value ) == "number" or type( value ) == "string" or type( value ) == "thread" then
		if evaluateCode:starts(target) then
			table.insert(options, evaluateCode)
		end
	elseif type( value ) == "function" then
		if(target:starts(evaluateCode.."()")) then
			local status,val = pcall(value)
			if status then
				addTo(options, evaluateCode.."()", val, depth+1, target)
			end
		else
			if (evaluateCode.."("):starts(target) then
				table.insert(options, (evaluateCode.."("))
			end
		end
	elseif type( value ) == "table" then
		if evaluateCode:starts(target) then
			table.insert(options, evaluateCode)
		end
		if(evaluateCode == "") then
			for tname,tvalue in pairs(value) do
				addTo(options, tname, tvalue, depth+1, target)
			end
		else
			for tname,tvalue in pairs(value) do
				if(type(tname) == "string") then
					if (evaluateCode.."."..tostring(tname)):starts(target) then
						table.insert(options, evaluateCode.."."..tostring(tname))
					end
					addTo(options, evaluateCode.."."..tostring(tname), tvalue, depth+1, target)
					if(type(tvalue) == "function") then
						addTo(options, evaluateCode..":"..tostring(tname), tvalue, depth+1, target)
					end
				elseif(type(tname) == "number") then
					addTo(options, evaluateCode.."["..tostring(tname).."]", tvalue, depth+1, target)
					if (evaluateCode.."["..tostring(tname).."]"):starts(target) then
						table.insert(options, evaluateCode.."["..tostring(tname).."]")
					end
				end
			end
		end
	else
		local tbl = getmetatable(value)
		for tname,tvalue in pairs(tbl) do
				if(type(tname) == "string") then
					addTo(options, evaluateCode.."."..tostring(tname), tvalue, depth+1, target)
					if(type(tvalue) == "function") then
						addTo(options, evaluateCode..":"..tostring(tname), tvalue, depth+1, target)
					end
				elseif(type(tname) == "number") then
					addTo(options, evaluateCode.."["..tostring(tname).."]", tvalue, depth+1, target)
				end
		end
	end
	return options
end
concommand.Add("hacks_lua",tryDebugger, getAutoCompleteOptions, "Lua code to evaluate")