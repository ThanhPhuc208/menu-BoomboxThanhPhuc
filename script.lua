-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Balo Chéo Cầu Vồng Giật Theo Nhạc + Nút Bật/Tắt Linh Hoạt 💟
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

local FakeBoombox = nil
local RainbowConnection = nil

-- Hàm xóa sạch loa cũ
local function RemoveBoombox()
    if RainbowConnection then RainbowConnection:Disconnect() RainbowConnection = nil end
    if FakeBoombox then FakeBoombox:Destroy() FakeBoombox = nil end
end

-- Hàm tạo Balo Chéo Cầu Vồng (Dựa theo cách hoạt động của khối vuông đầu tiên để đảm bảo 100% hiện)
local function CreateFakeBoombox()
    RemoveBoombox()
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("UpperTorso") and not character:FindFirstChild("Torso") then return end
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    
    -- Tạo Part cơ sở cho chiếc balo dẹp gọn
    local part = Instance.new("Part")
    part.Name = "ThanhPhucChromaBag"
    part.Size = Vector3.new(1.8, 1.2, 0.4) -- Kích thước dẹp gọn chuẩn dáng cặp chéo
    part.CanCollide = false
    part.Massless = true
    
    -- Dùng lưới Mesh của Chroma Boombox gốc để lấy chi tiết màng loa sắc nét
    local mesh = Instance.new("SpecialMesh", part)
    mesh.MeshId = "rbxassetid://212641536"
    mesh.TextureId = "rbxassetid://212641550"
    mesh.Scale = Vector3.new(1.1, 1.1, 1.1)
    
    FakeBoombox = part
    part.Parent = character
    
    -- Gắn chặt và xoay nghiêng tạo dáng quai chéo sau lưng
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = part
    weld.C0 = CFrame.new(0, -0.2, 0.6) * CFrame.Angles(0, math.rad(180), math.rad(25)) -- Xoay nghiêng 25 độ quai chéo
    weld.Parent = part
    
    -- Xử lý hiệu ứng cầu vồng chớp nháy mạnh/nhẹ và co giãn theo nhịp Bass (Loudness)
    local hue = 0
    RainbowConnection = RunService.RenderStepped:Connect(function()
        if part and part.Parent and mesh then
            hue = (hue + 1.5) % 360
            local baseColor = Color3.fromHSV(hue/360, 1, 1)
            
            -- Lấy độ lớn âm thanh thực tế
            local loudness = LocalSound.PlaybackLoudness
            local intensity = math.clamp(loudness / 280, 0.4, 2.5) -- Đập nháy theo tiếng Bass
            
            -- Màu sắc chớp nháy đồng bộ theo nhịp hát/nhạc
            local dynamicColor = Color3.new(
                math.clamp(baseColor.R * intensity, 0, 1),
                math.clamp(baseColor.G * intensity, 0, 1),
                math.clamp(baseColor.B * intensity, 0, 1)
            )
            part.Color = dynamicColor
            mesh.VertexColor = Vector3.new(dynamicColor.R, dynamicColor.G, dynamicColor.B)
            
            -- Hiệu ứng giật nhẹ độ lớn của balo theo tiếng Bass đập
            local scaleMultiplier = 1.1 + (math.clamp(loudness / 900, 0, 0.15))
            mesh.Scale = Vector3.new(scaleMultiplier, scaleMultiplier, scaleMultiplier)
        else
            RemoveBoombox()
        end
    end)
end

-- Tự động dọn dẹp âm thanh và loa cũ khi bạn nhân vật die
LocalPlayer.CharacterRemoving:Connect(function()
    RemoveBoombox()
    LocalSound:Stop()
end)

-- TẠO GIAO DIỆN GUI (Thay đổi kích thước để chứa thêm nút Tắt)
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 240) -- Tăng nhẹ chiều cao để giao diện thoáng hơn
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

-- Nút MỞ MENU (Kéo rê tự do)
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
PlayBtn.Size = UDim2.new(0.42, 0, 0, 40) -- Chia đôi chiều ngang cho nút Phát
PlayBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
PlayBtn.Text = "PHÁT"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
Instance.new("UICorner", PlayBtn)

-- Nút TẮT NHẠC (Tiện lợi để dừng nhạc và dọn dẹp loa)
local StopBtn = Instance.new("TextButton", MainFrame)
StopBtn.Size = UDim2.new(0.42, 0, 0, 40) -- Nút Tắt nằm đối xứng kế bên
StopBtn.Position = UDim2.new(0.53, 0, 0.55, 0)
StopBtn.Text = "TẮT"
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Instance.new("UICorner", StopBtn)

-- Sự kiện nhấn nút PHÁT NHẠC
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        
        -- Gọi tạo balo đeo chéo chớp nháy đồng hành cùng nhạc
        CreateFakeBoombox()
        print("Thanh Phuc đang quẩy nhạc + Đeo balo chéo Chroma!")
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

-- Sự kiện nhấn nút TẮT NHẠC
StopBtn.MouseButton1Click:Connect(function()
    LocalSound:Stop() -- Tắt tiếng nhạc hoàn toàn
    RemoveBoombox()   -- Xóa chiếc balo quai chéo đi gọn gàng
    print("Thanh Phuc đã dừng nhạc.")
end)
