Constants = { }
Constants.version = 2.2

--game
Constants.GAME_HL2 = 1
Constants.GAME_GMOD = 2
Constants.GAME_CSS = 3

--game-mode
Constants.GAMETYPE_DEFAULT = 1
Constants.GAMETYPE_TTT = 2
Constants.GAMETYPE_DARKRP = 3
Constants.GAMETYPE = Constants.GAMEMODE_DEFAULT
if GAMEMODE.Name == "Trouble in Terrorist Town" then
	Constants.GAMETYPE = Constants.GAMETYPE_TTT
elseif ConVarExists("rp_getvehicles_sv") then
	Constants.GAMETYPE = Constants.GAMETYPE_DARKRP
end

--aim-bot
Constants.AIMBOT_ERROR = -1
Constants.AIMBOT_OFF = 0
Constants.AIMBOT_SOFT = 1
Constants.AIMBOT_HARD = 2

--bones
Constants.BONE_GEAR = 0
Constants.BONE_SPINE = 1
Constants.BONE_TORSO = 3
Constants.BONE_HEAD = 6
Constants.BONE_RIGHT_HAND = 11
Constants.BONE_LEFT_HAND = 16
Constants.BONE_RIGHT_FOOT = 20
Constants.BONE_LEFT_FOOT = 24

--colors
Colors = {}
Colors.WHITE = Color(255,255,255)
Colors.PURPLE = Color(230,230,250)
Colors.RED = Color(255,0,0)
Colors.GREEN = Color(0,255,0)
Colors.BLUE = Color(0,0,255)
Colors.YELLOW = Color(255,255,0)
Colors.ORANGE = Color(255, 127, 0)
Colors.CONTINUUM = Color(85, 25, 176)