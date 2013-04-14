--[[
Name: BCESP.lua
Product: BloodyChef Client Scripts
Author: Eusion
]]--

--Start configuration
--Custom ents mode, add the full name of an entity to be displayed on the ESP.
local CustomEnts = {"money_printer", "drug_lab", "drug", "microwave", "food", "gunlab", "spawned_shipment", "spawned_food", "spawned_weapon"}
--Warning system mode, these entities will have "WARNINGnot " printed on them, they will also have a red dynamic light giving you a better visual advantage.
local WarningSystem = {"npc_grenade_frag", "crossbow_bolt", "rpg_missile", "grenade_ar2", "prop_combine_ball", "hunter_flechette", "ent_flashgrenade", "ent_explosivegrenade", "ent_smokegrenade"}
--The custom models in this table will appear on the ESP like the warning system or CustomEnts mode.
local CustomModels = {"models/props/cs_assault/money.mdl"}
--Show players on the ESP?
local BCESPShowPlayers = true
--Display wireframes for invisible targets (May cause slight lag on older computers).
local BCESPShowWireframe = true
--Warning system for entities such as grenades.
local BCESPWarningSystem = true
--When enabled, the ESP will show models you specify on-screen.
local BCESPCustomModels = true
--Custom entities will be displayed on-screen if enabled, this uses the CustomEnts table.
local BCESPCustomEnts = true
--Display a box ESP if the player is visible.
local BCESPBox = true
--Show props and owners when you look at them on the ESP.
local BCESPShowProps = true
--The close distance (When an entity is a certain range a warning or information will should be displayed).
local BCESPCloseDistance = 300
--Draws a line from the players crosshair to the point of which it hits the world.
local BCESPAimLine = true
--End configuration, please don't edit below this line unless you have a vague knowledge of LUA Scripting.

local function GetAdmin(ply)
if ply:IsAdmin() and not ply:IsSuperAdmin() then
return "Admin"
elseif ply:IsSuperAdmin() then
return "Super Admin"
elseif not ply:IsAdmin() and not ply:IsSuperAdmin() then
return "Player"
end
end

local HeadOffset = Vector(0,0,45)
local TargetHead = true
local function HeadPos(ent)
if ent:IsPlayer() then
if TargetHead and ent:GetAttachment(1) ~= nil and ent:GetAttachment(1).Pos ~= nil then
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

local function Visible(ply)
local trace = {start = LocalPlayer():GetShootPos(),endpos = HeadPos(ply),filter = {LocalPlayer(), ply}}
local tr = util.TraceLine(trace)
if tr.Fraction == 1 then
return true
else
return false
end	
end

local function Close(ply)
if math.Round(tostring(ply:GetPos():Distance(LocalPlayer():GetShootPos()))) <= BCESPCloseDistance then
return true
else
return false
end
end

