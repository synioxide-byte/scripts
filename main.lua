---------------------------------------------------------------------
-- CONFIGURATION
---------------------------------------------------------------------

local VERSION = "1.6.66"

---------------------------------------------------------------------
-- LIBRARY
---------------------------------------------------------------------

local WindUI = loadstring(
    game:HttpGet(
        "https://github.com/Footagesus/WindUI/releases/download/"
        .. VERSION ..
        "/main.lua"
    )
)()

WindUI:SetFont("rbxassetid://12187371324")

local HttpService = game:GetService("HttpService")

local ConfigFile = "SyniumHub/settings.json"
if makefolder and not isfolder("SyniumHub") then
    makefolder("SyniumHub")
end

local SettingsData = {
    Theme = "OLED",
    AutoTheme = false,
    HubMusic = false,
    UIScale = "110%",
}

if isfile and isfile(ConfigFile) then
    local Success, Data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFile))
    end)

    if Success then
        for Key, Value in pairs(Data) do
            SettingsData[Key] = Value
        end
    end
end

local function SaveSettings()
    if writefile then
        writefile(
            ConfigFile,
            HttpService:JSONEncode(SettingsData)
        )
    end
end

---------------------------------------------------------------------
-- THEME
---------------------------------------------------------------------

WindUI:AddTheme({
    Name = "OLED",

    Accent = Color3.fromHex("#7C3AED"),
    Outline = Color3.fromHex("#C4B5FD"),

    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#A78BFA"),

    Icon = Color3.fromHex("#A855F7"),

    Background = Color3.fromHex("#030303"),
    Dialog = Color3.fromHex("#10061A"),

    Button = Color3.fromHex("#6D28D9"),
    ElementBackground = Color3.fromHex("#1A092B"),
})

pcall(function()
    WindUI:SetTheme(SettingsData.Theme)
end)

---------------------------------------------------------------------
-- WINDOW
---------------------------------------------------------------------

--// Duplicate UI prevention
pcall(function()
    if getgenv().SyniumWindow then
        getgenv().SyniumWindow:Destroy()
    end
end)

--// Window
local Window = WindUI:CreateWindow({
    Title = "Synium Hub",
    Icon = "sparkles",
    Author = "Premium Script Suite",
    Folder = "SyniumHub",

    Theme = SettingsData.Theme,
    Transparent = true,
    ToggleKey = Enum.KeyCode.M,

    Size = UDim2.fromOffset(600, 500),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(900, 650),

    Resizable = true,
    SideBarWidth = 210,

    HideSearchBar = false,
    ScrollBarEnabled = false,

    Background = "",
    BackgroundImageTransparency = 0.5,

    User = {
        Enabled = true,
        Anonymous = false,

        Callback = function()
            print("Opened user profile")
        end,
    },
})
getgenv().SyniumWindow = Window

local ScaleValues = {
    ["75%"] = 0.75,
    ["90%"] = 0.9,
    ["100%"] = 1,
    ["110%"] = 1.1,
    ["125%"] = 1.25,
    ["150%"] = 1.5
}

pcall(function()
    Window:SetUIScale(
        ScaleValues[SettingsData.UIScale] or 1
    )
end)

---------------------------------------------------------------------
-- SIDEBAR CATEGORIES
---------------------------------------------------------------------

local MainCategory = Window:Section({
    Title = "Main"
})

local GamesCategory = Window:Section({
    Title = "Games"
})

local SystemCategory = Window:Section({
    Title = "System"
})

---------------------------------------------------------------------
-- TABS
---------------------------------------------------------------------

local Home = MainCategory:Tab({
    Title = "Home",
    Icon = "house"
})

local Universal = MainCategory:Tab({
    Title = "Universal",
    Icon = "globe"
})

local NDS = GamesCategory:Tab({
    Title = "NDS",
    Icon = "tornado"
})

local MM2 = GamesCategory:Tab({
    Title = "MM2",
    Icon = "brush"
})

local FTAP = GamesCategory:Tab({
    Title = "FTAP",
    Icon = "wind"
})

local Misc = SystemCategory:Tab({
    Title = "Misc",
    Icon = "package"
})

local Settings = SystemCategory:Tab({
    Title = "Settings",
    Icon = "settings"
})

local Credits = SystemCategory:Tab({
    Title = "Credits",
    Icon = "heart"
})

---------------------------------------------------------------------
-- HOME TAB
---------------------------------------------------------------------

