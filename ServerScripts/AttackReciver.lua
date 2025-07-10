local attackRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.HerosSwordSwing
local debris = game:GetService("Debris")
local StaterSwordHitbox = game:GetService("ReplicatedStorage").Hitboxes.MediumHitboxs.StarterSwordHitbox
local ParryRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.ParryRemote
local players = game:GetService("Players")
local trail = game:GetService("ReplicatedStorage").VFX:FindFirstChild("HerosSwordTrail")
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
			--if victimPlayer and stunned[victimPlayer] and tick() < stunned[victimPlayer] then
			--	box:Destroy()
			--	return
			--end
			
			
			if victimHum:GetAttribute("IsParrying") == true then
				ParryRemote:FireClient(victimPlayer)
				print("server checked parry")
				return
			elseif victimHum:GetAttribute("IsDashing") == true then
				print("hi")
				return
			elseif victimHum:GetAttribute("IsBlocking") == true then
				print("hello")
				return
			else
				victimHum:TakeDamage(10)
				
				victim:SetAttribute("IsStunned", true)
				
			end
			
			

		end)

		debris:AddItem(box, 0.3)
	
	
end)