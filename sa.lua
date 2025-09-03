--[[
	Geliştirilmiş Script v3.0
	Hazırlayan: Gemini (Stark'ın isteği üzerine)
	Özellikler:
	- Modern, sürüklenebilir ve sekmeli arayüz (Main, ESP). 
	- Main Sekmesi:
		- Gelişmiş Fly (Uçma) Modu (Aç/Kapat, Hız Ayarı). [cite: 2]
		- Infinite Jump (Sınırsız Zıplama) (Aç/Kapat). [cite: 2]
		- WalkSpeed (Yürüme Hızı) Ayarı (Aç/Kapat, Hız Ayarı). [cite: 3]
		- Jump Power (Zıplama Gücü) Ayarı (Aç/Kapat, Güç Ayarı). [cite: 3]
		- Noclip (Duvardan Geçme) (Aç/Kapat).
		- Anti-AFK (Oyun Atmasın) (Aç/Kapat).
	- ESP Sekmesi:
		- Oyuncu ESP (Kutucuk, İsim, Mesafe) (Aç/Kapat). [cite: 4]
	- Tüm özellikler için klavye kısayolları (Keybinds). [cite: 4]
]]

--==============================================================================
-- TEMEL DEĞİŞKENLER VE AYARLAR
--==============================================================================

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Özelliklerin durumunu ve orijinal değerleri saklamak için tablolar
local Toggles = {
	Fly = false,
	InfiniteJump = false,
	WalkSpeed = false,
	JumpPower = false,
	Noclip = false,
	AntiAFK = false,
	ESP = false
}

local OriginalValues = {
	WalkSpeed = 16,
	JumpPower = 50
}

--==============================================================================
-- MODERN KULLANICI ARAYÜZÜ (GUI) OLUŞTURMA
--==============================================================================

-- Ana GUI elementi
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Ana Çerçeve
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderColor3 = Color3.fromRGB(85, 85, 125)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 380) -- Boyut artırıldı
MainFrame.Draggable = true
MainFrame.Active = true

-- Başlık Çubuğu
local Header = Instance.new("Frame")
Header.Name = "Header" [cite: 6]
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Position = UDim2.new(0, 0, 0, 0)

-- Başlık Yazısı
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Header
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Header.BackgroundColor3
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Stark's Menu v3.0"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 18

-- Sekme Butonları Çerçevesi
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = MainFrame.BackgroundColor3
TabsFrame.BackgroundTransparency = 1
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)

-- İçerik Çerçevesi
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = MainFrame.BackgroundColor3
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70) [cite: 7]

-- Sekme İçeriklerini Saklayacak Çerçeveler
local MainContent = Instance.new("Frame")
MainContent.Name = "MainContent"
MainContent.Parent = ContentFrame
MainContent.BackgroundColor3 = MainFrame.BackgroundColor3
MainContent.BackgroundTransparency = 1
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.Visible = true

local ESPContent = Instance.new("Frame")
ESPContent.Name = "ESPContent"
ESPContent.Parent = ContentFrame
ESPContent.BackgroundColor3 = MainFrame.BackgroundColor3
ESPContent.BackgroundTransparency = 1
ESPContent.Size = UDim2.new(1, 0, 1, 0)
ESPContent.Visible = false

-- Sekme Değiştirme Fonksiyonu
local function SwitchTab(tabName)
	MainContent.Visible = (tabName == "Main")
	ESPContent.Visible = (tabName == "ESP")
end

-- Sekme Butonları
local MainTabButton = Instance.new("TextButton")
MainTabButton.Name = "MainTab"
MainTabButton.Parent = TabsFrame
MainTabButton.BackgroundColor3 = Color3.fromRGB(65, 65, 95)
MainTabButton.Size = UDim2.new(0.5, 0, 1, 0)
MainTabButton.Font = Enum.Font.SourceSansBold
MainTabButton.Text = "Main"
MainTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabButton.TextSize = 16
MainTabButton.MouseButton1Click:Connect(function() SwitchTab("Main") end)

