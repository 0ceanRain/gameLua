
local equipped = false

local uis = game:GetService("UserInputService")

-- player
local player = game:GetService("Players").LocalPlayer
local character = player.Character
--local IsStunnedAttribute = character:GetAttribute("IsStunned")
local stunRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.stunnedRemote

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
local ParryRemoteFromClient = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.ParryRemoteFromClient

-- Block
local blockRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.BlockRemote



--local parryAnim = character:FindFirstChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.Parry.GotParried)
--local parrySuccessfullAnim = character:FindFirstChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.Parry.GotParried)
--local GotParriedAnim = character:FindFirstChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.Parry.GotParried)

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
local stunned
local hitStun = false
local parryStun = false

if hitStun then 
	stunned = true
elseif parryStun then
	stunned = true
else
	stunned = false
end

character:GetAttributeChangedSignal("IsStunned"):Connect(function()
	if character:GetAttribute("IsStunned") == true then
		hitStun = true
		if not parryStun then
			print("stunned set to true")
			task.delay(0.5, function()
				print("reset  hit stun")
				stunRemote:FireServer(2)
			end)
		else
			task.delay(0.3, function()
				print("reset parry stun")
				stunRemote:FireServer(2)
			end)
		
		end
		
	end
	if character:GetAttribute("IsStunned") == false then 
		hitStun = false
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
	if doingAction or stunned then return end
	
	
	if Input.KeyCode == Enum.KeyCode.Q and not doingAction and not cdQ then
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
	if not equipped or doingAction or stunned or AttackCD then return end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 and not doingAction and not AttackCD then
		CurrentAttack +=1
		
		if CurrentAttack == 1 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			task.delay(0.5, function()
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
			
			task.delay(0.5, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.8)
			character:SetAttribute("IsSwinging", false)
			AttackCD = false
			doingAction = false
		elseif CurrentAttack == 3 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			task.delay(0.5, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.8)
			character:SetAttribute("IsSwinging", false)
			AttackCD = false
			doingAction = false
		elseif CurrentAttack == 4 then
			AttackCD = true
			doingAction = true
			AttackAnim:Play()
			character:SetAttribute("IsSwinging", true)
			
			task.delay(0.5, function()
				AttackRemote:FireServer()
			end)

			task.wait(0.8)
			character:SetAttribute("IsSwinging", false)
		
			doingAction = false
			finshedSwing = true
			print('final swing')
		end
		
			if finshedSwing == true then
		
				task.delay(1, function()
					CurrentAttack = 0
					finshedSwing = false
					AttackCD = false
				end)
				
			end		
	end
end)
--local module = game.ReplicatedStorage.Modules.WeaponScripts.HerosBlade.HerosBladeModule

--require(module)
local parryDone = false
local parrySuccessful = false
local parryCD = false
local blocking = false
local Parry = uis.InputBegan:Connect(function(Input, gpe)
	if doingAction or stunned then return end
	
	if Input.KeyCode == Enum.KeyCode.F and not doingAction and not parryCD then
		if uis:IsKeyDown(Input.KeyCode) then
			doingAction = true
		end
		parryDone = false
		parryCD = true
		doingAction = true
		--ParryAnim:Play()
		ParryRemoteFromClient:FireServer(1) -- sets true
		local ParryWait = task.delay(0.75, function()
			ParryRemoteFromClient:FireServer(2) -- sets false
			-- something missing here?
			parryCD = true
			parryDone = true
			task.delay(1.5, function()
				parryCD = false
			end)
			
		end)
		local blockWait = task.delay(0.1, function()
			if uis:IsKeyDown(Input.KeyCode) and parryDone then
				blocking = true
				blockRemote:FireServer(1) -- sets true
			end
		end)	
		if parrySuccessful then
			task.cancel(ParryWait)
		end
	elseif parryCD and Input.KeyCode == Enum.KeyCode.F then -- can block when parry is on cd
		blocking = true
		blockRemote:FireServer(1)
	end

	uis.InputEnded:Connect(function(Input, gpe)
		if Input.KeyCode == Enum.KeyCode.F and parryDone and blocking then
			
			doingAction = false
			blocking = false
			blockRemote:FireServer(2) -- sets false
		end
	end)
	
	
end)


ParryRemote.OnClientEvent:Connect(function(amount)
	if 1 then
		doingAction = false
		parryCD = false
		print("parry")
		parrySuccessful = true
		parryDone = true
		ParryRemoteFromClient:FireServer(3)
		--character:SetAttribute("IsParrying", false)
		--parrySuccessfullAnim:Play()
		task.delay(0.1, function()
			
			parrySuccessful = false
		end)
	end
	if 2 then
		parryStun = true
		--GotParriedAnim:Play()
	end
	
	
	
	
end)



