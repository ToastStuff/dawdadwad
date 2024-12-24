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

-- Variables to track the position for the next button
local lastButtonX = 10  -- Initial X position of the first button
local lastButtonY = 55  -- Initial Y position below the separator
local buttonsInRow = 0  -- Track how many buttons are in the current row
local buttonCount = 0    -- Track the total number of buttons created

function VulcanLIB.NewButton(buttonText)
    -- Check if the total number of buttons exceeds 24
    if buttonCount >= 24 then
        return  -- Exit the function without creating a new button
    end

    local Button = Instance.new("TextButton")
    local ButtonUICorner = Instance.new("UICorner")
    
    -- Set up the Button
    Button.Name = "Button"
    Button.Parent = Frame
    Button.Text = buttonText or "Text"
    Button.Font = Enum.Font.Creepster
    Button.TextSize = 22
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)  -- Black text for contrast
    Button.BackgroundColor3 = Color3.fromRGB(128, 0, 0)  -- Maroon button
    Button.Size = UDim2.new(0, 120, 0, 35)  -- Width: 120px, Height: 35px
    
    -- Position the button
    Button.Position = UDim2.new(0, lastButtonX, 0, lastButtonY)

    -- Update the X position for the next button
    lastButtonX = lastButtonX + 120 + 20  -- Increased spacing (20px)


    -- Increment the number of buttons in the current row
    buttonsInRow = buttonsInRow + 1
    buttonCount = buttonCount + 1  -- Increment the total button count

    -- If 4 buttons are created in the current row, move to the next row
    if buttonsInRow == 4 then
        -- Reset X position to the start of the next row
        lastButtonX = 10
        -- Move Y position down by the height of the button plus spacing
        lastButtonY = lastButtonY + 35 + 10  -- 35px for button height + 10px for spacing
        -- Reset the row count
        buttonsInRow = 0
    end

    -- Add rounded corners to the button
    ButtonUICorner.Parent = Button
    ButtonUICorner.CornerRadius = UDim.new(0, 12)
end






end
