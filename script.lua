-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Bản Menu Tách Biệt: Nút Phát Nhạc & Nút Bật Loa Cầu Vồng Riêng Biệt 💟
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Khởi tạo bộ phát âm thanh chuẩn ban đầu của bạn
local LocalSound = Instance.new("Sound")
LocalSound.Name = "ThanhPhucLocalSound"
LocalSound.Parent = LocalPlayer:WaitForChild("PlayerWorkspace", 5) or workspace
LocalSound.Volume = 2
LocalSound.Looped = true

local FakeBoombox = nil
local RainbowConnection = nil

-- Hàm dọn dẹp loa cũ
local function RemoveBoombox()
    if RainbowConnection then RainbowConnection:Disconnect() RainbowConnection = nil end
    if FakeBoombox then FakeBoombox:Destroy() FakeBoombox = nil end
end

-- Hàm tạo Boombox cầu vồng dáng balo chéo giật theo Bass
local function CreateFakeBoombox()
    RemoveBoombox()
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("UpperTorso") and not character:FindFirstChild("Torso") then return end
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    
    -- Tạo dáng cặp chéo dẹp gọn gàng
    local part = Instance.new("Part")
    part.Name = "ThanhPhucChromaBag"
    part.Size = Vector3.new(1.8, 1.2, 0.4)
    part.CanCollide = false
    part.Massless = true
    
    local mesh = Instance.new("SpecialMesh", part)
    mesh.MeshId = "rbxassetid://212641536"
    mesh.TextureId = "rbxassetid://212641550"
    mesh.Scale = Vector3.new(1.1, 1.1, 1.1)
    
    FakeBoombox = part
    part.Parent = character
    
    -- Weld giữ chặt và xoay nghiêng 25 độ quai đeo chéo sau lưng
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = part
    weld.C0 = CFrame.new(0, -0.2, 0.6) * CFrame.Angles(0, math.rad(180), math.rad(25))
    weld.Parent = part
    
    -- Hiệu ứng cầu vồng chớp nháy và co giãn giật theo nhịp Bass (Loudness)
    local hue = 0
    RainbowConnection = RunService.RenderStepped:Connect(function()
        if part and part.Parent and mesh then
            hue = (hue + 1.5) % 360
            local baseColor = Color3.fromHSV(hue/360, 1, 1)
            
            -- Đồng bộ trực tiếp theo độ lớn bài nhạc đang phát
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0.4, 2.5) -- Giật màu sáng rực theo bass
            
            local dynamicColor = Color3.new(
                math.clamp(baseColor.R * intensity, 0, 1),
                math.clamp(baseColor.G * intensity, 0, 1),
                math.clamp(baseColor.B * intensity, 0, 1)
            )
            part.Color = dynamicColor
            mesh.VertexColor = Vector3.new(dynamicColor.R, dynamicColor.G, dynamicColor.B)
            
            -- Balo co giãn nhẹ nhàng cực phiêu theo nhịp đập
            local scaleMultiplier = 1.1 + (math.clamp(loudness / 900, 0, 0.15))
            mesh.Scale = Vector3.new(scaleMultiplier, scaleMultiplier, scaleMultiplier)
        else
            RemoveBoombox()
        end
    end)
end

-- Tự động dọn loa cũ khi die
LocalPlayer.CharacterRemoving:Connect(function()
    RemoveBoombox()
end)

-- GIAO DIỆN GUI (Nâng cấp thêm nút Bật Loa riêng)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 240) -- Tăng nhẹ chiều cao để vừa nút mới
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Draggable = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Nút ẨN MENU (-)
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

-- Nút MỞ MENU (TP 🎵)
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
InputBox.Position = UDim2.new(0.05, 0, 0.23, 0)
InputBox.PlaceholderText = "Nhập ID nhạc..."
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InputBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", InputBox)

-- Nút PHÁT NHẠC (Nguyên bản 100% để tránh lỗi)
local PlayBtn = Instance.new("TextButton", MainFrame)
PlayBtn.Size = UDim2.new(0.9, 0, 0, 40)
PlayBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
PlayBtn.Text = "PHÁT NHẠC"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", PlayBtn)

-- NÚT BẬT BOOMBOX (Thêm riêng tiện lợi theo ý bạn)
local BoomboxBtn = Instance.new("TextButton", MainFrame)
BoomboxBtn.Size = UDim2.new(0.9, 0, 0, 40)
BoomboxBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
BoomboxBtn.Text = "⚡ BẬT LOA CẦU VỒNG"
BoomboxBtn.TextColor3 = Color3.new(1, 1, 1)
BoomboxBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 200) -- Màu tím neon bắt mắt
Instance.new("UICorner", BoomboxBtn)

-- Xử lý nút Phát nhạc (Chỉ phát nhạc, cực kỳ ổn định)
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        print("Thanh Phuc đang phát ID: " .. cleanID)
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

-- Xử lý nút Bật Loa (Chủ động nhấn để hiện balo chéo cầu vồng)
BoomboxBtn.MouseButton1Click:Connect(function()
    CreateFakeBoombox()
    print("Thanh Phuc đã kích hoạt Loa Cầu Vồng Đeo Chéo thành công!")
end)
