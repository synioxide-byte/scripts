--// Pose Controller
--// LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

local AnimationThread = 0

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

for _, Gui in ipairs(PlayerGui:GetChildren()) do

	if Gui.Name == "PoseController" then
		Gui:Destroy()
	end

end

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local PANEL_WIDTH = 220
local PANEL_HEIGHT = 340
local HANDLE_WIDTH = 32

local POSE_FOLDER =
	"PoseController"

local POSE_FILE =
	POSE_FOLDER ..
	"/poses.json"

--------------------------------------------------
-- STATE
--------------------------------------------------

local CurrentPose = nil
local DrawerOpen = false
local CurrentPage = 1

local Poses = {}
local PosePages = {}

--------------------------------------------------
-- DEFAULT POSES
--------------------------------------------------

local DefaultPoses = {

	["Face Flat"] = {
		X = 90,
		Y = 0,
		Z = 0
	},

	["Face Up"] = {
		X = -90,
		Y = 0,
		Z = 0
	},

	["Diagonal"] = {
		X = 45,
		Y = 0,
		Z = 45
	},

	["Headstand"] = {
		X = 180,
		Y = 0,
		Z = 0
	},

	["Side Tilt"] = {
		X = 0,
		Y = 0,
		Z = 90
	},

	["Side Tilt 2"] = {
		X = 0,
		Y = 0,
		Z = -90
	},

	["Back Bend"] = {
		X = -45,
		Y = 0,
		Z = 0
	},

	["Forward Bend"] = {
		X = 45,
		Y = 0,
		Z = 0
	}
}

--------------------------------------------------
-- FILES
--------------------------------------------------

local function EnsureFolder()

	if not isfolder(
		POSE_FOLDER
	) then

		makefolder(
			POSE_FOLDER
		)

	end

end

local function SavePoseFile()

	EnsureFolder()

	writefile(
		POSE_FILE,
		HttpService:JSONEncode(
			Poses
		)
	)

end

local function CreateDefaultFile()

	Poses = {}

	for Name, Pose in pairs(
		DefaultPoses
	) do

		Poses[Name] = {
			X = Pose.X,
			Y = Pose.Y,
			Z = Pose.Z
		}

	end

	SavePoseFile()

end

local function LoadPoses()

	EnsureFolder()

	if not isfile(
		POSE_FILE
	) then

		CreateDefaultFile()

	end

	local Success, Data =
		pcall(
			function()

				return
					HttpService:JSONDecode(
						readfile(
							POSE_FILE
						)
					)

			end
		)

	if not Success then

		CreateDefaultFile()

		Data =
			HttpService:JSONDecode(
				readfile(
					POSE_FILE
				)
			)

	end

	Poses = Data

end

--------------------------------------------------
-- PAGES
--------------------------------------------------

local function RebuildPages()

	table.clear(
		PosePages
	)

	local Page = {}

	for PoseName in pairs(
		Poses
	) do

		table.insert(
			Page,
			PoseName
		)

		if #Page >= 4 then

			table.insert(
				PosePages,
				Page
			)

			Page = {}

		end

	end

	if #Page > 0 then

		table.insert(
			PosePages,
			Page
		)

	end

	if CurrentPage >
		#PosePages then

		CurrentPage =
			math.max(
				1,
				#PosePages
			)

	end

end

LoadPoses()
RebuildPages()
--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "PoseController"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

--------------------------------------------------
-- POSITIONS
--------------------------------------------------

local CLOSED_OFFSET =
	PANEL_WIDTH -
	HANDLE_WIDTH

local OPEN_POS =
	UDim2.new(
		1,
		0,
		0.5,
		-PANEL_HEIGHT/2
	)

local CLOSED_POS =
	UDim2.new(
		1,
		CLOSED_OFFSET,
		0.5,
		-PANEL_HEIGHT/2
	)

--------------------------------------------------
-- PANEL
--------------------------------------------------

local Panel =
	Instance.new("Frame")

Panel.Name = "Panel"

Panel.AnchorPoint =
	Vector2.new(1,0)

Panel.Size =
	UDim2.new(
		0,
		PANEL_WIDTH,
		0,
		PANEL_HEIGHT
	)

Panel.Position =
	CLOSED_POS

Panel.BackgroundColor3 =
	Color3.fromRGB(
		20,
		20,
		25
	)

