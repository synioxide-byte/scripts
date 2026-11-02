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

local Window = WindUI:CreateWindow({
    Title = "Synium Hub",
    Icon = "sparkles",
    Author = "Premium Script Suite",
    Folder = "SyniumHub",

    Theme = "OLED",
    Transparent = true,

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
        -- TODO
    end
})

MovementSection:Button({
    Title = "Source Engine Movement",
    Desc = "Source-style movement mechanics",
    Icon = "move-3d",

    Callback = function()
        -- TODO
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
        -- TODO
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
        -- TODO
    end
})

AdminSection:Button({
    Title = "Infinite Yield",
    Desc = "Popular admin command system",
    Icon = "shield-check",

    Callback = function()
        -- TODO
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
        -- TODO
    end
})

FunSection:Button({
    Title = "7yd7's Infinite Emote Script",
    Desc = "Emote utilities",
    Icon = "music-4",

    Callback = function()
        -- TODO
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