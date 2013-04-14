resource.AddFile("materials/continuum/crosshairs2.png")
aimbotMode = aimbotMode or 0
aimbotv2Mode = aimbotv2Mode or 0
aimbotv2Target = aimbotv2Target or nil
local function drawHackHUD()
	--[[if(LocalPlayer():GetActiveWeapon() ~= nil and LocalPlayer():GetActiveWeapon() ~= NULL and LocalPlayer():GetActiveWeapon():GetPos() ~= nil) then
		local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
		cam.Start3D(EyePos(), EyeAngles())
		render.SetMaterial(Material("sprites/bluelaser1"))
		render.DrawBeam(LocalPlayer():GetActiveWeapon():GetPos(), tr.HitPos, 2, 0, 12.5, Color(255, 0, 0, 255))
		cam.End3D()
	end
	]]
	
	local baseX = ScrW() - 300
	local baseY =  ScrH() - 400
	local width = 150
	local height = 200
	
    --Draw background:
	draw.RoundedBox(10, baseX, baseY, width, height, Color(25,25,25,200))
	surface.SetDrawColor(Color(220,220,220,200))
	surface.DrawLine(baseX, baseY+27, baseX+width, baseY+27)
	
	--Draw title:
	draw.DrawText("Engine Modules", "CenterPrintText", baseX+ (width / 2), baseY+5, Colors.CONTINUUM, TEXT_ALIGN_CENTER )
	
    surface.SetDrawColor( Colors.WHITE );
	surface.SetMaterial( Material( "continuum/crosshairs2.png" ) );
    surface.DrawTexturedRect( baseX+5, baseY+30, 26, 26 );
	draw.DrawText(aimbotMode == Constants.AIMBOT_ERROR and "Error" or aimbotMode == Constants.AIMBOT_SOFT and "Weak Lock" or aimbotMode == Constants.AIMBOT_HARD and "Strong Lock"
	 or "Off", "ChatFont", baseX+40, baseY+35, GetTrafficColor(aimbotMode*50), TEXT_ALIGN_LEFT )
	 
	 
	surface.SetMaterial( Material( "continuum/crosshairs2.png" ) );
    surface.DrawTexturedRect( baseX+5, baseY+50, 26, 26 );
	draw.DrawText(  "v2","TargetIDSmall",baseX+25, baseY+60,Color(255, 255, 255, 255),1)
	draw.DrawText(aimbotMode == Constants.AIMBOT_ERROR and "Error" or aimbotv2Mode == Constants.AIMBOT_SOFT and "AimRape" or "Off", "ChatFont",baseX+40, baseY+60, GetTrafficColor(aimbotv2Mode*100), TEXT_ALIGN_LEFT )
	
	surface.SetMaterial( Material( "icon16/eye.png" ) );
    surface.DrawTexturedRect( baseX+5, baseY+75, 26, 26 );
	draw.DrawText(GetConVarNumber("hacks_wallhack") >= 1 and "On" or "Off", "ChatFont", baseX+40, baseY+85, GetTrafficColor(GetConVarNumber("hacks_wallhack")*100), TEXT_ALIGN_LEFT )
	
	
	local traceRes = LocalPlayer():GetEyeTrace()
	local data = LoadTraceData( traceRes, nil, nil )
	if data ~= nil then
		if(data.target ~= nil and data.target:IsValid()) then
			draw.DrawText("Hit: "..data.target:GetClass() or "", "ChatFont", baseX+40, baseY+110, Colors.WHITE, TEXT_ALIGN_LEFT )
		else
			draw.DrawText("Hit: None" or "", "ChatFont", baseX+40, baseY+110, Colors.WHITE, TEXT_ALIGN_LEFT )
		end
		draw.DrawText("Bone: "..tostring(data.boneName) or "", "ChatFont", baseX+40, baseY+135, Colors.WHITE, TEXT_ALIGN_LEFT )
	end
	--
    surface.SetDrawColor( Colors.WHITE );
	surface.SetMaterial( Material( "hlmv/debugmrmwireframe" ) );
    surface.DrawTexturedRect( baseX+5, baseY+160, 26, 26 );
	draw.DrawText(GetConVarNumber("hacks_wireframe") == 1 and "Weapons" or GetConVarNumber("hacks_wireframe") == 2 and "Bodies" or GetConVarNumber("hacks_wireframe") == 3 and
	 "Doors" or GetConVarNumber("hacks_wireframe") == 4 and "All" or "None", "ChatFont", baseX+40, baseY+160, GetConVarNumber("hacks_wireframe") == 0 and GetTrafficColor(0) or
	 GetConVarNumber("hacks_wireframe") == 4 and GetTrafficColor(100) or GetTrafficColor(50), TEXT_ALIGN_LEFT )
	
	
	if(GAMETYPE == GAMETYPE_TTT) then
		local str = "Known traitors: "
		for k,v in pairs (player.GetAll()) do
			if v.HatTraitor or (v.GetTraitor ~= nil and v:GetTraitor()) then
				if str == "Known traitors: " then
					str = str..v:Nick()
				else
					str = str.."; "..v:Nick()
			end
				end
		end
		draw.DrawText(str, "TargetID", ScrH() - 100, ScrW() / 2, Colors.RED, TEXT_ALIGN_CENTER)
	end
	
	
end
function tryDrawHackHUD()
	local success, callback = pcall(drawHackHUD)
	if(not success) then
		LogError(callback)
		hook.Remove("HUDPaint", "HackHUD")
	end
end
hook.Add("HUDPaint", "HackHUD", tryDrawHackHUD)

