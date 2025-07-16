-- ReplicatedStorage.Abilities.MediumMagic.DashnSlash
-- Handles client-side dash VFX, animation, and cooldown tracking

local DashnSlash = {}
DashnSlash.Name = "DashnSlash"
DashnSlash.Cooldown = 3
DashnSlash.Animations = { Slash = "Animations.HerosBlades.Attacks.Swing1" }

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CombatStateModule = require(ReplicatedStorage.Modules.CombatStateModule)
local debris = game:GetService("Debris")

DashnSlash._cooldowns = {}
local script = script
local doingAction = game:GetService("ReplicatedStorage").Remotes.DoingAction

local slashAnim = game.ReplicatedStorage.Animations.abilities.medium.slash

local VFXEvent = game.ReplicatedStorage.Remotes.VFXEvent
local dashRemote = game.ReplicatedStorage.Remotes.DefenseRemotes.DashRemote
local CanActivate = true
local function slash()
	local character = game.Players.LocalPlayer.Character
	local hum = character:FindFirstChildOfClass("Humanoid")

	hum:LoadAnimation(slashAnim):Play()
	Remotes.AttackRemotes.Magic.UseAbility:FireServer(script.Name)
	doingAction:FireServer(2)
	dashRemote:FireServer(2)
	
	task.delay(0.15, function()
		VFXEvent:FireServer(2)
	end)
	
end
local function startDash(duration, speed)
	local character = game.Players.LocalPlayer.Character
	local RunService = game:GetService("RunService")
	local camera = workspace.CurrentCamera
	local DashDuration = 0.3
	local DashSpeed = 100
	local hrp = character.HumanoidRootPart
	local bv  = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(100000, 0, 100000)
	bv.Velocity = Vector3.new(0,0,0)
	bv.Parent = hrp


	
	local elapsed = 0


	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		elapsed = elapsed + dt
		if elapsed >= DashDuration then
			conn:Disconnect()
			return
		end


		local look = camera.CFrame.LookVector
		local dir  = Vector3.new(look.X, 0, look.Z)
		if dir.Magnitude > 0 then
			bv.Velocity = dir.Unit * DashSpeed
		end
	end)


	task.delay(duration, function()
		bv:Destroy()
		--doingAction = false
	end)
end



function DashnSlash:CanActivate(player)
	--if not player or not player.Character then return false end
	if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) or not CanActivate then 
		return false 
	elseif CanActivate then
		return true
	end
	
	--if tick() - (self._cooldowns[player] or 0) < self.Cooldown then
	--	return false
	--end
	
end

function DashnSlash:Activate(player)
	local character = player.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end


	self._cooldowns[player] = tick()
	CanActivate = false
	
	doingAction:FireServer(1)
	VFXEvent:FireServer(1)
	dashRemote:FireServer(1)
	startDash(0.2, 100)

	-- Play animation
	--local animTrack
	--if self.Animations.Slash then
	--	local anim = ReplicatedStorage:FindFirstChild(self.Animations.Slash, true)
	--	if anim then
	--		animTrack = hum:LoadAnimation(anim)
	--		animTrack:Play()
	--	end
	--end

	-- Play VFX
	--Remotes.PlayFX:FireClient(player, self.Name)

	task.delay(0.22, function()
		slash()
		
	end)
	task.delay(DashnSlash.Cooldown, function()
		CanActivate = true
	end)
end

return DashnSlash
