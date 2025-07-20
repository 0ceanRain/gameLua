local NewAbility = {}
NewAbility.cooldown = 7
NewAbility.windup = 0.55
NewAbility.Name = "NewAbility"


local CombatStateModule = require(game:GetService("RobloxReplicatedStorage").Modules.CombatStateModule)

local CanActivate = true

local attackRemote = game.ReplicatedStorage.Remotes.attackRemote

local player = game.Players.LocalPlayer



function NewAbility:CheckMouse()
    task.delay(self.windup, function()
        local mousePos = player:GetMouse()
        local target = mousePos.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            return true
        else
            return false
        end
    end)
end


function NewAbility:CanActivate(player)
    if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) or not CanActivate then 
		return false 
	elseif CanActivate then
		return true
	end
end


function NewAbility:Activate(player)
    if NewAbility:CheckMouse() then
        attackRemote:FireServer()
        task.delay(self.windup, function()
            
        end)
    else
        return false
    end

end



return NewAbility