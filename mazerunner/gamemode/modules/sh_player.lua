-- Global Use Variables
local mapname = game.GetMap()
if string.sub( mapname, 1, 23 ) == "rm_hedgemaze_night_beta" then mapname = "rm_hedgemaze_night" end

MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
MR = MR or {}

// Meta Table Fun
local meta = FindMetaTable("Player")

function meta:GetLives()
	return self:GetNWInt("Lives")
end

function meta:GetMRClass()
	return self:GetNWString("MRClass")
end

function meta:GetMRNxtClass()
	return self:GetNWString("MRNxtClass")
end

function meta:GetMRCanSelect()
	return self:GetNWBool("MRCanSelect")
end

function meta:GetConfigTable()
	local newTbl = {}
	table.Merge( newTbl, MR_CONFIG.TeamSetup[self:Team()+1] )
	local cfg = MR_CONFIG
	
	local class
	if self:Team() == 1 then -- if Ply Runner then Get MR Class & add it to Tbl
		local class = self:GetMRClass()
		-- If not a Runner Class, then Set class to Scout by Default
		if ( cfg.RunnerClasses[class] == nil ) then class = "Scout" self:SetMRClass( class ) end
		table.Merge( newTbl, MR_CONFIG.RunnerClasses[ class ] )
	elseif self:Team() == 0 then -- Else get Mino MR Class
		local class = self:GetMRClass()
		-- If not a Minotaur Class, then Set class to Normal by Default
		if ( cfg.MinotaurClasses[class] == nil ) then class = "Normal" self:SetMRClass( class ) end
		table.Merge( newTbl, MR_CONFIG.MinotaurClasses[ class ] )
	end
	
	return newTbl
end

if(CLIENT) then return end

function meta:SetLives(amt)
	self:SetNWInt("Lives", amt)
end

function meta:SetMRClass(str)
	self:SetNWString("MRClass", str)
end

function meta:SetMRNxtClass(str)
	self:SetNWString("MRNxtClass", str)
end

function meta:SetMRCanSelect(bool)
	self:SetNWBool("MRCanSelect", bool)
end

function meta:AddLives(amt)
	self:SetNWInt("Lives", self:GetLives() + amt)
end

