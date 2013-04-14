for _,v in pairs(player.GetAll()) do
        v.HatTraitor = nil
end
for _,v in pairs(ents.GetAll()) do
        v.HatESPTracked = nil
end
for _,v in pairs(player.GetAll()) do
	v._weapons = { }
	v._tmpweapons = { }
end

--local PM = FindMetaTable("Player")
hook.Add("PostDrawOpaqueRenderables", "wire_animations_idle", function()
		for _,v in pairs(player.GetAll()) do
       		v._tmpweapons = { }
		end
        if GAMEMODE.round_state ~= ROUND_ACTIVE then
                for _,v in pairs(player.GetAll()) do
                        v.HatTraitor = nil
						v._weapons = { }
						v._tmpweapons = { }
                end
                for _,v in pairs(ents.GetAll()) do
                        v.HatESPTracked = nil
                end
                return
        end
        for _,v in pairs( ents.GetAll() ) do
                local pl = v.Owner
        		if v and IsValid(v) then
                        if pl and IsValid(pl) and pl.IsTerror ~= nil and pl:IsTerror() and pl ~= LocalPlayer() then
                        		if(v.Slot ~= nil) then
                        			pl._tmpweapons[v.Slot] = v
                        		end
                        		
                        end
        		end
                if v and IsValid(v) and IsTraitorWeapon(v) and not v.HatESPTracked then
                        local pl = v.Owner
                        if pl and IsValid(pl) and pl:IsTerror() then
                                if pl:IsDetective() then
                                        v.HatESPTracked = true
                                else
                                        v.HatESPTracked = true
                                        pl.HatTraitor = true
                                        local wname = LANG.TryTranslation( v.PrintName)
                                        chat.AddText( pl, Color(255,125,0), " is a ",Color(255,0,0), "TRAITOR",Color(255,125,0), " with a ",Color(255,0,0),wname.."!")
                                end
                        end
                end
        end
		for _,v in pairs(player.GetAll()) do
       		v._weapons = v._tmpweapons
       		--v._weapon = v.GetActiveWeapon()
		end
end)