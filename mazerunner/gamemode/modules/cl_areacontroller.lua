if CLIENT then
	local Area = {}
	Area.Noclip = true
	function Area.NoclipNotice()
		local Col = Color(255, 255, 255, 255)
		hook.Add("HUDPaint", "NoclipNotice", function()
			Col.a = Col.a - 4
			draw.DrawText("Noclip disabled in this area", "DermaLarge", ScrW()/2, 20, Col, 1)
			if Col.a < 0 then hook.Remove("HUDPaint", "NoclipNotice") end
		end)
	end
	
	net.Receive("Area", function() 
		local Type = net.ReadString()
		print(" Received Area Message! ")
		if Type == "SendChat" then 
			chat.AddText(unpack(net.ReadTable()))
		elseif Type == "Noclip" then
			local Bl = net.ReadBit()
			if Bl == 1 then Area.Noclip = true elseif Bl == 0 then Area.Noclip = false end
		elseif Type == "NoclipNotice" then
			Area.NoclipNotice()
		end
	end)

	hook.Add("PlayerBindPress", "AreaNoclip", function(Ply, Bind, Pressed)
		if string.find(string.lower(Bind), "noclip", 1, true) and not Area.Noclip  then
			Area.NoclipNotice()
			return true
		end
	end)
	
end