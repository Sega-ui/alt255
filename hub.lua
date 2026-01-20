local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local function isTargetVisible(targetPart)
	if not targetPart then return false end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {player.Character}

	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)

	local result = workspace:Raycast(origin, direction, params)
	return result and result.Instance:IsDescendantOf(targetPart.Parent)
end
-- GUI AYARLARI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.Enabled = false -- Başlangıçta kapalı

-- KEYBIND AYARI (Değiştirebilirsin)
local OPEN_KEY = Enum.KeyCode.Insert -- INSERT tuşu

-- FARE KONTROLÜ
local mouse = player:GetMouse()
local MouseIconVisible = true

-- FARE GÖRÜNÜRLÜĞÜNÜ DEĞİŞTİR
local function setMouseVisibility(visible)
    if UIS.MouseEnabled then
        UIS.MouseIconEnabled = visible
        MouseIconVisible = visible
    end
end

-- GUI TOGGLE FONKSİYONU
local function toggleGUI()
    gui.Enabled = not gui.Enabled
    
    if gui.Enabled then
        -- GUI açıldığında fareyi aktif et
        setMouseVisibility(true)
        print("GMOD NEON HUB açıldı - INSERT tuşuna basarak kapatabilirsin")
    else
        -- GUI kapandığında fareyi oyun kontrolüne geri döndür
        setMouseVisibility(false)
        print("GMOD NEON HUB kapandı")
    end
end

-- KEYBIND INPUT
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Oyun input'larına müdahale etme
    
    if input.KeyCode == OPEN_KEY then
        toggleGUI()
    end
end)

-- FPS MODUNDA FARE KİTLİ KALMASIN DİYE
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if gui.Enabled and input.UserInputType == Enum.UserInputType.MouseMovement then
        -- GUI açıkken fare hareketi engellenmesin
        if not MouseIconVisible then
            setMouseVisibility(true)
        end
    end
end)

-- ESC'YE BASINCA GUI KAPANSIN
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gui.Enabled and input.KeyCode == Enum.KeyCode.Escape then
        gui.Enabled = false
        setMouseVisibility(false)
    end
end)

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(820, 460)
main.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(410,230)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.BorderSizePixel = 0

-- GUI AÇILDIĞINDA FARE KİTLİLİĞİNİ ÖNLEMEK İÇİN
main.Active = true
main.Selectable = true

-- RGB STROKE
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,14)

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,42)
top.BackgroundColor3 = Color3.fromRGB(25,25,30)
top.BorderSizePixel = 0
top.Active = true
top.Selectable = true

local topCorner = Instance.new("UICorner", top)
topCorner.CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "GMOD NEON HUB [INSERT]"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- KEYBIND BİLGİSİ
local keybindInfo = Instance.new("TextLabel", top)
keybindInfo.Size = UDim2.new(0,120,1,0)
keybindInfo.Position = UDim2.new(1,-130,0,0)
keybindInfo.BackgroundTransparency = 1
keybindInfo.Text = "INSERT: Aç/Kapa"
keybindInfo.TextColor3 = Color3.fromRGB(0,255,255)
keybindInfo.Font = Enum.Font.Gotham
keybindInfo.TextSize = 12
keybindInfo.TextXAlignment = Enum.TextXAlignment.Right

-- DRAG (ONLY TOP)
local dragging, dragStart, startPos
top.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)
top.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- BODY
local body = Instance.new("Frame", main)
body.Position = UDim2.new(0,0,0,42)
body.Size = UDim2.new(1,0,1,-42)
body.BackgroundTransparency = 1
body.Active = true
body.Selectable = true

-- TABS LEFT
local tabs = Instance.new("Frame", body)
tabs.Size = UDim2.fromOffset(180, body.AbsoluteSize.Y)
tabs.BackgroundColor3 = Color3.fromRGB(20,20,25)
tabs.BorderSizePixel = 0
tabs.Active = true

local tabsCorner = Instance.new("UICorner", tabs)
tabsCorner.CornerRadius = UDim.new(0,12)

-- CONTENT RIGHT
local content = Instance.new("Frame", body)
content.Position = UDim2.fromOffset(190,10)
content.Size = UDim2.new(1,-200,1,-20)
content.BackgroundColor3 = Color3.fromRGB(18,18,22)
content.BorderSizePixel = 0
content.Active = true

local contentCorner = Instance.new("UICorner", content)
contentCorner.CornerRadius = UDim.new(0,12)

-- TAB SYSTEM
local pages = {}

local function createTab(name, order)
	local btn = Instance.new("TextButton", tabs)
	btn.Size = UDim2.fromOffset(160,40)
	btn.Position = UDim2.fromOffset(10, 10 + (order-1)*50)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = true
	btn.Active = true
	btn.Selectable = true

	local bc = Instance.new("UICorner", btn)
	bc.CornerRadius = UDim.new(0,10)

	local page = Instance.new("Frame", content)
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Active = true

	pages[name] = page

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible = false end
		page.Visible = true
	end)

	return page
end

