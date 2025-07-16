local TeleportModule = {}


local CombatStateModule = require(game:GetService("RobloxReplicatedStorage").Modules.CombatStateModule)

local CanActivate = true

local function CanActivate(player)
    if CombatStateModule.IsStunned(player) or CombatStateModule.IsDoingAction(player) or not CanActivate then 
		return false 
	elseif CanActivate then
		return true
	end
end


-- ok

local function Activate()
    CanActivate = false
end

return TeleportModule