MODULE.name = "Aimbotv2"
aimbotv2Target = nil
aimbotv2Mode = 0
function findPlayerOnScreen()
	if(Constants.aimbotMode == AIMBOT_HARD and aimbotv2Target ~= nil) then
		if(aimbotv2Target ~= nil and aimbotv2Target.target.Alive == nil or not aimbotv2Target.target:Alive()) then
			aimbotv2Target = nil
			return nil
		end
		local trace = util.TraceLine({endpos = aimbotv2Target.bone, start=EyePos()})
		if trace.HitNonWorld and trace.Entity == v then
			return aimbotv2Target
		end
	end
	local topDamageInfo = LoadTraceData( nil, nil, nil )
	for k,v in pairs (player.GetAll()) do
		if v:Alive() and v:IsValid() and v ~= LocalPlayer() and ((not IsTraitorBuddy(v) and not IsFriend(v)) or IsRoundOver()) then
			local bones = { Constants.BONE_HEAD ,Constants.BONE_TORSO, Constants.BONE_GEAR,Constants.BONE_SPINE,Constants.BONE_LEFT_HAND,Constants.BONE_RIGHT_HAND,Constants.BONE_LEFT_FOOT, Constants.BONE_RIGHT_FOOT }
			for _,bone in pairs(bones) do
				local boneTraceData = LoadTraceData(nil, v, bone)
				if boneTraceData.traceRes ~= nil and boneTraceData.traceRes.HitNonWorld and boneTraceData.target == v then
					if(boneTraceData.dist < topDamageInfo.dist) then
						topDamageInfo = boneTraceData
						break
					end
				end
			end
		end
	end
	if topDamageInfo.target == nil then
		return nil
	else
		aimbotv2Target = topDamageInfo
		return topDamageInfo
	end
end
function aimbotv2()
	if(not LocalPlayer():Alive() or
	 aimbotv2Mode < 1 or LocalPlayer():GetActiveWeapon() == NULL
	 or LocalPlayer():GetActiveWeapon():GetPrintName() == "Holstered") then
	 	aimbotv2Target = nil
		return
	end
	local data = findPlayerOnScreen()
	if(data == nil) then
		return
	end
	local target = data.target
	local bone = data.bone
	if(target ~= nil) then
		local targetheadpos = target:GetBonePosition(bone)
		if(targetheadpos == nil) then
			return
		end
		LocalPlayer():SetEyeAngles((targetheadpos - LocalPlayer():GetShootPos()):Angle())
	end
end

function tryAimbotv2()
	if(aimbotv2Mode == Constants.AIMBOT_ERROR) then
		return
	end
	local success, callback = pcall(aimbotv2)
	if(not success) then
		LogError(callback)
		aimbotv2Mode = -1
	end
end
hook.Add("Think","aimbotv2",tryAimbotv2)
concommand.Add("hacks_aimbotv2_toggle", function()
	aimbotv2Mode = (aimbotv2Mode+1) % 2
end)
