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
local MagicRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.Magic.UseAbility
local box
local TeleportAbility = require(game.ReplicatedStorage.Abilities.MediumMagic.TeleportAbility)
attackRemote.OnServerEvent:Connect(function(player, amount)
	local player = player
	local char = player.Character

	
	local hrp = char:FindFirstChild("HumanoidRootPart")

	if amount == 2 then
		box = game.ReplicatedStorage.Hitboxes.AbilityHitbox.Medium.DashnSlashHitbox:Clone()
	else
		box = StaterSwordHitbox:Clone()
	end
	box.Anchored = false
	box.Massless = true
	if amount == 2 then
		box.CFrame = hrp.CFrame
	else
		box.CFrame = hrp.CFrame * CFrame.new(0,0,-5)
	end
	
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
		if isNpc then
			if victim:GetAttribute("IsParrying") == true then
				ParryRemote:FireClient(player, 2)
			end
		end
			
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
				if amount == 2 then
					victimHum:TakeDamage(20)
				else
					victimHum:TakeDamage(10)
				end
				
				
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

--local abilites = {}
--local mediumMagic = game.ReplicatedStorage.Abilities.MediumMagic
--for _, x in pairs(mediumMagic:GetChildren()) do
--	abilites[x] = require(script.Parent.x)
--end
--MagicRemote.OnServerEvent:Connect(function(player, amount)
	
--end)

-- Add this to your MainInputsReceiver.lua file

--local GrabRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.GrabRemote
--local GrabHitbox = game:GetService("ReplicatedStorage").Hitboxes.MediumHitboxs.StarterSwordHitbox -- Using same hitbox as sword
--local GrabDuration = 1.0
--local GrabDamage = 15

---- Add this remote event handler to your MainInputsReceiver.lua
--GrabRemote.OnServerEvent:Connect(function(player, action)
--	if action == "attempt" then
--		local char = player.Character
--		if not char then return end

--		local hrp = char:FindFirstChild("HumanoidRootPart")
--		if not hrp then return end

--		-- Create hitbox for grab
--		local box = GrabHitbox:Clone()
--		box.Massless = true
--		box.CFrame = hrp.CFrame * CFrame.new(0, 0, -2) -- Slightly closer than sword
--		box.Parent = workspace

--		local weld = Instance.new("WeldConstraint", box)
--		weld.Part0 = hrp
--		weld.Part1 = box

--		local hitOnce = {}
--		local grabConnected = false

--		box.Touched:Connect(function(hitPart)
--			if grabConnected then return end -- Only allow one grab per attempt

--			local victim = hitPart:FindFirstAncestorOfClass("Model")
--			if not victim or victim == char or hitOnce[victim] then return end
--			hitOnce[victim] = true

--			local victimHum = victim:FindFirstChildOfClass("Humanoid")
--			if not victimHum then return end

--			local victimPlayer = players:GetPlayerFromCharacter(victim)
--			if not victimPlayer then return end -- Only grab players, not NPCs

--			-- Check if victim can be grabbed
--			if victim:GetAttribute("IsParrying") then
--				print("Grab blocked by parry")
--				ParryRemote:FireClient(player, 1)
--				ParryRemote:FireClient(victimPlayer, 2)
--				return
--			elseif victim:GetAttribute("IsDashing") then
--				print("Grab blocked by dash")
--				return
--			elseif victim:GetAttribute("IsBlocking") then
--				print("Grab bypassed block")
--				-- Continue with grab - blocks don't stop grabs
--			end

--			-- Successful grab
--			grabConnected = true

--			-- Immobilize both players
--			char:SetAttribute("doingAction", true)
--			victim:SetAttribute("IsStunned", true)

--			-- Reduce movement speed during grab
--			local grabberHum = char:FindFirstChildOfClass("Humanoid")
		

--			char:FindFirstChild("HumanoidRootPart").Anchored = true
--			victim:FindFirstChild("HumanoidRootPart").Anchored = true

--			-- Load and play animations
--			local grabberAnim = grabberHum:LoadAnimation(game.ReplicatedStorage.Animations.HerosBlades.Grab.Grabber)
--			local grabbedAnim = victimHum:LoadAnimation(game.ReplicatedStorage.Animations.HerosBlades.Grab.Grabbed)

--			grabberAnim:Play()
--			grabbedAnim:Play()

--			-- Deal damage over time during grab
--			local damageInterval = 0.2
--			local damagePerTick = GrabDamage / (GrabDuration / damageInterval)

--			local damageConnection
--			damageConnection = game:GetService("RunService").Heartbeat:Connect(function()
--				if victim and victimHum then
--					victimHum:TakeDamage(damagePerTick)
--				end
--			end)

--			-- Clean up after grab duration
--			task.delay(GrabDuration, function()
--				-- Stop damage
--				if damageConnection then
--					damageConnection:Disconnect()
--				end

--				-- Stop animations
--				grabberAnim:Stop()
--				grabbedAnim:Stop()

--				-- Restore movement
--				if grabberHum then
--					char:FindFirstChild("HumanoidRootPart").Anchored = true
					
--				end
--				if victimHum then
--					victim:FindFirstChild("HumanoidRootPart").Anchored = true
--				end

--				-- Remove stun
--				char:SetAttribute("doingAction", false)
--				victim:SetAttribute("IsStunned", false)

--				print("Grab completed")
--			end)

--			print("Grab successful: " .. player.Name .. " grabbed " .. victimPlayer.Name)
--		end)

--		-- Clean up hitbox
--		debris:AddItem(box, 0.3)
--	end
--end)


local TeleportRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.Magic.teleportRemote
local TeleportHitbox = game:GetService("ReplicatedStorage").Hitboxes.AbilityHitbox.Medium.TeleportHitbox
local TeleportDamage = 20


TeleportRemote.OnServerEvent:Connect(function(player, action, targetPlayer)
	if action == "teleport" then
		local char = player.Character
		

		local hrp = char:FindFirstChild("HumanoidRootPart")
	

		
		if not targetPlayer or not targetPlayer.Character then 
			print("Invalid target for teleport")
			return 
		end

		local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not targetHRP then 
			print("Target has no HumanoidRootPart")
			return 
		end

		
		local targetCFrame = targetHRP.CFrame
		local teleportPosition = targetCFrame.Position + (targetCFrame.LookVector * -3)


		hrp.CFrame = CFrame.lookAt(teleportPosition, targetHRP.Position)

		
		local box = TeleportHitbox:Clone()
		box.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
		box.Parent = workspace

		local weld = Instance.new("WeldConstraint", box)
		weld.Part0 = hrp
		weld.Part1 = box

		local hitOnce = {}

		box.Touched:Connect(function(hitPart)
			local victim = hitPart:FindFirstAncestorOfClass("Model")
			if not victim or victim == char or hitOnce[victim] then return end
			hitOnce[victim] = true

			local victimHum = victim:FindFirstChildOfClass("Humanoid")
	

			local victimPlayer = players:GetPlayerFromCharacter(victim)

		
			if not victimPlayer then
				print("Teleport hit NPC")
				victimHum:TakeDamage(TeleportDamage)
			end

			
			if victim:GetAttribute("IsParrying") then
				print("Teleport attack parried")
				ParryRemote:FireClient(victimPlayer, 1)
				ParryRemote:FireClient(player, 2)
				

			elseif victim:GetAttribute("IsDashing") then
				print("Teleport attack dodged")
				

			else
			
				victimHum:TakeDamage(TeleportDamage)
				victim:SetAttribute("IsStunned", true)
				TeleportAbility:OnTeleportSuccess(player, targetPlayer)
			
			end
		end)

	
		debris:AddItem(box, 0.3)

		
		
		


	end
end)
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
