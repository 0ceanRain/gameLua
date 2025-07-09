local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VFXEvent = ReplicatedStorage.Remotes.VFXEvent
local VFXReplicateEvent = ReplicatedStorage.Remotes.VFXReplicateEvent
--local ParryVFX = ReplicatedStorage:FindFirstChild("ParryVFXEvent")
local function ensureVFXPart(character, vfxTemplate)
	local existingVFX = character:FindFirstChild("VFXPart")
	if existingVFX then return existingVFX end
	local vfx = vfxTemplate:Clone()
	vfx.Name = "VFXPart"
	vfx.Parent = character

	local hrp = character:WaitForChild("HumanoidRootPart")
	local weld = Instance.new("Weld")
	weld.Part0 = hrp
	weld.Part1 = vfx
	weld.Parent = vfx




	return vfx
end

VFXEvent.OnServerEvent:Connect(function(player, amount)
	local character = player.Character


	local vfxTemplate = ReplicatedStorage.VFX.VFXPart
	local vfxPart = ensureVFXPart(character, vfxTemplate)


	VFXReplicateEvent:FireAllClients(player, amount)
	
end)

--VFXEvent.OnServerEvent:Connect(function(player, amount)
--	local character = player.Character
--	if not character then return end

--	local vfxTemplate = ReplicatedStorage:WaitForChild("VFX")
--	local vfxPart = ensureVFXPart(character, vfxTemplate)


--	for _, attachment in ipairs(vfxPart:GetDescendants()) do
--		if attachment:IsA("Attachment") then
--			for _, emitter in ipairs(attachment:GetChildren()) do
--				if emitter:IsA("ParticleEmitter") then
--					emitter:Clear()
--				end
--			end
--		end
--	end

--	VFXReplicateEvent:FireAllClients(player, amount)
--	task.wait(2)
--	vfxPart:Destroy()
--end)


