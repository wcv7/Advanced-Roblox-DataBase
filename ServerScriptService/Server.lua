local ServerStorage = game.ServerStorage
local DataStoreService= game:GetService("DataStoreService")
local PlayerService = game:GetService("Players")
local Http = game:GetService("HttpService")
local ForLoops = require(script.ForLoops)
local PlayerClasses = {

}

local OnJoinTable = {
	[true] = function(Player, Result)
		print("Not Data Was Found, Player Joined For The First Time.")
		local PlayerClass = require(script.PlayerClass).new(Player)
		PlayerClasses[PlayerService:GetUserIdFromNameAsync(Player.Name)] = PlayerClass
		print(PlayerClass)
	end,
	[false] = function(Player, Result)
		print("Player Data Was Found, Loading Data...")
		Result = Http:JSONDecode(Result)
		local PlayerClass = require(script.PlayerClass).new(Player, Result)
		PlayerClass:SetName(Player.Name)
		PlayerClass:SetCharacter(Player.Character)
		PlayerClasses[PlayerService:GetUserIdFromNameAsync(Player.Name)] = PlayerClass
		print(PlayerClass)
	end,
}
local PlayerClassDB = DataStoreService:GetDataStore("_PlayerClassData_")

function PlayerJoined(Player)
	print("Player Joined")
	local PlayerID = PlayerService:GetUserIdFromNameAsync(Player.Name)
	local Success, Result = pcall(function()
		return PlayerClassDB:GetAsync(PlayerID)
	end)
	if not Success then
		warn("Data Was Not Loaded")
	end

	OnJoinTable[Result == nil or Result == "null"](Player, Result)
end

function Save(PlayerID)
	print("Data Saved")
	local PlayerClass = PlayerClasses[PlayerID]
	local Success, Error = pcall(function()
		local JsonStructure = Http:JSONEncode(PlayerClass)
		PlayerClassDB:SetAsync(PlayerID, JsonStructure)
	end)
end

function PlayerLeaves(Player)
	print("Player Left")
	local PlayerID = PlayerService:GetUserIdFromNameAsync(Player)
	Save(PlayerID, PlayerClasses[PlayerID])
end

PlayerService.PlayerAdded:Connect(PlayerJoined)
PlayerService.PlayerRemoving:Connect(PlayerLeaves)
game:BindToClose(function()
	print("Server Shutdown")
	ForLoops.PairsForLoop(Save, PlayerClasses)
end)
