
local DarkRPWallhackEnabled = false
function DarkRPHack()
        DarkRPWallhackEnabled = true
        hook.Add("HUDPaint", "DarkRPESP", function()
                for _, ent in pairs(ents.GetAll()) do
                        if RPSlobBotAllowed(ent) then                   
                                local rpepos = ent:GetPos()
                                if rpepos:ToScreen().x > 0 and                  
                                rpepos:ToScreen().y > 0 and                     
                                rpepos:ToScreen().x < ScrW() and
                                rpepos:ToScreen().y < ScrH() then
                        local rppos1 = (ent:LocalToWorld( Vector(0,0,0)) ):ToScreen()   
                    if ent:GetModel() ~= "models/props/cs_assault/money.mdl" then                                       
                                                draw.SimpleTextOutlined("Class: "..ent:GetClass(), "ScoreboardText", rppos1.x, rppos1.y, Color(0, 0, 255, 255), 2, 1, 1, Color(255, 255, 255, 255))
                                        else
                                                draw.SimpleTextOutlined("MONEY", "ScoreboardText", rppos1.x, rppos1.y, Color(0, 0, 255, 255), 2, 1, 1, Color(255, 255, 255, 255))
                                        end     
                                end     
                        end
                end
        end)
end
concommand.Add("wots_togglerphack", function()
    if DarkRPWallhackEnabled then
        ook.Remove("HUDPaint", "DarkRPHUD")
        chat.addText("DarkRP mode: OFF")  
        DarkRPWallhackEnabled = false
    elseif not DarkRPWallhackEnabled then      
        DarkRPHack()
        chat.addText("DarkRP Mode: ON")   
        DarkRPWallhackEnabled = true            
    end
end)