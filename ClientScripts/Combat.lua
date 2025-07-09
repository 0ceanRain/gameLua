
local equipped = false
local EquippedRemote = game:GetService("ReplicatedStorage").Remotes.EquippedRemote
local uis = game:GetService("UserInputService")



-- dash
local idleAnim = script.Parent:WaitForChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.HerosBlades.Idle)
local CurrentDash = 0
local doingAction = false
local cdQ = false
local dashCompleted
local DashRemote = game:GetService("ReplicatedStorage").Remotes.DashRemote


-- player
local player = game:GetService("Players").LocalPlayer
local character = player.Character

-- VFX
local VFXEvent = game.ReplicatedStorage.Remotes .VFXEvent


-- Attacks
local AttackRemote = game:GetService("ReplicatedStorage").Remotes.AttackRemotes.HerosSwordSwing
local AttackAnim = character:FindFirstChild("Humanoid"):LoadAnimation(game:GetService("ReplicatedStorage").Animations.Attacks.HerosBlades.Swing1)


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


local EquippedHeard = EquippedRemote.OnClientEvent:Connect(function( amount)
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

uis.InputBegan:Connect(function(Input, gpe)
	if gpe then return end
	if doingAction == true then return end
	
	
	if Input.KeyCode == Enum.KeyCode.Q and doingAction == false and cdQ == false then
		CurrentDash +=1
		doingAction = true
		if CurrentDash < 4 then
		
			doingAction = true
			print("pressed Q")
			VFXEvent:FireServer(1) 
			print(CurrentDash)
			dashCompleted = false
			DashRemote:FireServer(1)
			doingAction = false
			cdQ = true
			character.Humanoid.WalkSpeed = 52
			task.wait(0.3)
			dashCompleted = true
			DashRemote:FireServer(2)
			character.Humanoid.WalkSpeed = 16
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

uis.InputBegan:Connect(function(Input, gpe)
	if equipped == false or doingAction == true then return end
	if Input.UserInputType == Enum.UserInputType.MouseButton1 and doingAction == false then
		doingAction = true
		AttackAnim:Play()
		
		AttackRemote:FireServer()
		
		task.wait(0.85)
		
	end
end)