Panel.BorderSizePixel = 0

Panel.Parent = Gui

local PanelCorner =
	Instance.new("UICorner")

PanelCorner.CornerRadius =
	UDim.new(
		0,
		14
	)

PanelCorner.Parent =
	Panel

local PanelStroke =
	Instance.new("UIStroke")

PanelStroke.Color =
	Color3.fromRGB(
		60,
		60,
		70
	)

PanelStroke.Thickness = 1.5

PanelStroke.Parent =
	Panel

--------------------------------------------------
-- HANDLE
--------------------------------------------------

local Handle =
	Instance.new(
		"TextButton"
	)

Handle.Parent =
	Panel

Handle.Size =
	UDim2.new(
		0,
		HANDLE_WIDTH,
		0,
		120
	)

Handle.Position =
	UDim2.new(
		0,
		0,
		0.5,
		-60
	)

Handle.BackgroundColor3 =
	Color3.fromRGB(
		35,
		35,
		40
	)

Handle.BorderSizePixel = 0
Handle.Text = ""

local HandleCorner =
	Instance.new(
		"UICorner"
	)

HandleCorner.Parent =
	Handle

--------------------------------------------------
-- HANDLE ARROW
--------------------------------------------------

local Arrow =
	Instance.new(
		"TextLabel"
	)

Arrow.Parent =
	Handle

Arrow.Size =
	UDim2.fromScale(
		1,
		1
	)

Arrow.BackgroundTransparency = 1

Arrow.Text = ">"

Arrow.TextScaled = true

Arrow.Font =
	Enum.Font.GothamBold

Arrow.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

--------------------------------------------------
-- CONTENT
--------------------------------------------------

local Content =
	Instance.new(
		"Frame"
	)

Content.Parent =
	Panel

Content.BackgroundTransparency = 1

Content.Position =
	UDim2.new(
		0,
		HANDLE_WIDTH,
		0,
		0
	)

Content.Size =
	UDim2.new(
		1,
		-HANDLE_WIDTH,
		1,
		0
	)

local Padding =
	Instance.new(
		"UIPadding"
	)

Padding.Parent =
	Content

Padding.PaddingTop =
	UDim.new(
		0,
		10
	)

Padding.PaddingLeft =
	UDim.new(
		0,
		10
	)

Padding.PaddingRight =
	UDim.new(
		0,
		10
	)

local Layout =
	Instance.new(
		"UIListLayout"
	)

Layout.Parent =
	Content

Layout.Padding =
	UDim.new(
		0,
		8
	)

Layout.HorizontalAlignment =
	Enum.HorizontalAlignment
	.Center

--------------------------------------------------
-- TITLE
--------------------------------------------------

local Title =
	Instance.new(
		"TextLabel"
	)

Title.Parent =
	Content

Title.Size =
	UDim2.new(
		1,
		0,
		0,
		40
	)

Title.BackgroundTransparency = 1

Title.Text =
	"Pose Controller"

Title.Font =
	Enum.Font.GothamBold

Title.TextSize = 18

Title.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

--------------------------------------------------
-- BUTTON FACTORY
--------------------------------------------------

local function CreateButton(
	Text,
	Color
)

	local Button =
		Instance.new(
			"TextButton"
		)

	Button.Size =
		UDim2.new(
			0,
			170,
			0,
			36
		)

	Button.BackgroundColor3 =
		Color

	Button.Text = Text

	Button.BorderSizePixel = 0

	Button.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	Button.Font =
		Enum.Font
		.GothamSemibold

	Button.TextSize = 14

	local Corner =
		Instance.new(
			"UICorner"
		)

	Corner.CornerRadius =
		UDim.new(
			0,
			10
		)

	Corner.Parent =
		Button

	local Stroke =
		Instance.new(
			"UIStroke"
		)

	Stroke.Color =
		Color3.fromRGB(
			90,
			90,
			100
		)

	Stroke.Parent =
		Button

	Button.MouseEnter:Connect(
		function()

			TweenService:Create(
				Button,
				TweenInfo.new(
					0.1
				),
				{
					BackgroundColor3 =
						Color:Lerp(
							Color3.new(
								1,
								1,
								1
							),
							0.08
						)
				}
			):Play()

		end
	)

	Button.MouseLeave:Connect(
		function()

			TweenService:Create(
				Button,
				TweenInfo.new(
					0.1
				),
				{
					BackgroundColor3 =
						Color
				}
			):Play()

		end
	)

	return Button

