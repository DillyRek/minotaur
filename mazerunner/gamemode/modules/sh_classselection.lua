-- Get Allowed / Blacklisted classes for map
local mapname = game.GetMap()
if string.sub( mapname, 1, 23 ) == "rm_hedgemaze_night_beta" then mapname = "rm_hedgemaze_night" end

-- Get Config for classes
MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
			
-- Create Class Selection screen
MR = MR or {}

////////////////////////////////////////////////////////
///////////////////// SERVER ///////////////////////////
////////////////////////////////////////////////////////
if SERVER then
	
	util.AddNetworkString("MR.SelMenuBuild")
	function MR.SelMenuBuild( ply )
		if ply == nil then error("\n --- No player info sent for Menu Building ---") end
		net.Start("MR.SelMenuBuild")
		net.Send(ply)
	end
	
	// On spawn, player has 30 seconds to switch classes unless they take damage or move
	-- Spawn Hook
	hook.Add( "PlayerSpawn", "MR.SpawnSelectTime", function( ply )
		if ply:Team() == 2 then return end -- Not for Spectators
		ply:SetMRCanSelect( true )
		local maxTime = cfg.SpawnSelectTime or 15
		local Reps = 0
		local origin
			
		-- Timer to remove ply special perms
		timer.Create( "MR.SpawnSelectTime"..ply:EntIndex(), 1, maxTime, function() 
			Reps = Reps + 1
			if Reps >= maxTime then
				hook.Remove( "PlayerShouldTakeDamage", "MR.SpawnSelectTime"..ply:EntIndex() )
				if !ply then return end
				ply:SetMRCanSelect( false )
				return
			end
			if Reps == 5 then
				if !ply:IsValid() or !ply:Alive() then return end
			-- Move Check
				origin = ply:GetPos()
				
			-- Damage Hook
				hook.Add( "PlayerShouldTakeDamage", "MR.SpawnSelectTime"..ply:EntIndex(), function( play, atk ) 
					if play == ply then 
						hook.Remove( "PlayerShouldTakeDamage", "MR.SpawnSelectTime"..ply:EntIndex() )
						timer.Remove( "MR.SpawnSelectTime"..ply:EntIndex() )
						ply:SetMRCanSelect( false )
					end
				end)
			elseif Reps > 5 then
				if ply:IsValid() and ply:GetPos() != origin then
					hook.Remove( "PlayerShouldTakeDamage", "MR.SpawnSelectTime"..ply:EntIndex() )
					timer.Remove( "MR.SpawnSelectTime"..ply:EntIndex() )
					ply:SetMRCanSelect( false )
				end
			end // end if Reps > 5
		end ) // end Spawn Select Timer
	end ) // end Player Select Time Hook
	
	// Check Max Players
	function MR.FnCMC( class, classTeam) -- check max classes
		
		local classCount = table.Copy( classTeam )
		for k,v in pairs( player.GetAll() ) do
			if v then
				local class = v:GetMRClass()
				if !class or class == "N/A" or !classCount[class] then continue end
				classCount[class].curcount = classCount[class].curcount + 1
			end
		end
		
		local curPly = classCount[class].curcount
		local maxInClass = classCount[class].maxIC
		if maxInClass < 0 then -- infinite
			return true
		else
			maxInClass = math.ceil( classCount[class].maxIC * player.GetCount() / 32, 0 )
			if maxInClass == 0 then maxInClass = 1 end
			if curPly >= maxInClass then -- Max Reached
				return false
			else -- Within Limit
				return true
			end
		end
	end // end FnCMC / Check Max Classes
	
	// Select a Class
	util.AddNetworkString("MR.SelClass")
	net.Receive( "MR.SelClass", function( len, ply ) 
		if IsValid( ply ) then
		
			-- Check if Class request was sent
			local class = net.ReadString()
			if class == nil then return end
			
			-- Check if Class Exists
			if cfg.RunnerClasses[class] == nil then 
				if cfg.MinotaurClasses[class] == nil then error("\n --- No Class Found --- ") return
				else // It is a Minotaur Class
				
					-- Check if Player is a Minotaur or Spectator
					if ply:Team() == 0 or ply:Team() == 2 then
						-- Set Player's Class
						local bool = MR.FnCMC( class, cfg.MinotaurClasses )
						if bool then 
							ply:SetMRNxtClass( class ) 
							if ply:GetMRCanSelect() then hook.Run( "PlayerLoadout", ply ) else
								ply:ChatPrint("You will change classes when you respawn")
							end
						else ply:ChatPrint( "That Class is Full!" ) end
						timer.Simple( 0.1, function() MR.SelMenuBuild( ply ) end )
					else // Ply is not a Minotaur or Spectator
						ply:ChatPrint( "You must be a Minotaur to Choose that" )
					end
				end // end Minotaur Class
			else // It is a Runner Class
			
				-- Check if Player is a Runner or Spectator
				if ply:Team() == 1 or ply:Team() == 2 then
					-- Set Player's Class
					local bool = MR.FnCMC( class, cfg.RunnerClasses )
					if bool then 
						ply:SetMRNxtClass( class ) 
						if ply:GetMRCanSelect() then hook.Run( "PlayerLoadout", ply ) else
							ply:ChatPrint("You will change classes when you respawn")
						end
					else ply:ChatPrint( "That Class is Full!" ) end
					timer.Simple( 0.1, function() MR.SelMenuBuild( ply ) end )
				else // Ply is not a Runner or Spectator
					ply:ChatPrint( "You must be a Runner to Choose that" )
				end
			
			end // end Runner Class
			
		end // end Ply Valid
	end ) // end Receive Sel Class
	
	
