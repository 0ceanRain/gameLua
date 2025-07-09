
local vfxReplicate = game.ReplicatedStorage.Remotes.VFXReplicateEvent
local player = game:GetService("Players").LocalPlayer
local attach

vfxReplicate.OnClientEvent:Connect(function(player, amount)
	local vfxPart = player.Character:FindFirstChild("VFXPart")
	
	if amount == 1 then
		attach = amount == 1 and vfxPart:FindFirstChild("Dash")
	end 
	print(attach)
	if amount == 1 then
		for _, p in ipairs(attach:GetDescendants()) do
			if p:IsA("ParticleEmitter") then
				p:Emit(p:GetAttribute("EmitCount"))
			end
		end
	end
	if amount == 2 then
		
	end
end)
