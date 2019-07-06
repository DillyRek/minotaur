local root = GM.FolderName .. "/gamemode/modules/"
local files = file.Find(root.."*", "LUA")

include("config.lua")
include("shared.lua")
include("wepconfig.lua")
include("info_config.lua")

for k, f in SortedPairs(files, true) do
	if(f:StartWith("sh_") || f:StartWith("cl_")) then
		include(root..f)
	end
end