// Bind it
	function GM:ShowSpare2( ply )
		MR.SelMenuBuild( ply )
	end
	
end // End if SERVER

////////////////////////////////////////////////////////
///////////////////// CLIENT ///////////////////////////
////////////////////////////////////////////////////////
if CLIENT then
	local classes

//// COLORS ////
	MRNavbarColor = Color( 0, 0, 0, 245)
	local DefMRNavbarColor = MRNavbarColor
	MRBGColor = Color( 150, 150, 150, 255 )
	local DefMRBGColor = MRBGColor
	MRFGColor = Color( 175, 175, 175, 255 )
	local DefMRFGColor = MRFGColor
	MRNormTextColor = Color( 255, 255, 255, 255)
	local DefMRNormTextColor = MRNormTextColor
	MRHeadlineColor = Color( 255, 255, 255, 255)
	local DefMRHeadlineColor = MRHeadlineColor
	MRNameColor = Color( 255, 255, 255, 255)
	local DefMRNameColor = MRNameColor
	MRLPTextColor = Color( 230, 180, 80, 235)
	local DefMRLPTextColor = MRLPTextColor
	MRLPBGColor = Color( 230, 230, 230, 255 )
	local DefMRLPBGColor = MRLPBGColor
	MRBtn1Color = Color( 230, 230, 230, 255)
	local DefMRBtn1Color = MRBtn1Color
	MRBtn2Color = Color( 50, 50, 50, 255 )
	local DefMRBtn2Color = MRBtn2Color
	MRBtn3Color = Color( 50, 190, 25, 255 )
	local DefMRBtn3Color = MRBtn3Color
	MRBtn4Color = Color( 255, 42, 42, 255 )
	local DefMRBtn4Color = MRBtn4Color
	MRBtn5Color = Color( 125, 125, 125, 255 )
	local DefMRBtn5Color = MRBtn5Color