end
--------------------------------------------------
-- PAGE BAR
--------------------------------------------------

local PageFrame =
	Instance.new("Frame")

PageFrame.Parent =
	Content

PageFrame.Size =
	UDim2.new(
		0,
		170,
		0,
		35
	)

PageFrame.BackgroundTransparency = 1

local PrevPage =
	Instance.new("TextButton")

PrevPage.Parent =
	PageFrame

PrevPage.Size =
	UDim2.new(
		0,
		40,
		1,
		0
	)

PrevPage.Text = "<"

PrevPage.Font =
	Enum.Font.GothamBold

PrevPage.TextColor3 =
	Color3.new(1,1,1)

PrevPage.BackgroundColor3 =
	Color3.fromRGB(
		40,
		40,
		50
	)

local PrevCorner =
	Instance.new(
		"UICorner"
	)

PrevCorner.Parent =
	PrevPage

local PageLabel =
	Instance.new(
		"TextLabel"
	)

PageLabel.Parent =
	PageFrame

PageLabel.Position =
	UDim2.new(
		0,
		40,
		0,
		0
	)

PageLabel.Size =
	UDim2.new(
		1,
		-80,
		1,
		0
	)

PageLabel.BackgroundTransparency = 1

PageLabel.TextColor3 =
	Color3.new(1,1,1)

PageLabel.Font =
	Enum.Font.GothamBold

PageLabel.TextSize = 14

local NextPage =
	Instance.new(
		"TextButton"
	)

NextPage.Parent =
	PageFrame

NextPage.Size =
	UDim2.new(
		0,
		40,
		1,
		0
	)

NextPage.Position =
	UDim2.new(
		1,
		-40,
		0,
		0
	)

NextPage.Text = ">"

NextPage.Font =
	Enum.Font.GothamBold

NextPage.TextColor3 =
	Color3.new(1,1,1)

NextPage.BackgroundColor3 =
	Color3.fromRGB(
		40,
		40,
		50
	)

local NextCorner =
	Instance.new(
		"UICorner"
	)

NextCorner.Parent =
	NextPage

--------------------------------------------------
-- POSE BUTTON AREA
--------------------------------------------------

local PoseContainer =
	Instance.new(
		"Frame"
	)

PoseContainer.Parent =
	Content

PoseContainer.Size =
	UDim2.new(
		1,
		0,
		0,
		190
	)

PoseContainer.BackgroundTransparency = 1

local PoseLayout =
	Instance.new(
		"UIListLayout"
	)

PoseLayout.Parent =
	PoseContainer

PoseLayout.Padding =
	UDim.new(
		0,
		5
	)

PoseLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Center

--------------------------------------------------
-- DISABLE BUTTON
--------------------------------------------------

local DisableButton =
	CreateButton(
		"Disable Pose",
		Color3.fromRGB(
			180,
			60,
			60
		)
	)

DisableButton.Parent =
	Content

--------------------------------------------------
-- APPLY POSE
--------------------------------------------------