-- CREATE TABS
local movement = createTab("Movement", 1)
local playersTab = createTab("Players", 2)
local visuals = createTab("Visuals", 3)
local misc = createTab("Misc", 4)

movement.Visible = true

-- RGB + PULSE
local t = 0
RunService.RenderStepped:Connect(function(dt)
	t += dt
	local hue = (t*0.15)%1
	stroke.Color = Color3.fromHSV(hue,1,1)
	stroke.Thickness = 2.5 + math.sin(t*3)*1
end)

-- KARAKTER DEĞİŞKENLERİ
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- ========== MOVEMENT TAB ==========

-- SPEED TOGGLE
local speedOn = false
local speed = 30

local speedBtn = Instance.new("TextButton", movement)
speedBtn.Size = UDim2.fromOffset(180,40)
speedBtn.Position = UDim2.fromOffset(20,20)
speedBtn.Text = "Speed: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
speedBtn.TextColor3 = Color3.fromRGB(0,255,255)
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 14
speedBtn.AutoButtonColor = true
speedBtn.Active = true
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0,8)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
	hum.WalkSpeed = speedOn and speed or 16
end)

-- SPEED SLIDER
local sBar = Instance.new("Frame", movement)
sBar.Size = UDim2.fromOffset(260,6)
sBar.Position = UDim2.fromOffset(20,70)
sBar.BackgroundColor3 = Color3.fromRGB(60,60,70)
sBar.Active = true

local sFill = Instance.new("Frame", sBar)
sFill.Size = UDim2.new(0.3,0,1,0)
sFill.BackgroundColor3 = Color3.fromRGB(0,255,255)

sBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local c; c = UIS.InputChanged:Connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp(
					(m.Position.X - sBar.AbsolutePosition.X) / sBar.AbsoluteSize.X,
					0,1
				)
				sFill.Size = UDim2.new(pct,0,1,0)
				speed = math.floor(16 + pct*100)
				if speedOn then hum.WalkSpeed = speed end
			end
		end)
		UIS.InputEnded:Once(function() 
			if c then 
				c:Disconnect() 
			end 
		end)
	end
end)

-- FLY SİSTEMİ
local flyOn = false
local flySpeed = 50
local flying = false
local flyBV = nil
local flyBG = nil

-- FLY BUTTON
local flyBtn = Instance.new("TextButton", movement)
flyBtn.Size = UDim2.fromOffset(180,40)
flyBtn.Position = UDim2.fromOffset(20,120)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
flyBtn.TextColor3 = Color3.fromRGB(0,255,255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 14
flyBtn.AutoButtonColor = true
flyBtn.Active = true
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0,8)

-- FLY SPEED SLIDER
local flySpeedLabel = Instance.new("TextLabel", movement)
flySpeedLabel.Size = UDim2.fromOffset(260,30)
flySpeedLabel.Position = UDim2.fromOffset(20,170)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Fly Speed: " .. flySpeed
flySpeedLabel.TextColor3 = Color3.fromRGB(0,255,255)
flySpeedLabel.Font = Enum.Font.GothamBold
flySpeedLabel.TextSize = 14

local flySpeedBar = Instance.new("Frame", movement)
flySpeedBar.Size = UDim2.fromOffset(260,6)
flySpeedBar.Position = UDim2.fromOffset(20,200)
flySpeedBar.BackgroundColor3 = Color3.fromRGB(60,60,70)
flySpeedBar.Active = true

local flySpeedFill = Instance.new("Frame", flySpeedBar)
flySpeedFill.Size = UDim2.new(flySpeed / 200, 0, 1, 0)
flySpeedFill.BackgroundColor3 = Color3.fromRGB(0,255,255)

-- FLY SPEED SLIDER LOGIC
flySpeedBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local c; c = UIS.InputChanged:Connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp(
					(m.Position.X - flySpeedBar.AbsolutePosition.X) / flySpeedBar.AbsoluteSize.X,
					0,1
				)
				flySpeedFill.Size = UDim2.new(pct,0,1,0)
				flySpeed = math.floor(10 + pct * 190)
				flySpeedLabel.Text = "Fly Speed: " .. flySpeed
			end
		end)
		UIS.InputEnded:Once(function()
			if c then 
				c:Disconnect() 
			end
		end)
	end
end)

-- NOCLIP SİSTEMİ
local noclipOn = false
local noclipLoop = nil

-- NOCLIP BUTTON
local noclipBtn = Instance.new("TextButton", movement)
noclipBtn.Size = UDim2.fromOffset(180,40)
noclipBtn.Position = UDim2.fromOffset(20,230)
noclipBtn.Text = "NoClip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
noclipBtn.TextColor3 = Color3.fromRGB(0,255,255)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 14
noclipBtn.AutoButtonColor = true
noclipBtn.Active = true
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0,8)

