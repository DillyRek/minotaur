STATE_INPROGRESS = 0
STATE_COOLDOWN = 1
STATE_LOBBY = 2
MR_WINNINGTEAM = "Spectators"
	
MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
local cd = CurTime()

function GM:SetRoundTime( time )
	SetGlobalInt( "RoundTime", time )
end

function GM:GetRoundTime()
	return GetGlobalInt( "RoundTime" )
end

function GM:SetRoundState(state)
	SetGlobalInt("RoundState", state)
end

function GM:GetRoundState()
	return GetGlobalInt("RoundState")
end

if SERVER then

	util.AddNetworkString("MR_playsound")
	function GM:MR_PlaySound( soundFile ) 
		net.Start("MR_playsound") 
		net.WriteString(soundFile)
		net.Broadcast()
	end

	util.AddNetworkString("MR_playsoundloc")
	function GM:MR_PlaySoundLoc( soundFile, loc, level, pitch, vol ) 
		net.Start("MR_playsoundloc") 
		net.WriteString(soundFile)
		net.WriteVector(loc)
		net.WriteInt(level, 16)
		net.WriteInt(pitch, 8)
		net.WriteInt(vol, 8)
		net.Broadcast()
	end
	
	MR_CONFIG.MR_PlaySoundLoc = function( soundFile, loc, level, pitch, vol ) 
		net.Start("MR_playsoundloc") 
		net.WriteString(soundFile)
		net.WriteVector(loc)
		net.WriteInt(level, 16)
		net.WriteInt(pitch, 8)
		net.WriteInt(vol, 8)
		net.Broadcast()
	end

else
	net.Receive("MR_playsound", function()
		local soundFile = net.ReadString()
		surface.PlaySound(soundFile)
	end )
	
	net.Receive("MR_playsoundloc", function()
		local soundFile = net.ReadString()
		local loc = net.ReadVector()
		local level = net.ReadInt(16)
		local pitch = net.ReadInt(8)
		local vol = net.ReadInt(8)
		sound.Play( soundFile, loc, level, pitch, vol )
	end )
end