local ESPTabButton = Instance.new("TextButton")
ESPTabButton.Name = "ESPTab"
ESPTabButton.Parent = TabsFrame
ESPTabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ESPTabButton.Size = UDim2.new(0.5, 0, 1, 0)
ESPTabButton.Position = UDim2.new(0.5, 0, 0, 0) [cite: 8]
ESPTabButton.Font = Enum.Font.SourceSansBold
ESPTabButton.Text = "ESP"
ESPTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTabButton.TextSize = 16
ESPTabButton.MouseButton1Click:Connect(function() SwitchTab("ESP") end)

-- Bileşen Oluşturma Fonksiyonları
local function CreateToggleButton(parent, text, keybind, position)
	local button = Instance.new("TextButton")
	button.Parent = parent
	button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	button.BorderColor3 = Color3.fromRGB(150, 40, 40)
	button.Size = UDim2.new(0, 120, 0, 30)
	button.Position = position
	button.Font = Enum.Font.SourceSansBold
	button.Text = text .. " [ " .. keybind .. " ]"
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 14
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = button
	
	return button
end

local function CreateTextBox(parent, placeholder, position)
	local box = Instance.new("TextBox")
	box.Parent = parent
	box.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
	box.BorderColor3 = Color3.fromRGB(85, 85, 125)
	box.Size = UDim2.new(0, 100, 0, 30)
	box.Position = position [cite: 9]
	box.Font = Enum.Font.SourceSans
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.TextSize = 14
	box.ClearTextOnFocus = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = box

	return box
end

--==============================================================================
-- "MAIN" SEKMESİ İÇERİĞİ
--==============================================================================

-- Fly
local FlyButton = CreateToggleButton(MainContent, "Fly", "F", UDim2.new(0, 0, 0, 0))
local FlySpeedInput = CreateTextBox(MainContent, "Speed (e.g., 3)", UDim2.new(0, 140, 0, 0))

-- Infinite Jump
local InfJumpButton = CreateToggleButton(MainContent, "Infinite Jump", "G", UDim2.new(0, 0, 0, 40))

-- WalkSpeed
local SpeedButton = CreateToggleButton(MainContent, "WalkSpeed", "X", UDim2.new(0, 0, 0, 80))
local SpeedInput = CreateTextBox(MainContent, "Speed (e.g., 100)", UDim2.new(0, 140, 0, 80))

-- Jump Power
local JumpButton = CreateToggleButton(MainContent, "Jump Power", "C", UDim2.new(0, 0, 0, 120))
local JumpInput = CreateTextBox(MainContent, "Power (e.g., 150)", UDim2.new(0, 140, 0, 120)) [cite: 10]

-- Noclip
local NoclipButton = CreateToggleButton(MainContent, "Noclip", "B", UDim2.new(0, 0, 0, 160))

-- Anti-AFK
local AntiAFKButton = CreateToggleButton(MainContent, "Anti-AFK", "K", UDim2.new(0, 0, 0, 200))


--==============================================================================
-- "ESP" SEKMESİ İÇERİĞİ
--==============================================================================
local ESPButton = CreateToggleButton(ESPContent, "Player ESP", "V", UDim2.new(0, 0, 0, 0))

--==============================================================================
-- ÖZELLİKLERİN FONKSİYONLARI
--==============================================================================

-- Fly Fonksiyonu
local fly_bv, fly_bg
function ToggleFly(state)
	Toggles.Fly = state
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local rootPart = char.HumanoidRootPart

	if Toggles.Fly then
		FlyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Yeşil
		
		fly_bv = Instance.new("BodyVelocity", rootPart)
		fly_bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		fly_bv.Velocity = Vector3.new(0, 0, 0)

		fly_bg = Instance.new("BodyGyro", rootPart)
		fly_bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		fly_bg.P = 5000
		
		humanoid.PlatformStand = true
	else
		FlyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Kırmızı
		if fly_bv then fly_bv:Destroy() end
		if fly_bg then fly_bg:Destroy() end
		if humanoid then humanoid.PlatformStand = false end
	end
end

