local CombatStateModule = {}

-- Returns true if the player is currently stunned
function CombatStateModule.IsStunned(player)
	if player.Character:GetAttribute("IsStunned") then
		return true
	else
		return false
	end
end

-- Returns true if the player is currently performing an action
function CombatStateModule.IsDoingAction(player)
	if player.Character:GetAttribute("doingAction") then
		return true
	else
		return false
	end
end

return CombatStateModule
