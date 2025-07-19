local DoubleSlashModule = {
	
}
DoubleSlashModule.cooldown = 8
DoubleSlashModule.windup1 = 0.5
DoubleSlashModule.windup2 = 0.8
DoubleSlashModule.Name = "DoubleSlash"

local CombatStateModule = require(game:GetService("RobloxReplicatedStorage").Modules.CombatStateModule)

local CanActivate = true

local attackRemote = game.ReplicatedStorage.Remotes.attackRemote

function DoubleSlashModule:CanActivate(player)
    if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) or not CanActivate then 
		return false 
	elseif CanActivate then
		return true
	end
end
local Swing1Finshed = false


-- ok
function DoubleSlashModule:Activate(player)
	local swing1Anim = game.ReplicatedStorage.animations.abilities.DoubleSlash1
	local swing2Anim = game.ReplicatedStorage.animations.abilities.DoubleSlash2
	CanActivate = true

	swing1Anim:Play()

	local FirstSwing = task.delay(self.windup1, function()
		
		attackRemote:FireServer(player)

		Swing1Finshed = true
	end)

	if Swing1Finshed then
		Swing1Finshed = false
		swing2Anim:Play()
		task.delay(self.windup2, function()
			attackRemote:FireServer(player)

		end)
	end
	task.delay(self.cooldown, function()
		CanActivate = true
	end)
    
end

return DoubleSlashModule