local WelcomeSection = Home:Section({
    Title = "Welcome",
    Desc = "Synium Hub information",
    Icon = "sparkles",
    Box = true,
    Opened = true
})

local QuickActionsSection = Home:Section({
    Title = "Quick Actions",
    Desc = "Common actions",
    Icon = "rocket",
    Box = true,
    Opened = true
})

QuickActionsSection:Button({
    Title = "Unload Synium Hub",
    Desc = "Close the interface",
    Icon = "power",

    Callback = function()
        Window:Destroy()
    end
})

WelcomeSection:Paragraph({
    Title = "Version",
    Desc = VERSION
})

WelcomeSection:Paragraph({
    Title = "Game",
    Desc = game:GetService("MarketplaceService")
        :GetProductInfo(game.PlaceId).Name
})

WelcomeSection:Paragraph({
    Title = "Players",
    Desc = tostring(#game.Players:GetPlayers())
})

WelcomeSection:Paragraph({
    Title = "Executor",
    Desc = identifyexecutor and identifyexecutor() or "Unknown"
})

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local FPSParagraph = WelcomeSection:Paragraph({
    Title = "FPS",
    Desc = "Calculating..."
})

local PingParagraph = WelcomeSection:Paragraph({
    Title = "Ping",
    Desc = "Loading..."
})

local TimeParagraph = WelcomeSection:Paragraph({
    Title = "Local Time",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(1) do
        local CurrentTime = os.date("%H:%M:%S")

        pcall(function()
            TimeParagraph:SetDesc(CurrentTime)
        end)

        pcall(function()
            TimeParagraph:Set({
                Desc = CurrentTime
            })
        end)
    end
end)

local MemoryParagraph = WelcomeSection:Paragraph({
    Title = "Memory",
    Desc = "Loading..."
})

task.spawn(function()
    while task.wait(2) do
        local Memory = string.format("%.1f MB", gcinfo() / 1024)

        pcall(function()
            MemoryParagraph:SetDesc(Memory)
        end)

        pcall(function()
            MemoryParagraph:Set({
                Desc = Memory
            })
        end)
    end
end)

local Frames = 0
local LastUpdate = tick()

RunService.RenderStepped:Connect(function()
    Frames += 1
end)

task.spawn(function()
    while task.wait(1) do
        local FPS = Frames
        Frames = 0

        local Ping = "N/A"
        pcall(function()
            Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
        end)

        pcall(function()
            FPSParagraph:Set({
                Desc = tostring(FPS)
            })

            PingParagraph:Set({
                Desc = Ping
            })
        end)

        pcall(function()
            FPSParagraph:SetDesc(tostring(FPS))
            PingParagraph:SetDesc(Ping)
        end)
    end
end)

---------------------------------------------------------------------
-- UNIVERSAL TAB
---------------------------------------------------------------------

local MovementSection = Universal:Section({
    Title = "Movement",
    Desc = "Movement enhancements and traversal",
    Icon = "move",
    Box = true,
    Opened = true
})

local PlayerSection = Universal:Section({
    Title = "Player",
    Desc = "Character modifications",
    Icon = "user",
    Box = true,
    Opened = true
})

local UniversalUtilitySection = Universal:Section({
    Title = "Utility",
    Desc = "Useful universal tools",
    Icon = "wrench",
    Box = true,
    Opened = true
})

local AdminSection = Universal:Section({
    Title = "Admin",
    Desc = "Administration scripts",
    Icon = "shield",
    Box = true,
    Opened = false
})

local FunSection = Universal:Section({
    Title = "Fun",
    Desc = "Extra features",
    Icon = "sparkles",
    Box = true,
    Opened = false
})

local CharacterSection = Universal:Section({
    Title = "Character",
    Desc = "Character actions and states",
    Icon = "person-standing",
    Box = true,
    Opened = true
})

local EnvironmentSection = Universal:Section({
    Title = "Environment",
    Desc = "Workspace settings",
    Icon = "mountain",
    Box = true,
    Opened = true
})

local ServerSection = Universal:Section({
    Title = "Server",
    Desc = "Server utilities",
    Icon = "server",
    Box = true,
    Opened = true
})

---------------------------------------------------------------------
-- MOVEMENT
---------------------------------------------------------------------

MovementSection:Button({
    Title = "QuickFly",
    Desc = "Simple flying system",
    Icon = "plane",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/quickfly.lua"))()
    end
})

MovementSection:Button({
    Title = "Source Engine Movement",
    Desc = "Source-style movement mechanics",
    Icon = "move-3d",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/sem.lua"))()
    end
})

MovementSection:Button({
    Title = "PoseCTRL",
    Desc = "Control how your player moves",
    Icon = "person-standing",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/PoseCTRL.lua"))()
    end
})

---------------------------------------------------------------------
-- Character
---------------------------------------------------------------------

CharacterSection:Button({
    Title = "KFling",
    Desc = "Lets you fling yourself precisely with the keybind K",
    Icon = "rotate-cw",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/KFling.lua"))()
    end
})

CharacterSection:Button({
    Title = "Fall",
    Desc = "Lets you push yourself down, or drive on the ground by holding down L",
    Icon = "arrow-down",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/Fall.lua"))()
    end
})

---------------------------------------------------------------------
-- PLAYER
---------------------------------------------------------------------

local function GetHumanoid()
    local Character = game.Players.LocalPlayer.Character
    if not Character then
        return nil
    end

    return Character:FindFirstChildOfClass("Humanoid")
end

PlayerSection:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your movement speed",

    Value = {
        Min = 0,
        Max = 200,
        Default = 16
    },

    Step = 1,
    Flag = "walkspeed",

    Callback = function(Value)
        local Humanoid = GetHumanoid()
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerSection:Slider({
    Title = "JumpPower",
    Desc = "Adjust your jump height",

    Value = {
        Min = 0,
        Max = 300,
        Default = 50
    },

    Step = 1,
    Flag = "jumppower",

    Callback = function(Value)
        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value
        end
    end
})

PlayerSection:Slider({
    Title = "Hip Height",
    Desc = "Adjust character height",

    Value = {
        Min = 0,
        Max = 25,
        Default = 0
    },

    Step = 0.1,

    Callback = function(Value)
        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid.HipHeight = Value
        end
    end
})

PlayerSection:Slider({
    Title = "Field Of View",
    Desc = "Adjust camera FOV",

    Value = {
        Min = 30,
        Max = 120,
        Default = 70
    },

    Step = 1,

    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

PlayerSection:Button({
    Title = "Reset Character",
    Desc = "Respawn yourself",
    Icon = "tombstone",

    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})


local AntiAFKConnection

PlayerSection:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents idle kick",
    Icon = "coffee",
    Value = false,
    Flag = "antiafk",

    Callback = function(Value)
        if Value then
            local VirtualUser = game:GetService("VirtualUser")

            AntiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            if AntiAFKConnection then
                AntiAFKConnection:Disconnect()
                AntiAFKConnection = nil
            end
        end
    end
})

local InfiniteJump = false
local UIS = game:GetService("UserInputService")

PlayerSection:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump without touching ground",
    Icon = "arrow-up",

    Callback = function(Value)
        InfiniteJump = Value
    end
})

