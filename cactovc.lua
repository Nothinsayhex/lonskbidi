local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50
local flyKey = Enum.KeyCode.E

local bodyGyro, bodyVelocity, flyConnection

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "???",
    Theme = "Dark",
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

local Themes = {
    Light = { Primary = Color3.fromRGB(232, 232, 232), Secondary = Color3.fromRGB(255, 255, 255), Component = Color3.fromRGB(245, 245, 245), Interactables = Color3.fromRGB(235, 235, 235), Tab = Color3.fromRGB(50, 50, 50), Title = Color3.fromRGB(0, 0, 0), Description = Color3.fromRGB(100, 100, 100), Shadow = Color3.fromRGB(255, 255, 255), Outline = Color3.fromRGB(210, 210, 210), Icon = Color3.fromRGB(100, 100, 100), },
    Dark = { Primary = Color3.fromRGB(30, 30, 30), Secondary = Color3.fromRGB(35, 35, 35), Component = Color3.fromRGB(40, 40, 40), Interactables = Color3.fromRGB(45, 45, 45), Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240,240,240), Description = Color3.fromRGB(200,200,200), Shadow = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220), },
    Void = { Primary = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(20, 20, 20), Component = Color3.fromRGB(25, 25, 25), Interactables = Color3.fromRGB(30, 30, 30), Tab = Color3.fromRGB(200, 200, 200), Title = Color3.fromRGB(240,240,240), Description = Color3.fromRGB(200,200,200), Shadow = Color3.fromRGB(0, 0, 0), Outline = Color3.fromRGB(40, 40, 40), Icon = Color3.fromRGB(220, 220, 220), },
}

Window:SetTheme(Themes.Dark)

Window:AddTabSection({ Name = "Main", Order = 1 })
Window:AddTabSection({ Name = "Settings", Order = 2 })

local Main = Window:AddTab({ Title = "fly", Section = "Main", Icon = "rbxassetid://7300477598" })

Window:AddSection({ Name = "	", Tab = Main })
Window:AddParagraph({ Title = "Paragraph", Description = "Insert any important text here.", Tab = Main }) 
Window:AddSection({ Name = "Interactable", Tab = Main }) 

Window:AddToggle({
    Title = "Toggle",
    Description = "Switching",
    Tab = Main,
    Callback = function(Boolean) 
        warn(Boolean)
    end,
}) 

Window:AddToggle({
    Title = "Fly Mode",
    Description = "Bật/tắt bay",
    Tab = Main,
    Callback = function(state)
        flying = state
        if flying then
            local hrp = Character:WaitForChild("HumanoidRootPart")
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 9e4
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = hrp.CFrame
            bodyGyro.Parent = hrp
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Parent = hrp
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flying then return end
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end
})

Window:AddSlider({
    Title = "Fly Speed",
    Description = "Tốc độ bay",
    Tab = Main,
    Default = 50,
    MinValue = 10,
    MaxValue =300,
    AllowDecimals = false,
    Callback = function(val)
        flySpeed = val
    end,
})

Window:AddKeybind({
    Title = "Fly Keybind",
    Description = "Phím bật/tắt bay",
    Tab = Main,
    Default = flyKey,
    Callback = function(key)
        flyKey = key
    end,
})

local Hitbox = Window:AddTab({
    Title = "Hitbox",
    Section = "Main",
    Icon = "rbxassetid://6034996695"
})

_G.HeadSize = 20
_G.Disabled = true 

Window:AddToggle({
    Title = "Bật Hitbox ESP",
    Description = "Đầu người chơi khác lớn và phát sáng",
    Tab = Hitbox,
    Callback = function(state)
        _G.Disabled = not state
    end,
})

RunService.RenderStepped:Connect(function()
    if not _G.Disabled then  
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                pcall(function()
                    local head = v.Character and v.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                        head.Transparency = 1
                        head.BrickColor = BrickColor.new("Really red")
                        head.Material = Enum.Material.Neon
                        head.CanCollide = false
                        head.Massless = true
                    end
                end)
            end
        end
    end
end)

local Settings = Window:AddTab({ Title = "Settings", Section = "Settings", Icon = "rbxassetid://7300489566" })

Window:AddKeybind({
    Title = "Minimize Keybind",
    Description = "Set the keybind for Minimizing",
    Tab = Settings,
    Callback = function(Key) 
        Window:SetSetting("Keybind", Key)
    end,
})

Window:AddDropdown({
    Title = "Set Theme",
    Description = "Set the theme of the library!",
    Tab = Settings,
    Options = {
        ["Light Mode"] = "Light",
        ["Dark Mode"] = "Dark",
        ["Extra Dark"] = "Void",
    },
    Callback = function(Theme) 
        Window:SetTheme(Themes[Theme])
    end,
})

Window:AddToggle({
    Title = "UI Blur",
    Description = "Nếu bật, cần để Graphics ở mức 8+",
    Default = true,
    Tab = Settings,
    Callback = function(Boolean) 
        Window:SetSetting("Blur", Boolean)
    end,
})

Window:AddSlider({
    Title = "UI Transparency",
    Description = "Chỉnh độ trong suốt giao diện",
    Tab = Settings,
    AllowDecimals = true,
    MaxValue = 1,
    Callback = function(Amount) 
        Window:SetSetting("Transparency", Amount)
    end,
})

