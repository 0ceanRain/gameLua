
local equipped = false

local uis = game:GetService("UserInputService")

-- player
local player = game:GetService("Players").LocalPlayer
local character = player.Character
--local IsStunnedAttribute = character:GetAttribute("IsStunned")

-- dash
local idleAnim = script.Parent:WaitForChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.HerosBlades.Idle)
local CurrentDash = 0
local doingAction = false
local cdQ = false
local dashCompleted
local DashRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.DashRemote
local IsDashingAttribute = character:GetAttribute("IsDashing")


-- VFX
local VFXEvent = game.ReplicatedStorage.Remotes .VFXEvent


-- Attacks
local AttackRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.HerosSwordSwing
local AttackAnim = character:FindFirstChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.HerosBlades.Attacks.Swing1)
local AttackCD = false
local IsSwingingAttribute = character:GetAttribute("IsSwinging")
local EquippedRemote = game:GetService("ReplicatedStorage").Remotes.EquippedRemote


-- parry
local ParryRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.ParryRemote
local IsParryingAttribute = character:GetAttribute("IsParrying")

--if player.Backpack:FindFirstChild("Tool") then
--	print("in players backpack")
--	equipped = false
--end



--if player.Character:FindFirstChildOfClass("Tool") and equipped == false then
--	print("equipped")
--	equipped = true
--	--local Name = player.Character:FindFirstChildOfClass("Tool").Name
--	EquippedRemote:FireServer()
	
--	--if equipped == true and not player.Character:FindFirstChildWhichIsA("Tool") then
--	--	print("unequipped")
--	--	equipped = false
--	--	EquippedRemote:FireServer("unequipped")
--	--end
	
--end


--if player.Character:FindFirstChildOfClass("Tool") then
--	print("equipped")
--end

local stunned = false

character:GetAttributeChangedSignal("IsStunned"):Connect(function()
	if character:GetAttribute("IsStunned") == true then
		stunned = true
		print("stunned set to true")
		task.delay(0.5, function()
			print("reset stun")
			character:SetAttribute("IsStunned", false)
		end)
	end
	if character:GetAttribute("IsStunned") == false then 
		stunned = false
		print("Stunned set to false")
	end
		
end)



--if stunned == true then
--	task.delay(0.5, function()
--		print("reset stun")
--		character:SetAttribute("IsStunned", false)
--	end)
--end

local EquippedHeard = EquippedRemote.OnClientEvent:Connect(function(amount)
	if amount ~= 3 then
		idleAnim:Play()
		equipped = true
		print("clientevent here")
		--print(Class)
	end
	
	if amount == 3 then
		
		idleAnim:Stop()
		equipped = false
		print(amount) 
	end
end)
--if equipped == false then
--	EquippedHeard:Disconnect()
--end

local Dash = uis.InputBegan:Connect(function(Input, gpe)
	if gpe then return end
	if doingAction == true or stunned == true then return end
	
	
	if Input.KeyCode == Enum.KeyCode.Q and doingAction == false and cdQ == false then
		CurrentDash +=1
		
		if CurrentDash < 4 then
			
			doingAction = true
			character:SetAttribute("IsDashing", true)
			VFXEvent:FireServer(1) 
			dashCompleted = false
			DashRemote:FireServer(1)
			cdQ = true
			character.Humanoid.WalkSpeed = 52
			task.wait(0.3)
			
			
			dashCompleted = true
			DashRemote:FireServer(2)
			character.Humanoid.WalkSpeed = 16
			character:SetAttribute("IsDashing", false)
			wait(0.05)
			doingAction = false
			cdQ = false
			
		end	
		if CurrentDash == 3 then
			cdQ = true
			print("maxDashes")
			task.wait(2)
			cdQ = false
			CurrentDash = 0
		end
	end

	if equipped == false then return end
	

	
end)
local CurrentAttack = 0

	
local finshedSwing = false
local Swings = uis.InputBegan:Connect(function(Input, gpe)
	if equipped == false or doingAction == true or stunned == true or AttackCD == true then return end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 and doingAction == false and AttackCD == false then
		CurrentAttack +=1
		
		if CurrentAttack == 1 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			task.delay(0.7, function()
				AttackRemote:FireServer()
			end)
				
			
			character:SetAttribute("IsSwinging", false)
			AttackCD = false
			doingAction = false
		
		elseif CurrentAttack == 2 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			
			task.delay(0.7, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.85)
			character:SetAttribute("IsSwinging", false)
			AttackCD = false
			doingAction = false
		elseif CurrentAttack == 3 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			task.delay(0.7, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.85)
			character:SetAttribute("IsSwinging", false)
			AttackCD = false
			doingAction = false
		elseif CurrentAttack == 4 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			
			task.delay(0.7, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.85)
			character:SetAttribute("IsSwinging", false)
		
			doingAction = false
			finshedSwing = true
			print('final swing')
		end
		
			if finshedSwing == true then
		
				task.delay(1.2, function()
					CurrentAttack = 0
					finshedSwing = false
					AttackCD = false
				end)
				
			end		
	end
end)
--local module = game.ReplicatedStorage.Modules.WeaponScripts.HerosBlade.HerosBladeModule

--require(module)
local parrySuccessful = false
local parryCD = false
local Parry = uis.InputBegan:Connect(function(Input, gpe)
	if doingAction == true or stunned == true or parryCD == true then return end
	
	if Input.KeyCode == Enum.KeyCode.F and doingAction == false then
		parryCD = true
		doingAction = true
		print("parry")
		character:SetAttribute("IsParrying", true)
		--ParryAnim:Play()
		ParryRemote:FireServer()
		local ParryWait = task.delay(1.25, function()
			character:SetAttribute("IsParrying", false)
			parryCD = false
			doingAction = false
		end)
			
			if parrySuccessful == true then
				task.cancel(ParryWait)
			end
	end
end)


ParryRemote.OnClientEvent:Connect(function()
	doingAction = false
	parryCD = false
	print("parry")
	parrySuccessful = true
	character:SetAttribute("IsParrying", false)
	--ParryAnim:Play()
	
end)
