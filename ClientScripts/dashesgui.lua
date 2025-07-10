
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local dashEvt = RS.Remotes.DefenseRemotes.DashRemote

local MAX = 3
local RESET_T = 2
local HIDE_T = 15


local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")


local gui = Instance.new("BillboardGui")
gui.Adornee = hrp

gui.ExtentsOffset = Vector3.new(-2.5, 1, 0)  

gui.Size = UDim2.new(0, 30, 0, 90)
gui.AlwaysOnTop = true
gui.Enabled = false
gui.Parent = hrp

local holder = Instance.new("Frame", gui)
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", holder)
layout.FillDirection = Enum.FillDirection.Vertical
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 3)


local circles = {}
for i = 1, MAX do
	local c = Instance.new("Frame", holder)
	c.Size = UDim2.new(1, 0, 0, 25)
	c.BackgroundColor3 = Color3.new(1, 1, 1)
	c.BackgroundTransparency = 0
	local u = Instance.new("UICorner", c)
	u.CornerRadius = UDim.new(1, 0)
	circles[i] = c
end


local used = 0
local hideThread

local function update()
	local avail = MAX - used
	for i, c in ipairs(circles) do
		c.BackgroundColor3 = (i <= avail) and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
	end
end

local function show()
	gui.Enabled = true

	if hideThread then
		task.cancel(hideThread)
	end
	hideThread = task.delay(HIDE_T, function()
		gui.Enabled = false
		hideThread = nil
	end)
end

dashEvt.OnClientEvent:Connect(function()
	used = math.min(used + 1, MAX)
	update()
	show()
	if used == MAX then
		task.delay(RESET_T, function()
			used = 0
			update()
			show()
		end)
	end
end)