if(CLIENT) then
	
	
	function GM:RoundBegun()
		if !cfg.RandomClasses then
			timer.Simple( 0.1, function() if LocalPlayer():IsValid() then MR.SelMenuBuild() end end )
		end
		--chat.AddText("Round Begin")
	end

	function GM:RoundEnded()
		--chat.AddText("Round End")
		
	end

	function GM:RoundLobby()
		--chat.AddText("Round Lobby")
	end
	
	function GM:RunnersWin()
		MR_WINNINGTEAM = "Runner"
		local soundFile = MR_CONFIG.RunnerWinsounds[math.random( 1, #MR_CONFIG.RunnerWinsounds )]
		-- LocalPlayer():EmitSound( soundFile , 0, 100, 1, CHAN_AUTO )
		-- surface.PlaySound( soundFile )
		
		// If no menu, make menu
		if( !REMenu ) then
			REMenu = vgui.Create( "menu_runnerswin" )
			REMenu:SetVisible( true )
		end
		
		// If not center, make center
		--if( REMenu.x == -REMenu:GetWide() ) then
		if( REMenu and REMenu.x != ScrW()/2 - REMenu:GetWide()/2 ) then
			REMenu:MoveTo( ScrW()/2 - REMenu:GetWide()/2, ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
			REMenu:Show()
			-- gui.EnableScreenClicker( true )
			timer.Simple( 7, function()
				if REMenu then
				REMenu:MoveTo( -REMenu:GetWide(), ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
				REMenu:NewAnimation( 0, 0.3, 0.5, function()
					if REMenu then
						REMenu:Remove()
						REMenu = nil
					end
				end)
				end
				--[[
				if LocalPlayer() and !LocalPlayer():IsTyping() then
					gui.EnableScreenClicker( false )
				end
				--]]
			end )
		end
	end
	
	function GM:MinotaursWin()
		MR_WINNINGTEAM = "Minotaur"
		local soundFile = MR_CONFIG.MinotaurWinsounds[math.random( 1, #MR_CONFIG.MinotaurWinsounds )]
		-- LocalPlayer():EmitSound( soundFile , 0, 100, 1, CHAN_AUTO )
		-- surface.PlaySound( soundFile )
		// If no menu, make menu
		if( !REMenu ) then
			REMenu = vgui.Create( "menu_minotaurswin" )
			REMenu:SetVisible( true )
		end
		
		// If not center, make center
		--if( REMenu.x == -REMenu:GetWide() ) then
		if( REMenu.x != ScrW()/2 - REMenu:GetWide()/2 ) then
			REMenu:MoveTo( ScrW()/2 - REMenu:GetWide()/2, ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
			REMenu:Show()
			-- gui.EnableScreenClicker( true )
			timer.Simple( 7, function()
				if REMenu then
				REMenu:MoveTo( -REMenu:GetWide(), ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
				REMenu:NewAnimation( 0, 0.3, 0.5, function()
					if REMenu then
						REMenu:Remove()
						REMenu = nil
					end
				end)
				end
				--[[
				if LocalPlayer() and !LocalPlayer():IsTyping() then
					gui.EnableScreenClicker( false )
				end
				--]]
			end )
		end
	end
	
	function GM:RoundDraw()
		MR_WINNINGTEAM = "Draw"
		local soundFile = MR_CONFIG.MinotaurWinsounds[math.random( 1, #MR_CONFIG.MinotaurWinsounds )]
		-- LocalPlayer():EmitSound( soundFile , 0, 100, 1, CHAN_AUTO )
		-- surface.PlaySound( soundFile )
		// If no menu, make menu
		if( !REMenu ) then
			REMenu = vgui.Create( "menu_rounddraw" )
			REMenu:SetVisible( true )
		end
		
		// If not center, make center
		--if( REMenu.x == -REMenu:GetWide() ) then
		if( REMenu.x != ScrW()/2 - REMenu:GetWide()/2 ) then
			REMenu:MoveTo( ScrW()/2 - REMenu:GetWide()/2, ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
			REMenu:Show()
			-- gui.EnableScreenClicker( true )
			timer.Simple( 7, function()
				if REMenu then
				REMenu:MoveTo( -REMenu:GetWide(), ScrH()/2 - REMenu:GetTall()/2, 0.3, 0, 0.5 )
				REMenu:NewAnimation( 0, 0.3, 0.5, function()
					if REMenu then
						REMenu:Remove()
						REMenu = nil
					end
				end)
				end
				--[[
				if LocalPlayer() and !LocalPlayer():IsTyping() then
					gui.EnableScreenClicker( false )
				end
				--]]
			end )
		end
	end


local PANEL = {
	Init = function( self )
		
		// Panel Basics
		self:SetSize( ScrW(), ScrH() )
		self:SetVisible( true )
		
		local x, y = self:GetSize()
		
		self:SetPos( -x, ScrH()/2 - y/2 )
		
		// Team Name
		local teamName = MR_WINNINGTEAM or "Best"
		local teamcolor
		if teamName == "Minotaur" then
			teamcolor = Color( 231, 76, 60, 255 )
		elseif teamName == "Runner" then
			teamcolor = Color( 52, 152, 219, 255 )
		else
			teamcolor = Color ( 240, 240, 240, 255 )
		end
		local label = vgui.Create( "DLabel", self )
		label:SetFont( "RoundEndTeam" )
		label:SetText( "The " .. teamName .. " Team Wins!" )
		label:SetTextColor( teamcolor )
		label:SizeToContents()
		label:SetPos( x/2 - label:GetWide()/2, y/3 )
		
		// Define working area
		local mainpanel = vgui.Create( "DPanel", self )
		mainpanel:SetPos( 3, 35 )
		mainpanel:SetSize( x-6, y-35-3 )
		mainpanel.Paint = function( self, w ,h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 100 ) )
		end
		
	end,
	
	Paint = function( self, w, h )
	
		-- draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		-- surface.SetDrawColor( 255, 255, 255 )
		-- surface.DrawOutlinedRect( 2, 2, w-4, h-4 )
		
	end
	
}

local PANEL_DRAW = {
	Init = function( self )
		
		// Panel Basics
		self:SetSize( ScrW(), ScrH() )
		self:SetVisible( true )
		
		local x, y = self:GetSize()
		
		self:SetPos( -x, ScrH()/2 - y/2 )
		
		// Team Name
		local teamName = "Draw"
		local teamcolor = Color ( 240, 240, 240, 255 )
		local label = vgui.Create( "DLabel", self )
		label:SetFont( "RoundEndTeam" )
		label:SetText( "Draw" )
		label:SetTextColor( teamcolor )
		label:SizeToContents()
		label:SetPos( x/2 - label:GetWide()/2, y/3 )
		
		local label2 = vgui.Create( "DLabel", self )
		label2:SetFont( "RoundEndTeam" )
		label2:SetText( "You ran out of time!" )
		label2:SetTextColor( teamcolor )
		label2:SizeToContents()
		label2:SetPos( x/2 - label2:GetWide()/2, y/3 - label2:GetTall() )
		
		// Define working area
		local mainpanel = vgui.Create( "DPanel", self )
		mainpanel:SetPos( 3, 35 )
		mainpanel:SetSize( x-6, y-35-3 )
		mainpanel.Paint = function( self, w ,h )
			-- draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 100 ) )
		end
		
	end,
	
	Paint = function( self, w, h )
	
		-- draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 100 ) )
		-- surface.SetDrawColor( 255, 255, 255 )
		-- surface.DrawOutlinedRect( 2, 2, w-4, h-4 )
		
	end
	
}
vgui.Register( "menu_minotaurswin", PANEL )
vgui.Register( "menu_runnerswin", PANEL )
vgui.Register( "menu_rounddraw", PANEL_DRAW )

	net.Receive("RoundBegun", GM.RoundBegun)
	net.Receive("RoundEnded", GM.RoundEnded)
	net.Receive("RoundLobby", GM.RoundLobby)
	net.Receive("RunnersWin", GM.RunnersWin)
	net.Receive("MinotaursWin", GM.MinotaursWin)
	net.Receive("RoundDraw", GM.RoundDraw)

	return
end

util.AddNetworkString("RoundBegun")
util.AddNetworkString("RoundEnded")
util.AddNetworkString("RoundLobby")
util.AddNetworkString("RunnersWin")
util.AddNetworkString("MinotaursWin")
util.AddNetworkString("RoundDraw")

local cdDuration = MR_CONFIG.RoundCooldown

function GM:StartRound()
	game.CleanUpMap()

	self:SetRoundState(STATE_INPROGRESS)
	self:SetupTeams()
	local timeIn = cfg.RoundTimeLimit or 60
	self:SetRoundTime( timeIn )
	timer.Create( "MR.RoundTimer", 1, timeIn, function()
		if self:GetRoundState() == STATE_INPROGRESS then
			self:SetRoundTime( self:GetRoundTime() - 1 )
			local newTime = self:GetRoundTime()
			self:SetRoundTime( math.Clamp( newTime, 0, newTime ) )
			if cfg.Debug then print( "Round Timer: Time Left = "..newTime ) end
			if newTime == 0 then
				self:RoundDraw()
				cd = CurTime() + cdDuration
				self:EndRound()
			end
		else
			if cfg.Debug then print( "Round Timer: Removed Timer" ) end
			timer.Remove( "MR.RoundTimer" )
		end
	end )

	net.Start("RoundBegun")
	net.Broadcast()
end

function GM:EndRound()
	game.CleanUpMap()

	self:SetRoundState(STATE_COOLDOWN)
	self:Spectatorify()
	MR_CONFIG.Areas.ClearEnts()
	self:SetRoundTime( 0 )
	timer.Remove( "MR.RoundTimer" )
	
	net.Start("RoundEnded")
	net.Broadcast()
end

function GM:Lobby()
	if(self:GetRoundState() == STATE_INPROGRESS) then
		self:EndRound()
	end

	self:SetRoundState(STATE_LOBBY)
	self:SetRoundTime( 0 )
	timer.Remove( "MR.RoundTimer" )

	net.Start("RoundLobby")
	net.Broadcast()
end

GM:Lobby()

function GM:Tick()
	local state = self:GetRoundState()

	if(state == STATE_LOBBY && CurTime() > cd) then
		if(#player.GetAll() < MR_CONFIG.MinPlayers) then
			self:Notify("Not enough players to start the round!")
			cd = CurTime() + 8
		else
			self:StartRound()
			cd = CurTime()
		end
	end

	if(state == STATE_INPROGRESS && CurTime() > cd) then
		cd = CurTime() + 0.5

		local minotaurs = team.GetPlayers(0)
		local runners = team.GetPlayers(1)

		local m = 0
		for k, v in pairs(minotaurs) do
			m = m + v:GetLives()
		end

		local r = 0
		for k, v in pairs(runners) do
			r = r + v:GetLives()
		end

		if(m == 0 || r == 0) then
			if(m == 0) then self:RunnersWin()
			elseif(r == 0) then self:MinotaursWin() end

			self:EndRound()
			cd = CurTime() + cdDuration
		end
	end

	if(state == STATE_COOLDOWN && CurTime() > cd) then
		self:Lobby()
	end
end

function GM:RunnersWin()
	print("Runners Win")
	MR_WINNINGTEAM = "Runner"
	local soundFile = MR_CONFIG.RunnerWinsounds[math.random( 1, #MR_CONFIG.RunnerWinsounds )]
	-- local soundFile = "vo/coast/odessa/male01/nlo_cheer01.wav"
	timer.Simple( 0.2, function() self:MR_PlaySound( soundFile ) end )

	net.Start("RunnersWin")
	net.Broadcast()
end

function GM:MinotaursWin()
	print("Minotaurs Win")
	MR_WINNINGTEAM = "Minotaur"
	local soundFile = MR_CONFIG.MinotaurWinsounds[math.random( 1, #MR_CONFIG.MinotaurWinsounds )]
	-- local soundFile = "npc/combine_gunship/gunship_moan.wav"
	timer.Simple( 0.2, function() self:MR_PlaySound( soundFile ) end )

	net.Start("MinotaursWin")
	net.Broadcast()
end

function GM:RoundDraw()
	print("Draw: No Team Wins!")
	MR_WINNINGTEAM = "Draw"
	local soundFile = MR_CONFIG.MinotaurWinsounds[math.random( 1, #MR_CONFIG.MinotaurWinsounds )]
	-- local soundFile = "npc/combine_gunship/gunship_moan.wav"
	timer.Simple( 0.2, function() self:MR_PlaySound( soundFile ) end )

	net.Start("RoundDraw")
	net.Broadcast()
end