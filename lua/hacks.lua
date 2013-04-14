include( "constants.lua" )
include( "util.lua" )
checkForUpdates()
local modules = file.Find( "lua/modules/*", "MOD" )
function loadModules()
	for _,name in pairs(modules) do
		if not loadModule(name) then
			return false
		end
	end
	chat.AddText(Colors.CONTINUUM,"Continuum Engine ", Colors.CONTINUUM, ""..Constants.version, Colors.WHITE, " loaded! Type hacks_help in console to learn more" )
	return true
end
if not loadModules() then
	chat.AddText(Colors.CONTINUUM,"Continuum Engine ", Colors.CONTINUUM, ""..Constants.version, Colors.WHITE, " failed to load!" )
end
