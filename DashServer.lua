local dashRemote = game.ReplicatedStorage.Remotes.DashRemote

dashRemote.OnServerEvent:Connect(function(player, amount)
	local character = player.Character
	if amount == 1 then
		dashRemote:FireClient(player)
		for i,v in pairs(character:GetDescendants()) do 
			if v:IsA("BasePart") or v:IsA("Decal") and not v:HasTag("VFX") then 
				v.Transparency = 1

			end
		end
	end	
	if amount == 2 then
		for i,v in pairs(character:GetDescendants()) do 
			if v:IsA("BasePart") or v:IsA("Decal") and not v:HasTag("VFX") then 
				v.Transparency = 0
				if  v.Name == "HumanoidRootPart" then
					v.Transparency = 1
				end
			end
		end
	end
end)