UIS.JumpRequest:Connect(function()
    if InfiniteJump then
        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Noclip = false

PlayerSection:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Icon = "scan-line",

    Callback = function(Value)
        Noclip = Value
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _,v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

---------------------------------------------------------------------
-- UTILITY
---------------------------------------------------------------------

UniversalUtilitySection:Button({
    Title = "Grab Tool v2",
    Desc = "Universal grab tool",
    Icon = "hand",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/grabtool.lua"))()
    end
})

UniversalUtilitySection:Button({
    Title = "Universal FE",
    Desc = "A Hub with FE scripts.",
    Icon = "globe",

    Callback = function()
        loadstring(game:HttpGet"https://you.whimper.xyz/UFE.lua")()
    end
})

---------------------------------------------------------------------
-- ADMIN
---------------------------------------------------------------------

AdminSection:Button({
    Title = "Nameless Admin",
    Desc = "Alternative admin script",
    Icon = "terminal",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
    end
})

AdminSection:Button({
    Title = "Infinite Yield",
    Desc = "Popular admin command system",
    Icon = "shield-check",

    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Infinite-Yield-FE-239454"))()
    end
})

---------------------------------------------------------------------
-- FUN
---------------------------------------------------------------------

FunSection:Button({
    Title = "Gravel.CC",
    Desc = "Utility script collection",
    Icon = "package",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/gravel.cc.lua"))()
    end
})

FunSection:Button({
    Title = "7yd7's Infinite Emote Script",
    Desc = "Emote utilities",
    Icon = "music-4",

    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
    end
})

---------------------------------------------------------------------
-- SERVER
---------------------------------------------------------------------

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

ServerSection:Paragraph({
    Title = "Place ID",
    Desc = tostring(game.PlaceId)
})

ServerSection:Paragraph({
    Title = "Job ID",
    Desc = tostring(game.JobId)
})

ServerSection:Button({
    Title = "Copy Place ID",
    Desc = "This can help you making a game detector.",
    Icon = "copy",

    Callback = function()
        setclipboard(tostring(game.PlaceId))
    end
})

ServerSection:Button({
    Title = "Copy Rejoin Script",
    Desc = "This lets you or anyone with the snippet join that exact server.",
    Icon = "copy-check",

    Callback = function()
        setclipboard(string.format(
            "game:GetService('TeleportService'):TeleportToPlaceInstance(%s,'%s',game.Players.LocalPlayer)",
            game.PlaceId,
            game.JobId
        ))
    end
})

ServerSection:Paragraph({
    Title = "Server Players",
    Desc = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers),
    Icon = "users-round"
})

