LANG.AddToLanguage("english", "continuum_traitor", "TRAITOR")
LANG.AddToLanguage("english", "continuum_dead", "DEAD")
function ScoreGroup(p)
   if not IsValid(p) then return -1 end -- will not match any group panel

   if DetectiveMode() then
      if p:IsSpec() and (not p:Alive()) then
         if p:GetNWBool("body_found", false) then
            return GROUP_FOUND
         else
            return GROUP_NOTFOUND
         end
      end
   end

   return p:IsTerror() and GROUP_TERROR or GROUP_SPEC
end
hook.Add("Think", "ScoreboardTags", function() 
        if GAMEMODE.round_state ~= ROUND_ACTIVE then
                for _,v in pairs(player.GetAll()) do
					player.sb_tag = nil
                end
                return
        end
	for _,ply in pairs(player.GetAll()) do
		if ply:Alive() then
			local traitor = ply.HatTraitor or (GAMETYPE == GAMETYPE_TTT and ply:IsActiveTraitor())
			local detective = GAMETYPE == GAMETYPE_TTT and ply:IsActiveDetective()
			local spectator = not ply:Alive() or ply:Team() ~= 1
			local innocent = not traitor and not detective and not spectator
			local role = traitor and ROLE_TRAITOR or detective and ROLE_DETECTIVE or innocent and ROLE_INNOCENT or -1
			if role == ROLE_TRAITOR then
				ply.sb_tag = { txt='continuum_traitor', color=Color(255,0,0) }
			end
			if(ply.sb_tag ~= nil and ply.sb_tag.txt == "continuum_dead") then
				ply.sb_tag = { txt=''}
			end
			if(ply.sb_tag ~= nil) then
			--	print(ply:Nick()..": "..tostring(ply.sb_tag.txt))
			end
		else
				ply.sb_tag = { txt='continuum_dead', color=Color(20,20,20) }
		end
	end
end)