-- FLY FONKSİYONU
local function startFly()
	if not player.Character then return end
	local character = player.Character
	local humanoid = character:FindFirstChild("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not humanoid or not rootPart then return end
	
	flying = true
	
	-- BodyVelocity ve BodyGyro ekle
	flyBV = Instance.new("BodyVelocity")
	flyBV.P = 10000
	flyBV.MaxForce = Vector3.new(100000, 100000, 100000)
	flyBV.Velocity = Vector3.new(0, 0, 0)
	flyBV.Parent = rootPart
	
	flyBG = Instance.new("BodyGyro")
	flyBG.P = 10000
	flyBG.MaxTorque = Vector3.new(100000, 100000, 100000)
	flyBG.CFrame = rootPart.CFrame
	flyBG.Parent = rootPart
	
	-- Fly kontrol loop'u
	local flyConnection
	flyConnection = RunService.RenderStepped:Connect(function()
		if not flying or not rootPart or not flyBV then
			flyConnection:Disconnect()
			return
		end
		
		local camera = workspace.CurrentCamera
		local direction = Vector3.new(0, 0, 0)
		
		-- W, A, S, D kontrolleri
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			direction = direction + camera.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			direction = direction - camera.CFrame.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			direction = direction - camera.CFrame.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			direction = direction + camera.CFrame.RightVector
		end
		
		-- Space ve Shift kontrolleri
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			direction = direction + Vector3.new(0, 1, 0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then
			direction = direction + Vector3.new(0, -1, 0)
		end
		
		-- Hızı uygula
		if direction.Magnitude > 0 then
			direction = direction.Unit * flySpeed
		end
		
		flyBV.Velocity = direction
		
		-- Kamera yönünü takip et
		if flyBG then
			flyBG.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
		end
	end)
	
	humanoid.PlatformStand = true
	print("Fly Aktif! W,A,S,D = Hareket, Space = Yukarı, Shift = Aşağı")
end

local function stopFly()
	flying = false
	
	if player.Character then
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
		
		local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			if flyBV then flyBV:Destroy() flyBV = nil end
			if flyBG then flyBG:Destroy() flyBG = nil end
		end
	end
	
	print("Fly Kapalı")
end

-- FLY TOGGLE
flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"
	
	if flyOn then
		startFly()
	else
		stopFly()
	end
end)

-- NOCLIP FONKSİYONU
local function startNoclip()
	if noclipLoop then noclipLoop:Disconnect() end
	
	noclipLoop = RunService.Stepped:Connect(function()
		if noclipOn and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		else
			if noclipLoop then
				noclipLoop:Disconnect()
				noclipLoop = nil
			end
		end
	end)
	
	print("NoClip Aktif!")
end

local function stopNoclip()
	if noclipLoop then
		noclipLoop:Disconnect()
		noclipLoop = nil
	end
	
	-- Collision'ı geri aç
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
	
	print("NoClip Kapalı")
end

-- NOCLIP TOGGLE
noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = noclipOn and "NoClip: ON" or "NoClip: OFF"
	
	if noclipOn then
		startNoclip()
	else
		stopNoclip()
	end
end)

-- ========== PLAYERS TAB ==========

-- GOTO INPUT
local box = Instance.new("TextBox", playersTab)
box.Size = UDim2.fromOffset(200,36)
box.Position = UDim2.fromOffset(20,20)
box.PlaceholderText = "oyuncu adı"
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(30,30,40)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.ClearTextOnFocus = false
box.Active = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

local gotoBtn = Instance.new("TextButton", playersTab)
gotoBtn.Size = UDim2.fromOffset(120,36)
gotoBtn.Position = UDim2.fromOffset(230,20)
gotoBtn.Text = "GOTO"
gotoBtn.BackgroundColor3 = Color3.fromRGB(40,40,55)
gotoBtn.TextColor3 = Color3.fromRGB(0,255,255)
gotoBtn.Font = Enum.Font.GothamBold
gotoBtn.TextSize = 14
gotoBtn.AutoButtonColor = true
gotoBtn.Active = true
Instance.new("UICorner", gotoBtn).CornerRadius = UDim.new(0,8)

gotoBtn.MouseButton1Click:Connect(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1,#box.Text) == box.Text:lower() then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
				end
			end
		end
	end
end)

-- ========== VISUALS TAB ==========

-- FULLBRIGHT
local fbOn = false

local fbBtn = Instance.new("TextButton", visuals)
fbBtn.Size = UDim2.fromOffset(200,40)
fbBtn.Position = UDim2.fromOffset(20,20)
fbBtn.Text = "Fullbright: OFF"
fbBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
fbBtn.TextColor3 = Color3.fromRGB(0,255,255)
fbBtn.Font = Enum.Font.GothamBold
fbBtn.TextSize = 14
fbBtn.AutoButtonColor = true
fbBtn.Active = true
Instance.new("UICorner", fbBtn).CornerRadius = UDim.new(0,8)

fbBtn.MouseButton1Click:Connect(function()
	fbOn = not fbOn
	fbBtn.Text = fbOn and "Fullbright: ON" or "Fullbright: OFF"
	Lighting.Brightness = fbOn and 5 or 1
	Lighting.ClockTime = fbOn and 14 or 12
end)

-- PLAYER ESP
local espOn = false
local espObjects = {}
local maxESPDistance = 500

