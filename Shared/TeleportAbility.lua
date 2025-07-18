

local TeleportAbility = {}
TeleportAbility.Name = "TeleportAbility"
TeleportAbility.Cooldown = 3
TeleportAbility.WindUpDuration = 0.42
TeleportAbility.MaxRange = 10000
TeleportAbility.Animations = { 
	Teleport = "Animations.HerosBlades.Teleport.TeleportAnim" 
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CombatStateModule = require(ReplicatedStorage.Modules.CombatStateModule)
local RunService = game:GetService("RunService")

TeleportAbility._cooldowns = {}
local script = script
local doingAction = game:GetService("ReplicatedStorage").Remotes.DoingAction


local teleportAnim = game.ReplicatedStorage.Animations.abilities.medium.TeleportWindup

local VFXEvent = game.ReplicatedStorage.Remotes.VFXEvent
local teleportRemote = game.ReplicatedStorage.Remotes.AttackRemotes.Magic.teleportRemote
local CanActivate = true


local function findNearestEnemyToCursor(player)
	local camera = workspace.CurrentCamera
	local mouse = player:GetMouse()
	local playerChar = player.Character
	if not playerChar then return nil end

	local playerHRP = playerChar:FindFirstChild("HumanoidRootPart")
	if not playerHRP then return nil end


	local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
	local rayDirection = ray.Direction * 1000

	local nearestEnemy = nil
	local shortestDistance = math.huge

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			if otherHRP then
				
				local distanceToPlayer = (playerHRP.Position - otherHRP.Position).Magnitude
				if distanceToPlayer <= TeleportAbility.MaxRange then
				
					local enemyPos = otherHRP.Position
					local rayOrigin = ray.Origin

					local toEnemy = enemyPos - rayOrigin
					local projectionLength = toEnemy:Dot(ray.Direction.Unit)
					local projectedPoint = rayOrigin + ray.Direction.Unit * projectionLength

					
					local distanceToRay = (enemyPos - projectedPoint).Magnitude

				
					local totalDistance = distanceToRay + (distanceToPlayer * 0.1)

					if totalDistance < shortestDistance then
						shortestDistance = totalDistance
						nearestEnemy = otherPlayer
					end
				end
			end
		end
	end

	return nearestEnemy
end

function TeleportAbility:CanActivate(player)
	if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) then 
		return false 
	else
		return true
	end
end

function TeleportAbility:Activate(player)
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	--self._cooldowns[player] = tick()
	CanActivate = false

	
	doingAction:FireServer(1)


	local targetPlayer = findNearestEnemyToCursor(player)


	local originalSpeed = hum.WalkSpeed
	hum.WalkSpeed = originalSpeed * 0.3 


	local animTrack = hum:LoadAnimation(teleportAnim)
	animTrack:Play()


	VFXEvent:FireServer(3)

	
	task.delay(self.WindUpDuration, function()
		
		hum.WalkSpeed = originalSpeed

		
		--animTrack:Stop()

		if targetPlayer and targetPlayer.Character then
			
			local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if targetHRP then
				
				teleportRemote:FireServer("teleport", targetPlayer)

				
				VFXEvent:FireServer(2)

				print("Teleporting to: " .. targetPlayer.Name)
			else
				
				print("Target lost during wind-up")
				doingAction:FireServer(2)
			end
		else
			
			print("No valid target found for teleport")
			doingAction:FireServer(2)
		end
	end)

	CanActivate = true
	task.delay(3, function()
		print("cool down off")
		CanActivate = true
	end)
end


function TeleportAbility:OnTeleportSuccess(player, targetPlayer)
	local character = player.Character
	if not character then return end

	CanActivate = true
	print("landed ability cooldown off")
	task.delay(0.1, function()
		doingAction:FireServer(2)
	end)
	

end

return TeleportAbility