local function BCESP(ply)
	local TurnedOn = true
	hook.Add("HUDPaint", "BCESP", function()
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) and v ~= LocalPlayer() then
				local PlyPos = v:GetPos():ToScreen()
				if table.HasValue(WarningSystem, v:GetClass()) and BCESPWarningSystem == true then
					draw.WordBox(1, PlyPos.x, PlyPos.y, "WARNINGnot  (" .. string.gsub(v:GetClass(),"_"," ") .. ")" , "Default", Color(255,0,0,100), Color(255,255,255,255))
					draw.WordBox(1, PlyPos.x, PlyPos.y + 15, "Dist: ".. math.Round(tostring(v:GetPos():Distance(LocalPlayer():GetShootPos()))) .."", "Default", Color(255,0,0,100), Color(255,255,255,255))
					v:SetMaterial("BloodyChef/xray")
					v:SetColor(255,0,0,100)
					local dlight = DynamicLight(LocalPlayer():UserID())
					dlight.Pos = v:GetPos()
					dlight.r = 255
					dlight.g = 0
					dlight.b = 0
					dlight.Brightness = 10 
					dlight.Size = 100
					dlight.Decay = 0 
					dlight.DieTime = CurTime() + 0.2
				elseif table.HasValue(CustomEnts, v:GetClass()) and BCESPCustomEnts == true then
					draw.WordBox(1, PlyPos.x, PlyPos.y, ""  .. string.gsub(v:GetClass(),"_"," ") .. "", "Default", Color(0,255,0,100), Color(255,255,255,255))
					draw.WordBox(1, PlyPos.x, PlyPos.y + 15, "Dist: ".. math.Round(tostring(v:GetPos():Distance(LocalPlayer():GetShootPos()))) .."", "Default", Color(0,255,0,100), Color(255,255,255,255))
					v:SetMaterial("BloodyChef/xray")
					v:SetColor(0,255,0,100)
					local dlight = DynamicLight(LocalPlayer():UserID())
					dlight.Pos = v:GetPos()
					dlight.r = 0
					dlight.g = 255
					dlight.b = 0
					dlight.Brightness = 10 
					dlight.Size = 50
					dlight.Decay = 0 
					dlight.DieTime = CurTime() + 0.2
				elseif table.HasValue(CustomModels, v:GetModel()) and BCESPCustomModels == true then
					draw.WordBox(1, PlyPos.x, PlyPos.y, ""  .. v:GetModel() .. "", "Default", Color(100,100,100,100), Color(255,255,255,255))
					draw.WordBox(1, PlyPos.x, PlyPos.y + 15, "Dist: ".. math.Round(tostring(v:GetPos():Distance(LocalPlayer():GetShootPos()))) .."", "Default", Color(100,100,100,100), Color(255,255,255,255))
					v:SetMaterial("BloodyChef/xray")
					v:SetColor(255,255,255,100)
					local dlight = DynamicLight(LocalPlayer():UserID())
					dlight.Pos = v:GetPos()
					dlight.r = 255
					dlight.g = 255
					dlight.b = 255
					dlight.Brightness = 10 
					dlight.Size = 50
					dlight.Decay = 0 
					dlight.DieTime = CurTime() + 0.2
				elseif v:GetClass() == "player" and BCESPShowPlayers == true then
					if not Visible(v) and BCESPShowWireframe == true then
						local Col = team.GetColor(v:Team())
						draw.WordBox(1, PlyPos.x, PlyPos.y, v:Name(), "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
						draw.WordBox(1, PlyPos.x, PlyPos.y + 15, "Dist: ".. math.Round(tostring(v:GetPos():Distance(LocalPlayer():GetShootPos()))) .."", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
						draw.WordBox(1, PlyPos.x, PlyPos.y + 30, "" .. GetAdmin(v) .. "", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
						--hlmv/debugmrmwireframe
						v:SetMaterial("BloodyChef/xray")
						v:SetColor(Col.r, Col.g, Col.b, 100)
						elseif Visible(v) then
						v:SetMaterial("")
						v:SetColor(255,255,255,255)
						if v:GetActiveWeapon():IsValid() then
							local Col = team.GetColor(v:Team())
							draw.WordBox(1, PlyPos.x, PlyPos.y, v:Name(), "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
							draw.WordBox(1, PlyPos.x, PlyPos.y + 15, "Dist: ".. math.Round(tostring(v:GetPos():Distance(LocalPlayer():GetShootPos()))) .."", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
							draw.WordBox(1, PlyPos.x, PlyPos.y + 30, "HP: " .. v:Health() .. "", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
							draw.WordBox(1, PlyPos.x, PlyPos.y + 45, "" .. v:GetActiveWeapon():GetPrintName() .. "", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
							draw.WordBox(1, PlyPos.x, PlyPos.y + 60, "" .. GetAdmin(v) .. "", "Default", Color(Col.r,Col.g,Col.b,100), Color(255,255,255,255))
							--Start box ESP
							if BCESPBox == true and BCESPShowPlayers == true then
							local Col = team.GetColor(v:Team())
							local center = v:LocalToWorld(v:OBBCenter())
							local min,max = v:WorldSpaceAABB()
							local dim = max-min
							
							local front = v:GetForward()*(dim.y/2)
							local right = v:GetRight()*(dim.x/2)
							local top = v:GetUp()*(dim.z/2)
							local back = (v:GetForward()*-1)*(dim.y/2)
							local left = (v:GetRight()*-1)*(dim.x/2)
							local bottom = (v:GetUp()*-1)*(dim.z/2)
							local FRT = center+front+right+top
							local BLB = center+back+left+bottom
							local FLT = center+front+left+top
							local BRT = center+back+right+top
							local BLT = center+back+left+top
							local FRB = center+front+right+bottom
							local FLB = center+front+left+bottom
							local BRB = center+back+right+bottom
							
							FRT = FRT:ToScreen()
							BLB = BLB:ToScreen()
							FLT = FLT:ToScreen()
							BRT = BRT:ToScreen()
							BLT = BLT:ToScreen()
							FRB = FRB:ToScreen()
							FLB = FLB:ToScreen()
							BRB = BRB:ToScreen()
							
							local xmax = math.max(FRT.x,BLB.x,FLT.x,BRT.x,BLT.x,FRB.x,FLB.x,BRB.x)
							local xmin = math.min(FRT.x,BLB.x,FLT.x,BRT.x,BLT.x,FRB.x,FLB.x,BRB.x)
							local ymax = math.max(FRT.y,BLB.y,FLT.y,BRT.y,BLT.y,FRB.y,FLB.y,BRB.y)
							local ymin = math.min(FRT.y,BLB.y,FLT.y,BRT.y,BLT.y,FRB.y,FLB.y,BRB.y)
							
							surface.SetDrawColor(Col.r, Col.g, Col.b, 255)
							
							surface.DrawLine(xmax,ymax,xmax,ymin)
							surface.DrawLine(xmax,ymin,xmin,ymin)
							surface.DrawLine(xmin,ymin,xmin,ymax)
							surface.DrawLine(xmin,ymax,xmax,ymax)
							--End box ESP
							if BCESPAimLine == true then
								local Col = team.GetColor(v:Team())
								local AP = v:GetEyeTrace().HitPos:ToScreen()
								local HP = HeadPos(v):ToScreen()
								surface.SetDrawColor(Col.r, Col.g, Col.b, 255)
								surface.DrawLine(HP.x, HP.y, AP.x, AP.y)
							end
						end
					end
				end
				end
			end
		end
	end)
end
BCESP()

concommand.Add("bc_esp", function()
if TurnedOn then
hook.Remove("HUDPaint", "BCESP")
for k, v in pairs(player.GetAll()) do
v:SetMaterial("")
v:SetColor(255,255,255,255)
end
--ESNotify("[ESP] - Removed hooks.", NOTIFY_GENERIC, 6)
TurnedOn = false
elseif not TurnedOn then
BCESP()
--ESNotify("[ESP] - Game hook added.", NOTIFY_GENERIC, 6)
TurnedOn = true
end
end)

concommand.Add("bc_esp_players", function()
if BCESPShowPlayers then
BCESPShowPlayers = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Player ESP disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPShowPlayers then
BCESPShowPlayers = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Player ESP enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_wireframe", function()
if BCESPShowWireframe then
BCESPShowWireframe = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Wireframe disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPShowWireframe then
BCESPShowWireframe = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Wireframe enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_box", function()
if BCESPBox then
BCESPBox = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Box ESP disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPBox then
BCESPBox = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Box ESP enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_warning", function()
if BCESPWarningSystem then
BCESPWarningSystem = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Warnings disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPWarningSystem then
BCESPWarningSystem = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Warnings enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_customents", function()
if BCESPCustomEnts then
BCESPCustomEnts = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Custom ents disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPCustomEnts then
BCESPCustomEnts = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Custom ents enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_custommodels", function()
if BCESPCustomModels then
BCESPCustomModels = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Custom models disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPCustomModels then
BCESPCustomModels = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Custom models enabled.", NOTIFY_GENERIC, 6)
end
end)

concommand.Add("bc_esp_aimline", function()
if BCESPAimLine then
BCESPAimLine = false
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Aim line disabled.", NOTIFY_GENERIC, 6)
elseif not BCESPAimLine then
BCESPAimLine = true
hook.Remove("HUDPaint", "BCESP")
BCESP()
--ESNotify("[ESP] - Aim line enabled.", NOTIFY_GENERIC, 6)
end
end)

local function BCESPConfig()
local DermaPanel = vgui.Create( "DFrame" )
DermaPanel:SetPos( 50,50 )
DermaPanel:SetSize( 200, 250 )
DermaPanel:SetTitle( "BloodyChef ESP Configuration" )
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true )
DermaPanel:ShowCloseButton( true )
DermaPanel:MakePopup()
 
local MenuButton = vgui.Create("DButton")
MenuButton:SetParent( DermaPanel )
MenuButton:SetText( "Toggle Options" )
MenuButton:SetPos(25, 50)
MenuButton:SetSize( 150, 175 )
MenuButton.DoClick = function ( btn )
local MenuButtonOptions = DermaMenu()
MenuButtonOptions:AddOption("Toggle ESP", function() RunConsoleCommand("bc_esp") end )
MenuButtonOptions:AddOption("Show Players", function() RunConsoleCommand("bc_esp_players") end )
MenuButtonOptions:AddOption("Wallhack", function() RunConsoleCommand("bc_esp_wireframe") end )
MenuButtonOptions:AddOption("BOX ESP", function() RunConsoleCommand("bc_esp_box") end )
MenuButtonOptions:AddOption("Warnings", function() RunConsoleCommand("bc_esp_warning") end )
MenuButtonOptions:AddOption("Custom Entities", function() RunConsoleCommand("bc_esp_customents") end )
MenuButtonOptions:AddOption("Custom Models", function() RunConsoleCommand("bc_esp_custommodels") end )
MenuButtonOptions:AddOption("Aimline", function() RunConsoleCommand("bc_esp_aimline") end )
MenuButtonOptions:Open()
end
end
concommand.Add("bc_esp_config", BCESPConfig)