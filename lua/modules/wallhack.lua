local indicator   = surface.GetTextureID("effects/select_ring")
local c4warn      = surface.GetTextureID("VGUI/ttt/icon_c4warn")
local sample_scan = surface.GetTextureID("VGUI/ttt/sample_scan")
local det_beacon  = surface.GetTextureID("VGUI/ttt/det_beacon")
local WarningSystem = {"ttt_firegrenade_proj","ttt_c4", "npc_tripmine", "npc_grenade_frag", "crossbow_bolt", "rpg_missile", "grenade_ar2", "prop_combine_ball", "hunter_flechette", "ent_flashgrenade", "ent_explosivegrenade", "ent_smokegrenade"}

function MODULE:Activate()
	hook.Add( "HUDPaint", "hacks_wallhack", function()
	local ply = LocalPlayer()
	local vm = ply:GetViewModel()
	local gun = ply:GetActiveWeapon()
	local t = util.GetPlayerTrace(ply)
	local tr = util.TraceLine(t)
	
	if(GetConVarNumber("hacks_laserpointer") == 1 and ply:Alive()) then
		if vm and gun ~= NULL then
			local attachmentIndex = vm:LookupAttachment("1")
		 
			if attachmentIndex == 0 then attachmentIndex = vm:LookupAttachment("muzzle") end 
			local attachment = ply:GetAttachment(attachmentIndex)
			if attachment ~= nil and attachment ~= NULL then
				local eye = EyePos()
				local gunPos = attachment.Pos-- + Vector(20, -10, 0)
				if(ply:Crouching()) then
					gunPos = gunPos+Vector(0,0,-30)
				end
				
				cam.Start3D(eye, EyeAngles())
				render.SetMaterial(Material("sprites/bluelaser1"))
				render.DrawBeam(gunPos, tr.HitPos, 5, 1, 1, Color(255, 0, 0, 255))
				local dist = VectorDistance(tr.StartPos, tr.HitPos)
				local Size = math.Clamp((math.random()+.1) * 600 / dist, 5, 5)
				render.SetMaterial(Material("Sprites/light_glow02_add_noz"))
				render.DrawQuadEasy(tr.HitPos, (eye - tr.HitPos):GetNormal(), Size, Size, Color(255,0,0,255), 0)
				cam.End3D()
					local dlight = DynamicLight()
					dlight.Pos = tr.HitPos
					dlight.r = 200
					dlight.g = 0
					dlight.b = 0
					dlight.Brightness = 1
					dlight.Size = 50
					dlight.Decay = 0
					dlight.DieTime = CurTime() + 0.05
				print("Dynamic light: "..tostring(dlight.Pos))
					dlight = nil
			else
				local dlight = DynamicLight(LocalPlayer():UserID()+1)
				dlight.Size = 0
				dlight.Pos = Vector(0,0,0)
			end
		end
	end
		for k,ent in pairs (ents.GetAll()) do
			if(ent:GetClass() == "prop_ragdoll" and not CORPSE.GetFound(ent, false)) then
				local name = CORPSE.GetPlayerNick(ent, nil)
				if(name ~= nil) then
					local Position = ( ent:GetPos() + Vector( 0,0,20 ) ):ToScreen()
					--draw.DrawText( ent:Name(), "ChatFont", Position.x, Position.y, Color(0,0,0), 1 )
					draw.WordBox(1, Position.x, Position.y, name, "ChatFont", Color(0,0,0), Color(255,255,255,255))
					surface.SetDrawColor(0, 0, 0, 255)
					surface.SetTextColor(0, 0, 0, 255)
					drawRadar(ent, nil)
				end
			end
		end
		for k,v in pairs (player.GetAll()) do
			local isSpectating = not v:Alive() or v:Team() ~= 1
			if (GetConVarNumber("hacks_wallhack") >= 1 and v ~= LocalPlayer() and (GetConVarNumber("hacks_wallhack_spec") >= 1 or not isSpectating)) then
				if (not IsRoundOver() and LocalPlayer():Team()==1 and LocalPlayer():Alive()) or (isSpectating and GetConVarNumber("hacks_wallhack_spec") >= 1) then
					local Position = ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen()
					local Health = math.Clamp(v:Health(), 0, 100)
					local textColor = GetTrafficColor(Health)
					draw.DrawText( v:Name(), "ChatFont", Position.x, Position.y, textColor, 1 )
				end
				local textColor = Color( 10, 255, 0, 255 )
				local traitor = v.HatTraitor or (GAMETYPE == GAMETYPE_TTT and v:IsActiveTraitor())
				local detective = GAMETYPE == GAMETYPE_TTT and v:IsActiveDetective()
				local spectator = not v:Alive() or v:Team() ~= 1
				local innocent = not traitor and not detective and not spectator
				local role = traitor and ROLE_TRAITOR or detective and ROLE_DETECTIVE or innocent and ROLE_INNOCENT or -1
				if traitor then
					textColor = Colors.RED
				elseif detective then
					textColor = Colors.BLUE
				elseif spectator then
					textColor = Colors.YELLOW
				else
					textColor = Colors.GREEN
				end
				
				local x1,y1,x2,y2 = coordinates(v)
				
				surface.SetDrawColor(textColor)
				if((x1 > 0 or x2 > 0) and (y1 > 0 or y2 > 0) and false) then
					local size = math.Clamp((x2 - x1) / 5, 5, 200)
					surface.DrawLine( x1, y1, math.min( x1 + size, x2 ), y1 )
					surface.DrawLine( x1, y1, x1, math.min( y1 + size, y2 ) )
			 
			 
					surface.DrawLine( x2, y1, math.max( x2 - size, x1 ), y1 )
					surface.DrawLine( x2, y1, x2, math.min( y1 + size, y2 ) )
			 
			 
					surface.DrawLine( x1, y2, math.min( x1 + size, x2 ), y2 )
					surface.DrawLine( x1, y2, x1, math.max( y2 - size, y1 ) )
			 
			 
					surface.DrawLine( x2, y2, math.max( x2 - size, x1 ), y2 )
					surface.DrawLine( x2, y2, x2, math.max( y2 - size, y1 ) )
				end
			
			
				if role == ROLE_TRAITOR then
					surface.SetDrawColor(255, 0, 0, alpha)
					surface.SetTextColor(255, 0, 0, alpha)
				elseif role == ROLE_DETECTIVE then
					surface.SetDrawColor(0, 0, 255, alpha)
					surface.SetTextColor(0, 0, 255, alpha)
				elseif role == ROLE_INNOCENT then
					surface.SetDrawColor(0, 255, 0, alpha)
					surface.SetTextColor(0, 255, 0, alpha)
				else
					surface.SetDrawColor(255, 255, 0, alpha)
					surface.SetTextColor(255, 255, 0, alpha)
				end
				drawRadar(v, nil)
			if(GetConVarNumber("hacks_eyetrace") == 1) then
				local AP = v:GetEyeTrace().HitPos:ToScreen()
				local HP = HeadPos(v):ToScreen()
				surface.DrawLine(HP.x, HP.y, AP.x, AP.y)
			end
				--[[if v:Alive() then
					local y = 60
					for _,weapon in pairs(v._weapons) do
						local Position = ( v:GetPos() + Vector( -50,0,100 - y ) ):ToScreen()
						local wname = (_+1)..". "..LANG.TryTranslation( weapon.PrintName)
						local texture = weapon.WepSelectIcon
						--if(v._weapon ~= nil and weapon.PrintName == v._weapon.PrintName) then
						--	wname = "> ".wname
						--end
						draw.DrawText( wname, "ChatFont", Position.x, Position.y, Color(255, 255, 255), 1 )
						y = y + 15
					end
				end]]
			end
		end
	end)
	
	hook.Add("HUDPaint", "C4Warning", function()
		if(Constants.GAMETYPE == Constants.GAMETYPE_TTT and LocalPlayer():GetRole() ~= ROLE_TRAITOR) then
			surface.SetTexture(c4warn)
			surface.SetTextColor(200, 55, 55, 220)
			surface.SetDrawColor(255, 255, 255, 200)
			for _,ent in pairs(ents.GetAll()) do
				if(ent:GetClass() == "ttt_c4") then
					local bomb = { }
					bomb.t=-1--CurTime()--+60.0
					bomb.pos=ent:GetPos()
					DrawTarget(bomb, 24, 0, true)
				end
			end
		end
	end)
