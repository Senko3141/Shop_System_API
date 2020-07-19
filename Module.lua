-- ShopAPI.lua
-- Sylvern

local Module = {}
local Event = game:GetService("ReplicatedStorage").ShopEvent

local Cooldowns = {};

local Configuration = {
	DailyShop = false,
};

function Module:GetNormalShop()
	local Shop = script:WaitForChild("NormalShop"):GetChildren()
	if #Shop < 1 then warn"You must have at least 1+ items in the shop folder for you to be able to fetch the shop." return 'Error' end
	
	local SortedItems = {};
	
	for i,v in pairs(Shop) do
		print(i,v, v.Name)
		
		SortedItems[v.Name] = {
			Cost = v['Cost'].Value, -- Number
			Name = v['ItemName'].Value,
			Buyable = v['Buyable'].Value, -- If you just want the item for show or not.
		};
	end
	
	return SortedItems -- Array.
end

function Module:GetDailyShop()
	if Configuration.DailyShop == false then warn'Did you forget to enable the daily shop in the Configuration? Please remember to enable that before accessing the DailyShop.' return end
	
	-- WIP.
end

function Module:BuyItem(plr, itemName)
	local Items = script:WaitForChild("Items")
	local getItem = Items:WaitForChild(itemName)
	
	if not getItem then warn'ERROR: COULD NOT GET ITEM' return end
	
	local function giveItem(backpack, item)
		local Tools = game:GetService("ReplicatedStorage").Tools
		local Clone = Tools[item]:Clone()
		Clone.Parent = backpack
	end
	
	local Cost = getItem.Cost.Value
	local YenAmount = plr:WaitForChild('Yen').Value
	
	if YenAmount < Cost then warn'Not enough.' return false end
	
	if Cooldowns[plr.Name] then
		warn('Please wait a bit before buying an item again.')
		return false
	end
	
	if YenAmount >= Cost then		
		
		coroutine.wrap(function()
			Cooldowns[plr.Name] = true -- Cooldowns and stuff.
			wait(2)
			Cooldowns[plr.Name] = nil
		end)()
		
		
		plr.Yen.Value = plr.Yen.Value - getItem.Cost.Value
		
		giveItem(plr.Backpack, itemName)
		
		Event:InvokeClient(plr, 'BoughtItem', 
			{
				['ItemName'] = itemName
			}
		 )
	
		warn('Successfully bought item ||| INFO: '.. itemName)
		return true
	end
	
end



return Module