local root = GM.FolderName .. "/gamemode/modules/"
local files = file.Find(root.."*", "LUA")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("wepconfig.lua")
AddCSLuaFile("info_config.lua")
include("wepconfig.lua")
include("info_config.lua")
include("config.lua")
include("shared.lua")

---------------------------------

MR_CONFIG = MR_CONFIG || {}
local cfg = MR_CONFIG
local debugBool = cfg.Debug

---------------------------------

MsgC(Color(0, 255, 0), "\n----- Started Module Load -----\n")
for k, f in SortedPairs(files, true) do
	local path = root..f

	if(f:StartWith("sv_")) then
		MsgC(Color(255, 255, 255, 255), "Included serverside file ", Color(0, 255, 255), f, "\n")
		include(path)
	elseif (f:StartWith("cl_")) then
		MsgC(Color(255, 255, 255, 255), "Sent clientside file ", Color(255, 255, 0), f, "\n")
		AddCSLuaFile(path)
	elseif (f:StartWith("sh_")) then
		MsgC(Color(255, 255, 255, 255), "Included and sent shared file ", Color(0, 0, 255), f, "\n")
		AddCSLuaFile(path)
		include(path)
	end
end
MsgC(Color(0, 255, 0), "----- Completed Module Load -----\n\n")

-- Automatically send all gamemode-specific materials
local fileCounter = { ["materials"] = 0, ["models"] = 0 }
local function addContentFolder( path, ID, var )
	ID = ID or "materials"
    local files, folders = file.Find( path .. "/*", "THIRDPARTY" )
    for k, v in pairs( files ) do
		resource.AddFile( path .. "/" .. v )
		fileCounter[ID] = fileCounter[ID] + 1
		if debugBool then print("File Sent #"..fileCounter[ID]..": ".. path .. "/" .. v) end
    end
    
    for k, v in pairs( folders ) do
		if debugBool then print("Folder Loaded: ".. path .. "/" .. v) end
		addContentFolder( path .. "/" .. v, ID )
    end
	if var then
		MsgC(Color(255,255,255,255), "MR Files Loaded for ",Color(255, 255, 0), ID, Color(255,255,255,255),": ", Color(255, 255, 0), fileCounter[ID], "\n" )
	end
end

MsgC(Color(0, 255, 200), "\n----- Started Material Load -----\n\n")

--local root = GM.FolderName .. "/content/materials"
local root = "materials"
addContentFolder( root, "materials", true )

MsgC(Color(0, 255, 200), "\n----- Completed Material Load -----\n\n")
--]]