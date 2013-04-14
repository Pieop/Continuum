function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
function math.round(x, place)
	if(place == nil) then
		place = 0
	end
	x = x * math.pow(10, place)
	if x%2 ~= 0.5 then
		    return math.floor(x+0.5)
	end
	x = x-0.5
	return x / math.pow(10,place)
end
function drawRadar(ent, color)
	if not IsValid(ent) then
		return
	end
	local alpha_base = 230
	local mpos = Vector(ScrW() / 2, ScrH() / 2, 0)	
	local role, alpha, scrpos, md
	if color ~= nil then
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
		surface.SetTextColor(color.r, color.g, color.b, color.a)
	end
	surface.SetTexture(surface.GetTextureID("effects/select_ring"))
	local pos = ent:GetPos() + Vector(0, 0, 40)
	alpha = alpha_base
	scrpos = pos:ToScreen()
	md = mpos:Distance(Vector(scrpos.x, scrpos.y, 0))
	if md < 180 then
		alpha = math.Clamp(alpha * (md / 180), 40, 230)
	end
	alpha = 230
	DrawTarget(ent, 24, 0)
end
function IsTraitorWeapon(v)
	return v.CanBuy ~= nil and not v.AutoSpawnable and #v.CanBuy == 1 and v.CanBuy[1]==ROLE_TRAITOR
end
function string.url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end
function string.url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end
HeadOffset = Vector(0,0,30)
TargetHead = false
function HeadPos(ent)
	if ent:IsPlayer() then
		if TargetHead then
			return ent:GetAttachment(1).Pos + ent:GetAngles():Forward() * -4
		else
			if ent:Crouching() then
				return ent:GetPos() + (HeadOffset * 0.586)
			else
				return ent:GetPos() + HeadOffset
			end
		end
	else
		return ent:GetPos() + HeadOffset
	end
end

function LogError(error)
	local caller = debug.getinfo(2)
	chat.AddText(Colors.RED,"Error in ", Colors.WHITE, caller.short_src, Colors.RED, " module; ", Colors.ORANGE, error )
end
function GetTrafficColor(percentage)
	local x = (100.0-percentage) / 100.0
	return Color(math.Clamp(2.0 * x * 255, 0, 255), math.Clamp(2.0 * (1 - x) * 255, 0, 255), 0);
end
function IsTraitorBuddy(target)
	if Constants.GAMETYPE == Constants.GAMETYPE_TTT and target.GetTraitor ~= nil then
		return target:GetTraitor() and LocalPlayer():GetTraitor()
	end
	return false
end
function IsFriend(target)
	if target:SteamID() == "STEAM_0:1:45204579" or target:SteamID() == "STEAM_0:1:30917314" then
		return true
	end
	return false
end
function VectorDistance(v1, v2)
	return math.sqrt((v1.x-v2.x)^2+(v1.y-v2.y)^2+(v1.z-v2.z)^2)
end
function LoadTraceData( traceRes, targetPlayer, targetBone )
	if(targetBone ~= nil and targetPlayer ~= nil and traceRes == nil) then
		local trace = {endpos = targetPlayer:GetBonePosition(targetBone), start=LocalPlayer():GetActiveWeapon():GetPos()}
		--icon
		--vgui from slob
		--other stuff in skype
		--launcher
		
		if(targetBone == Constants.BONE_HEAD) then
			trace.endpos = trace.endpos + Vector(0, 0, 10)
		end
		traceRes = util.TraceLine(trace)
	end
	if(targetBone == nil and traceRes == nil) then
		return {visible=false, traceRes=nil, target=nil, bone=-1, damage=0, dist=5000, boneName="None" }
	end
	local target = nil
	local bone = 0
	local boneName = nil
	local damage = 0
	local dist = VectorDistance(traceRes.StartPos, traceRes.HitPos)
	local visible = false
	local hitTarget = false
	target = traceRes.Entity
	if(target ~= nil and target:IsPlayer()) then
		bone = target:TranslatePhysBoneToBone(traceRes.PhysicsBone)
		boneName = GetBoneName(traceRes.Entity:TranslatePhysBoneToBone(traceRes.PhysicsBone))
		if(targetBone ~= nil) then
			visible = bone == targetBone
		end
		hitTarget = target == targetPlayer
		damage = 1
		local hitgroup = traceRes.HitGroup
		if ( hitgroup == HITGROUP_HEAD ) then
			damage = 2
		end
		if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_GEAR ) then
			damage = .25
		end
	end
	if(targetBone ~= nil) then
		bone = targetBone
		boneName = GetBoneName(bone)
	end
	return { visible=visible, hitTarget=hitTarget, traceRes=traceRes, target=target, bone=bone, damage=damage, dist=dist, boneName=boneName }
