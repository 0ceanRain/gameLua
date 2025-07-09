local weld = Instance.new("Motor6D")
local EquippedRemote = game:GetService("ReplicatedStorage").Remotes.EquippedRemote
local CollectionService = game:GetService("CollectionService")
local weld = Instance.new("Motor6D")
local Equip = EquippedRemote.OnServerEvent:Connect(function(player, amount)
	
	if player.Character:FindFirstChildOfClass("Tool") and amount == 1 then
		player.Character:FindFirstChildOfClass("Tool").Equipped:Connect(function()
			local Character = player.Character
			
			local Tool = Character:FindFirstChildOfClass("Tool")
			local Class = Tool:GetTags()
			
			
			weld.Part0 = Character:FindFirstChild("Right Arm")
			weld.Part1 = Tool.Handle
			weld.Parent = Tool.Handle
			
			--weld.C0 = CFrame.new(0,0,0)
			--weld.C1 = Tool:GetAttribute("C1")
			--Tool:SetAttribute("Equipped", true)
			--Tool.Parent = Character
			print("player equipped tool from server")
			EquippedRemote:FireClient(player)
		end)
		player.Character:FindFirstChildOfClass("Tool").Unequipped:Connect(function()
		
		end)
	end
	if amount == 2 then
		EquippedRemote:FireClient(player, 3)
		
	end
	

end)

--Equip:Disconnect()