-- ESP BUTTON
local espBtn = Instance.new("TextButton", visuals)
espBtn.Size = UDim2.fromOffset(220,40)
espBtn.Position = UDim2.fromOffset(20,80)
espBtn.Text = "Player ESP: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
espBtn.TextColor3 = Color3.fromRGB(0,255,255)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 14
espBtn.AutoButtonColor = true
espBtn.Active = true
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,8)

-- ESP DISTANCE LABEL
local distLabel = Instance.new("TextLabel", visuals)
distLabel.Size = UDim2.fromOffset(260,30)
distLabel.Position = UDim2.fromOffset(20,130)
distLabel.BackgroundTransparency = 1
distLabel.Text = "ESP Distance: " .. maxESPDistance
distLabel.TextColor3 = Color3.fromRGB(0,255,255)
distLabel.Font = Enum.Font.GothamBold
distLabel.TextSize = 14

-- DISTANCE SLIDER BAR
local dBar = Instance.new("Frame", visuals)
dBar.Size = UDim2.fromOffset(260,6)
dBar.Position = UDim2.fromOffset(20,165)
dBar.BackgroundColor3 = Color3.fromRGB(60,60,70)
dBar.Active = true

local dFill = Instance.new("Frame", dBar)
dFill.Size = UDim2.new(maxESPDistance / 1500, 0, 1, 0)
dFill.BackgroundColor3 = Color3.fromRGB(0,255,255)

-- SLIDER LOGIC
dBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local c; c = UIS.InputChanged:Connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp(
					(m.Position.X - dBar.AbsolutePosition.X) / dBar.AbsoluteSize.X,
					0,1
				)
				dFill.Size = UDim2.new(pct,0,1,0)
				maxESPDistance = math.floor(50 + pct * 1450)
				distLabel.Text = "ESP Distance: " .. maxESPDistance
			end
		end)
		UIS.InputEnded:Once(function()
			if c then 
				c:Disconnect() 
			end
		end)
	end
end)

-- WALL CHECK FUNCTION
local function isVisible(targetHRP)
	local myCharacter = player.Character
	if not myCharacter then return false end
	
	local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
	if not myHRP then return false end
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {myCharacter}
	
	local origin = Camera.CFrame.Position
	local direction = (targetHRP.Position - origin).Unit * (origin - targetHRP.Position).Magnitude
	
	local result = workspace:Raycast(origin, direction, params)
	if result and result.Instance:IsDescendantOf(targetHRP.Parent) then
		return true
	end
	return false
end

-- CREATE ESP
local function createESP(plr)
	if plr == player then return end
	if not plr.Character then return end
	if not plr.Character:FindFirstChild("HumanoidRootPart") then return end

	-- Highlight
	local hl = Instance.new("Highlight")
	hl.FillTransparency = 0.5
	hl.OutlineTransparency = 0
	hl.Parent = plr.Character

	-- NAME TAG
	local bill = Instance.new("BillboardGui")
	bill.Size = UDim2.fromOffset(200,40)
	bill.AlwaysOnTop = true
	bill.StudsOffset = Vector3.new(0,3,0)
	bill.Parent = plr.Character.HumanoidRootPart

	local txt = Instance.new("TextLabel", bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = plr.Name
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 14
	txt.TextStrokeTransparency = 0
	txt.TextColor3 = Color3.fromRGB(0,255,0)

	espObjects[plr] = {hl = hl, bill = bill, txt = txt}
end

-- REMOVE ESP
local function removeESP(plr)
	if espObjects[plr] then
		if espObjects[plr].hl then espObjects[plr].hl:Destroy() end
		if espObjects[plr].bill then espObjects[plr].bill:Destroy() end
		espObjects[plr] = nil
	end
end

-- ESP UPDATE LOOP
RunService.RenderStepped:Connect(function()
	if not espOn then return end
	
	local myCharacter = player.Character
	if not myCharacter then return end
	
	local myHRP = myCharacter:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end
	
	for plr, data in pairs(espObjects) do
		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = plr.Character.HumanoidRootPart
			
			-- Mesafe kontrolü
			local dist = (myHRP.Position - targetHRP.Position).Magnitude
			
			if dist > maxESPDistance then
				data.hl.Enabled = false
				data.bill.Enabled = false
			else
				data.hl.Enabled = true
				data.bill.Enabled = true
				
				-- Görünürlük kontrolü
				local visible = isVisible(targetHRP)
				if visible then
					data.hl.FillColor = Color3.fromRGB(0, 255, 0)
					data.txt.TextColor3 = Color3.fromRGB(0, 255, 0)
				else
					data.hl.FillColor = Color3.fromRGB(255, 0, 0)
					data.txt.TextColor3 = Color3.fromRGB(255, 0, 0)
				end
			end
		else
			-- Karakter yoksa ESP'yi kapat
			data.hl.Enabled = false
			data.bill.Enabled = false
		end
	end
end)

-- ESP TOGGLE
espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "Player ESP: ON" or "Player ESP: OFF"

	if espOn then
		for _,plr in pairs(Players:GetPlayers()) do
			createESP(plr)
		end
	else
		for plr,_ in pairs(espObjects) do
			removeESP(plr)
		end
	end
end)