local function ApplyPose(Pose)

    local Character = Player.Character
    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Root or not Humanoid then
        return
    end
    AnimationThread += 1

    local BaseRotation =
        CFrame.fromMatrix(
            Vector3.zero,
            Root.CFrame.RightVector,
            Root.CFrame.UpVector,
            -Root.CFrame.LookVector
        )    

    local OldAlign = Root:FindFirstChild("PoseAlign")
    if OldAlign then
        OldAlign:Destroy()
    end
    local OldPosition =
        Root:FindFirstChild(
            "PosePosition"
        )

    if OldPosition then

        OldPosition:Destroy()

    end

    local OldAttachment = Root:FindFirstChild("PoseAttachment")
    if OldAttachment then
        OldAttachment:Destroy()
    end

    Humanoid:ChangeState(
        Enum.HumanoidStateType.Physics
    )

    local Attachment = Instance.new("Attachment")
    Attachment.Name = "PoseAttachment"
    Attachment.Parent = Root

    local Align = Instance.new("AlignOrientation")
    Align.Name = "PoseAlign"
    Align.Mode =
        Enum.OrientationAlignmentMode.OneAttachment

    Align.RigidityEnabled = true
    Align.Responsiveness = 200
    Align.Attachment0 = Attachment
    Align.Parent = Root

    local HasPosition =
        Pose.PX ~= nil
        or Pose.PY ~= nil
        or Pose.PZ ~= nil

    if not HasPosition
    and Pose.Animation then

        for _, Frame in ipairs(
            Pose.Animation
        ) do

            if Frame.PX ~= nil
            or Frame.PY ~= nil
            or Frame.PZ ~= nil then

                HasPosition =
                    true

                break

            end

        end

    end

    local PositionAlign =
        nil

    local BasePosition =
        Root.Position

    if HasPosition then

        PositionAlign =
            Instance.new(
                "AlignPosition"
            )

        PositionAlign.Name =
            "PosePosition"

        PositionAlign.Mode =
            Enum.PositionAlignmentMode
            .OneAttachment

        PositionAlign.Attachment0 =
            Attachment

        PositionAlign.RigidityEnabled =
            true

        PositionAlign.Responsiveness =
            200

        PositionAlign.Parent =
            Root

        PositionAlign.Position =
            BasePosition

    end

    if Pose.Animation then


        local ThreadId =
            AnimationThread

        task.spawn(
            function()

                local FrameIndex =
                    1

                while
                    ThreadId ==
                    AnimationThread
                do

                    local Frame =
                        Pose.Animation[
                            FrameIndex
                        ]

                    if not Frame then
                        break
                    end

                    local GoalRotation =
                        BaseRotation
                        *
                        CFrame.Angles(
                            math.rad(
                                Frame.X or 0
                            ),
                            math.rad(
                                Frame.Y or 0
                            ),
                            math.rad(
                                Frame.Z or 0
                            )
                        )

                    local StartRotation =
                        Align.CFrame

                    local GoalPosition =
                        nil

                    local StartPosition =
                        nil

                    if PositionAlign then

                        GoalPosition =
                            BasePosition +
                            Vector3.new(
                                Frame.PX or 0,
                                Frame.PY or 0,
                                Frame.PZ or 0
                            )

                        StartPosition =
                            PositionAlign.Position

                    end

                    local Duration =
                        Pose.Speed
                        or 0.15

                    local StartTick =
                        tick()

                    repeat

                        if ThreadId ~=
                            AnimationThread then
                            return
                        end

                        local Alpha =
                            math.clamp(
                                (
                                    tick()
                                    -
                                    StartTick
                                )
                                /
                                Duration,
                                0,
                                1
                            )

                        Alpha =
                            TweenService:GetValue(
                                Alpha,
                                Enum.EasingStyle[
                                    Pose.Easing
                                    or "Sine"
                                ],
                                Enum.EasingDirection[
                                    Pose.Direction
                                    or "InOut"
                                ]
                            )

                        Align.CFrame =
                            StartRotation:Lerp(
                                GoalRotation,
                                Alpha
                            )

                        if PositionAlign then

                            PositionAlign.Position =
                                StartPosition:Lerp(
                                    GoalPosition,
                                    Alpha
                                )

                        end

                        RunService
                            .RenderStepped
                            :Wait()

                    until
                        Alpha >= 1

                    FrameIndex += 1

                    if FrameIndex >
                        #Pose.Animation then

                        FrameIndex = 1

                    end

                end

            end
        )

    else

        Align.CFrame =
            BaseRotation
            *
            CFrame.Angles(
                math.rad(
                    Pose.X or 0
                ),
                math.rad(
                    Pose.Y or 0
                ),
                math.rad(
                    Pose.Z or 0
                )
            )

        if PositionAlign then

            PositionAlign.Position =
                BasePosition +
                Vector3.new(
                    Pose.PX or 0,
                    Pose.PY or 0,
                    Pose.PZ or 0
                )

        end

    end
end
--------------------------------------------------
-- PAGE LOADER
--------------------------------------------------