end
hook.Add("RenderScene", "WireFrame", function()
	for _, ent in pairs(ents.GetAll()) do
	if (table.HasValue(WarningSystem, ent:GetClass()) or IsTraitorWeapon(ent)) and ent.Owner ~= LocalPlayer() then
					local dlight = DynamicLight()
					dlight.Pos = ent:GetPos()
					dlight.r = 200
					dlight.g = 0
					dlight.b = 0
					dlight.Brightness = 10 
					dlight.Size = 30
					if(ent:GetClass() == "ttt_firegrenade_proj") then
						dlight.Size = 250
					end
					dlight.Decay = 0 
					dlight.DieTime = CurTime() + 0.2
		end
		local wep = ent:GetClass():starts("weapon_") or ent:GetClass():starts("item_ammo_") or ent:GetClass():starts("item_box_");
		local door = ent:GetClass():find("door") ~= nil;
		local body = ent:GetClass()  == "player" or ent:GetClass()  == "prop_ragdoll";
		
		local wireframeMode = GetConVarNumber("hacks_wireframe")
		local opt1 = (wireframeMode == 1 or wireframeMode == 4) and wep
		local opt2 = (wireframeMode == 2 or wireframeMode == 4) and body
		local opt3 = (wireframeMode == 3 or wireframeMode == 4) and door
		if (ent.Primary == nil or ent.Owner ~= LocalPlayer()) and (opt1 or opt2 or opt3)  then
			if opt3 then
				ent:SetMaterial("continuum/transparent.vmt")
			else
				ent:SetMaterial("hlmv/debugmrmwireframe")--"continuum/xray.vmt")   
			end 
			if ent:GetClass() == "player" then
				local textColor = Color( 10, 255, 0, 255 )
				if(ent.HatTraitor) then
					textColor = Colors.RED
				end
				if(GAMETYPE == GAMETYPE_TTT and ent:IsActiveDetective()) then
					textColor = Colors.BLUE
				end
				if(GAMETYPE == GAMETYPE_TTT and ent:IsActiveTraitor()) then
					textColor = Colors.RED
				end
				if(not ent:Alive() or ent:Team() ~= 1) then
					textColor = Colors.YELLOW
				end
				ent:SetColor(textColor)
			elseif wep then
				ent:SetColor(GetTrafficColor(25))
			else
				ent:SetColor(Color(0, 0, 0, 10))
			end
		else
			ent:SetMaterial("")
			ent:SetColor(Color(255, 255, 255, 255))
		end
		
	end