//// GENERAL USE FUNCTIONS ////
	function MR.CrDLabel( Panel, text, font, color, align )
		local DLabel = vgui.Create( "DLabel", Panel )
		DLabel:SetText( text )
		DLabel:SetFont( font )
		DLabel:SetColor( color )
		DLabel:SizeToContents()
		DLabel:SetContentAlignment( align )
		return DLabel
	end
	
	local function ConfirmSelection(str, Toptional)
		local text = "You are about to go to"
		local text2 = "\"".. str.. "\""
		surface.PlaySound( "garrysmod/ui_click.wav" )
		
		if MR.PNLConfirm != nil then MR.PNLConfirm:Remove() end
		
		MR.PNLConfirm = vgui.Create( "DFrame" )
		local MRconfirm = MR.PNLConfirm
		MRconfirm:SetTitle("")
		MRconfirm:SetSize(300,150)
		MRconfirm:Center()
		MRconfirm.Paint = function()
			draw.RoundedBox(0, 0, 0, MRconfirm:GetWide(), MRconfirm:GetTall(), MRBGColor )
			draw.RoundedBox(0, 0, 0, MRconfirm:GetWide(), 30, MRNavbarColor)
			draw.SimpleText("Confirmation", "coolvetica24", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)    
			draw.SimpleText(text, "H2", 150, 45, MRNormTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
			draw.SimpleText(text2, "H1", 150, 70, MRNormTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
		end
		MRconfirm:SetVisible( true )
		MRconfirm:SetDraggable( true )
		MRconfirm:ShowCloseButton( true )
		MRconfirm:MakePopup()
		
		local BtnMRConfirm = vgui.Create( "DButton", MRconfirm ) // Create the button and parent it to the frame
		BtnMRConfirm:SetText( "Confirm" )					// Set the text on the button
		BtnMRConfirm:SetPos( 150-100, 100 )					
		BtnMRConfirm:SetSize( 80, 30 )					
		BtnMRConfirm.DoClick = function()
			MRconfirm:Remove()
			--surface.PlaySound( "buttons/button15.wav" )
			if str == "Class Selection" then MR.SelMenuBuild(MRframe)
			elseif str == "Info Menu" then MR.InfoMenuBuild(MRframe)
			end
		end
		
		local BtnMRCancel = vgui.Create( "DButton", MRconfirm ) // Create the button and parent it to the frame
		BtnMRCancel:SetText( "Cancel" )					// Set the text on the button
		BtnMRCancel:SetPos( 150+20, 100 )					
		BtnMRCancel:SetSize( 80, 30 )					
		BtnMRCancel.DoClick = function()
			MRconfirm:Remove()
		end
		
	// Special Considerations
		if str == "WIP" then text = "This option is currently" text2 = "unavailable"
		end
		
	end // End Confirm Selection

//// Build Selection Menu ////
	function MR.SelMenuBuild( MRframe )
		if MR.SELPNL != nil then
			MR.SELPNL:Remove()
		end
		
		if MRframe == nil then
			MRframe = vgui.Create( "DFrame" )
			MRframe:SetTitle("")
			MRframe.Paint = function()
				draw.RoundedBox(0,0,0,MRframe:GetWide(), MRframe:GetTall(), MRBGColor )
				draw.RoundedBox(0,0,0,MRframe:GetWide(), 30, MRNavbarColor )
				draw.SimpleText("MR: Class Selection", "coolvetica24", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			MRframe:SetSize( 800, 600 )
			MRframe:SetVisible( true )
			MRframe:SetDraggable( true )
			MRframe:ShowCloseButton( true )
			MRframe:MakePopup()
		end
		
		MR.SELPNL = MRframe
		MR.SELPNL:Center()
		
	// Create Panels within MR.SELPNL
		MR.SELPNL.Navbar = vgui.Create( "DPanel", MR.SELPNL )
		local Navbar = MR.SELPNL.Navbar
		MR.SELPNL.Main = vgui.Create( "DPanel", MR.SELPNL )
		MR.SELPNL.Main:Dock( FILL )
		local Main = MR.SELPNL.Main
		
	// Navbar Setup
		Navbar:SetSize( 200, 30)
		Navbar:SetPos( 500, 0)
		Navbar.Paint = function() end -- removes the visible bar
	
	// Navbar Settings
		local CBSettings1 = vgui.Create( "DComboBox", Navbar)
		CBSettings1:SetPos( 0, 7 )
		CBSettings1:SetSize( 128, 16 )
		CBSettings1:SetValue( "Filter" )
		CBSettings1:AddChoice( "1.) All" )
		CBSettings1:AddChoice( "2.) Runner" )
		CBSettings1:AddChoice( "3.) Minotaur" )
		CBSettings1.OnSelect = function( panel, index, value )
			if value == "1.) All" then
				MR.SELPNL.FnClearClasses()
				MR.SELPNL.FnBuildClasses( cfg.RunnerClasses, cfg.TeamSetup[2]["name"], cfg.TeamSetup[2]["color"] )
				MR.SELPNL.FnBuildClasses( cfg.MinotaurClasses, cfg.TeamSetup[1]["name"], cfg.TeamSetup[1]["color"] )
			elseif ( value == "2.) Runner" ) then
				MR.SELPNL.FnClearClasses()
				MR.SELPNL.FnBuildClasses( cfg.RunnerClasses, cfg.TeamSetup[2]["name"], cfg.TeamSetup[2]["color"] )
			elseif ( value == "3.) Minotaur" ) then
				MR.SELPNL.FnClearClasses()
				MR.SELPNL.FnBuildClasses( cfg.MinotaurClasses, cfg.TeamSetup[1]["name"], cfg.TeamSetup[1]["color"] )
			end
				
		end
		
		local ImgHome1 = Navbar:Add("DImageButton")
		ImgHome1:SetPos( 128+25, 7 )
		ImgHome1:SetSize( 16, 16 )
		ImgHome1:SetImage( "icon16/house.png" )
		ImgHome1.DoClick = function()
			ConfirmSelection("Class Selection")
		end
		
		local ImgInfo1 = Navbar:Add("DImageButton")
		ImgInfo1:SetPos( 128+50, 7 )
		ImgInfo1:SetSize( 16, 16 )
		ImgInfo1:SetImage( "icon16/information.png" )
		ImgInfo1.DoClick = function()
			ConfirmSelection("Info Menu")
			-- MR.InfoMenuBuild()
		end
		
	// Build Main Panel
		Main.Paint = function()
			draw.RoundedBox(0,0,0,Main:GetWide(), Main:GetTall(), MRFGColor )
			--draw.RoundedBox(0, 0, 0, Main:GetWide(), 30, Color( 40, 40, 40, 245 ))    
		end
	
	// Build Horizontal Scrollbar
		Main.SB = vgui.Create( "DHorizontalScroller", Main )
		local SB = Main.SB
		SB:Dock( FILL )
		SB:SetOverlap( -4 )
		--[[
		function SB.btnLeft:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0 ) )
		end
		function SB.btnRight:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 100, 200 ) )
		end--]]
		
	// Build Class Selection Panels
		function MR.SELPNL.FnBuildClasses( classTeam, teamName, teamColor )
			if classTeam == nil then error( "\n --- No Class Team Found ---" ) end
			local classCount = table.Copy( classTeam )
			for k,v in pairs( player.GetAll() ) do
				if v then
					local class = v:GetMRClass()
					if !class or class == "N/A" or !classCount[class] then continue end
					classCount[class].curcount = classCount[class].curcount + 1
				end
			end
			
			for k,v in pairs( classTeam ) do
				local Panel = vgui.Create( "DPanel", SB )
				Panel:SetSize( 250 ,SB:GetTall() )
				SB:AddPanel( Panel )
				
				teamName = teamName or "Default"
				teamColor = teamColor or Color( 150, 100, 255 )
				
				// Build Model
				local mdl = vgui.Create( "DModelPanel", Panel )
				mdl:SetSize( Panel:GetWide(), Panel:GetWide()*1.5 )
				mdl:SetModel( v.model )
				function mdl:LayoutEntity( ent ) return end -- stop spinning
				
				if cfg.ColorizePly then
					local color = Vector( 61,87,105 ) -- default color code
					if teamName == "Runner" then
						color = Vector(52, 152, 219) 
					else
						color = Vector(231, 76, 60)
					end
					color:Normalize()
					function mdl.Entity:GetPlayerColor() return color end -- change color
				end
				local eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ) - Vector(0,0,25)
				mdl:SetLookAt( eyepos )
				mdl:SetFOV( 54 )
				mdl:SetCamPos( eyepos + Vector( 56, 0, 6 ) )
				
				// Build Descriptions
				-- Team & Class Name
				local TeName = MR.CrDLabel( Panel, teamName, "H1", teamColor, 5 )
				TeName:SetPos( Panel:GetWide()/2 - TeName:GetWide()/2, mdl:GetTall() + 10 )
				local ClName = MR.CrDLabel( Panel, v.classname, "H1", teamColor, 5 )
				ClName:SetPos( Panel:GetWide()/2 - ClName:GetWide()/2, mdl:GetTall() + TeName:GetTall() + 10 )
				
				-- Walkspeed, Runspeed, Health, Armor
				local base = 20
				local Stats = MR.CrDLabel( Panel, "Health: "..v.health, "H3", Color(255,70,70,255), 4 )
				Stats:SetPos( 10, base )
				local Stats2 = MR.CrDLabel( Panel, "Armor: "..v.armor, "H3", Color(40,125,255,255), 4 )
				Stats2:SetPos( 10, base + Stats:GetTall() )
				local Stats3 = MR.CrDLabel( Panel, "Walk: "..v.walkspeed.."\nRun: "..v.runspeed, "H3", MRLPTextColor, 4 )
				Stats3:SetPos( 10, base + Stats:GetTall() + Stats2:GetTall() )
				
				-- Loadout + Shadow
				local Loadout = MR.CrDLabel( Panel, "Loadout:   \n" .. table.concat( v.weps, "\n" ), "H3", Color(50,50,50,255), 6 )
				Loadout:SetPos( 10 + 1, mdl:GetTall()*3/4 + 1 )
				local Loadout = MR.CrDLabel( Panel, "Loadout:   \n" .. table.concat( v.weps, "\n" ), "H3", teamColor, 6 )
				Loadout:SetPos( 10, mdl:GetTall()*3/4 )
				
				-- Description
				local DesBG = vgui.Create( "DPanel", Panel )
				
				local Description = MR.CrDLabel( Panel, v.description, "Normal", MRNormTextColor, 8 )
				Description:SetPos( 20, ClName.y + 44 )
				Description:SetSize( Panel:GetWide() - 40, 40 )
				Description:SetWrap( true )
				
				DesBG:SetSize( Description:GetWide()+20, Description:GetTall()+20 )
				DesBG:SetPos( Description.x - 10, Description.y - 10 )
				function DesBG:Paint(w,h)
					draw.RoundedBox(0,0,0, w, h, Color( 40, 40, 40, 255 ) )
					draw.RoundedBox(0,0,0, w-2, h-2, Color( 120, 120, 120, 255 ) )
					draw.RoundedBox(0,0,0, w-4, h-4, Color( 80, 80, 80, 255 ) )
				end
				
				-- Build Selection Button
				local Select = vgui.Create( "DButton", Panel )
				Select:SetSize( Panel:GetWide()-10, 500 )
				Select:SetPos(5,5)
				Select:SetText("Select")
				function Select:Paint(w,h)
					-- invisible
				end
				function Select:DoClick()
					net.Start( "MR.SelClass" )
					net.WriteString( k )
					net.SendToServer()
				end
				
				-- Cur Players / Max Players
				local curPly = classCount[k].curcount
				local maxInClass = classCount[k].maxIC
				if maxInClass <= 0 then maxInClass = "Inf" 
				else
					maxInClass = math.ceil( classCount[k].maxIC * player.GetCount() / 32, 0 )
					if maxInClass == 0 then maxInClass = 1 end
					if curPly >= maxInClass then
						Select:SetDisabled( true )
						Select:SetText( "Max Players Reached" )
						Select:SetColor( Color(255,40,40,255) )
					end
				end
				local PlyCnt = MR.CrDLabel( Panel, curPly .. "/" .. maxInClass , "H3", Color(50,50,50,255), 6 )
				PlyCnt:SetPos( 10, 4 )
				
			end // End For Every Class do...
			
		end // end Fn Build Class Selection Panels
		
		MR.SELPNL.FnBuildClasses( cfg.RunnerClasses, cfg.TeamSetup[2]["name"], cfg.TeamSetup[2]["color"] )
		MR.SELPNL.FnBuildClasses( cfg.MinotaurClasses, cfg.TeamSetup[1]["name"], cfg.TeamSetup[1]["color"] )
	
	// Clear Class Selection Panels
		function MR.SELPNL.FnClearClasses()
			SB:Clear()
		end
		
	// Select starting Filter
		local ply = LocalPlayer()
		if ply:Team() == 1 then CBSettings1:ChooseOption( "2.) Runner", 2 )
		elseif ply:Team() == 0 then CBSettings1:ChooseOption( "3.) Minotaur", 3 ) end
		
	end // end MR.SelMenuBuild
	
// -- Client Networking --
	net.Receive( "MR.SelMenuBuild", function() MR.SelMenuBuild() end )
	
end // end CLIENT

////////////////////////////////////////////////////////
///////////////////// SHARED ///////////////////////////
////////////////////////////////////////////////////////