end
function GetBoneName( id )
	local name = "?"
	if id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == -1 then
		name = ""
	elseif id == Constants.BONE_GEAR then
		name = "Gear"
	elseif id == Constants.BONE_LEFT_HAND then
		name = "Left Hand"
	elseif id == Constants.BONE_RIGHT_HAND then
		name = "Right Hand"
	elseif id == Constants.BONE_LEFT_FOOT then
		name = "Left Foot"
	elseif id == Constants.BONE_RIGHT_FOOT then
		name = "Right Foot"
	elseif id == Constants.BONE_SPINE then
		name = "Spine"
	elseif id == Constants.BONE_HEAD then
		name = "Head"
	elseif id == Constants.BONE_TORSO then
		name = "Torso"
	end
	return name .. " ["..id.."]"
end
function IsRoundOver()
	return GAMEMODE.round_state == ROUND_POST
end
function coordinates( ent )
	local min, max = ent:OBBMins(), ent:OBBMaxs()
	local corners = {
			Vector( min.x, min.y, min.z ),
			Vector( min.x, min.y, max.z ),
			Vector( min.x, max.y, min.z ),
			Vector( min.x, max.y, max.z ),
			Vector( max.x, min.y, min.z ),
			Vector( max.x, min.y, max.z ),
			Vector( max.x, max.y, min.z ),
			Vector( max.x, max.y, max.z )
	}
	 
	local minX, minY, maxX, maxY = ScrW() * 2, ScrH() * 2, 0, 0
	for _, corner in pairs( corners ) do
			local onScreen = ent:LocalToWorld( corner ):ToScreen()
			minX, minY = math.min( minX, onScreen.x ), math.min( minY, onScreen.y )
			maxX, maxY = math.max( maxX, onScreen.x ), math.max( maxY, onScreen.y )
	end
	 
	return minX, minY, maxX, maxY
end
function strjoin(delimiter, list)
  local len = #list
  if len == 0 then 
    return "" 
  end
  local string = list[1]
  for i = 2, len do 
    string = string .. delimiter .. list[i] 
  end
  return string
end
function broadcast(...)
	BroadcastLua( "chat.AddText( Entity("..ply:EntIndex().."), Color( 255, 255, 255 ), [[ voted to change the gamemode]] )" )
end
function msg (...)
	local printResult = ""
	local arg={...}
	for i,v in ipairs(arg) do
		printResult = printResult .. tostring(v) .. "\t"
	end
	printResult = printResult .. "\n"
	LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, printResult)
end
function tableToString (...)
	local printResult = ""
	local arg={...}
	for i,v in ipairs(arg) do
		printResult = printResult .. tostring(v) .. ", "
	end
	return printResult
end
function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0-- iterator variable
		local iter = function () -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
function printTable(t)
	for key, val in pairsByKeys(t) do
		msg(key, val)
	end
