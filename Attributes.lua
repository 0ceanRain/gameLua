local players = game:GetService("Players")
players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)

		char:SetAttribute("IsParrying", false)
		char:SetAttribute("IsSwinging", false)
		char:SetAttribute("IsStunned", false)
	end)
end)