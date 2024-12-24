VulcanLIB = VulcanLIB or {}

function VulcanLIB.NewWindow(titleText)
-- Create the GUI elements
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")  -- Create a TextLabel for the title
local Separator = Instance.new("Frame")  -- Create a separator line

-- Set up the ScreenGui
ScreenGui.Name = "SmoothDragGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Set up the Frame
Frame.Name = "DragFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black color
Frame.Position = UDim2.new(0.5, -100, 0.5, -50) -- Centered
Frame.Size = UDim2.new(0, 650, 0, 350)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Set up rounded corners
UICorner.Parent = Frame
UICorner.CornerRadius = UDim.new(0, 12) -- Smooth rounded corners

-- Set up the Title
Title.Name = "TitleLabel"
Title.Parent = Frame
Title.Text = titleText or "PlaceHolder Title"  -- Use the dynamic title passed to the function

Title.Font = Enum.Font.Creepster
Title.TextSize = 30
Title.TextColor3 = Color3.fromRGB(128, 0, 0)

Title.BackgroundTransparency = 1  -- No background
Title.Size = UDim2.new(0, 200, 0, 50)  -- Width: 200px, Height: 50px
Title.Position = UDim2.new(0, 10, 0, -2)
Title.TextXAlignment = Enum.TextXAlignment.Left 

-- Set up the horizontal separator
Separator.Name = "Separator"
Separator.Parent = Frame
Separator.BorderSizePixel = 0
Separator.BackgroundColor3 = Color3.fromRGB(128, 0, 0)  -- Maroon color
Separator.Size = UDim2.new(1, 0, 0, 5)  -- Full width, 5px height
Separator.Position = UDim2.new(0, 0, 0, 40)  -- Positioned below the title

-- Variables for dragging
local dragging = false
local dragInput, mousePos, framePos

-- Function to smoothly interpolate the position of the frame
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function smoothUpdate(input)
    local delta = input.Position - mousePos
    local targetPosition = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
    Frame:TweenPosition(targetPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.05, true)
end

-- Input events for dragging
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Smooth dragging
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        smoothUpdate(input)
    end
end)

end