end
function DrawTarget(tgt, size, offset, no_shrink)
	if(tgt.GetPos == nil) then
		return
	end
	tgt.pos = tgt:GetPos()
   local scrpos = tgt.pos:ToScreen() -- sweet
   local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size

   scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
   scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)

   surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

   -- Drawing full size?
   if sz == size then
      local text = math.ceil(LocalPlayer():GetPos():Distance(tgt.pos))
      local w, h = surface.GetTextSize(text)

      -- Show range to target
      surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
      surface.DrawText(text)

      if tgt.t then
         -- Show time
         if tgt.t >= 0 then
         	text = util.SimpleTime(tgt.t - CurTime(), "%02i:%02i")
         else
         	text = "--:--"
         end
         w, h = surface.GetTextSize(text)

         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      elseif tgt.nick then
         -- Show nickname
         text = tgt.nick
         w, h = surface.GetTextSize(text)

         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      end
   end
end
function addCommandToggle(cvar, name, description, maxValue, printTables)
	if maxValue == nil then
		maxValue = 1
	end
	table.insert(cvars, {cvar=cvar, name=name, description=description, maxValue=maxValue, printTables=printTables})
	concommand.Add(cvar.."_toggle", function()
		local val = (GetConVarNumber(cvar) + 1) % (maxValue+1)
		RunConsoleCommand(cvar,val)
		if(printTables ~= nil and printTables[val+1] ~= nil) then
			chat.AddText(unpack(printTables[val+1]))
		end
	end)
end
cvars = { }
function loadModule(name)
	if(name:starts("ttt.") and Constants.GAMETYPE ~= Constants.GAMETYPE_TTT) then
		return true
	end
	if(name:starts("darkrp.") and Constants.GAMETYPE ~= Constants.GAMETYPE_DARKRP) then
		return true
	end
	MODULE = { name=name, version=1.0, cvars = { } }
	local success, callback = pcall(include, "modules/"..name)
	if(not success) then
		chat.AddText(Colors.RED, "An error occurred while loading", Colors.WHITE, name, Colors.RED, "module:")
		LogError(callback)
		return false
	end
	if MODULE.description == nil then
		MODULE.description = MODULE.name.." module version "..MODULE.version
	end
	if MODULE.cvars ~= nil then
		for _,cvar in pairs(MODULE.cvars) do 
			addCommandToggle(cvar.name, cvar.options, cvar.optionsCount)
		end
	end
	msg("[Continuum Engine] ".. MODULE.name ~= nil and MODULE.name or name .." module loaded")
	return true
end
function checkForUpdates()
	Constants.newVersion = nil
	Constants.versionLoaded = false
	print("Checking for latest version...")
	http.Post( "http://www.fatalhazard.com/continuum/version.txt", { },
		function( versionStr )
			Constants.newVersion = tonumber(versionStr) or 1.0
			if(Constants.newVersion > Constants.version) then
				chat.AddText(Colors.WHITE,"A new version of ", Colors.CONTINUUM, "Continuum Engine", Colors.WHITE, " (v"..Constants.newVersion..") is available! Opening update page...")
				gui.OpenURL("http://www.fatalhazard.com/continuum/update.php?name="..LocalPlayer():Nick():url_encode())
			elseif Constants.newVersion < Constants.version then
				chat.AddText(Colors.WHITE,"You are currently running on a development build ["..Constants.version..">"..Constants.newVersion.."]!" )
			else
				chat.AddText(Colors.WHITE,"You are currently running the latest version of ", Colors.CONTINUUM, "Continuum Engine", Colors.WHITE,"!" )
			end
			Constants.versionLoaded = true
		end,
		function()
			print("Error occurred while trying to fetch latest version number")
			Constants.newVersion = -1
			print(Constants.newVersion)
			Constants.versionLoaded = true
		end
	 );
end
function hacks_help( calling_ply,command,args )
	if(#args > 0) then
		RunConsoleCommand("find", "hacks_"..args[1])
	else
		RunConsoleCommand("find", "hacks_")
	end
end
concommand.Add("hacks_help",hacks_help)