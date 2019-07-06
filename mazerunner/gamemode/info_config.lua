MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
cfg.WEP = cfg.WEP || {}
local wcfg = cfg.WEP
cfg.InfoMenu = cfg.InfoMenu || {}
local infm = cfg.InfoMenu
infm.Pages = {}

function infm.FnAddPage( cName )
	infm.Pages[cName] = { ["name"] = cName, ["text"] = {} }
end

function infm.FnAddHL( cName, cText, num, color )
	if num == nil then num = 1 end
	if color == nil then color = Color( 255, 255, 255 ) end
	infm.Pages[cName]["text"][num] = infm.Pages[cName]["text"][num] or {}
	infm.Pages[cName]["text"][num]["HL"] = { ["text"] = cText, ["color"] = color }
end

function infm.FnAddText( cName, cText, num, color )
	if num == nil then num = 1 end
	if color == nil then color = Color( 255, 255, 255 ) end
	infm.Pages[cName]["text"][num] = infm.Pages[cName]["text"][num] or {}
	infm.Pages[cName]["text"][num]["text"] = { ["text"] = cText, ["color"] = color } 
end

function infm.FnAddTitle( cName, cText, num, tcolor )
	if num == nil then num = 1 end
	if tcolor == nil then tcolor = Color( 255, 255, 255 ) end
	infm.Pages[cName]["text"][num] = infm.Pages[cName]["text"][num] or {}
	infm.Pages[cName]["text"][num]["title"] = { ["text"] = cText, ["color"] = tcolor }
end

///// Add Your Pages Below using this: /////////////////////
///// infm.FnAddPage( "NameOfPage", "Page Text" ) //////////
///// Titles, Headlines, and Text can be added with their specific functions, eg. infm.FnAddTitle( "PageName", "What Text You Want", 1, Color( 255,255,255 ) )
///// Replace the 1 with the slot you want to fill, where 1 is the top, and 9999999999 is the bottom.
///// The Text can change using parsing such as \n for a new line, \t for a tab
///// If you want to add a special character in, like "" you will need to use \ ahead of it, like \"
///// You can also just use [[ insert text here ]] to copy text as you write it here.

infm.FnAddPage( "General")
infm.FnAddTitle( "General", "General", 1 )
infm.FnAddHL( "General", "Basics:", 1 )
infm.FnAddText( "General", "Each round, at least one player is randomly selected to be the minotaur. The minotaur's job is to defeat all of the runners. The minotaur is stronger than all of the runners, but he isn't necessarily the fastest. Make sure to limit your flashlight usage, as its batteries take time to recharge. Visiting a shrine can recharge batteries faster. \n\nBe wary of traveling in the maze. Traps lie around each and every corner!", 1 )
infm.FnAddHL( "General", "Unnecessary Information", 2, Color( 255, 210, 180 ) )
infm.FnAddText( "General", "Memes are good!", 2, Color( 255, 230, 120 ) )
for i = 3, 30 do
	infm.FnAddText( "General", 
	[[Yay for memes!
I can write text like this!
	It works	very	very well!
	 " " " " !@$!%^*@*]],
	i, Color( 255 - i*5, 230 - i*5, 120 - i*2 ) )
end
infm.FnAddPage( "Runner")
	local color = Color(52, 152, 219)
infm.FnAddTitle( "Runner", "Runner", 1, color )
infm.FnAddHL( "Runner", "Basics:", 1 )
-- infm.FnAddTitle( "Runner", " \nClasses:", 2, Color( 50, 140, 200 ) )
infm.FnAddHL( "Runner", " \nClass - Scout:", 2, color )
infm.FnAddHL( "Runner", "Class - Brute:", 3, color )
infm.FnAddHL( "Runner", "Class - Tracker:", 4, color )
infm.FnAddHL( "Runner", "Class - Cleric:", 5, color )
infm.FnAddText( "Runner", "Your goal is to defeat the minotaur! You can run to the center of the maze to obtain weapons.", 1 )
infm.FnAddText( "Runner", "Move quickly! \n", 2 )
infm.FnAddText( "Runner", "Be strong!", 3 )
infm.FnAddText( "Runner", "Track others!", 4 )
infm.FnAddText( "Runner", "Heal allies!", 5 )
infm.FnAddPage( "Minotaur")
	local color = Color(231, 76, 60)
infm.FnAddTitle( "Minotaur", "Minotaur", 1, color )
infm.FnAddHL( "Minotaur", "Basics:",  1 )
infm.FnAddText( "Minotaur", "Your goal is to defeat the runners!", 1 )