-- ========== MISC TAB ==========

-- INFO
local info = Instance.new("TextLabel", misc)
info.Size = UDim2.fromOffset(360,100)
info.Position = UDim2.fromOffset(20,20)
info.BackgroundTransparency = 1
info.Text = "GMOD NEON HUB\n\nINSERT: Aç/Kapa\nESC: Kapat\nFare: GUI Kontrolü\n\nFPS modunda fare kilitli kalırsa INSERT'a bas!"
info.TextColor3 = Color3.fromRGB(0,255,255)
info.Font = Enum.Font.GothamBold
info.TextSize = 16
info.TextWrapped = true

-- KONTROL TUŞLARI İÇİN MESAJ EKLE
local controlsInfo = Instance.new("TextLabel", misc)
controlsInfo.Size = UDim2.fromOffset(360, 120)
controlsInfo.Position = UDim2.fromOffset(20, 130)
controlsInfo.BackgroundTransparency = 1
controlsInfo.Text = "🏃 FLY KONTROLLERİ:\nW,A,S,D = Hareket\nSpace = Yukarı Çık\nShift = Aşağı İn\n\n🎮 NOCLIP:\nAktif edince duvardan geçebilirsin!"
controlsInfo.TextColor3 = Color3.fromRGB(0, 255, 255)
controlsInfo.Font = Enum.Font.GothamBold
controlsInfo.TextSize = 14
controlsInfo.TextWrapped = true
controlsInfo.TextXAlignment = Enum.TextXAlignment.Left

-- ========== OLAY İŞLEYİCİLER ==========

-- PLAYER JOIN/LEAVE ESP
Players.PlayerAdded:Connect(function(plr)
	if espOn then
		plr.CharacterAdded:Wait()
		task.wait(1)
		createESP(plr)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	removeESP(plr)
end)

-- RESPAWN FIX FOR ESP
for _,plr in pairs(Players:GetPlayers()) do
	plr.CharacterAdded:Connect(function()
		if espOn then
			task.wait(1)
			createESP(plr)
		end
	end)
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espOn then
			task.wait(1)
			createESP(plr)
		end
	end)
end)

-- KARAKTER DEĞİŞİKLİĞİNDE DÜZELTME
player.CharacterAdded:Connect(function(character)
	task.wait(0.5)
	
	-- Speed'ı yeniden uygula
	if speedOn then
		local hum = character:WaitForChild("Humanoid")
		hum.WalkSpeed = speed
	end
	
	-- Fly'ı yeniden başlat
	if flyOn then
		stopFly()
		task.wait(0.1)
		startFly()
	end
	
	-- NoClip'ı yeniden başlat
	if noclipOn then
		stopNoclip()
		task.wait(0.1)
		startNoclip()
	end
end)

-- ========== AIMBOT SİSTEMİ ==========

local aimbotOn = false
local silentAimOn = false
local aimbotKey = Enum.KeyCode.F -- F tuşuna basılı tutunca aktif
local aimbotFOV = 100 -- Field of View (görüş alanı)
local aimbotSmoothness = 20 -- Yumuşaklık (1 = anında, 100 = çok yavaş)
local aimbotPart = "Head" -- Varsayılan hedef: Head, Torso, HumanoidRootPart

-- AIMBOT DEĞİŞKENLERİ
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- VISUALS: FOV CIRCLE
local circle = Drawing.new("Circle")
circle.Visible = false
circle.Color = Color3.fromRGB(0, 255, 255)
circle.Thickness = 2
circle.Radius = aimbotFOV
circle.Filled = false
circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

-- EN YAKIN OYUNCUYU BUL
local function getClosestPlayer()
	if not player.Character then return nil end
	local myHead = player.Character:FindFirstChild("Head")
	if not myHead then return nil end
	
	local closestPlayer = nil
	local closestDistance = aimbotFOV
	local mousePos = Vector2.new(mouse.X, mouse.Y)
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local targetHead = plr.Character:FindFirstChild(aimbotPart)
			if targetHead then
				local screenPos, onScreen = camera:WorldToViewportPoint(targetHead.Position)
				
				if onScreen then
					local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
					local distance = (mousePos - screenPoint).Magnitude
					
					if distance < closestDistance then
						closestDistance = distance
						closestPlayer = plr
					end
				end
			end
		end
	end
	
	return closestPlayer
end

