local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode ~= Enum.KeyCode.K then return end

	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then return end

	local cam = workspace.CurrentCamera
	local look = cam.CFrame.LookVector.Unit

	-- Launch exactly where the camera is looking
	root.AssemblyLinearVelocity =
		look * 200 +
		Vector3.new(
			math.random(-15, 15),
			math.random(-15, 15),
			math.random(-15, 15)
		)

	-- Chaotic spin
	root.AssemblyAngularVelocity = Vector3.new(
		math.random(-75, 75),
		math.random(-75, 75),
		math.random(-75, 75)
	)

	-- Fall over
	humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)

	-- Extra chaos shortly after launch
--[[	task.delay(0.15, function()
		if root.Parent then
			root.AssemblyAngularVelocity += Vector3.new(
				math.random(-50, 50),
				math.random(-50, 50),
				math.random(-50, 50)
			)
		end
	end)
]]
	task.delay(1.5, function()
		if humanoid and humanoid.Parent then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)
end)