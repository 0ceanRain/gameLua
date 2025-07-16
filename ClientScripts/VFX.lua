
local vfxReplicate = game.ReplicatedStorage.Remotes.VFXReplicateEvent
local player = game:GetService("Players").LocalPlayer
local attach

vfxReplicate.OnClientEvent:Connect(function(player, amount)
	local vfxPart = player.Character:FindFirstChild("VFXPart")
	
	if amount == 1 then
		attach = amount == 1 and vfxPart:FindFirstChild("Dash")
	else if amount == 2 then
			attach = amount == 2 and vfxPart:FindFirstChild("Slash")
		end
	end 
	print(attach)
	if amount then
		for _, p in ipairs(attach:GetDescendants()) do
			if p:IsA("ParticleEmitter") then
				p:Emit(p:GetAttribute("EmitCount"))
			end
		end
	end
	
end)
