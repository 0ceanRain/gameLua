local attackRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.HerosSwordSwing
local debris = game:GetService("Debris")
local StaterSwordHitbox = game:GetService("ReplicatedStorage").Hitboxes.MediumHitboxs.StarterSwordHitbox
local ParryRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.ParryRemote
local players = game:GetService("Players")
local trail = game:GetService("ReplicatedStorage").VFX:FindFirstChild("HerosSwordTrail")
local isPlayer
local isNpc
local ParryRemoteFromClient = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.ParryRemoteFromClient
local blockRemote = game:GetService('ReplicatedStorage').Remotes.DefenseRemotes.BlockRemote
attackRemote.OnServerEvent:Connect(function(player)
	
	local char = player.Character
	if not char then return end
	
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local box = StaterSwordHitbox:Clone()
	box.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
	box.Parent = workspace
	Instance.new("WeldConstraint", box).Part0 = hrp
	box.WeldConstraint.Part1 = box
			
	
	local hitOnce = {}
	box.Touched:Connect(function(hitPart)
		local victim = hitPart:FindFirstAncestorOfClass("Model")
		if not victim or victim == char or hitOnce[victim] then return end
		hitOnce[victim] = true

		local victimHum = victim:FindFirstChildOfClass("Humanoid")
		if not victimHum then return end
		--local hitAnimTrack = victimHum:LoadAnimation(HitAnim)

		--game.Debris:AddItem(hitAnimTrack, 0.2)




		local victimPlayer = players:GetPlayerFromCharacter(victim)
			
		if not victimPlayer then
			print("npc")
			isNpc = true
			isPlayer = false
		else
			isPlayer = true
			print("player")
		end
		
		--if victimPlayer and stunned[victimPlayer] and tick() < stunned[victimPlayer] then
		--	box:Destroy()
		--	return
		--end
			
		if isPlayer == true then
			if victim:GetAttribute("IsParrying") == true then
				ParryRemote:FireClient(victimPlayer, 1)
				ParryRemote:FireClient(player, 2)
				print("server checked parry")
					
			elseif victim:GetAttribute("IsDashing") == true then
				print("dodged")
				
			elseif victim:GetAttribute("IsBlocking") == true then
				print("blocked")
				
			else
				victimHum:TakeDamage(10)
				
				victim:SetAttribute("IsStunned", true)
				
			end
			
		end
			
			

		
		
	end)

	debris:AddItem(box, 0.3)
	
	
end)

ParryRemoteFromClient.OnServerEvent:Connect(function(player, amount)
	local character = player.Character
	if amount == 1 then
		character:SetAttribute("IsParrying", true)
		
	elseif amount == 2 then
		character:SetAttribute("IsParrying", false)
	elseif amount == 3 then
		character:SetAttribute("IsParrying", false)
	end
	
end)

blockRemote.OnServerEvent:Connect(function(player, amount)
	if amount == 1 then
		player.Character:SetAttribute("IsBlocking", true)
	elseif amount == 2 then
		player.Character:SetAttribute("IsBlocking", false)
	end
end)
