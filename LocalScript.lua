local player = game.Players.LocalPlayer
local isAdminfunc = game:GetService("ReplicatedStorage"):WaitForChild("IsAdmin")


--===========================================================================================
--===========================================================================================
--===========================================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdminGui"
ScreenGui.Parent = player.PlayerGui

--===========================================================================================
--===========================================================================================
--===========================================================================================

local Frame = Instance.new("Frame")
Frame.Name = "Admin Container"
Frame.Size = UDim2.new(0,400,0,300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(27, 23, 70)
Frame.Transparency = 0.5
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

local isAdmin = isAdminfunc:InvokeServer()

if isAdmin then
	Frame.Visible = true
else
	Frame.Visible = false
end

--===========================================================================================
--===========================================================================================
--===========================================================================================

local NameFrame = Instance.new("TextLabel")
NameFrame.Text = "Admin Panel"
NameFrame.BackgroundTransparency = 0.5
NameFrame.Size = UDim2.new(1, 0, 0, 50)
NameFrame.Position = UDim2.new(0, 0, 0, 0)
NameFrame.Parent = Frame

--===========================================================================================
--===========================================================================================
--===========================================================================================

local KickButton = Instance.new("TextButton")
KickButton.Text = "Kick"
KickButton.TextScaled = true
KickButton.BackgroundColor = BrickColor.new("Black metallic")
KickButton.Font = Enum.Font.Jura
KickButton.Size = UDim2.new(0.5, -75, 0, 45)
KickButton.Position = UDim2.new(0,0,0,70)
KickButton.Parent = Frame

--===========================================================================================
--===========================================================================================
--===========================================================================================

local BanButton = Instance.new("TextButton")
BanButton.Text = "Ban"
BanButton.TextScaled = true
BanButton.BackgroundColor = BrickColor.new("Black metallic")
BanButton.Font = Enum.Font.Jura
BanButton.Size = UDim2.new(0.5, -75, 0, 45)
BanButton.Position = UDim2.new(0,0,0,70 * 2)
BanButton.Parent = Frame

--===========================================================================================
--===========================================================================================
--===========================================================================================

local TpButton = Instance.new("TextButton")
TpButton.Text = "Tp"
TpButton.TextScaled = true
TpButton.BackgroundColor = BrickColor.new("Black metallic")
TpButton.Font = Enum.Font.Jura
TpButton.Size = UDim2.new(0.5, -75, 0, 45)
TpButton.Position = UDim2.new(0,0,0,70 * 3)
TpButton.Parent = Frame

--===========================================================================================
--===========================================================================================
--===========================================================================================

local TextBox = Instance.new("TextBox") 
TextBox.Size = UDim2.new(1, 0, 0, 40)
TextBox.Position = UDim2.new(0, 0, 1, -45)
TextBox.Parent = Frame
TextBox.Visible = false

--===========================================================================================
--===========================================================================================
--===========================================================================================

local KickEvent = game:GetService("ReplicatedStorage"):WaitForChild("KickPanel")
local BanEvent = game:GetService("ReplicatedStorage"):WaitForChild("BanPanel")
local TpEvent = game:GetService("ReplicatedStorage"):WaitForChild("TpPanel")

local currentAction = nil

--===========================================================================================
--===========================================================================================
--===========================================================================================

KickButton.MouseButton1Click:Connect(function()
	currentAction = "kick"
	TextBox.Visible = true
	TextBox.PlaceholderText = "Player name..."
	TextBox:CaptureFocus()
end)

BanButton.MouseButton1Click:Connect(function()
	currentAction = "ban"
	TextBox.Visible = true
	TextBox.PlaceholderText = "Player name..."
	TextBox:CaptureFocus()
end)

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and TextBox.Text ~= "" then
		if currentAction == "kick" then
			KickEvent:FireServer(TextBox.Text)
		elseif currentAction == "ban" then
			BanEvent:FireServer(TextBox.Text)
		end
		TextBox.Text = ""
		TextBox.Visible = false
		currentAction = nil
	end
end)

--===========================================================================================
--===========================================================================================
--===========================================================================================

TpButton.MouseButton1Click:Connect(function()
	TextBox.Visible = true
	TextBox.PlaceholderText = "Player1.Player2"
	TextBox:CaptureFocus()
end)

TextBox.FocusLost:Connect(function(enterPressed)
	if currentAction == "ban" or currentAction == "kick" then return end
	
	if enterPressed and TextBox.Text ~= "" then
		local Names = string.split(TextBox.Text, " ")
		
		if not Names[1] or not Names[2] then
			print("Scrivi due nomi separati da spazio")
			return
		end
		
		TpEvent:FireServer(Names[1], Names[2])
		TextBox.Text = ""
		TextBox.Visible = false
	end
end)