Window:Notify({
    Title = "Hello World!",
    Description = "Nhấn Left Alt để thu nhỏ UI!",
    Duration = 10
})

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == flyKey then
        flying = not flying
        if flying then
            Window:SetToggle("Fly Mode", true)
        else
            Window:SetToggle("Fly Mode", false)
        end
    end
end)

Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    flying = false
end)

local Mouse = Player:GetMouse()

local TeleportTab = Window:AddTab({
    Title = "Teleport",
    Section = "Main",
    Icon = "rbxassetid://6034287594"
})

Window:AddParagraph({
    Title = "Hướng Dẫn",
    Description = "Giữ Ctrl và click chuột trái để dịch chuyển!",
    Tab = TeleportTab
})

Window:AddToggle({
    Title = "Bật dịch chuyển",
    Description = "Bật/tắt tính năng click teleport",
    Default = true,
    Tab = TeleportTab,
    Callback = function(state)
        teleportEnabled = state
    end,
})

UserInputService.InputBegan:Connect(function(input)
    if teleportEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local hit = Mouse.Hit
        if hit then
            local hrp = Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(hit.p + Vector3.new(0, 4, 0))
            end
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false

local function createHighlight(character)
    if character and character:FindFirstChild("Head") and not character:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.new(1, 0, 0) -- Màu đỏ
        highlight.OutlineColor = Color3.new(1, 1, 1) -- Viền trắng
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end
end

local function removeHighlight(character)
    local highlight = character:FindFirstChild("ESP_Highlight")
    if highlight then
        highlight:Destroy()
    end
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                if ESPEnabled then
                    createHighlight(character)
                else
                    removeHighlight(character)
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1)
        if ESPEnabled then
            createHighlight(character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeHighlight(player.Character)
    end
end)

RunService.RenderStepped:Connect(function()
    updateESP()
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createHighlight(player.Character)
    end
end

local ESPTab = Window:AddTab({ Title = "ESP", Section = "Main", Icon = "rbxassetid://7300480952" })

Window:AddToggle({
    Title = "Bật ESP",
    Description = "Hiển thị highlight cho người chơi khác",
    Tab = ESPTab,
    Callback = function(state)
        ESPEnabled = state
        if not ESPEnabled then
          
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    removeHighlight(player.Character)
                end
            end
        else
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    createHighlight(player.Character)
                end
            end
        end
    end
})

local NoclipTab = Window:AddTab({
    Title = "Noclip",
    Section = "Main",
    Icon = "rbxassetid://7300486042"
})

Window:AddToggle({
    Title = "Bật Noclip",
    Description = "Cho phép xuyên vật thể",
    Tab = NoclipTab,
    Callback = function(state)
        noclipOn = state
        if noclipOn then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = Player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local character = Player.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local noclipKey = Enum.KeyCode.N

Window:AddKeybind({
    Title = "Phím tắt Noclip",
    Description = "Nhấn phím này để bật/tắt Noclip",
    Tab = NoclipTab,
    Default = noclipKey,
    Callback = function(key)
        noclipKey = key
    end,
})

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == noclipKey then
        noclipOn = not noclipOn
        Window:SetToggle("Bật Noclip", noclipOn)
    end
end)

local AimTab = Window:AddTab({
    Title = "Aimlock",
    Section = "Main",
    Icon = "rbxassetid://7300486042"
})

local aimEnabled = false
local aimFOV = 250
local aimSmoothness = 0.2
local currentTarget = nil
local camera = workspace.CurrentCamera
local mouse = Player:GetMouse()

local function highlightTarget(target)
    if not target then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1
    highlight.Name = "AimHighlight"
    highlight.Parent = target.Character
end

local function clearHighlights()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("AimHighlight") then
            plr.Character.AimHighlight:Destroy()
        end
    end
end

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = aimFOV
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= Player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = target
                end
            end
        end
    end
    return closestPlayer
end

local function aimAt(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local targetPos = target.Character.HumanoidRootPart.Position
    local camPos = camera.CFrame.Position
    local targetCF = CFrame.new(camPos, targetPos)
    camera.CFrame = camera.CFrame:Lerp(targetCF, aimSmoothness)
end

Window:AddToggle({
    Title = "Bật Aimlock",
    Description = "Tự động ngắm mục tiêu gần chuột",
    Tab = AimTab,
    Callback = function(state)
        aimEnabled = state
        if not aimEnabled then
            clearHighlights()
            currentTarget = nil
        end
    end
})

Window:AddSlider({
    Title = "FOV",
    Description = "Khoảng cách gần chuột để chọn mục tiêu",
    Tab = AimTab,
    MinValue = 50,
    MaxValue = 500,
    Default = aimFOV,
    AllowDecimals = false,
    Callback = function(val)
        aimFOV = val
    end,
})

Window:AddSlider({
    Title = "Mượt",
    Description = "Lerp tốc độ quay camera",
    Tab = AimTab,
    MinValue = 0.01,
    MaxValue = 1,
    Default = aimSmoothness,
    AllowDecimals = true,
    Callback = function(val)
        aimSmoothness = val
    end,
})

RunService.RenderStepped:Connect(function()
    if aimEnabled then
        currentTarget = getClosestPlayerToMouse()
        clearHighlights()
        if currentTarget then
            highlightTarget(currentTarget)
            aimAt(currentTarget)
        end
    end
end)