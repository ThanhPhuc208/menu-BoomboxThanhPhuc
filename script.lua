-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Chroma Boombox Đeo Chéo: Giật Cầu Vồng Theo Nhịp Nhạc (Bất Tử Khi Die) 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Khởi tạo bộ phát âm thanh chuẩn của bạn
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 2
LocalSound.Looped = true

local CurrentPart = nil
local CurrentMesh = nil

-- Hàm tạo Loa Đeo Chéo chuẩn hình mẫu
local function CreateChromaBoombox()
    if CurrentPart then CurrentPart:Destroy() end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("UpperTorso") and not character:FindFirstChild("Torso") then return end
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    
    local part = Instance.new("Part")
    part.Name = "ThanhPhucChromaBackpack"
    part.Size = Vector3.new(1, 1, 1)
    part.CanCollide = false
    part.Massless = true
    
    -- Dùng Mesh Chroma Boombox xịn của Roblox (Dáng dẹp, rõ nét màng loa)
    local mesh = Instance.new("SpecialMesh", part)
    mesh.MeshId = "rbxassetid://212641536"
    mesh.TextureId = "rbxassetid://212641550"
    mesh.Scale = Vector3.new(1.1, 1.1, 1.1)
    
    CurrentPart = part
    CurrentMesh = mesh
    part.Parent = character
    
    -- Weld giữ chặt đeo xéo như cặp quai chéo
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = part
    weld.C0 = CFrame.new(0, -0.2, 0.6) * CFrame.Angles(0, math.rad(180), math.rad(25)) -- Nghiêng xéo góc quai đeo
    weld.Parent = part
end

-- Vừa bật Script là loa xuất hiện ngay lập tức
if LocalPlayer.Character then
    CreateChromaBoombox()
end

-- Tự động đeo lại ngay khi nhân vật hồi sinh (Bất tử khi die)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    CreateChromaBoombox()
end)

-- VÒNG LẶP XỬ LÝ HIỆU ỨNG CẦU VỒNG + CHỚP GIẬT THEO NHỊP BASS
local hue = 0
RunService.RenderStepped:Connect(function()
    if CurrentPart hills and CurrentPart.Parent and CurrentMesh then
        -- Chạy màu cầu vồng liên tục
        hue = (hue + 1.5) % 360
        local baseColor = Color3.fromHSV(hue/360, 1, 1)
        
        -- Lấy độ lớn của âm thanh hiện tại (Nhịp Bass / Tiếng hát)
        local loudness = LocalSound.PlaybackLoudness
        local intensity = math.clamp(loudness / 300, 0.3, 2.5) -- Giới hạn độ chớp giật phù hợp
        
        -- Cho màu sắc chớp nháy (nhạt/đậm hoặc sáng rực) theo nhịp nhạc
        local dynamicColor = Color3.new(
            math.clamp(baseColor.R * intensity, 0, 1),
            math.clamp(baseColor.G * intensity, 0, 1),
            math.clamp(baseColor.B * intensity, 0, 1)
        )
        
        CurrentPart.Color = dynamicColor
        CurrentMesh.VertexColor = Vector3.new(dynamicColor.R, dynamicColor.G, dynamicColor.B)
        
        -- Tạo hiệu ứng loa giật nhẹ (co giãn) nhẹ nhàng theo nhịp đập của nhạc
        local scaleMultiplier = 1.1 + (math.clamp(loudness / 1000, 0, 0.15))
        CurrentMesh.Scale = Vector3.new(scaleMultiplier, scaleMultiplier, scaleMultiplier)
    end
end)

-- TẠO GIAO DIỆN GUI (Giữ nguyên giao diện di chuyển linh hoạt)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 220)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Draggable = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Nút ẨN MENU
local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.new(1, 1, 1)
HideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Instance.new("UICorner", HideBtn)
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false 
end)

-- Nút MỞ MENU (Kéo rê tự do tránh vướng màn hình)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "TP 🎵"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenBtn.Draggable = true
OpenBtn.Active = true
Instance.new("UICorner", OpenBtn)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true 
end)

-- Tiêu đề Menu
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Text = "🎵 THANH PHÚC MUSIC"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Ô nhập ID Nhạc
local InputBox = Instance.new("TextBox", MainFrame)
InputBox.Size = UDim2.new(0.9, 0, 0, 40)
InputBox.Position = UDim2.new(0.05, 0, 0.25, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

-- Nút PHÁT NHẠC
local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 40)
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT NHẠC"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", PlayBtn)

-- Sự kiện click nút Phát nhạc
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        print("Thanh Phuc đang quẩy nhạc nhịp Bass!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)
