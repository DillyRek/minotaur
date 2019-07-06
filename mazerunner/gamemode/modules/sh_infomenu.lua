-- Get Config for classes
MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
cfg.InfoMenu = cfg.InfoMenu || {}
local infm = cfg.InfoMenu
infm.Pages = infm.Pages || {}
local Pages = infm.Pages
			
-- Create Menu Table
include( "sh_classselection.lua" )
MR = MR or {}

////////////////////////////////////////////////////////
///////////////////// SERVER ///////////////////////////
////////////////////////////////////////////////////////
if SERVER then
	
	util.AddNetworkString("MR.InfoMenuBuild")
	function MR.InfoMenuBuild( ply )
		if ply == nil then error("\n --- No player info sent for Info Menu Building ---") end
		net.Start("MR.InfoMenuBuild")
		net.Send(ply)
	end
	
// Bind it
	function GM:ShowHelp( ply )
		MR.InfoMenuBuild( ply )
	end
	
end // end if Server

////////////////////////////////////////////////////////
///////////////////// CLIENT ///////////////////////////
////////////////////////////////////////////////////////

if CLIENT then
	
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
	function MR.InfoMenuBuild( MRframe )
		if MR.INFPNL != nil then
			MR.INFPNL:Remove()
		end
		
		local infmSel = "1.) General"
		
		if MRframe == nil then
			MRframe = vgui.Create( "DFrame" )
			MRframe:SetTitle("")
			MRframe.Paint = function()
				draw.RoundedBox(0,0,0,MRframe:GetWide(), MRframe:GetTall(), MRBGColor )
				draw.RoundedBox(0,0,0,MRframe:GetWide(), 30, MRNavbarColor )
				draw.SimpleText("MR: Information Menu", "coolvetica24", 4, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			MRframe:SetSize( 800, 600 )
			MRframe:SetVisible( true )
			MRframe:SetDraggable( true )
			MRframe:ShowCloseButton( true )
			MRframe:MakePopup()
		end
		
		MR.INFPNL = MRframe
		MR.INFPNL:Center()
		
	// Create Panels within MR.INFPNL
		MR.INFPNL.Navbar = vgui.Create( "DPanel", MR.INFPNL )
		local Navbar = MR.INFPNL.Navbar
		MR.INFPNL.Main = vgui.Create( "DPanel", MR.INFPNL )
		MR.INFPNL.Main:Dock( FILL )
		local Main = MR.INFPNL.Main
		
	// Navbar Setup
		Navbar:SetSize( 200, 30)
		Navbar:SetPos( 500, 0)
		Navbar.Paint = function() end -- removes the visible bar
	
	// Navbar Settings
		local CBSettings1 = vgui.Create( "DComboBox", Navbar)
		CBSettings1:SetPos( 0, 7 )
		CBSettings1:SetSize( 128, 16 )
		CBSettings1:SetValue( "Info Page" )
		-- Create Choices from Table
		local it = 0
		for k, v in pairs( Pages ) do
			it = it+1
			local pgName = it .. ".) " .. v.name
			CBSettings1:AddChoice( pgName )
			if it == 1 then
				infmSel = pgName
			end
		end
		CBSettings1.OnSelect = function( panel, index, value )
			
			it = 0
			Main:Clear()
			local DScrollPanel = vgui.Create( "DScrollPanel", Main )
			DScrollPanel:Dock( FILL )
			
			local function crtFont( Value, Font, Scrollbar )
				if Value == nil then return end
				if Font == nil then Font = "Normal" end
				if Scrollbar == nil then Scrollbar = DScrollPanel end
				
				local richtext = vgui.Create( "RichText", Scrollbar )
				richtext:Dock( TOP )
				richtext:AppendText( Value.text )
				function richtext:PerformLayout()
					self:SetFontInternal( Font )
					self:SetFGColor( Value.color )
				end
				timer.Simple( 0.02, function() if richtext:IsValid() then richtext:SetToFullHeight() end end )
				return richtext
			end // end crtFont Fn
			
			for k, v in pairs( Pages ) do
				it = it+1
				if value == ( it ..".) "..v.name ) then -- load page
				-- Create RichText panels with parsed text
					for key, val in pairs( v.text ) do
					-- Create Title, then Headline, then Text
						local Title, HL, Txt = val.title, val.HL, val.text
						local TiFnt, HLFnt, TxFnt = "Title", "H1", "Normal"
						if Title then -- Make Title
							local richtext = crtFont( Title, TiFnt, DScrollPanel )
							if HL then
								local richtext = crtFont( HL, HLFnt, DScrollPanel )
								if Txt then
									local richtext = crtFont( Txt, TxFnt, DScrollPanel )
									richtext:SetVerticalScrollbarEnabled( false )
								end
							elseif Txt then
								local richtext = crtFont( Txt, TxFnt, DScrollPanel )
								richtext:SetVerticalScrollbarEnabled( false )
							end
						elseif HL then -- No Title! Make Headline
							local richtext = crtFont( HL, HLFnt, DScrollPanel )
							if Txt then
								local richtext = crtFont( Txt, TxFnt, DScrollPanel )
								richtext:SetVerticalScrollbarEnabled( false )
							end
						elseif Txt then -- No Title! No Headline! Make Text
							local richtext = crtFont( Txt, TxFnt, DScrollPanel )
							richtext:SetVerticalScrollbarEnabled( false )
						end
					end // end for v.text pairs
				end // end if name
			end // end for Pages pairs
				
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
		end
		
	// Build Main Panel
		Main.Paint = function()
			draw.RoundedBox(0,0,0,Main:GetWide(), Main:GetTall(), MRFGColor )
			--draw.RoundedBox(0, 0, 0, Main:GetWide(), 30, Color( 40, 40, 40, 245 ))    
		end
		
	// Select starting Filter
		CBSettings1:ChooseOption( infmSel, 1 )
		local ply = LocalPlayer()
		
	end // end MR.InfoMenuBuild
	
// -- Client Networking --
	net.Receive( "MR.InfoMenuBuild", function() MR.InfoMenuBuild() end )
	
end // end if Client

-- end of code