end)
MODULE:Activate()

CreateClientConVar("hacks_laserpointer", 1, true, false)
addCommandToggle("hacks_laserpointer", "Laser pointer", "Draws a laser on your screen from your gun", 1, { { "Laser turned ", Color(255, 0, 0), "off" },{ "Laser turned ", Color(0, 255, 0), "on" } })

CreateClientConVar("hacks_eyetrace", 0, true, false)
addCommandToggle("hacks_eyetrace", "Eyetrace", "Show where players are looking", 1, { { "Eyetrace turned ", Color(255, 0, 0), "off" },{ "Eyetrace turned ", Color(0, 255, 0), "on" } })
CreateClientConVar("hacks_wallhack", 1, true, false)
addCommandToggle("hacks_wallhack", "Wallhack", "Show all player names, and radar icons", 1, { { "Wallhack turned ", Color(255, 0, 0), "off" },{ "Wallhack turned ", Color(0, 255, 0), "on" } })
CreateClientConVar("hacks_wallhack_spec", 1, true, false)
addCommandToggle("hacks_wallhack_spec", "Wallhack Spectators", "Show spectators in the wallhack", 1, { { "Wallhack set to ", GetTrafficColor(0), "not show", Color(255,125,0), " spectators" },
 { "Wallhack set to ", GetTrafficColor(100), "show", Color(255,125,0), " spectators" },
	 })
	
CreateClientConVar("hacks_wireframe", 1, true, false)
addCommandToggle("hacks_wireframe", "Wireframe", "Toggle between different things to show wireframes for", 4, { {  "Wireframe set to ", GetTrafficColor(0), "off"},{"Wireframe set to ", GetTrafficColor(50), "weapons" },
	{ "Wireframe set to ", GetTrafficColor(50), "players" }, {"Wireframe set to ", GetTrafficColor(50), "doors"},{"Wireframe set to ", GetTrafficColor(100), "all"} })