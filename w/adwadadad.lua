VulcanLIB = VulcanLIB or {}

function VulcanLIB.NewWindow()
    -- Create the GUI elements
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")

    -- Set up the ScreenGui
    ScreenGui.Name = "SmoothDragGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Set up the Frame
    Frame.Name = "DragFrame"
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black color
    Frame.Position = UDim2.new(0.5, -100, 0.5, -50) -- Centered
    Frame.Size = UDim2.new(0, 600, 0, 340) -- Width: 600px, Height: 340px
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Set up rounded corners
    UICorner.Parent = Frame
    UICorner.CornerRadius = UDim.new(0, 12) -- Smooth rounded corners

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

    return Frame
end