-- SILENT AIM: MOUSE'U HEDEFE YÖNLENDİR (gizli)
local function silentAim()
	if not silentAimOn then return end
	
	local closestPlayer = getClosestPlayer()
	if not closestPlayer or not closestPlayer.Character then return end
	
	local targetPart = closestPlayer.Character:FindFirstChild(aimbotPart)
	if not targetPart then return end
	
	-- Mouse pozisyonunu hesapla (ama gerçek mouse'u hareket ettirme)
	local screenPos = camera:WorldToViewportPoint(targetPart.Position)
	local mousePos = Vector2.new(screenPos.X, screenPos.Y)
	
	-- Burada mouse pozisyonunu manipüle edebilirsin
	-- (Advanced: mouse hooking gerekebilir)
end

-- REGULAR AIMBOT: MOUSE'U HEDEFE KİTLET
local function regularAimbot()
	if not aimbotOn then return end

	local targetPlr = getClosestPlayer()
	if not targetPlr then return end
	if not targetPlr.Character then return end

local targetPart = targetPlr.Character:FindFirstChild(aimbotPart)
if not targetPart then return end
if not isTargetVisible(targetPart) then return end

	local camCF = camera.CFrame
	local camPos = camCF.Position

	-- hedefe bakılacak CFrame
	local targetCF = CFrame.new(camPos, targetPart.Position)

	-- smooth aim (lerp)
	camera.CFrame = camCF:Lerp(targetCF, 1 / aimbotSmoothness)
end
-- ========== GUI ELEMENTS ==========

-- AIMBOT TAB'INI OLUŞTUR
local aimbotTab = createTab("Aimbot", 5) -- Yeni tab ekle

-- AIMBOT TOGGLE BUTTON
local aimbotToggleBtn = Instance.new("TextButton", aimbotTab)
aimbotToggleBtn.Size = UDim2.fromOffset(200, 40)
aimbotToggleBtn.Position = UDim2.fromOffset(20, 20)
aimbotToggleBtn.Text = "Aimbot: OFF (Hold F)"
aimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
aimbotToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
aimbotToggleBtn.Font = Enum.Font.GothamBold
aimbotToggleBtn.TextSize = 14
Instance.new("UICorner", aimbotToggleBtn).CornerRadius = UDim.new(0, 8)

-- SILENT AIM TOGGLE BUTTON
local silentAimBtn = Instance.new("TextButton", aimbotTab)
silentAimBtn.Size = UDim2.fromOffset(200, 40)
silentAimBtn.Position = UDim2.fromOffset(240, 20)
silentAimBtn.Text = "Silent Aim: OFF"
silentAimBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
silentAimBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
silentAimBtn.Font = Enum.Font.GothamBold
silentAimBtn.TextSize = 14
Instance.new("UICorner", silentAimBtn).CornerRadius = UDim.new(0, 8)

-- FOV SLIDER
local fovLabel = Instance.new("TextLabel", aimbotTab)
fovLabel.Size = UDim2.fromOffset(200, 30)
fovLabel.Position = UDim2.fromOffset(20, 80)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. aimbotFOV
fovLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
fovLabel.Font = Enum.Font.GothamBold
fovLabel.TextSize = 14

local fovBar = Instance.new("Frame", aimbotTab)
fovBar.Size = UDim2.fromOffset(260, 6)
fovBar.Position = UDim2.fromOffset(20, 110)
fovBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

local fovFill = Instance.new("Frame", fovBar)
fovFill.Size = UDim2.new(aimbotFOV / 500, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

fovBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local c; c = UIS.InputChanged:Connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp((m.Position.X - fovBar.AbsolutePosition.X) / fovBar.AbsoluteSize.X, 0, 1)
				fovFill.Size = UDim2.new(pct, 0, 1, 0)
				aimbotFOV = math.floor(10 + pct * 490)
				fovLabel.Text = "FOV: " .. aimbotFOV
				circle.Radius = aimbotFOV
			end
		end)
		UIS.InputEnded:Once(function()
			if c then c:Disconnect() end
		end)
	end
end)

-- SMOOTHNESS SLIDER
local smoothLabel = Instance.new("TextLabel", aimbotTab)
smoothLabel.Size = UDim2.fromOffset(200, 30)
smoothLabel.Position = UDim2.fromOffset(20, 140)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "Smoothness: " .. aimbotSmoothness
smoothLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
smoothLabel.Font = Enum.Font.GothamBold
smoothLabel.TextSize = 14

local smoothBar = Instance.new("Frame", aimbotTab)
smoothBar.Size = UDim2.fromOffset(260, 6)
smoothBar.Position = UDim2.fromOffset(20, 170)
smoothBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

local smoothFill = Instance.new("Frame", smoothBar)
smoothFill.Size = UDim2.new(aimbotSmoothness / 100, 0, 1, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

smoothBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		local c; c = UIS.InputChanged:Connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseMovement then
				local pct = math.clamp((m.Position.X - smoothBar.AbsolutePosition.X) / smoothBar.AbsoluteSize.X, 0, 1)
				smoothFill.Size = UDim2.new(pct, 0, 1, 0)
				aimbotSmoothness = math.floor(1 + pct * 99)
				smoothLabel.Text = "Smoothness: " .. aimbotSmoothness
			end
		end)
		UIS.InputEnded:Once(function()
			if c then c:Disconnect() end
		end)
	end
end)

-- TARGET PART SELECTOR
local partLabel = Instance.new("TextLabel", aimbotTab)
partLabel.Size = UDim2.fromOffset(200, 30)
partLabel.Position = UDim2.fromOffset(20, 200)
partLabel.BackgroundTransparency = 1
partLabel.Text = "Target: " .. aimbotPart
partLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
partLabel.Font = Enum.Font.GothamBold
partLabel.TextSize = 14

