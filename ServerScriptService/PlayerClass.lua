local PlayerClass = {}
PlayerClass.__index = PlayerClass

function PlayerClass.new(Player, self)
	repeat task.wait() until Player.Character ~= nil
	if self then return setmetatable(self, PlayerClass) end
	local self = setmetatable({}, PlayerClass)
	self.Name = Player.Name
	self.Character = Player.Character
	self.Cash = 0
	self.Multiplier = 0
	self.Level = 1
	self.Rebirth = 0
	return self
end

function PlayerClass:SetCharacter(Character)
	self.Character = Character
end

function PlayerClass:SetName(Name)
	self.Character = Name
end

function PlayerClass:TeleportPlayer(NewCFrame)
	self.Character.HumanoidRootPart.CFrame = NewCFrame
end

function PlayerClass:AddCash(value)
	self.Cash += value
end

return PlayerClass