ServerSection:Paragraph({
    Title = "Private Server",
    Desc = game.PrivateServerId ~= "" and "Yes" or "No",
    Icon = "lock"
})

ServerSection:Button({
    Title = "Rejoin",
    Desc = "Rejoin the current server",
    Icon = "rotate-cw",

    Callback = function()
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            game.JobId,
            Players.LocalPlayer
        )
    end
})

ServerSection:Button({
    Title = "Server Hop",
    Desc = "Join a different server",
    Icon = "shuffle",

    Callback = function()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    end
})

ServerSection:Button({
    Title = "Copy Job ID",
    Desc = "Copy current server JobId",
    Icon = "copy",

    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
        end
    end
})

ServerSection:Button({
    Title = "Leave Game",
    Desc = "Disconnect from the server",
    Icon = "log-out",

    Callback = function()
        Players.LocalPlayer:Kick("Left via Synium Hub")
    end
})

ServerSection:Button({
    Title = "Copy Position",
    Desc = "Copy your current position",
    Icon = "copy",

    Callback = function()
        local Root = game.Players.LocalPlayer.Character
            and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if Root and setclipboard then
            setclipboard(string.format(
                "Vector3.new(%.2f, %.2f, %.2f)",
                Root.Position.X,
                Root.Position.Y,
                Root.Position.Z
            ))

            WindUI:Notify({
                Title = "Copied",
                Content = "Position copied to clipboard"
            })
        end
    end
})

---------------------------------------------------------------------
-- Environment
---------------------------------------------------------------------

EnvironmentSection:Slider({
    Title = "Gravity",
    Desc = "Adjust workspace gravity",

    Value = {
        Min = 0,
        Max = 500,
        Default = workspace.Gravity
    },

    Step = 1,
    Flag = "gravity",

    Callback = function(Value)
        workspace.Gravity = Value
    end
})

-- Time Of Day
EnvironmentSection:Slider({
    Title = "Time Of Day",
    Desc = "Adjust the game clock",
    
    Value = {
        Min = 0,
        Max = 24,
        Default = tonumber(string.match(game.Lighting.TimeOfDay, "^(%d+)")) or 12
    },
    
    Step = 1,
    Flag = "timeofday",
    
    Callback = function(Value)
        game.Lighting.ClockTime = Value
    end
})

-- Brightness
EnvironmentSection:Slider({
    Title = "Brightness",
    Desc = "Adjust lighting brightness",
    
    Value = {
        Min = 0,
        Max = 10,
        Default = game.Lighting.Brightness
    },
    
    Step = 0.1,
    Flag = "brightness",
    
    Callback = function(Value)
        game.Lighting.Brightness = Value
    end
})

EnvironmentSection:Toggle({
    Title = "Bloom",
    Desc = "Enable bloom effect",
    Icon = "sun",
    Value = false,
    Flag = "bloom",

    Callback = function(Value)
        Bloom.Enabled = Value
    end
})

-- Fullbright
local FullbrightData = {
    Brightness = game.Lighting.Brightness,
    Ambient = game.Lighting.Ambient,
    OutdoorAmbient = game.Lighting.OutdoorAmbient,
    ClockTime = game.Lighting.ClockTime,
    GlobalShadows = game.Lighting.GlobalShadows
}

