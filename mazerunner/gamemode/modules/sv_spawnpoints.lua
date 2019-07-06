if SERVER then
	local mapname = game.GetMap()
	if string.sub( mapname, 1, 23 ) == "rm_hedgemaze_night_beta" then mapname = "rm_hedgemaze_night" end
	// Load Spawn Points
	
	spawnpointsminotaur = {}
	spawnpointsminotaur[ mapname ] = {}
	spawnpointsrunner = {}
	spawnpointsrunner[ mapname ] = {}
				
	if !file.Exists( "mazerunner", "DATA" ) then
		file.CreateDir( "mazerunner", "DATA" ) 
	end
	
	if !file.Exists( "mazerunner/spawnpointsminotaur.txt", "DATA" ) then
		file.Write( "mazerunner/spawnpointsminotaur.txt", util.TableToKeyValues( spawnpointsminotaur ) )
	else
		spawnpointsminotaur = util.KeyValuesToTable( file.Read( "mazerunner/spawnpointsminotaur.txt", "DATA" ) )
		if spawnpointsminotaur[ mapname ] == nil then 
			spawnpointsminotaur[ mapname ] = {} 
			print("[MR]: No spawn points found on " .. mapname .. " for team Minotaur!") 
		end
	end
	
	if !file.Exists( "mazerunner/spawnpointsrunner.txt", "DATA" ) then
		file.Write( "mazerunner/spawnpointsrunner.txt", util.TableToKeyValues( spawnpointsrunner ) )
	else
		spawnpointsrunner = util.KeyValuesToTable( file.Read( "mazerunner/spawnpointsrunner.txt", "DATA" ) )
		if spawnpointsrunner[ mapname ] == nil then 
			spawnpointsrunner[ mapname ] = {} 
			print("[MR]: No spawn points found on " .. mapname .. " for team Runner!")
			print("[MR]: NOTE Runner spawnpoints may not be necessary! The map may default to them!")
		end
	end
end