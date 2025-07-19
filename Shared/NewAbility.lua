local NewAbility = {}
NewAbility.cooldown = 7
NewAbility.windup = 0.55
NewAbility.Name = "_"


local CombatStateModule = require(game:GetService("RobloxReplicatedStorage").Modules.CombatStateModule)

local CanActivate = true

local attackRemote = game.ReplicatedStorage.Remotes.attackRemote

function NewAbility:CanActivate(player)
    if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) or not CanActivate then 
		return false 
	elseif CanActivate then
		return true
	end
end


function NewAbility:Activate(player)
    
end



return NewAbility