MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
//--------------------------------

//First one will always be minotaur, second one will always be runner
cfg.TeamSetup = {
	{
		name = "Minotaur",
		color = Color(231, 76, 60),
		lives = 1,
		maxMinotaurs = 4, -- Default: 4 ; Scales based on expected max of 32 players
	},
	{
		name = "Runner",
		color = Color(52, 152, 219),
		lives = 10,
	},
	{
		name = "Spectator",
		color = Color(220, 220, 220, 255),
		model = "models/player/p2_chell.mdl",
		walkspeed = 200,
		runspeed = 300,
		health = 100,
		armor = 100,
		weps = {},
		ammo = {}
	}
}

//True or False, enables a lot of extra debug text
cfg.Debug = false

//Amount of seconds a round lasts
cfg.RoundTimeLimit = 900 -- 900 (15 min) by default ;

//True or False, Toggle colorizing player clothing based on teams
cfg.ColorizePly = true

//True or False, Toggle Random Class respawning for Runners. 
-- Players can override this by selecting a class, AND This ignores max class-type limits.
cfg.RandomClasses = false

//Amount of seconds someone is unable to respawn for
cfg.RespawnTime = 5

//Amount of time people can become a class after respawning
cfg.SpawnSelectTime = 15

//Minimum amount of players required for round to start
cfg.MinPlayers = 2

//Seconds to lobby in between rounds
cfg.RoundCooldown = 8

//Flashlight Configs
cfg.FlashlightTime = 15 //seconds
cfg.FlashlightRegenFactor = 5 //how many times over you need the flashlighttime to pass for it to fully regen

// All Players Configs
cfg.CanSuicide = true //Can players kill themselves?

////** Runner Configs
cfg.RunnerCenterLoadout = { // What items players get when they reach the center of the map
		weps = {
			"cw_ar15",
			"weapon_shotgun",
			"weapon_pistol",
		},
		ammo = {
			["5.56x45MM"] = 90,
			["buckshot"] = 40,
			["pistol"] = 160,
		},
}

cfg.RunnerDeathsounds = {
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"ambient/voices/citizen_beaten1.wav",
	"ambient/voices/citizen_beaten5.wav",
}

// Runner Classes Config
cfg.RunnerClasses = {
	["Scout"] = { 
		classname = "Scout",
		description = "Mobility is your greatest ally",
		health = 100,
		armor = 50,
		model = "models/player/alyx.mdl",
		walkspeed = 235,
		runspeed = 350,
		weps = {
			"weapon_mr_run_leap",
		},
		ammo = {},
		curcount = 0,
		maxIC = -1, -- out of 32 players, how many can be this? -1 for infinite
	},
	
	["Brute"] = {
		classname = "Brute",
		description = "Fear not that which stands before you",
		health = 200,
		armor = 100,
		model = "models/player/barney.mdl",
		walkspeed = 190,
		runspeed = 280,
		weps = {
			"weapon_mr_run_brute",
		},
		ammo = {},
		curcount = 0,
		maxIC = 6, -- out of 32 players, how many can be this? -1 for infinite
	},
	
	["Tracker"] = {
		classname = "Tracker",
		description = "Your heightened awareness gives you an edge",
		health = 100,
		armor = 100,
		model = "models/player/eli.mdl",
		walkspeed = 200,
		runspeed = 300,
		weps = {
			"weapon_mr_run_sense",
		},
		ammo = {},
		curcount = 0,
		maxIC = 8, -- out of 32 players, how many can be this? -1 for infinite
	},
	
	["Cleric"] = {
		classname = "Cleric",
		description = "Wield the light that shall aid all beside you",
		health = 100,
		armor = 25,
		model = "models/player/monk.mdl",
		walkspeed = 220,
		runspeed = 330,
		weps = {
			"weapon_mr_run_heal",
		},
		ammo = {},
		curcount = 0,
		maxIC = 12, -- out of 32 players, how many can be this? -1 for infinite
	},
}


////** Minotaur Configs
cfg.HaloDistance = 1280 //source engine units to start drawing minotaur outlines at -- 1280 is about fog distance
cfg.MinotaurMovesound = "npc/antlion_guard/foot_heavy1.wav"
cfg.MinotaurDeathsounds = {
	"npc/antlion_guard/antlion_guard_die1.wav",
	"npc/dog/dog_alarmed1.wav",
	"npc/dog/dog_alarmed3.wav",
}

// Minotaur Classes Config
cfg.MinotaurClasses = {
	["Normal"] = { 
		classname = "Normal",
		description = "A balance between power and awareness",
		model = "models/player/breen.mdl",
		walkspeed = 210,
		runspeed = 320,
		health = 1000,
		armor = 1000,
		weps = {
			--"weapon_shotgun",
			--"weapon_357",
			"weapon_axe",
		},
		ammo = {
			["5.56x45MM"] = 90,
			["357"] = 90,
			["Buckshot"] = 900,
		},
		curcount = 0,
		maxIC = -1, -- out of 32 players, how many can be this? -1 for infinite
	},
	["Heavy"] = { 
		classname = "Heavy",
		description = "Slow and powerful",
		model = "models/player/magnusson.mdl",
		walkspeed = 190,
		runspeed = 290,
		health = 1250,
		armor = 1250,
		weps = {
			"weapon_axe",
		},
		ammo = {
			["5.56x45MM"] = 90,
			["357"] = 90,
			["Buckshot"] = 900,
		},
		curcount = 0,
		maxIC = 2, -- out of 32 players, how many can be this? -1 for infinite
	},
	["Light"] = { 
		classname = "Light",
		description = "Fast and purposeful",
		model = "models/player/mossman_arctic.mdl",
		walkspeed = 250,
		runspeed = 400,
		health = 750,
		armor = 500,
		weps = {
			"weapon_axe",
		},
		ammo = {
			["5.56x45MM"] = 90,
			["357"] = 90,
			["Buckshot"] = 900,
		},
		curcount = 0,
		maxIC = -1, -- out of 32 players, how many can be this? -1 for infinite
	},
}

// Shrine Trap Configs
cfg.ShrineTraps = {
	IgniteTime = 10, // How long will players be on fire?
	MaxUses = 120, // Max Uses per Round
}

// Regular Shrines Configs
cfg.Shrines = {
	Cooldown = 0, // Cooldown in seconds between use
	MaxUses = 3, // Max Uses per Round. Does not apply to Infinite shrines ( eg. rm_hedgemaze_night shrines )
}

// Winning Configs
cfg.RoundEndsound = {
	"weapons/physcannon/energy_sing_explosion2.wav"
}

cfg.RunnerWinsounds = {
	"vo/coast/odessa/male01/nlo_cheer01.wav",
	"vo/coast/odessa/male01/nlo_cheer02.wav",
	"vo/coast/odessa/male01/nlo_cheer03.wav",
	"vo/coast/odessa/male01/nlo_cheer04.wav",
}

cfg.MinotaurWinsounds = {
	"ambient/creatures/town_moan1.wav",
	"npc/combine_gunship/gunship_moan.wav",
}