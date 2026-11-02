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

local SettingsData = {
    Theme = "OLED",
    AutoTheme = false,
    HubMusic = false
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

Window:OnClose(function()
    WindUI:Notify({
        Title = "GUI Closed",
        Content = "Press M to reopen the GUI!",
        Duration = 5
    })
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

---------------------------------------------------------------------
-- Character
---------------------------------------------------------------------

CharacterSection:Button({
    Title = "KFling",
    Desc = "Lets you fling yourself precisely with the keybind K",
    Icon = "spin",

    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/synioxide-byte/scripts/main/KFling.lua"))()
    end
})

CharacterSection:Button({
    Title = "Fall",
    Desc = "Lets you push yourself down, or drive on the ground by holding down L",
    Icon = "fall",

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

ServerSection:Paragraph({
    Title = "Server Players",
    Desc = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers)
})

ServerSection:Paragraph({
    Title = "Private Server",
    Desc = game.PrivateServerId ~= "" and "Yes" or "No"
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

---------------------------------------------------------------------
-- MM2
---------------------------------------------------------------------

MM2:Button({
    Title = "YARHM",
    Desc = "Overall the best MM2/Universal Script.",
    Icon = "knife",

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

    Value = "OLED",
    Multi = false,
    Locked = false,
    Flag = "theme_select",

    Callback = function(Theme)
        SettingsData.Theme = Theme
        SaveSettings()

        WindUI:SetTheme(Theme)

        Window:Notify({
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
local musicEnabled = false
local started = false

local function fadeIn()
    task.spawn(function()
        if not started then
            started = true
            sound:Play()
        else
            sound:Resume()
        end

        while sound.Volume < 1 and musicEnabled do
            sound.Volume = math.min(sound.Volume + fadeSpeed, 1)
            task.wait()
        end
    end)
end

local function fadeOut()
    task.spawn(function()
        while sound.Volume > 0 and not musicEnabled do
            sound.Volume = math.max(sound.Volume - fadeSpeed, 0)
            task.wait()
        end

        if sound.Volume <= 0 then
            sound:Pause()
        end
    end)
end

Settings:Toggle({
    Title = "Hub Music",
    Desc = "Play background music",

    Value = false,
    Flag = "hub_music",

    Callback = function(Value)
        musicEnabled = Value

        if Value then
            fadeIn()
        else
            fadeOut()
        end
    end
})

Window:OnOpen(function()
    if musicEnabled then
        fadeIn()
    end
end)

Window:OnClose(function()
    if musicEnabled then
        task.spawn(function()
            musicEnabled = false
            fadeOut()
            task.wait(1)
            musicEnabled = true
        end)
    end

    WindUI:Notify({
        Title = "GUI Closed",
        Content = "Press M to reopen the GUI!",
        Duration = 5
    })
end)

local AutoTheme = false

local function UpdateTheme()
    if not AutoTheme then
        return
    end

    local Hour = tonumber(os.date("%H"))

    if Hour >= 8 and Hour < 17 then
        WindUI:SetTheme("Light")
    else
        WindUI:SetTheme("OLED")
    end
end

Settings:Toggle({
    Title = "Auto Theme",
    Desc = "Light during the day, OLED at night",

    Value = false,
    Locked = false,
    Flag = "auto_theme",

    Callback = function(Value)
        AutoTheme = Value

        if Value then
            UpdateTheme()

            WindUI:Notify({
                Title = "Auto Theme",
                Content = "Enabled",
                Duration = 3
            })
        else
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