function GM:PlayerSpawn(ply)
	self.BaseClass.PlayerSpawn(self, ply)
	self:DeathscreenSpawn(ply)
	
	if SERVER then -- Set Ply Pos to Spawn Point
		if ply:Team() == 0 and #spawnpointsminotaur[ mapname ] > 0 then
		 ply:SetPos( Vector( spawnpointsminotaur[mapname][ math.random( 1, #spawnpointsminotaur[ mapname ] ) ] ) )
		elseif ply:Team() == 1 and #spawnpointsrunner[ mapname ] > 0 then
		 ply:SetPos( Vector( spawnpointsrunner[mapname][ math.random( 1, #spawnpointsrunner[ mapname ] ) ] ) )
		end
	end
	
	if cfg.RandomClasses then
		local class
		if ply:Team() == 1 then -- if Ply Runner then Set random Runner MR Class
			class = table.Random( MR_CONFIG.RunnerClasses )
			class = class.classname
			ply:SetMRNxtClass( class )
			ply:SetMRClass( class )
		elseif ply:Team() == 0 then -- if Ply Minotaur
			class = table.Random( MR_CONFIG.MinotaurClasses )
			class = class.classname
			ply:SetMRNxtClass( class )
			ply:SetMRClass( class )
		end
	end

	ply:DrawShadow(ply:Team() != 2 || self:GetRoundState() != STATE_INPROGRESS)
	hook.Run( "PlayerLoadout", ply )
end

function GM:PlayerLoadout(ply)
	if ply:GetMRNxtClass() != ply:GetMRClass() then
		-- check # players
		local classWanted = ply:GetMRNxtClass()
		local classTeam, bool, buc
		if ply:Team() == 0 then classTeam = cfg.MinotaurClasses buc = "Normal"
		elseif ply:Team() == 1 then classTeam = cfg.RunnerClasses buc = "Scout"
		else return end -- player is a Spectator
		if classTeam[classWanted] then
			local bool = MR.FnCMC( classWanted, classTeam )
			if bool then ply:SetMRClass( classWanted ) else
				ply:ChatPrint( "All slots are filled for that class. Please select another." )
				buc = buc or "Scout"
				ply:SetMRNxtClass( buc )
			end
		end
		
		-- too many players, set Ply as Scout or Default ( Team Check )
	end
	
	local info = ply:GetConfigTable()
	local weps, ammo = info.weps, info.ammo
	
	if cfg.ColorizePly then
		if ply:Team() == 0 then 
			local color = Vector(231, 76, 60)
			color:Normalize()
			ply:SetPlayerColor( color )
		elseif ply:Team() == 1 then
			local color = Vector(52, 152, 219)
			color:Normalize()
			ply:SetPlayerColor( color )
		end
	else
		local color = Vector( 61,87,105 ) -- default color code
		color:Normalize()
		ply:SetPlayerColor( color )
	end

	ply:SetWalkSpeed(info.walkspeed)
	ply:SetRunSpeed(info.runspeed)
	ply:SetCrouchedWalkSpeed(0.5)

	ply:SetMaxHealth(info.health || 100)

	ply:SetHealth(info.health || 100)
	ply:SetArmor(info.armor || 0)
	
	ply:StripAmmo()
	ply:StripWeapons()
	for k, v in pairs(weps) do
		ply:Give(v)
	end

	for k, v in pairs(ammo) do
		ply:SetAmmo(v, k)
	end
	
	local model = ply:GetConfigTable().model
	
	if(istable(model)) then
		model = model[math.Rand(1, #model)]
	end

	ply:SetModel(model)
	return true
end

function GM:PlayerSetModel(ply)
	local model = ply:GetConfigTable().model
	
	if(istable(model)) then
		model = model[math.Rand(1, #model)]
	end

	ply:SetModel(model)
end

function GM:PlayerDeath(ply, inflictor, attacker)
	self.BaseClass.PlayerDeath(self, ply, inflictor, attacker)
	self:DeathscreenDeath(ply, inflictor, attacker)
	
	if SERVER then
		if ply:Team() == 0 then -- Minotaur Death Sound
			local soundFile = MR_CONFIG.MinotaurDeathsounds[math.random( 1, #MR_CONFIG.MinotaurDeathsounds )]
			local loc = ply:GetPos()
			local level = 140
			local pitch = 100
			local vol = 1
			timer.Simple( 0.3, function() self:MR_PlaySoundLoc( soundFile, loc, level, pitch, vol ) end )
		elseif ply:Team() == 1 then -- Runner Death Sound
			local soundFile = MR_CONFIG.RunnerDeathsounds[math.random( 1, #MR_CONFIG.RunnerDeathsounds )]
			local loc = ply:GetPos()
			local level = 105
			local pitch = 100
			local vol = 1
			self:MR_PlaySoundLoc( soundFile, loc, level, pitch, vol )
		end
	end // end If Server

	local lives = ply:GetLives() - 1

	if(lives <= 0) then
		self:Spectatorify(ply)
	end
	
	ply.nextSpawn = CurTime() + MR_CONFIG.RespawnTime
	ply:SetLives(lives)
	
end // end Player Death

function GM:PlayerDeathThink(ply)
	if(CurTime() < ply.nextSpawn) then return false end
	ply:Spawn()
end

function GM:GetFallDamage(ply, speed)
	return speed/15
end

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(2)
	ply:SetMRClass( "Scout" ) -- Set Runner MR Class by default
	ply:SetCustomCollisionCheck(true)
	MR.InfoMenuBuild( ply )
end

function GM:PlayerNoClip(ply)
	if ply:IsAdmin() then 
		return true 
	else
		return ply:Team() == 2
	end
end

function GM:AllowPlayerPickup(ply)
	return ply:Team() != 2
end

function GM:PlayerCanPickupItem(ply)
	return ply:Team() != 2
end

function GM:CanPlayerSuicide(ply)
	if ( ply:Team() == 2 ) then return false else
		return MR_CONFIG.CanSuicide
	end
end

function GM:CanPlayerEnterVehicle(ply)
	return ply:Team() != 2
end

function GM:PlayerCanHearPlayersVoice(listener, talker)
	return listener:Team() == talker:Team(), true
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if(ply:Team() == 2) then return false end

	if(IsValid(attacker) && attacker:IsPlayer()) then
		if ( ply:Team() != attacker:Team() ) then
			return true
		elseif ( ply == attacker ) then
			return true
		end
	else
		return true
	end
end

if(SERVER) then
	function GM:PlayerFootstep(ply, pos)
		if( ply:Team() == 0 ) then -- Minotaur Step Sound
			ply:EmitSound(MR_CONFIG.MinotaurMovesound, 75, math.random(70,120), 0.8, CHAN_BODY)
		end
	end
end