EnvironmentSection:Toggle({
    Title = "Fullbright",
    Desc = "Makes the map fully bright",
    Icon = "lightbulb",
    Value = false,
    Flag = "fullbright",

    Callback = function(Value)
        if Value then
            game.Lighting.Brightness = 5
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            game.Lighting.ClockTime = 12
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.Brightness = FullbrightData.Brightness
            game.Lighting.Ambient = FullbrightData.Ambient
            game.Lighting.OutdoorAmbient = FullbrightData.OutdoorAmbient
            game.Lighting.ClockTime = FullbrightData.ClockTime
            game.Lighting.GlobalShadows = FullbrightData.GlobalShadows
        end
    end
})

local OriginalFogEnd = game.Lighting.FogEnd
local OriginalFogStart = game.Lighting.FogStart

EnvironmentSection:Toggle({
    Title = "No Fog",
    Desc = "Removes fog from the map",
    Icon = "cloud-off",
    Value = false,
    Flag = "nofog",

    Callback = function(Value)
        getgenv().NoFog = Value

        if Value then
            game.Lighting.FogStart = 0
            game.Lighting.FogEnd = 1000000

            task.spawn(function()
                while getgenv().NoFog do
                    game.Lighting.FogStart = 0
                    game.Lighting.FogEnd = 1000000
                    task.wait(1)
                end
            end)
        else
            game.Lighting.FogStart = OriginalFogStart
            game.Lighting.FogEnd = OriginalFogEnd
        end
    end
})


---------------------------------------------------------------------
-- MM2
---------------------------------------------------------------------

MM2:Button({
    Title = "YARHM",
    Desc = "Overall the best MM2/Universal Script.",

    Callback = function()
        local src = ""
        pcall(function()
            src = game:HttpGet("https://yarhm.com", false)
        end)

        if src == "" then
            window:Notify({
                title = "YARHM Outage",
                content = "Using Offline version."
            })
            src = game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/source/yarhm/1.21/yarhm.lua", false)
        end

        loadstring(src)()
    end
})

MM2:Button({
    Title = "Zero Point",
    Desc = "Better than YARHM in some ways, but is distractive.",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Murder-Mystery-2-Best-MM2-Zero-Point-Kill-All-Coin-farm-Live-Trade-Helper!-226629"))()
    end
})

---------------------------------------------------------------------
-- FTAP
---------------------------------------------------------------------

FTAP:Button({
    Title = "Player Hub",
    Desc = "Worse than Blitz Hub keyed, but in some places better than Blitz Hub keyless.",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Fling-Things-and-People-FTAP-Player-Hub-227209"))()
    end
})

FTAP:Button({
    Title = "Player Hub",
    Desc = "Worse than Blitz Hub keyed, but in some places better than Blitz Hub keyless.",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Fling-Things-and-People-FTAP-Player-Hub-227209"))()
    end
})

FTAP:Button({
    Title = "Blitz Hub",
    Desc = "Keyless, some features don't function and it's old.",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Fling-Things-and-People-Blitz-Hub-Crack-Key-Is-25ms-43155"))()
    end
})

FTAP:Button({
    Title = "Blitz Hub",
    Desc = "Keyed. The best FTAP Script Hub.",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Fling-Things-and-People-FTAP-BLITZ-43504"))()
    end
})

---------------------------------------------------------------------
-- Settings
---------------------------------------------------------------------

Settings:Dropdown({
    Title = "Theme",
    Desc = "Select a theme",

    Values = {
        "Dark",
        "Light",
        "Rose",
        "Plant",
        "Red",
        "Indigo",
        "Sky",
        "Violet",
        "Amber",
        "Emerald",
        "Midnight",
        "Crimson",
        "Mellowsi",
        "Rainbow",
        "OLED"
    },

    Value = SettingsData.Theme,
    Multi = false,
    Locked = false,
    Flag = "theme_select",

    Callback = function(Theme)
        SettingsData.Theme = Theme
        SaveSettings()

        if not AutoTheme then
            WindUI:SetTheme(Theme)
        end

        WindUI:Notify({
            Title = "Theme Changed",
            Content = Theme
        })
    end

})

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://77446979841289"
sound.Looped = true
sound.Volume = 0
sound.Parent = workspace

local fadeSpeed = 0.05
local musicEnabled = SettingsData.HubMusic
local started = false
local musicTransition = 0

