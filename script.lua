-- (Creator = Thanh Phuc)
-- 💟 Thanh Phuc - Bản Hoàn Thiện: Chroma Boombox Đeo Chéo (Hiện Ngay - Bất Tử Khi Die) 💟
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

-- CƠ CHẾ TẠO BOOMBOX CHUẨN ROBLOX (TỰ ĐỘNG KHÔI PHỤC KHI DIE)
local function EquipRealBoombox(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    -- Xóa loa cũ nếu có để tránh trùng lặp
    local oldAccessory = character:FindFirstChild("ThanhPhucChromaAccessory")
    if oldAccessory then oldAccessory:Destroy() end
    
    -- Tạo Accessory chuẩn Roblox để vác chân thật nhất
    local accessory = Instance.new("Accessory")
    accessory.Name = "ThanhPhucChromaAccessory"
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(2, 1.2, 0.5)
    handle.CanCollide = false
    handle.Massless = true
    
    local mesh = Instance.new("SpecialMesh", handle)
    mesh.MeshId = "rbxassetid://212641536" -- ID Mesh dáng gốc Chroma Boombox
    mesh.TextureId = "rbxassetid://212641550"
    mesh.Scale = Vector3.new(1.1, 1.1, 1.1) -- Tỉ lệ gọn gàng, vừa vặn cơ thể
    
    -- Tạo điểm neo để xoay xéo như Balo quai chéo
    local attachment = Instance.new("Attachment", handle)
    attachment.Name = "BodyBackAttachment"
    -- CFrame dịch chuyển ra sau lưng và xoay nghiêng góc chéo chuẩn 25 độ cực đẹp
    attachment.CFrame = CFrame.new(0, 0.2, 0.6) * CFrame.Angles(0, math.rad(180), math.rad(25))
    
    handle.Parent = accessory
    accessory.Parent = character
    humanoid:AddAccessory(accessory)
    
    -- Hiệu ứng cầu vồng chớp nháy mượt mà chạy ngầm
    coroutine.wrap(function()
        local hue = 0
        while handle and handle.Parent do
            hue = (hue + 2) % 360 -- Tăng tốc độ chớp cầu vồng cho bắt mắt
            local color = Color3.fromHSV(hue/360, 1, 1)
            handle.Color = color
            mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
            RunService.RenderStepped:Wait()
        end
    end)()
end

-- HIỆN NGAY LẬP TỨC KHI CHẠY SCRIPT
if LocalPlayer.Character then
    EquipRealBoombox(LocalPlayer.Character)
end

-- BẤT TỬ KHI DIE: Tự động phát hiện nhân vật mới để đeo lại ngay lập tức
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    EquipRealBoombox(newCharacter)
end)


-- GIAO DIỆN GUI (Giữ nguyên các tính năng bạn thích)
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

-- Nút MỞ MENU (Di chuyển tự do)
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

-- Sự kiện bật nhạc
PlayBtn.MouseButton1Click:Connect(function()
    local cleanID = InputBox.Text:match("%d+")
    if cleanID then
        LocalSound.SoundId = "rbxassetid://" .. cleanID
        LocalSound:Play()
        print("Thanh Phuc đang phát nhạc Local ID: " .. cleanID)
    else
        InputBox.Text = ""
        InputBox.PlaceholderText = "ID không hợp lệ!"
    end
end)

