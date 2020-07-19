local api  = require(game:GetService("ReplicatedStorage"):WaitForChild("Shop"))
local functions = require(script.Parent.Functions)

local shopOwners = workspace:WaitForChild("ShopOwners")
local event = game:GetService("ReplicatedStorage").ShopEvent

local shop = api:GetNormalShop()

if shop == 'Error' then warn'error has occurred for the shop api' return end

local open = false
local debounce = false

local config = {
	Cooldown = 2,
};

local Clicked;

--[[

*Module:GetNormalShop()* returns an array. Therefore use a for loop to get the name of the items etc like shown below.

for i,v in pairs(shop) do
	print('Name of item: '.. v['Name'].. ' ||| Cost: '.. v['Cost'].. ' ||| Buyable: '.. tostring(v['Buyable']))
end

--


]]


event.OnClientInvoke = function(action, tbl)
	if action == 'BoughtItem' then
		local ItemName = tbl['ItemName']
		
		local Clone = script:WaitForChild("TextLabel"):Clone()
		Clone.Parent = script.Parent.Parent.Effects
		
		Clone.Text = 'SUCCESSFULLY BOUGHT ITEM: '.. ItemName
		
		for i = 1,0,-0.1 do
			Clone.TextStrokeTransparency = i
			Clone.TextTransparency = i
			wait()
		end
		
		coroutine.wrap(function()
			wait(1)
			
			for i = 0,1,0.1 do
				Clone.TextStrokeTransparency = i
				Clone.TextTransparency = i
				wait()
			end
			Clone:Destroy()
			
		end)()
		
	end
	
end

for _,owners in pairs(shopOwners:GetChildren()) do
	if not owners.HumanoidRootPart:FindFirstChild('ShopClick') then warn'No shop click.' return end
	
	owners.HumanoidRootPart.ShopClick.MouseClick:Connect(function(plr)
		if debounce then return end
		
		if open == false then
			owners.HumanoidRootPart.ShopClick.MaxActivationDistance = 0
			
			Clicked = owners.HumanoidRootPart.ShopClick
		
			script.Parent.Frame.Visible = true
			open = true
			
			coroutine.wrap(function()
				debounce = true
				wait(config.Cooldown)
				debounce = false
			end)()
			
			for i = 1,0,-0.1 do
				script.Parent.Frame.BackgroundTransparency = i
				wait()
			end
			functions:updateUI(shop, script:WaitForChild("Frame"), script.Parent.Frame)
			script.Parent.TextButton.Visible = true
			
			
		end		
		
	end)
	
end

script.Parent.TextButton.MouseButton1Click:Connect(function()
	if open == true then
			coroutine.wrap(function()
				debounce = true
				wait(config.Cooldown)
				debounce = false
			end)()
			
			functions:DestroyChildren(script.Parent.Frame)
			for i = 0,1,0.1 do
				script.Parent.Frame.BackgroundTransparency = i
				wait()
			end
		open = false
		script.Parent.TextButton.Visible = false
		Clicked.MaxActivationDistance = 32
		
		Clicked = nil
			
		end
end)