local function FindPlayerFromName(name)
	local n = string.lower(name)
	local t = {}
	
	for k,v in pairs(player.GetAll()) do
		if(string.find(string.lower(v:Nick()), n)) then
			table.insert(t,v)
		end
	end
	return t[1] or nil
end
/////////////////////////////////////////////////////////////////////////////////////////////////////
---- TO DO LATER IF PAYED FOR, NOT SET UP YET
-- To create a better command system that can include "*" for everyone, as well as a menu system, 
-- create a separate function for each command.
/////////////////////////////////////////////////////////////////////////////////////////////////////

local function GM_ChatCommands (ply, text, ateam)

	if ateam then return end
	
	// Global Chat Var's
	local lowText = string.lower( text )
	local words = string.Explode( " ", lowText )
	local cmd = words[1]
	
	-- "If ! command"
	if ( string.sub( lowText, 1, 1 ) == "!" ) then
		
		-- Suicide Command: Kill self
		if cmd == "!suicide" then
			ply:Kill()
		elseif cmd == "!select" then
			MR.SelMenuBuild( ply )
		elseif cmd == "!help" or cmd == "!info" then
			MR.InfoMenuBuild( ply )
		end
	
	if ( ply:IsAdmin() ) then
		
		// "!" Command Var's
		local target = words[2]
		local targName
		
		-- Check Target
		if target == nil or target == "^" then 
			target = ply
			targName = ply:Nick()
		elseif target == "*" then -- not yet setup
			-- run command on everyone (Not Setup)
			target = ply
			targName = ply:Nick()
			-- Placeholder
		elseif cmd != "!npc" and cmd != "!setspawn" then
			target = FindPlayerFromName( target )
			if target == nil then 
				ply:ChatPrint( "Target not found." )
				return
			end
			targName = target:Nick()
		end
		
		-- Slay Command: Slay target
		if cmd == "!slay" then
			target:Kill()
		
		-- Hurt Command: Damage target for 25
		elseif cmd == "!hurt" then
			target:SetHealth( target:Health() - 25 )
			if( target:Health() <= 0 ) then target:Kill() end
			target:ChatPrint( "Ouch! You were hurt." )
		
		-- Heal Command: Heal self
		elseif cmd == "!heal" then
			target:SetHealth( target:GetMaxHealth() )
		
			target:ChatPrint( "You were healed!" )
		-- Stuck Command: Not useful currently
		elseif cmd == "!stuck" then
			ply:SetPos( ply:GetPos() + ply:GetUp() )
		
		-- SetSpawn Command: Sets Spawn for Team
		elseif cmd == "!setspawn" then
			
			if words[2] == nil then
				ply:Notify( "Team Input Required", 5, NOTIFY_ERROR )
				return
			end
			
			local mapname = game.GetMap()
			if string.sub( mapname, 1, 23 ) == "rm_hedgemaze_night_beta" then mapname = "rm_hedgemaze_night" end
			
			if words[2] == "minotaur" then
				spawnpointsminotaur[ mapname ] = spawnpointsminotaur[ mapname ] or {}
				table.insert( spawnpointsminotaur[ mapname ], tostring( ply:GetPos() + Vector( 0,0,5 ) ) )
				file.Write( "mazerunner/spawnpointsminotaur.txt", util.TableToKeyValues( spawnpointsminotaur ) )
			elseif words[2] == "runner" or words[2] == "runners" then
				spawnpointsrunner[ mapname ] = spawnpointsrunner[ mapname ] or {}
				table.insert( spawnpointsrunner[ mapname ], tostring( ply:GetPos() + Vector( 0,0,5 ) ) )
				file.Write( "mazerunner/spawnpointsrunner.txt", util.TableToKeyValues( spawnpointsrunner ) )
			else
				ply:Notify( "Invalid Team Specified", 5, NOTIFY_ERROR )
				return
			end
			
			ply:Notify( "Added spawnpoints for " .. words[2] .. "!", 5, NOTIFY_GENERIC )
			return
		
		-- Zombie NPC Spawn Command: Spawns Zombie
		elseif cmd == "!zombie" then
			local Ent = ents.Create( "npc_zombie" )
			if ( !IsValid( Ent ) ) then return end
			
			local tr = ply:GetEyeTrace()
			Ent:SetPos( tr.HitPos + Vector( 0,0,5 ) )
			Ent:Spawn()
			ply:Notify( "Zombie Spawned!", 1, NOTIFY_ERROR )
		
		-- NPC Spawn Command: Spawns Specified NPC by Class
		elseif cmd == "!npc" then
			if ( words[2] ) == nil then return end
			local Ent = ents.Create( words[2] )
			if ( !IsValid( Ent ) ) then 
				ply:Notify( "Invalid NPC Class", 1, NOTIFY_ERROR )
				return 
			end
			
			local tr = ply:GetEyeTrace()
			Ent:SetPos( tr.HitPos + Vector( 0,0,5 ) )
			Ent:Spawn()
			ply:Notify( "NPC Spawned!", 1, NOTIFY_ERROR )
			return
		else
			return
		end
		
		ply:ChatPrint("You executed: " .. cmd ..  " on " .. targName )
		
	end // end if Admin
		
	end // end if "!"
	
end // end ChatCommand string

hook.Add( "PlayerSay", "GM_ChatCommands", GM_ChatCommands )