local stunRemote = game:GetService("ReplicatedStorage").Remotes.DefenseRemotes.stunnedRemote

stunRemote.OnServerEvent:Connect(function(player, amount)
	local character = player.Character
	if amount == 1 then
		character:SetAttribute("IsStunned", true)
	else
		character:SetAttribute("IsStunned", false)
	end
end)