local parts = {"Head", "Torso", "HumanoidRootPart", "LeftFoot", "RightFoot", "LeftHand", "RightHand"}

local partDropdown = Instance.new("TextButton", aimbotTab)
partDropdown.Size = UDim2.fromOffset(180, 36)
partDropdown.Position = UDim2.fromOffset(20, 230)
partDropdown.Text = "▼ " .. aimbotPart
partDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
partDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
partDropdown.Font = Enum.Font.Gotham
partDropdown.TextSize = 14
Instance.new("UICorner", partDropdown).CornerRadius = UDim.new(0, 6)

local dropdownOpen = false
local dropdownFrame

partDropdown.MouseButton1Click:Connect(function()
	if dropdownOpen then
		if dropdownFrame then dropdownFrame:Destroy() end
		dropdownOpen = false
		partDropdown.Text = "▼ " .. aimbotPart
		return
	end
	
	dropdownOpen = true
	partDropdown.Text = "▲ " .. aimbotPart
	
	dropdownFrame = Instance.new("Frame", aimbotTab)
	dropdownFrame.Size = UDim2.fromOffset(180, 200)
	dropdownFrame.Position = UDim2.fromOffset(20, 266)
	dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	dropdownFrame.BorderSizePixel = 0
	Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 6)
	
	local yPos = 5
	for _, partName in pairs(parts) do
		local partBtn = Instance.new("TextButton", dropdownFrame)
		partBtn.Size = UDim2.fromOffset(170, 28)
		partBtn.Position = UDim2.fromOffset(5, yPos)
		partBtn.Text = partName
		partBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
		partBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		partBtn.Font = Enum.Font.Gotham
		partBtn.TextSize = 12
		Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0, 4)
		
		partBtn.MouseButton1Click:Connect(function()
			aimbotPart = partName
			partLabel.Text = "Target: " .. aimbotPart
			partDropdown.Text = "▼ " .. aimbotPart
			dropdownFrame:Destroy()
			dropdownOpen = false
		end)
		
		yPos = yPos + 30
	end
end)

-- FOV CIRCLE TOGGLE
local fovCircleBtn = Instance.new("TextButton", aimbotTab)
fovCircleBtn.Size = UDim2.fromOffset(200, 36)
fovCircleBtn.Position = UDim2.fromOffset(240, 140)
fovCircleBtn.Text = "FOV Circle: ON"
fovCircleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
fovCircleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
fovCircleBtn.Font = Enum.Font.GothamBold
fovCircleBtn.TextSize = 14
Instance.new("UICorner", fovCircleBtn).CornerRadius = UDim.new(0, 8)

fovCircleBtn.MouseButton1Click:Connect(function()
	circle.Visible = not circle.Visible
	fovCircleBtn.Text = circle.Visible and "FOV Circle: ON" or "FOV Circle: OFF"
end)

-- AIMBOT KEY CHANGER
local keyLabel = Instance.new("TextLabel", aimbotTab)
keyLabel.Size = UDim2.fromOffset(200, 30)
keyLabel.Position = UDim2.fromOffset(240, 190)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Key: F (Hold)"
keyLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 14

local keyButton = Instance.new("TextButton", aimbotTab)
keyButton.Size = UDim2.fromOffset(80, 36)
keyButton.Position = UDim2.fromOffset(240, 220)
keyButton.Text = "CHANGE"
keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keyButton.Font = Enum.Font.GothamBold
keyButton.TextSize = 12
Instance.new("UICorner", keyButton).CornerRadius = UDim.new(0, 6)

local listeningForKey = false
keyButton.MouseButton1Click:Connect(function()
	listeningForKey = true
	keyButton.Text = "PRESS KEY"
	keyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	
	local connection
	connection = UIS.InputBegan:Connect(function(input)
		if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
			aimbotKey = input.KeyCode
			keyLabel.Text = "Key: " .. tostring(aimbotKey):gsub("Enum.KeyCode.", "") .. " (Hold)"
			keyButton.Text = "CHANGE"
			keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
			listeningForKey = false
			connection:Disconnect()
		end
	end)
end)

-- ========== INPUT HANDLERS ==========

-- HOLD TO AIM (F TUŞUNA BASILI TUTUNCA)
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == aimbotKey then
		aimbotOn = true
		aimbotToggleBtn.Text = "Aimbot: ON (Hold F)"
		aimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == aimbotKey then
		aimbotOn = false
		aimbotToggleBtn.Text = "Aimbot: OFF (Hold F)"
		aimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	end
end)

-- SILENT AIM TOGGLE
silentAimBtn.MouseButton1Click:Connect(function()
	silentAimOn = not silentAimOn
	silentAimBtn.Text = silentAimOn and "Silent Aim: ON" or "Silent Aim: OFF"
	silentAimBtn.BackgroundColor3 = silentAimOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(35, 35, 45)
	
	if silentAimOn then
		-- Silent aim açılınca regular aimbot'u kapat
		aimbotOn = false
		aimbotToggleBtn.Text = "Aimbot: OFF (Hold F)"
		aimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	end
end)

