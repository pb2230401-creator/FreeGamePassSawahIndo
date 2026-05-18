-- GIFT GUI - Delta/Mobile Compatible
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Tunggu PlayerGui siap
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- Cari remote
local Event = nil
local function findRemote()
    local p1 = RS:FindFirstChild("Remotes")
    if p1 then
        local p2 = p1:FindFirstChild("TutorialRemotes")
        if p2 then return p2:FindFirstChild("RequestGift") end
    end
    local p3 = RS:FindFirstChild("TutorialRemotes")
    if p3 then return p3:FindFirstChild("RequestGift") end
    return RS:FindFirstChild("RequestGift")
end

Event = findRemote()

-- Buat GUI
local SG = Instance.new("ScreenGui")
SG.Name = "GiftTool"
SG.ResetOnSpawn = false
SG.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 260)
Frame.Position = UDim2.new(0.5, -160, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = SG

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Title.Text = "GIFT TEST TOOL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local UserIdBox = Instance.new("TextBox")
UserIdBox.Position = UDim2.new(0, 10, 0, 50)
UserIdBox.Size = UDim2.new(1, -20, 0, 32)
UserIdBox.PlaceholderText = "Target UserId (angka)"
UserIdBox.Text = ""
UserIdBox.ClearTextOnFocus = false
UserIdBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
UserIdBox.TextColor3 = Color3.new(1, 1, 1)
UserIdBox.Font = Enum.Font.SourceSans
UserIdBox.TextSize = 16
UserIdBox.Parent = Frame

local ItemBox = Instance.new("TextBox")
ItemBox.Position = UDim2.new(0, 10, 0, 92)
ItemBox.Size = UDim2.new(1, -20, 0, 32)
ItemBox.PlaceholderText = "Nama Item (contoh: FastGrow)"
ItemBox.Text = "FastGrow"
ItemBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ItemBox.TextColor3 = Color3.new(1, 1, 1)
ItemBox.Font = Enum.Font.SourceSans
ItemBox.TextSize = 16
ItemBox.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Position = UDim2.new(0, 10, 0, 132)
Status.Size = UDim2.new(1, -20, 0, 28)
Status.BackgroundTransparency = 1
Status.Text = Event and "Remote ditemukan: " .. Event.Name or "Remote TIDAK ditemukan!"
Status.TextColor3 = Event and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
Status.TextScaled = true
Status.Font = Enum.Font.SourceSansBold
Status.Parent = Frame

local BtnSend = Instance.new("TextButton")
BtnSend.Position = UDim2.new(0, 10, 0, 170)
BtnSend.Size = UDim2.new(1, -20, 0, 36)
BtnSend.Text = "KIRIM GIFT"
BtnSend.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
BtnSend.TextColor3 = Color3.new(1, 1, 1)
BtnSend.Font = Enum.Font.SourceSansBold
BtnSend.TextSize = 18
BtnSend.Parent = Frame

local BtnClose = Instance.new("TextButton")
BtnClose.Position = UDim2.new(0, 10, 0, 214)
BtnClose.Size = UDim2.new(1, -20, 0, 36)
BtnClose.Text = "TUTUP"
BtnClose.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
BtnClose.TextColor3 = Color3.new(1, 1, 1)
BtnClose.Font = Enum.Font.SourceSansBold
BtnClose.TextSize = 18
BtnClose.Parent = Frame

-- Fungsi
BtnSend.MouseButton1Click:Connect(function()
    if not Event then
        Status.Text = "Error: Remote tidak ada!"
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    local uid = tonumber(UserIdBox.Text)
    if not uid then
        Status.Text = "UserId harus angka!"
        Status.TextColor3 = Color3.fromRGB(255, 170, 0)
        return
    end
    
    local item = ItemBox.Text
    if item == "" then
        Status.Text = "Nama item tidak boleh kosong!"
        return
    end
    
    Status.Text = "Mengirim..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    local ok, res = pcall(function()
        return Event:InvokeServer("PROMPT_GIFT", uid, item)
    end)
    
    if not ok then
        Status.Text = "Error: " .. tostring(res)
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        if res == true or (type(res) == "table" and res[1] == true) then
            Status.Text = "Sukses! (Cek inventory target)"
            Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            Status.Text = "Server response: " .. tostring(res)
            Status.TextColor3 = Color3.fromRGB(255, 170, 0)
        end
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    SG:Destroy()
end)
