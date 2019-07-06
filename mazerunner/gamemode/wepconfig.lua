MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
cfg.WEP = cfg.WEP || {}
local wcfg = cfg.WEP
//--------------------------------

-- Key Configs are for aesthetic, stating "LMB" for "Left Mouse Button" in instructions
wcfg.keyconfigs = {
	[0] = "LMB",
	[1] = "RMB",
}

// BEGIN run_leap
wcfg.run_leap = {
	["Name"] = "Runner: Leap",
	["Description"] = "Leap in the direction you are aiming with right click",
	-- Punch
	["Damage"] = 35, 	-- Default: 35 ; This is the default damage of a punch with no boosts
	["Duration"] = 0, 	-- Default: 0 ; Punch has no duration
	["Radius"] = 0, 	-- Default: 0 ; Punch affects only 1 target. Radius has no effect.
	["Cooldown"] = 0.3, -- Default: 0.3 ; Punch cooldown
	["Sound1Swing"] = Sound( "WeaponFrag.Throw" ), -- Player makes an effort to punch
	["Sound1Hit"] = Sound( "Flesh.ImpactHard" ), -- Punch lands on target
	
	-- Leap: Leap in the direction you aim.  If you add damage, it will start to fling other players, props, & NPC's on landing
	["Damage2"] = 0, 		-- Default: 0
	["Duration2"] = 10, 	-- Default: 10 ; -- Currently has no effect. Later: Player will receive no fall damage if they land within this time
	["ForceMul2"] = 650, 	-- Default: 650 ; How strong a Leap launches you & how far people get flung
	["Radius2"] = 126, 		-- Default: 126 ; ( player is 32 units wide )
	["Cooldown2"] = 10, 	-- Default: 10 ;
	["Sound2Launch"] = Sound( "physics/concrete/concrete_break2.wav" ),
	["Sound2Land"] = Sound( "physics/concrete/boulder_impact_hard3.wav" ),
}
	// Weapon Instructions
	wcfg.run_leap.Instr = {
			["H1"] = wcfg.keyconfigs[0] .. " : ",
			["H2"] = wcfg.keyconfigs[1] .. " : ",
			["1"] = "Attack - Deal ".. wcfg.run_leap.Damage .." damage each swing".."\n".."Cooldown: ".. wcfg.run_leap.Cooldown .."s",
			["2"] = "Ability - Leap in the direction you are aiming!".."\n".."Cooldown: "..wcfg.run_leap.Cooldown2.."s",
	}

// END of run_leap
------------------

// BEGIN run_sense
wcfg.run_sense = {
	["Name"] = "Runner: Sense",
	["Description"] = "Sense other beings around you while crouched",
	-- Punch
	["Damage"] = 35, 	-- Default: 35 ;
	["Duration"] = 0, 	-- Default: 0 ;
	["Radius"] = 0, 	-- Default: 0 ;
	["Cooldown"] = 0.3, -- Default: 0.3 ;
	["Sound1Swing"] = Sound( "WeaponFrag.Throw" ), -- Player makes an effort to punch
	["Sound1Hit"] = Sound( "Flesh.ImpactHard" ), -- Punch lands on target
	
	-- Sense: Senses targets in the radius
	["Damage2"] = 0, 		-- Default: 0
	["Duration2"] = 0, 	-- Default: 0 ; -- Currently has no effect. Later: Players will detect entities for this duration. 0 is infinite.
	["Radius2"] = 1600, -- Default: 1000 ; ( player is 32 units wide )
	["Cooldown2"] = 3, 	-- Default: 3 ;
	["Sound2Activate"] = Sound( "ambient/materials/rock4.wav" ),	
	["Sound2Pulse"] = Sound( "vehicles/airboat/pontoon_scrape_smooth1.wav" ), -- Currently there is no use
}
	// Weapon Instructions
	local dur2 = wcfg.run_sense.Duration2
	if dur2 <= 0 then dur2 = "Infinite" end
	wcfg.run_sense.Instr = {
			["H1"] = wcfg.keyconfigs[0] .. " : ",
			["H2"] = wcfg.keyconfigs[1] .. " : ",
			["1"] = "Attack - Deal ".. wcfg.run_sense.Damage .." damage each swing".."\n".."Cooldown: ".. wcfg.run_sense.Cooldown .." s",
			["2"] = "Ability - Crouch and detect most nearby beings"..
			"\n".."Cooldown: "..wcfg.run_sense.Cooldown2.." s".." | Duration: "..dur2.." s",
	}

