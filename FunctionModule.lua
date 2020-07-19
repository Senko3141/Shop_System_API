local module = {}
local event = game:GetService("ReplicatedStorage").ShopEvent

function module:updateUI(shop, template, parent)
	
	for i,item in pairs(shop) do
		local clone = template:Clone()
		
		clone.Name = item['Name']
		
		clone.Cost.Text = item['Cost'].. ' Yen'
		clone.TextLabel.Text = item['Name']
		
		clone.Parent = parent
		
		clone.MouseButton1Click:Connect(function()
			if item['Buyable'] == false then warn'This item is just for show.' return end
			
			print('Player has requested to buy an item. ||| INFO:  Name-'.. clone.TextLabel.Text.. ' | Cost-'.. clone.Cost.Text)	
			
			event:InvokeServer('BuyItem', 
				{ 
					['ItemName'] = item['Name'] 
		
				}
				
			)
		end)
		
	end
	
end

function module:DestroyChildren(object)
	
	for _,v in pairs(object:GetChildren()) do
		if v:IsA('TextButton') then
			v:Destroy()
		end
	end
	
end

return module