local function fadeIn()
    musicTransition += 1
    local current = musicTransition

    if not started then
        started = true
        sound:Play()
    else
        sound:Resume()
    end

    while sound.Volume < 1 and musicEnabled and current == musicTransition do
        sound.Volume = math.min(sound.Volume + fadeSpeed, 1)
        task.wait()
    end
end

local function fadeOut()
    musicTransition += 1
    local current = musicTransition

    while sound.Volume > 0 and not musicEnabled and current == musicTransition do
        sound.Volume = math.max(sound.Volume - fadeSpeed, 0)
        task.wait()
    end

    if current == musicTransition and sound.Volume <= 0 then
        sound:Pause()
    end
end

Settings:Toggle({
    Title = "Hub Music",
    Desc = "Play background music",

    Value = SettingsData.HubMusic,
    Flag = "hub_music",

    Callback = function(Value)
        musicEnabled = Value

        SettingsData.HubMusic = Value
        SaveSettings()
        if Value then
            fadeIn()
        else
            fadeOut()
        end
    end
})

Window:OnOpen(function()
    if musicEnabled then
        task.spawn(fadeIn)
    end
end)

Window:OnClose(function()
    if musicEnabled then
        task.spawn(function()
            musicEnabled = false
            fadeOut()
            musicEnabled = true
        end)
    end

    WindUI:Notify({
        Title = "GUI Closed",
        Content = "Press M to reopen the GUI!",
        Duration = 5
    })
end)

local AutoTheme = SettingsData.AutoTheme

local function GetAutoTheme()
    local Hour = tonumber(os.date("%H"))

    if Hour >= 8 and Hour < 17 then
        return "Light"
    else
        return "OLED"
    end
end

local function UpdateTheme()
    if not AutoTheme then
        return
    end

    local Theme = GetAutoTheme()

    WindUI:SetTheme(Theme)
end

Settings:Toggle({
    Title = "Auto Theme",
    Desc = "Light during the day, OLED at night",

    Value = SettingsData.AutoTheme,
    Locked = false,
    Flag = "auto_theme",

    Callback = function(Value)
        AutoTheme = Value

        SettingsData.AutoTheme = Value
        SaveSettings()

        if Value then
            UpdateTheme()

            WindUI:Notify({
                Title = "Auto Theme",
                Content = "Enabled",
                Duration = 3
            })
        else
            -- Restore the user's saved theme
            WindUI:SetTheme(SettingsData.Theme)

            WindUI:Notify({
                Title = "Auto Theme",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})

task.spawn(function()
    while task.wait(60) do
        UpdateTheme()
    end
end)

-- Apply theme after UI loads
if AutoTheme then
    UpdateTheme()
else
    WindUI:SetTheme(SettingsData.Theme)
end

if musicEnabled then
    fadeIn()
end

Settings:Dropdown({
    Title = "UI Scale",
    Desc = "Adjust interface size. (WARNING! This feature is glitchy. Use 110% for the best experience)",

    Values = {
        "75%",
        "90%",
        "100%",
        "110%",
        "125%",
        "150%"
    },

    Value = SettingsData.UIScale or "100%",
    Multi = false,
    Flag = "ui_scale",

    Callback = function(Value)
        SettingsData.UIScale = Value
        SaveSettings()

        local Scale = ScaleValues[Value] or 1

        pcall(function()
            Window:SetUIScale(Scale)
        end)

        WindUI:Notify({
            Title = "UI Scale",
            Content = "Set to " .. Value,
            Duration = 3
        })
    end
})


---------------------------------------------------------------------
-- Credits
---------------------------------------------------------------------

Credits:Paragraph({
    Title = "Microsoft Copilot",
    Desc = "Structuring the hub. Helping with code and giving information."
})

Credits:Paragraph({
    Title = "Footagesus",
    Desc = "Making WindUI, so making Synium Hub possible"
})

Credits:Paragraph({
    Title = "Synioxide",
    Desc = "Making Synium Hub."
})

---------------------------------------------------------------------
-- NDS
---------------------------------------------------------------------

NDS:Button({
    Title = "Project Gravity",
    Desc = "Lets you control parts with awesome shapes.",
    Icon = "orbit",

    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Natural-Disaster-Survival-Project-Gravity-NDS-239526"))()
    end
})

NDS:Button({
    Title = "NDS Surf",
    Desc = "Lets you surf with unanchored parts",
    Icon = "waves",

    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/pTL8Ck6D/raw"))()
    end
})