local function LoadPage()

	for _, Child in ipairs(
		PoseContainer:GetChildren()
	) do

		if Child:IsA("TextButton") then
			Child:Destroy()
		end

	end

	PageLabel.Text =
		string.format(
			"%d / %d",
			CurrentPage,
			math.max(
				#PosePages,
				1
			)
		)

	local Page =
		PosePages[
			CurrentPage
		]

	if not Page then
		return
	end

	for _, PoseName in ipairs(
		Page
	) do

		local Button =
			CreateButton(
				PoseName,
				Color3.fromRGB(
					40,
					40,
					50
				)
			)

		Button.Parent =
			PoseContainer

		Button.MouseButton1Click:Connect(
			function()

				CurrentPose =
					PoseName

				local Pose =
					Poses[
						PoseName
					]

				if Pose then

					ApplyPose(
						Pose
					)

				end

			end
		)

	end

end

--------------------------------------------------
-- PAGE SWITCHING
--------------------------------------------------

PrevPage.MouseButton1Click:Connect(
	function()

		CurrentPage -= 1

		if CurrentPage < 1 then

			CurrentPage =
				math.max(
					#PosePages,
					1
				)

		end

		LoadPage()

	end
)

NextPage.MouseButton1Click:Connect(
	function()

		CurrentPage += 1

		if CurrentPage >
			#PosePages then

			CurrentPage = 1

		end

		LoadPage()

	end
)

--------------------------------------------------
-- DRAWER OPEN/CLOSE
--------------------------------------------------

local function SetDrawer(
	Open
)

	DrawerOpen = Open

	TweenService:Create(
		Panel,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),
		{
			Position =
				Open
				and OPEN_POS
				or CLOSED_POS
		}
	):Play()

	TweenService:Create(
		Arrow,
		TweenInfo.new(
			0.25
		),
		{
			Rotation =
				Open
				and 180
				or 0
		}
	):Play()

end

Handle.MouseButton1Click:Connect(
	function()

		SetDrawer(
			not DrawerOpen
		)

	end
)

--------------------------------------------------
-- DRAGGING
--------------------------------------------------

local Dragging = false
local StartMouseX = 0
local StartOffset = 0

Handle.InputBegan:Connect(
	function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging =
				true

			StartMouseX =
				Input.Position.X

			StartOffset =
				Panel.Position.X.Offset

		end

	end
)

UIS.InputChanged:Connect(
	function(Input)

		if not Dragging then
			return
		end

		if Input.UserInputType ~=
			Enum.UserInputType.MouseMovement then
			return
		end

		local Delta =
			Input.Position.X
			-
			StartMouseX

		local NewOffset =
			math.clamp(
				StartOffset +
				Delta,
				0,
				CLOSED_OFFSET
			)

		Panel.Position =
			UDim2.new(
				1,
				NewOffset,
				0.5,
				-PANEL_HEIGHT/2
			)

		local Progress =
			1 -
			(NewOffset /
			CLOSED_OFFSET)

		Arrow.Rotation =
			180 *
			Progress

	end
)

UIS.InputEnded:Connect(
	function(Input)

		if Input.UserInputType ~=
			Enum.UserInputType.MouseButton1 then
			return
		end

		if not Dragging then
			return
		end

		Dragging =
			false

		if Panel.Position.X.Offset <
			(CLOSED_OFFSET / 2) then

			SetDrawer(
				true
			)

		else

			SetDrawer(
				false
			)

		end

	end
)

--------------------------------------------------
-- DISABLE
--------------------------------------------------

DisableButton.MouseButton1Click:Connect(
	function()

		CurrentPose = nil

		local Character =
			Player.Character

		if not Character then
			return
		end
        AnimationThread += 1

		local Root =
			Character:FindFirstChild(
				"HumanoidRootPart"
			)

		local Humanoid =
			Character:FindFirstChildOfClass(
				"Humanoid"
			)

		if Root then

            local Position =
                Root:FindFirstChild(
                    "PosePosition"
                )

            if Position then

                Position:Destroy()

            end

			local Align =
				Root:FindFirstChild(
					"PoseAlign"
				)

			if Align then
				Align:Destroy()
			end

			local Attachment =
				Root:FindFirstChild(
					"PoseAttachment"
				)

			if Attachment then
				Attachment:Destroy()
			end

		end

		if Humanoid then

			Humanoid:ChangeState(
				Enum.HumanoidStateType
				.GettingUp
			)

		end

	end
)

--------------------------------------------------
-- STARTUP
--------------------------------------------------

LoadPage()

SetDrawer(
	false
)