-- ========== AIMBOT LOOP ==========

RunService.RenderStepped:Connect(function()
	-- FOV Circle güncelle
	circle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
	
	-- Aimbot çalıştır
	if aimbotOn then
		regularAimbot()
	elseif silentAimOn then
		silentAim()
	end
end)

-- ========== BONE ESP (İSTEĞE BAĞLI) ==========

local boneESPOn = false
local boneESPBtn = Instance.new("TextButton", aimbotTab)
boneESPBtn.Size = UDim2.fromOffset(200, 36)
boneESPBtn.Position = UDim2.fromOffset(240, 270)
boneESPBtn.Text = "Bone ESP: OFF"
boneESPBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
boneESPBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
boneESPBtn.Font = Enum.Font.GothamBold
boneESPBtn.TextSize = 14
Instance.new("UICorner", boneESPBtn).CornerRadius = UDim.new(0, 8)

local boneDrawings = {}

local function createBoneESP(plr)
	if plr == player then return end
	if not plr.Character then return end
	
	boneDrawings[plr] = {}
	
	-- Önemli kemik noktaları
	local bones = {
		"Head", "UpperTorso", "LowerTorso",
		"LeftUpperArm", "LeftLowerArm", "LeftHand",
		"RightUpperArm", "RightLowerArm", "RightHand",
		"LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
		"RightUpperLeg", "RightLowerLeg", "RightFoot"
	}
	
	for _, boneName in pairs(bones) do
		local bone = plr.Character:FindFirstChild(boneName)
		if bone then
			local dot = Drawing.new("Circle")
			dot.Visible = false
			dot.Color = Color3.fromRGB(255, 0, 255)
			dot.Radius = 3
			dot.Thickness = 2
			dot.Filled = true
			
			table.insert(boneDrawings[plr], {bone = bone, drawing = dot})
		end
	end
end

local function removeBoneESP(plr)
	if boneDrawings[plr] then
		for _, data in pairs(boneDrawings[plr]) do
			if data.drawing then
				data.drawing:Remove()
			end
		end
		boneDrawings[plr] = nil
	end
end

boneESPBtn.MouseButton1Click:Connect(function()
	boneESPOn = not boneESPOn
	boneESPBtn.Text = boneESPOn and "Bone ESP: ON" or "Bone ESP: OFF"
	
	if boneESPOn then
		for _, plr in pairs(Players:GetPlayers()) do
			createBoneESP(plr)
		end
	else
		for plr, _ in pairs(boneDrawings) do
			removeBoneESP(plr)
		end
	end
end)

-- Bone ESP update loop
RunService.RenderStepped:Connect(function()
	if not boneESPOn then return end
	
	for plr, drawings in pairs(boneDrawings) do
		if plr.Character then
			for _, data in pairs(drawings) do
				if data.bone and data.bone.Parent then
					local screenPos, onScreen = camera:WorldToViewportPoint(data.bone.Position)
					if onScreen then
						data.drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
						data.drawing.Visible = true
					else
						data.drawing.Visible = false
					end
				else
					data.drawing.Visible = false
				end
			end
		else
			for _, data in pairs(drawings) do
				data.drawing.Visible = false
			end
		end
	end
end)

-- Player join/leave için
Players.PlayerAdded:Connect(function(plr)
	if boneESPOn then
		plr.CharacterAdded:Wait()
		task.wait(0.5)
		createBoneESP(plr)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	removeBoneESP(plr)
end)

-- ========== INFO LABEL ==========

local aimbotInfo = Instance.new("TextLabel", aimbotTab)
aimbotInfo.Size = UDim2.fromOffset(400, 100)
aimbotInfo.Position = UDim2.fromOffset(20, 320)
aimbotInfo.BackgroundTransparency = 1
aimbotInfo.Text = "🎯 AIMBOT KULLANIMI:\n• F tuşuna basılı tut = Aimbot aktif\n• Silent Aim = Gizli nişan alma\n• FOV = Hedefleme alanı\n• Smoothness = Yumuşaklık\n• Bone ESP = Kemikleri gör"
aimbotInfo.TextColor3 = Color3.fromRGB(0, 255, 255)
aimbotInfo.Font = Enum.Font.Gotham
aimbotInfo.TextSize = 12
aimbotInfo.TextWrapped = true
aimbotInfo.TextXAlignment = Enum.TextXAlignment.Left

print("🎯 Aimbot sistemi yüklendi! F tuşuna basılı tutarak kullanabilirsin.")
-- GUI KAPANDIĞINDA FAREYİ KAPAT
gui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if not gui.Enabled then
		setMouseVisibility(false)
	end
end)

-- BAŞLANGIÇ MESAJI
print("=========================================")
print("GMOD NEON HUB YÜKLENDİ!")
print("INSERT tuşuna basarak aç/kapa")
print("ESC tuşuna basarak kapat")
print("Fly aktifken: WASD + Space/Shift")
print("FPS modunda fare kilitli kalırsa INSERT'a bas!")
print("=========================================")	
