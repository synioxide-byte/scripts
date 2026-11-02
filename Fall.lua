-- Destroy older copies
local SCRIPT_NAME = "LSpamRagdoll"

pcall(function()
    for _, v in ipairs(getgc and getgc() or {}) do
        if typeof(v) == "table" and rawget(v, "__LSpamRagdoll") then
            v.Active = false
        end
    end
end)

local State = {
    Active = true,
    __LSpamRagdoll = true
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Keybind = Enum.KeyCode.L

local i = 3
local Holding = false

local function DoRagdoll()
    local Character = Player.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not RootPart then return end

    RootPart.AssemblyLinearVelocity += Camera.CFrame.LookVector * 10

    Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not State.Active then return end
    if gameProcessed then return end
    if input.KeyCode ~= Keybind then return end
    if i ~= 3 then return end
    if Holding then return end

    Holding = true

    task.spawn(function()
        while Holding and State.Active do
            DoRagdoll()
            task.wait(0.05) -- spam every 0.1s
        end
    end)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Keybind then
        Holding = false
    end
end)