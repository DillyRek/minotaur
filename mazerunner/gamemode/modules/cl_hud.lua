MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
local offset = ScreenScale(8)

local elementTable = {
	["CHudAmmo"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSuitPower"] = true,
	["CHudCrosshair"] = true
}

hook.Add("HUDShouldDraw", "HideHUDElements", function(e)
	if(elementTable[e]) then return false end
end)

surface.CreateFont("HUD", {font = "Roboto Light", size = ScreenScale(10), weight = 100})
surface.CreateFont("HUDBar", {font = "Roboto Light", size = ScreenScale(7), weight = 100})
surface.CreateFont("HUDBarLabel", {font = "Roboto Light", size = ScreenScale(5), weight = 100})

local function drawBar(x, y, w, h, val, maxval, col, label, r)
	maxval = maxval or 100
	val = val or 100
	
	draw.RoundedBox(4, x, y, w, h, Color(0, 0, 0, 200))
	draw.RoundedBox(6, x+3, y+3, w-6, h-6, Color(255, 255, 255, 10))
	
	local barVal = math.Clamp(val/maxval, 0, 1)

	local dx = x
	if(r) then dx = x + w - w*barVal end

	draw.RoundedBox(6, dx+3, y+3, w*barVal-6, h-6, col)
	
	val = math.Clamp(val, 0, math.huge)
	val = math.Round(val)
	--[[
	local percval
	percval = math.Clamp(val, 0, math.huge)
	percval = math.Round(percval)
	--]]

	draw.SimpleText(val, "HUDBar", x+(r&&w-5||5),y+h/2,Color(255, 255, 255, 255),r&&TEXT_ALIGN_RIGHT||TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	--draw.SimpleText(percval, "HUDBar", x+(r&&w-5||5),y+h/2,Color(255, 255, 255, 255),r&&TEXT_ALIGN_RIGHT||TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	draw.SimpleText(label, "HUDBarLabel", x+(r&&w-5||5),y,Color(255, 255, 255, 255),r&&TEXT_ALIGN_RIGHT||TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
end

local function drawRoundTimer( timeIn )
	local timeMin = math.Round( timeIn/60, 2 )
	local minutes = math.floor( timeMin )
	local seconds = string.Explode( ".", tostring(timeMin) )
	seconds = seconds[2] or 0
	if string.len( seconds ) < 2 then seconds = seconds.."0" end
	seconds = tonumber( seconds )
	seconds = seconds/100
	seconds = math.Round( seconds * 60, 0 )
	if seconds < 10 then seconds = "0"..seconds end
	if minutes < 10 then minutes = "0"..minutes end
	local txt = minutes .. ":" .. seconds
	draw.SimpleText(txt, "H1", ScrW()/2, 55, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

end

local hpAnim = 0
local barW, barH = ScreenScale(50), ScreenScale(10)
local function drawHealth()
	local hp = LocalPlayer():Health() || 0
	local maxhp = LocalPlayer():GetMaxHealth() || 100
	hpAnim = Lerp(FrameTime() * 5, hpAnim, hp)

	local x, y = (ScrW()/2-offset/2) - barW, ScrH()-offset-barH
	drawBar(x, y, barW, barH, hpAnim, maxhp, Color(192, 57, 43), "Health", true)
end

local armorAnim = 0
local function drawArmor()
	local armor = LocalPlayer():Armor() || 0
	local maxap
	local plyClass = LocalPlayer():GetMRClass()
	if LocalPlayer():Team() == 1 then
		maxap = MR_CONFIG.RunnerClasses[plyClass] and MR_CONFIG.RunnerClasses[plyClass]["armor"] || 100
	elseif LocalPlayer():Team() == 0 then
		maxap = MR_CONFIG.MinotaurClasses[plyClass] and MR_CONFIG.MinotaurClasses[plyClass]["armor"] || 1000
	else
		maxap = 100
	end
	armorAnim = Lerp(FrameTime() * 5, armorAnim, armor)

	local x, y = ScrW()/2+offset/2, ScrH()-offset-barH
	drawBar(x, y, barW, barH, armorAnim, maxap, Color(41, 128, 185), "Armor")
end

local function drawAmmo()
	local wep = LocalPlayer():GetActiveWeapon()

	if(!IsValid(wep)) then return end
	if(!wep:Clip1() || wep:Clip1() == -1) then return end

	local mag = wep:Clip1()
	local reserve = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())

	local txt = mag.."/"..reserve

	draw.SimpleText(txt, "HUD", ScrW()-offset, ScrH()-offset, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

local function drawMeta()
	local name = LocalPlayer():Nick() || ""
	local teamName = team.GetName(LocalPlayer():Team()) || ""
	local className = LocalPlayer():GetMRClass() or "Default"
	local lives = "Lives: "..(LocalPlayer():GetLives() || 0)

	local x, y = offset, ScrH() - offset
	surface.SetFont("HUD")

	//Lives
	if(LocalPlayer():Team() != 2) then
		local w, h = surface.GetTextSize(lives)
		draw.SimpleText(lives, "HUD", x, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		y = y - h
	end

	//Team Name
	local w, h = surface.GetTextSize(teamName)
	draw.SimpleText(teamName..": "..className, "HUD", x, y, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	y = y - h

	//Player Name
	draw.SimpleText(name, "HUD", x, y, team.GetColor(LocalPlayer():Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	y = y - h
end

local Compass = Material("icons/compass.png")

surface.CreateFont("BigCompassFontPUBG", {font = "Lato", size = 15, weight = 600, shadow = true, extended = true})
surface.CreateFont("MidCompassFontPUBG", {font = "Lato", size = 15, weight = 400, shadow = true, extended = true})
surface.CreateFont("SmallCompassFontPUBG", {font = "Lato", size = 12, weight = 400, shadow = true, extended = true})

local nd = 0
local nti = 360 / 15
local noi = 18

 local function drawCompass()
    local lp = LocalPlayer()   
    local size = ScrW()*0.45   

    if IsValid(lp) then
        local dir = EyeAngles().y - nd

        for i=0, nti - 1 do
            local ang = i * 15
            local dif = math.AngleDifference(ang, dir)
            local numofinst = noi
            local offang = ( numofinst*15 )/2.8

            if math.abs(dif) < offang then
                local alpha = math.Clamp( 1-(math.abs(dif)/(offang)) , 0, 1 ) * 255
                local dif2 = size / noi
                local pos = dif/15 * dif2
                local text = tostring(360 - ang)
                local font = "SmallCompassFontPUBG"
                local clr = Color(200,200,200,alpha)

                if ang == 0 then
                    text = ("North")//"N"
                    font = "BigCompassFontPUBG"
                    clr = Color(255,255,255,alpha)
                elseif ang == 180 then
                    text = ("South")//"S"
                    font = "BigCompassFontPUBG"
                    clr = Color(255,255,255,alpha)
                elseif ang == 90 then
                    text = ("West")//"W"
                    font = "BigCompassFontPUBG"
                    clr = Color(255,255,255,alpha)
                elseif ang == 270 then
                    text = ("East")//"E"
                    font = "BigCompassFontPUBG"
                    clr = Color(255,255,255,alpha)
                elseif ang == 45 then
                    text = ("NorthWest")//"NW"
                    font = "MidCompassFontPUBG"
                    clr = Color(235,235,235,alpha)
                elseif ang == 135 then
                    text = ("SouthWest")//"SW"
                    font = "MidCompassFontPUBG"
                    clr = Color(235,235,235,alpha)
                elseif ang == 225 then
                    text = ("SouthEast")//"SE"
                    font = "MidCompassFontPUBG"
                    clr = Color(235,235,235,alpha)
                elseif ang == 315 then
                    text = ("SouthEast")//"NE"
                    font = "MidCompassFontPUBG"
                    clr = Color(235,235,235,alpha)
                end

                draw.DrawText("I\n"..text, font, ScrW()/2 - pos, 25, clr, TEXT_ALIGN_CENTER )         

            end // end Math

        end // end For i = 0, nti - 1
		
        surface.SetDrawColor( 255,255,255 )
        surface.SetMaterial( Compass )
        surface.DrawTexturedRect( ScrW()/2, 15,10,12 )    

    end // end if LocalPlayer()
end // end drawCompass() function

function GM:HUDPaint()
	self.BaseClass.HUDPaint(self)

	if(LocalPlayer():Team() == 2) then
		if(self:GetRoundState() == STATE_INPROGRESS) then
			self:SpectatorHUD()
			return
		end
	else
		self:FlashlightHUD()
	end

	drawCompass()
	drawMeta()
	drawHealth()
	drawArmor()
	drawAmmo()
	drawRoundTimer( self:GetRoundTime() )
end

surface.CreateFont("DisplayNameFont", {font = "Open Sans", size = 120})
surface.CreateFont("DisplayJobFont", {font = "Open Sans", size = 80})

local function drawPlayerInfo(ply)
	if(!IsValid(ply)) then return end
	if(ply == LocalPlayer()) then return end
	if(!ply:Alive() or LocalPlayer():InVehicle() or ply:Team() == 2) then return end
	if(ply:GetNoDraw()) then return end

	local distance = LocalPlayer():GetPos():Distance(ply:GetPos())

	local toCheck = 400

	if(distance > toCheck) then return end

	local offset = Vector(0, 0, 15)
	local ang = LocalPlayer():EyeAngles()

	local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
	local pos = ply:GetBonePosition(bone)
	pos = pos + offset + ang:Up()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	local alpha = math.Clamp(math.Remap(distance, toCheck/4, toCheck, 255, 0), 0, 255)

	cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.05)
		draw.DrawText(ply:Nick(), "DisplayNameFont", 0, -100, ColorAlpha(team.GetColor(ply:Team()), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.DrawText(team.GetName(ply:Team()) .. ": " .. ply:GetMRClass(), "DisplayJobFont", 0, 0, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.DrawText( ply:Health() .. "HP " .. ply:Armor() .. "AP" , "DisplayJobFont", 0, 75, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		--draw.DrawText(ply:GetLives() .. "L", "DisplayJobFont", 0, 150, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	cam.End3D2D()
end

function GM:PreDrawTranslucentRenderables()
	if(LocalPlayer():Team() == 2 && self:GetRoundState() == STATE_INPROGRESS) then return end

	for k, v in pairs(player.GetAll()) do
		drawPlayerInfo(v)
	end
end

function GM:HUDDrawTargetID() end

local dist = math.pow(MR_CONFIG.HaloDistance, 2)
function GM:PreDrawHalos()
	if(LocalPlayer():Team() != 0) then return end

	for k, v in pairs(team.GetPlayers(1)) do
		local distance = LocalPlayer():GetPos():DistToSqr(v:GetPos())
		
		if(distance < dist && v:Alive()) then
			--local fade = math.Remap(distance, dist, dist*2, 0, 255)	
			local fade = math.Remap(dist, distance, distance*2, 0, 255)	
			halo.Add({v}, ColorAlpha(team.GetColor(v:Team()), fade), 1, 1, 2, true, true)
		end
	end
end