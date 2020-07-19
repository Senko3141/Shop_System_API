local players = game:GetService("Players")
local event = game:GetService("ReplicatedStorage").ShopEvent

local module = require(game:GetService("ReplicatedStorage").Shop)

players.PlayerAdded:Connect(function(plr)
	local Yen = Instance.new("NumberValue", plr)
	Yen.Name = 'Yen'
	Yen.Value = 1000
end)

event.OnServerInvoke = function(plr, action, tbl)
	if action == 'BuyItem' then
		local ItemName = tbl['ItemName']
		
		module:BuyItem(plr, ItemName)
	end
	
end