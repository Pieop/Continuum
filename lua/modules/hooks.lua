local hookTable = hook.GetTable()
for hookID,hooks in pairs(hookTable) do
	--Ignore common hooks that are called very often:
	if(false and hookID ~= "Think" and hookID ~= "PostRender" and hookID ~= "PlayerTick" and hookID ~= "DrawOverlay" and hookID ~= "Tick"
	   and hookID ~= "PostDrawEffects" and hookID ~= "PreRender" and hookID ~= "NeedsDepthPass" and hookID ~= "RenderScreenspaceEffects" and hookID ~= ""
	   and hookID ~= "RenderScene" and hookID ~= "PostDrawOpaqueRenderables" and hookID ~= "HUDPaint" and hookID ~= "EntityRemoved" and hookID ~= "PlayerBindPress" and hookID ~= "" and hookID ~= ""
	   and hookID ~= "OnEntityCreated" and hookID ~= "XLIBDoAnimation") then
		hook.Add(hookID, "HacksHookCatchAll", function(...)
			local arg = {...}
			local printResult = "[HOOK] "..hookID.." called"
			local arg={...}
			if #arg > 0 then
				printResult = printResult.." with "
				for i,v in ipairs(arg) do
					printResult = printResult .. tostring(v) .. ", "
				end
			end
			print(printResult)
		
		end)
	else
		hook.Remove(hookID, "HacksHookCatchAll")
	end
end