// END of run_sense
------------------

// BEGIN run_brute
wcfg.run_brute = {
	["Name"] = "Runner: Brute",
	["Description"] = "Regenerate health every 0.25 seconds for a time.",
	-- Punch
	["Damage"] = 40, 	-- Default: 40 ; This is the default damage of a punch with no boosts
	["Duration"] = 0, 	-- Default: 0 ; Punch has no duration
	["Radius"] = 0, 	-- Default: 0 ; Punch affects only 1 target. Radius has no effect.
	["Cooldown"] = 0.3, -- Default: 0.3 ; Punch cooldown
	["Sound1Swing"] = Sound( "WeaponFrag.Throw" ), -- Player makes an effort to punch
	["Sound1Hit"] = Sound( "Flesh.ImpactHard" ), -- Punch lands on target
	
	-- Brute: Damage refers to the health the player regenerates per every 0.25 seconds
	["Damage2"] = 4, 		-- Default: 4
	["Duration2"] = 10, 	-- Default: 10 ; How long the buff lasts
	["Radius2"] = 0, 		-- Default: 0 ; -- Has no effect
	["Cooldown2"] = 15, 	-- Default: 15 ;
	["Sound2Activate"] = Sound( "npc/antlion/land1.wav" ),
	["Sound2Deactivate"] = Sound( "ambient/levels/labs/teleport_postblast_winddown1.wav" ),
}
	// Weapon Instructions
	wcfg.run_brute.Instr = {
			["H1"] = wcfg.keyconfigs[0] .. " : ",
			["H2"] = wcfg.keyconfigs[1] .. " : ",
			["1"] = "Attack - Deal ".. wcfg.run_brute.Damage .." damage each swing".."\n".."Cooldown: ".. wcfg.run_brute.Cooldown .."s",
			["2"] = "Ability - Regenerate "..wcfg.run_brute.Damage2.." health every 0.25 seconds for "..wcfg.run_brute.Duration2.."s".."\n".."Cooldown: "..wcfg.run_brute.Cooldown2.."s",
	}

// END of run_brute
------------------

// BEGIN run_heal
wcfg.run_heal = {
	["Name"] = "Runner: Heal",
	["Description"] = "Heal yourself and those around you.",
	-- Punch
	["Damage"] = 35, 	-- Default: 40 ; This is the default damage of a punch with no boosts
	["Duration"] = 0, 	-- Default: 0 ; Punch has no duration
	["Radius"] = 0, 	-- Default: 0 ; Punch affects only 1 target. Radius has no effect.
	["Cooldown"] = 0.3, -- Default: 0.3 ; Punch cooldown
	["Sound1Swing"] = Sound( "WeaponFrag.Throw" ), -- Player makes an effort to punch
	["Sound1Hit"] = Sound( "Flesh.ImpactHard" ), -- Punch lands on target
	
	-- Heal: Damage refers to the health the player heals
	["Damage2"] = 40, 		-- Default: 40
	["Duration2"] = 0, 	-- Default: 0 ; -- Has no effect
	["Radius2"] = 256, 		-- Default: 256 ; ( Players are 32 wide )
	["Cooldown2"] = 12, 	-- Default: 12 ;
	["Sound2Activate"] = Sound( "npc/vort/claw_swing1.wav" ),
	["Sound2Healed"] = Sound( "items/medshot4.wav" ),
}
	// Weapon Instructions
	wcfg.run_heal.Instr = {
			["H1"] = wcfg.keyconfigs[0] .. " : ",
			["H2"] = wcfg.keyconfigs[1] .. " : ",
			["1"] = "Attack - Deal ".. wcfg.run_heal.Damage .." damage each swing".."\n".."Cooldown: ".. wcfg.run_heal.Cooldown .."s",
			["2"] = "Ability - Heal everyone nearby for "..wcfg.run_heal.Damage2.." HP ".."\n".."Cooldown: "..wcfg.run_heal.Cooldown2.."s",
	}

// END of run_heal
------------------

