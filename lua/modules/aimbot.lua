local aimbotTarget = nil
aimbotMode = 1

function aimbot()
	if(aimbotTarget ~= nil and (aimbotTarget == NULL or not aimbotTarget:Alive())) then
		aimbotTarget = nil
	end
	local ply = LocalPlayer()
	if(aimbotv2Mode == 1) then
		return
	end
	if (aimbotMode == Constants.AIMBOT_HARD) then
		if(aimbotTarget == nil) then
			local traceRes = util.TraceLine( util.GetPlayerTrace( ply ) )
			if traceRes.HitNonWorld then
				local target = traceRes.Entity
				if target:IsPlayer() and not IsTraitorBuddy(target) and not IsFriend(target) then
					aimbotTarget = target
				end
			end
			return
		end
		local targethead = aimbotTarget:LookupBone("ValveBiped.Bip01_Head1") or Constants.BONE_HEAD
		local targetheadpos,targetheadang = aimbotTarget:GetBonePosition(targethead)
		ply:SetEyeAngles((targetheadpos - ply:GetShootPos()):Angle())
	elseif(aimbotMode == Constants.AIMBOT_SOFT) then
		local ply = LocalPlayer()
		local traceRes = util.TraceLine( util.GetPlayerTrace( ply ) )
		if traceRes.HitNonWorld then
			local target = traceRes.Entity
			if target:IsPlayer() and not IsTraitorBuddy(target) and not IsFriend(target) then
				local targethead = target:LookupBone("ValveBiped.Bip01_Head1") or Constants.BONE_HEAD
				local targetheadpos,targetheadang = target:GetBonePosition(targethead)
				ply:SetEyeAngles((targetheadpos - ply:GetShootPos()):Angle())
			end
		end
	else
		aimbotTarget = nil
	end
end
function tryAimbot()
	if(aimbotMode == Constants.AIMBOT_ERROR) then
		return
	end
	local success, callback = pcall(aimbot)
	if(not success) then
		LogError(callback)
		aimbotMode = -1
	end
end
hook.Add("Think","aimbot",tryAimbot)
concommand.Add("hacks_aimbot_toggle", function()
	aimbotMode = (aimbotMode+1) % 3
end)