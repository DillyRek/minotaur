if SERVER then
	
	MR_CONFIG = MR_CONFIG || {}
	local cfg = MR_CONFIG
	MR_CONFIG.Areas = MR_CONFIG.Areas || {}
	local Areas = MR_CONFIG.Areas
	Areas.List = {}
	
	function Areas.MakeArea( ID, pos1, pos2, rpt, uses )
		local NewArea = {}
		NewArea.Name = ID
		NewArea.Vec = { pos1, pos2 }
		NewArea.Players = {}
		NewArea.BlockPly = {}
		NewArea.Repeat = rpt || false
		NewArea.Uses = uses || nil
		MsgC(Color(250,100,100),"Areas: ", Color(255,255,255), "Made area ", Color(255,255,0), ID .. "\n")
		return Areas.List[table.insert( Areas.List, NewArea )]
	end
	
	local map = game.GetMap()
	if string.sub( map, 1, 23 ) == "rm_hedgemaze_night_beta" then map = "rm_hedgemaze_night" end
	local pos1, pos2
	
// Set Map-Specific Areas
	if map == "rm_hedgemaze_night" then
//////////////////////////////////////////////////////////////////////////////
	//** Area Functions
	// Shrine Traps
		// Fn: Area Decrease Uses
		local ArDecrUses = function( area )
		
			area.Uses = area.Uses - 1
			if area.Uses < 1 then 
				area.EnterFunction = function( ply ) end
				area.Repeat = false
			end
		
		end
		
		// Fn: Shrine Trap: Damage
		local strapDMG = function( ply, trap )
			
			if ply == nil then return end
			if ply:Health() > 0 then
				ply:ViewPunch( Angle( math.random(-25,25) , math.random(-25,25), math.random(-25,25) ) )
				ply:SetHealth( ply:Health() - 2 )
			else
				ply:Kill()
			end
			// Play Sound
			local soundFile, loc, level, pitch, vol = 
			"NPC_Strider.FireMinigun", ply:GetPos(), 90, math.random( 90, 100 ), 1
			MR_CONFIG.MR_PlaySoundLoc( soundFile, loc, level, pitch, vol )
			
			ArDecrUses( trap ) // Disable function after max uses
		end
		
		// Fn: Shrine Trap: Ignite
		local strapIGNITE = function( ply, trap, ignTime )
			
			if ply == nil then return end
			ignTime = ignTime or 10
			if ply:Health() > 0 then
				ply:ViewPunch( Angle( -10, 0, 0 ) )
				ply:Ignite( ignTime )
			end
			
			ArDecrUses( trap ) // Disable function after max uses
		end
		
		// Fn: Shrine Trap: Random Teleport
		local strapRTP = function( ply, trap )
			
			if ply == nil then return end
			if ply:Health() > 0 then
				local rtpTbl = ents.FindByName("pos_rtp*") or nil
				local pos
				if rtpTbl then
					local random = math.random( 1, #rtpTbl )
					if !random then print("No Random could be calculated") return end
					pos = rtpTbl[ random ]:GetPos()
				end
				local prepos = ply:GetPos()
				pos = pos or ply:GetPos()
				ply:SetPos( pos )
				
				// Sound Previous loc & Cur loc
				local soundFile, loc, level, pitch, vol = 
				"k_lab.teleport_spark", prepos, 90, math.random( 90, 100 ), 1
				MR_CONFIG.MR_PlaySoundLoc( soundFile, loc, level, pitch, vol )
				local soundFile, loc, level, pitch, vol = 
				"k_lab.teleport_spark", pos, 90, math.random( 90, 100 ), 1
				MR_CONFIG.MR_PlaySoundLoc( soundFile, loc, level, pitch, vol )
				
				// Client Effect
				ply:ViewPunch( Angle( math.random(-45,45), math.random(-45,45), math.random(-45,45) ) )
			end
			
			ArDecrUses( trap ) // Disable function after max uses
			
		end
		
	// Normal Shrines
		
		// Fn: Shrine Recharge
		local shrineRechFL = function( ply, shrine, infinite )
			if ply == nil || shrine.Uses < 1 then return end
			if shrine.CD then return end
			infinite = infinite || false
			if infinite then 
				shrine.Uses = 1000
			else
				ArDecrUses( shrine ) // Disable Fn after max uses
			end
			ply:SetFlashlightCharge(1)
			local hp = ply:Health()
			if hp > 0 and hp < ply:GetMaxHealth() then
				ply:SetHealth( hp + 1 )
			end
			
			// Shrine Cooldown
			shrine.CD = true
			timer.Simple( shrine.Cooldown, function() 
				shrine.CD = false
			end )
		end // end Fn: Shrine Recharge Flashlights
		
//////////////////////////////////////////////////////////////////////////////
	//** Define Areas
	// Area: CENTER
		pos1, pos2 = Vector( -12271.968750, -6511.968750, -9190 ), Vector( -10256.031250, -3152.031250, -8941.968750 )
		local ArCenter = Areas.MakeArea( "Center", pos1, pos2 )
		ArCenter.EnterFunction = function( ply )
			if ply == nil then return end
			if ply:Team() != 1 then return end // Runners Only
			if cfg.Debug then print( "sv_Ply: " .. ply:Nick() .. " Given Items at Center!" ) end
			local info = MR_CONFIG.RunnerCenterLoadout
			local weps, ammo = info.weps, info.ammo
			
			for k, v in pairs(weps) do
				ply:Give(v)
			end
			for k, v in pairs(ammo) do
				ply:SetAmmo(v, k)
			end
			
			// Remove ply weapons on death
			hook.Add( "PlayerDeath", "Area_Center_RemPly_"..ply:EntIndex(), function( plyr, infl, atk )
				if cfg.Debug then print( plyr:Nick() .. " Died, but " .. ply:Nick() .. " is the Hook owner" ) end
				if plyr == ply then 
					ArCenter.Players[plyr:EntIndex()] = nil 
					ArCenter.BlockPly[plyr:EntIndex()] = nil 
					hook.Remove( "PlayerDeath", "Area_Center_RemPly_"..ply:EntIndex() )
					if cfg.Debug then print( plyr:Nick() .. " Died, AND " .. ply:Nick() .. " had their death hook removed!" ) end
				end
			end )
			
			hook.Add( "PostCleanupMap", "Area_Center_RemPly_"..ply:EntIndex(), function()
				ArCenter.Players[ply:EntIndex()] = nil 
				ArCenter.BlockPly[ply:EntIndex()] = nil 
				hook.Remove( "PostCleanupMap", "Area_Center_RemPly_"..ply:EntIndex() )
				if cfg.Debug then print( ply:Nick() .. " Center hook removed. Map cleaned!" ) end
			end )
		end
		
		
	// Area: Shrine Traps
		local STinfo = MR_CONFIG.ShrineTraps
		pos1, pos2 = Vector( -8751.968750, -8528.031250, -9190 ), Vector( -8336.354492, -8949.091797, -8806.968750 )
		local ArShrineTrap1 = Areas.MakeArea( "ShrineTrap1", pos1, pos2, true, STinfo.MaxUses )
		ArShrineTrap1.EnterFunction = function( ply ) strapDMG( ply, ArShrineTrap1 ) end
		
		pos1, pos2 = Vector( -13893.789063, -7176.687500, -9190 ), Vector( -13685.83789, -6967.171387, -8936.249023 )
		local ArShrineTrap2 = Areas.MakeArea( "ShrineTrap2", pos1, pos2, true, STinfo.MaxUses )
		ArShrineTrap2.EnterFunction = function( ply ) strapRTP( ply, ArShrineTrap2 ) end
		
		pos1, pos2 = Vector( -10057.505859, -7498.034180, -9190 ), Vector( -9846.010742, -7285.772949, -8977.476563 )
		local ArShrineTrap3 = Areas.MakeArea( "ShrineTrap3", pos1, pos2, true, STinfo.MaxUses )
		ArShrineTrap3.EnterFunction = function( ply ) strapIGNITE( ply, ArShrineTrap3, STinfo.IgniteTime ) end
		
		
	// Area: Shrines
		local STinfo = MR_CONFIG.Shrines
		pos1, pos2 = Vector( -12433.554688, -10192.770508, -9190 ), Vector( -12218.299805, -9971.095703, -8942.549805 )
		local Shrine1 = Areas.MakeArea( "Shrine1", pos1, pos2, true, STinfo.MaxUses )
		Shrine1.Cooldown = STinfo.Cooldown or 1 
		Shrine1.EnterFunction = function( ply ) shrineRechFL( ply, Shrine1, true ) end
		
		pos1, pos2 = Vector( -8652.770508, -9931.596680, -9190 ), Vector( -8437.758789, -9719.353516, -8941.468750 )
		local Shrine2 = Areas.MakeArea( "Shrine2", pos1, pos2, true, STinfo.MaxUses )
		Shrine2.Cooldown = STinfo.Cooldown or 1 
		Shrine2.EnterFunction = function( ply ) shrineRechFL( ply, Shrine2, true ) end
		
		pos1, pos2 = Vector( -8008.016113, -6022.037598, -9190 ), Vector( -7810.413574, -5823.561035, -8948.46875 )
		local Shrine3 = Areas.MakeArea( "Shrine3", pos1, pos2, true, STinfo.MaxUses )
		Shrine3.Cooldown = STinfo.Cooldown or 1 
		Shrine3.EnterFunction = function( ply ) shrineRechFL( ply, Shrine3, true ) end
		
		pos1, pos2 = Vector( -11369.972656, -3654.027832, -9190 ), Vector( -11167.793945, -3449.702393, -8948.46875 )
		local Shrine4 = Areas.MakeArea( "Shrine4", pos1, pos2, true, STinfo.MaxUses )
		Shrine4.Cooldown = STinfo.Cooldown or 1 
		Shrine4.EnterFunction = function( ply ) shrineRechFL( ply, Shrine4, true ) end
		
		
	end // end if map is "rm_hedgemaze_night"
	
	MsgC( Color( 250, 100, 100 ), "Total Areas: ", Color( 255, 255, 0 ), #Areas.List .. "\n")
	
	function Areas.ClearEnts(selID)
		if selID == nil then
			if cfg.Debug then print("Clearing Entities from Areas!") end
			for ID, v in pairs(Areas.List) do
				v.BlockPly = {}
				if v.Players then
					v.Players = {}
				end
			end
		elseif Areas.List.selID and Areas.List.selID.Players then // if selID != nil
			Areas.List.selID.Players = {}
			if cfg.Debug then print("Clearing Entities from Area "..selID.."!") end
		end  
	end
	
	function Areas.PlayersChanged(ID, Ply, Entered)
		
		if !Ply:IsValid() or !Ply:IsPlayer() then return end
			if cfg.Debug then print( "Ply: " .. Ply:Nick() .. " Changed!" ) end
		if Areas.List[ID].BlockPly[Ply:EntIndex()] then
			if cfg.Debug then 
				print( "Ply: " .. Ply:Nick() .. " Blocked!" )
				Ply:ChatPrint( "Ply: " .. Ply:Nick() .. " Blocked!" ) 
			end
			return
		end
		Areas.List[ID].BlockPly[Ply:EntIndex()] = true
		
		// Areas with Repeat Functions -- Cooldown
		if Areas.List[ID].Repeat and Areas.List[ID].BlockPly then
			timer.Simple( 0.05, function() Areas.List[ID].BlockPly[Ply:EntIndex()] = nil end) 
		end
		
		// Execute when a player enters the area
		if Entered then
			if Areas.List[ID].EnterMessage then Areas.SendChat(Ply, Areas.List[ID].EnterMessage) end
			if Areas.List[ID].EnterFunction then Areas.List[ID].EnterFunction(Ply) end
		else // Execute when a player leaves the area
			if Areas.List[ID].LeaveMessage then Areas.SendChat(Ply, Areas.List[ID].LeaveMessage) end
			if Areas.List[ID].LeaveFunction then Areas.List[ID].LeaveFunction(Ply) end
		end
	end
	
	local PlyMT = FindMetaTable("Player")
	function PlyMT:GetArea()
		// v = Areas.List[ID]
		for ID, v in pairs(Areas.List) do
			if !v.Players then return end
			if v.Players[self] then return ID end
		end
	end
	
	function Areas.InBox(p,a,b)return  ( (a.x <= p.x and p.x <= b.x) or (b.x <= p.x and p.x <= a.x) )and ( (a.y <= p.y and p.y <= b.y) or (b.y <= p.y and p.y <= a.y) )and ( (a.z <= p.z and p.z <= b.z) or (b.z <= p.z and p.z <= a.z) )end
	
	local TickRate = 1/FrameTime()
	local CheckRate = 16/4/TickRate
	local AreaCheckCD = 1
	hook.Add( "Tick", "AreaController", function( ply, md ) 
		AreaCheckCD = AreaCheckCD - CheckRate
		if AreaCheckCD > 0 then return else AreaCheckCD = 1 end
		if #Areas.List == 0 then return end
		for ID, v in pairs(Areas.List) do
			// v = Areas.List[ID]
			// Search Inside that Area for players
			for _, Ent in pairs(ents.FindInBox(v.Vec[1], v.Vec[2])) do
				if Ent:GetClass() == "player" && Ent:Team() != 2 then
					local EntID = Ent:EntIndex()
					// Check if players have already been inside the area
					if v.Players != nil and !v.Players[EntID] and Ent:Alive() then
						// Put that player into our table, and call a function for entering.
						v.Players[EntID] = true
						Areas.PlayersChanged(ID, Ent, true)
					else--end
						if !Ent:IsPlayer() then return end
					end
				end
			end
			//Check if area repeats or has leave function
			if ( v.Repeat or v.LeaveFunction ) then 
			
				// Remove players from table when they leave the area
				for K, bool in pairs(v.Players) do
					local entList = ents.GetAll()
					local Plyr = entList[K]
					if ( not Areas.InBox(Plyr:GetPos(), v.Vec[1], v.Vec[2]) or (not Plyr:Alive()) ) then 
						v.Players[K] = nil Areas.PlayersChanged(ID, Plyr, false)
					end
				end // end for k, bool
			end // end if rpt or leave fn
		end // end for ID in Area List
		
	end ) // end Tick hook
	
end