-- Infinite Jump Fonksiyonu
function ToggleInfiniteJump(state)
	Toggles.InfiniteJump = state
	if Toggles.InfiniteJump then
		InfJumpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) [cite: 11]
		UserInputService.JumpRequest:Connect(function()
			if Toggles.InfiniteJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end [cite: 12]
end

-- WalkSpeed Fonksiyonu
function ToggleWalkSpeed(state)
	Toggles.WalkSpeed = state
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if Toggles.WalkSpeed then
		OriginalValues.WalkSpeed = humanoid.WalkSpeed
		local newSpeed = tonumber(SpeedInput.Text)
		humanoid.WalkSpeed = newSpeed or 100
		SpeedButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		humanoid.WalkSpeed = OriginalValues.WalkSpeed
		SpeedButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end

-- JumpPower Fonksiyonu
function ToggleJumpPower(state)
	Toggles.JumpPower = state
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if Toggles.JumpPower then
		OriginalValues.JumpPower = humanoid.JumpPower
		local newPower = tonumber(JumpInput.Text)
		humanoid.JumpPower = newPower or 150
		JumpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		humanoid.JumpPower = OriginalValues.JumpPower
		JumpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end

-- Noclip Fonksiyonu
local noclipConnection
function ToggleNoclip(state)
    Toggles.Noclip = state
    if Toggles.Noclip then
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- Karakter öldüğünde veya resetlendiğinde çarpışmayı tekrar aktif etmeyebilir.
        -- Bu basit versiyonda, kapatıldığında mevcut karakterin çarpışmasını düzeltmek yerine bağlantıyı keser.
    end
end

-- Anti-AFK Fonksiyonu
function ToggleAntiAFK(state)
    Toggles.AntiAFK = state
    if Toggles.AntiAFK then
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        coroutine.wrap(function()
            while Toggles.AntiAFK do
                wait(60) -- Her 60 saniyede bir
                if Toggles.AntiAFK then -- Tekrar kontrol et, belki bu arada kapatılmıştır
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        -- AFK sistemini resetlemek için küçük bir zıplama hareketi yap
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)()
    else
        AntiAFKButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end


-- ESP Fonksiyonu
local espConnections = {}
function ToggleESP(state)
	Toggles.ESP = state
	if Toggles.ESP then
		ESPButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
			if otherPlayer ~= player then [cite: 13]
				CreateESP(otherPlayer)
			end
		end
		espConnections.PlayerAdded = game:GetService("Players").PlayerAdded:Connect(CreateESP)
		espConnections.PlayerRemoving = game:GetService("Players").PlayerRemoving:Connect(function(leftPlayer)
			if espConnections[leftPlayer] then
				espConnections[leftPlayer].Connection:Disconnect()
				espConnections[leftPlayer].BillboardGui:Destroy()
				espConnections[leftPlayer] = nil
			end
		end)
	else
		ESPButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		for p, data in pairs(espConnections) do
			if type(p) == "userdata" then
				if data.Connection then data.Connection:Disconnect() end
				if data.BillboardGui then data.BillboardGui:Destroy() end
			else
				if data then data:Disconnect() end
			end
		end
		espConnections = {}
	end
end

function CreateESP(otherPlayer)
	if not Toggles.ESP or otherPlayer == player then return end

	local function setupEspForCharacter(character)
		if espConnections[otherPlayer] and espConnections[otherPlayer].BillboardGui then
			espConnections[otherPlayer].BillboardGui:Destroy()
		end

		local head = character:WaitForChild("Head", 5)
		if not head then return end

		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "ESP_GUI"
		billboardGui.Adornee = head
		billboardGui.AlwaysOnTop = true
		billboardGui.Size = UDim2.new(0, 200, 0, 100)
		billboardGui.StudsOffset = Vector3.new(0, 2, 0)
		billboardGui.Parent = game.CoreGui [cite: 14]

		local espBox = Instance.new("Frame")
		espBox.Parent = billboardGui
		espBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		espBox.BackgroundTransparency = 1
		espBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
		espBox.BorderSizePixel = 2
		espBox.Size = UDim2.new(1, 0, 1, 0)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Parent = billboardGui
		nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		nameLabel.BackgroundTransparency = 0.5
		nameLabel.Size = UDim2.new(1, 0, 0, 20)
		nameLabel.Position = UDim2.new(0, 0, 0, -20)
		nameLabel.Font = Enum.Font.SourceSans
		nameLabel.Text = otherPlayer.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextSize = 14

		local distLabel = Instance.new("TextLabel")
		distLabel.Parent = billboardGui
		distLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		distLabel.BackgroundTransparency = 0.5
		distLabel.Size = UDim2.new(1, 0, 0, 20)
		distLabel.Position = UDim2.new(0, 0, 1, 0)
		distLabel.Font = Enum.Font.SourceSans
		distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		distLabel.TextSize = 14
		
		local connection = RunService.RenderStepped:Connect(function()
			if not character or not character.Parent or not head or not head.Parent then
				billboardGui:Destroy()
				if espConnections[otherPlayer] then
					espConnections[otherPlayer].Connection:Disconnect()
					espConnections[otherPlayer] = nil [cite: 15]
				end
				return
			end
			local distance = (player.Character.HumanoidRootPart.Position - head.Position).Magnitude
			distLabel.Text = "Dist: " .. math.floor(distance) .. "m"
		end)

		espConnections[otherPlayer] = {
			BillboardGui = billboardGui,
			Connection = connection
		}
	end

	if otherPlayer.Character then
		setupEspForCharacter(otherPlayer.Character)
	end
	otherPlayer.CharacterAdded:Connect(setupEspForCharacter)
end


--==============================================================================
-- BUTON VE KLAVYE BAĞLANTILARI
--==============================================================================

FlyButton.MouseButton1Click:Connect(function() ToggleFly(not Toggles.Fly) end)
InfJumpButton.MouseButton1Click:Connect(function() ToggleInfiniteJump(not Toggles.InfiniteJump) end)
SpeedButton.MouseButton1Click:Connect(function() ToggleWalkSpeed(not Toggles.WalkSpeed) end)
JumpButton.MouseButton1Click:Connect(function() ToggleJumpPower(not Toggles.JumpPower) end)
NoclipButton.MouseButton1Click:Connect(function() ToggleNoclip(not Toggles.Noclip) end)
AntiAFKButton.MouseButton1Click:Connect(function() ToggleAntiAFK(not Toggles.AntiAFK) end)
ESPButton.MouseButton1Click:Connect(function() ToggleESP(not Toggles.ESP) end)

-- Klavye Kısayolları
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.F then
		ToggleFly(not Toggles.Fly)
	elseif input.KeyCode == Enum.KeyCode.G then
		ToggleInfiniteJump(not Toggles.InfiniteJump)
	elseif input.KeyCode == Enum.KeyCode.X then
		ToggleWalkSpeed(not Toggles.WalkSpeed)
	elseif input.KeyCode == Enum.KeyCode.C then
		ToggleJumpPower(not Toggles.JumpPower)
	elseif input.KeyCode == Enum.KeyCode.B then
		ToggleNoclip(not Toggles.Noclip)
	elseif input.KeyCode == Enum.KeyCode.K then
		ToggleAntiAFK(not Toggles.AntiAFK)
	elseif input.KeyCode == Enum.KeyCode.V then
		ToggleESP(not Toggles.ESP)
	end
end)


--==============================================================================
-- SÜREKLİ ÇALIŞACAK FONKSİYONLAR (ÖRNEĞİN FLY HAREKETİ)
--==============================================================================

RunService.RenderStepped:Connect(function()
	if Toggles.Fly and fly_bv and fly_bg then
		local speed = tonumber(FlySpeedInput.Text) or 3
		local moveVector = Vector3.new()
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Vector3.new(0, 0, -1) end [cite: 16]
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector + Vector3.new(0, 0, 1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Vector3.new(1, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector + Vector3.new(0, -1, 0) end

		local cameraCFrame = workspace.CurrentCamera.CFrame
		local relativeMoveVector = cameraCFrame:VectorToWorldSpace(moveVector.Unit)
		
		fly_bv.Velocity = relativeMoveVector * speed * 50
		fly_bg.CFrame = cameraCFrame
	end
end)
