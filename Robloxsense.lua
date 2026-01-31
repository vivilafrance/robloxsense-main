local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vivilafrance/robloxsense-main/refs/heads/main/Library.lua"))()

local Window = Library:Window({Name = "Robloxsense", Logo = "114505281882979"})
local Watermark = Library:Watermark("Robloxsense - ".. os.date("%b %d %Y") .. " - ".. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
local KeybindList = Library:KeybindList()

local Hooked = {}
local Detected, Kill
local FoundAC = false

local AdonisBypassEnabled = true

if AdonisBypassEnabled then
    setthreadidentity(2)

    for i, v in getgc(true) do
        if typeof(v) == "table" then
            local DetectFunc = rawget(v, "Detected")
            local KillFunc = rawget(v, "Kill")

            if typeof(DetectFunc) == "function" and not Detected then
                Detected = DetectFunc
                FoundAC = true

                local Old
                Old = hookfunction(Detected, function(Action, Info, NoCrash)
                    return true
                end)
                table.insert(Hooked, Detected)
            end

            if rawget(v, "Variables") and rawget(v, "Process") and typeof(KillFunc) == "function" and not Kill then
                Kill = KillFunc

                local Old
                Old = hookfunction(Kill, function(Info)
                end)
                table.insert(Hooked, Kill)
            end
        end
    end

    if Detected then
        local Old
        Old = hookfunction(getrenv().debug.info, newcclosure(function(...)
            local LevelOrFunc = ...
            if LevelOrFunc == Detected then
                return coroutine.yield(coroutine.running())
            end
            return Old(...)
        end))
    end

    setthreadidentity(7)
end
if FoundAC then
    Library:Notification("Anticheat detected! activated bypass", 5)
else
    Library:Notification("No anticheat detected", 5)
end
local RunService = game:GetService("RunService")
local Lighting = game:GetService('Lighting')
local UserInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local player = game:GetService("Players").LocalPlayer
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local hum = Character:WaitForChild("Humanoid")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local CombatTab = Window:Page({Name = "Combat", Columns = 3, Subtabs = false})
local MiscsTab = Window:Page({Name = "Misc", Columns = 2, Subtabs = false})
local EspTab = Window:Page({Name = "Esp", Columns = 2, Subtabs = false})
local VisualsTab = Window:Page({Name = "Visuals", Columns = 2, Subtabs = false})
local PlayerTab = Window:Page({Name = "Players", Columns = 2, Subtabs = false})
local SettingsPage = Library:CreateSettingsPage(Window, KeybindList, Watermark)

do
local frag = {fonts={}}
local char = {}
local CoreGui = cloneref(game:GetService("CoreGui"))
do
    function frag:registerfont(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then writefile(Asset.Id, Asset.Font) end
        if isfile(Name .. ".font") then delfile(Name .. ".font") end
        local Data = {
            name = Name,
            faces = {
                {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }
        writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))
        return getcustomasset(Name .. ".font")
    end
    frag.fonts.smallestpixel7 = Font.new(frag:registerfont("Verdana", 100, "normal", {
        Id = "verdana.ttf",
        Font = crypt.base64.decode(game:HttpGet("https://raw.githubusercontent.com/vivilafrance/robloxsense-main/refs/heads/main/assets/font2"))
    }))
end

frag.esp = {
    enabled = false,
    teamcheck = false,
    distanceESPCheck = false,
    maxdist = 1500,
    box = false,
    boxColor = Color3.fromRGB(255,255,255),
    boxUseGradient = false,
    boxGradient = {Color3.fromRGB(0,0,255), Color3.fromRGB(0,255,255)},
    boxGradientAnimation = false,
    boxGradientRotationSpeed = 60,
    boxGradientUseManual = false,
    boxGradientManualRotation = 90,
    fill = false,
    fillColor = Color3.fromRGB(0,255,0),
    fillUseGradient = false,
    fillGradient = {Color3.fromRGB(0,0,255), Color3.fromRGB(0,255,255)},
    fillTransparency = 0.3,
    fillGradientRotationEnabled = false,
    fillGradientRotationSpeed = 90,
    fillGradientUseManualRotation = false,
    fillGradientManualRotation = 90,
    healthbar = false,
    healthColor = Color3.fromRGB(0,255,0),
    healthUseGradient = false,
    healthGradient = {Color3.fromRGB(0,0,255), Color3.fromRGB(0,255,255)},
    healthLerpEnabled = false,
    healthLerpDuration = 1,
    healthThickness = 1,
    healthtext = false,
    healthtextColor = Color3.fromRGB(0,255,0),
    name = false,
    nameColor = Color3.fromRGB(255,255,255),
    weapon = false,
    weaponColor = Color3.fromRGB(255,255,255),
    distanceesp = false,
    distanceLabelColor = Color3.fromRGB(255,255,255),
    chams = {
        enabled = false,
        fillColor = Color3.fromRGB(0,0,255),
        outlineColor = Color3.fromRGB(0,255,255),
        fillTransparency = 0,
        outlineTransparency = 0,
        visibleCheck = false,
        thermal = false,
    },
    syncGradientAnimation = false
}

local function CreateClass(Class, Properties)
    local ClassInt = typeof(Class) == "string" and Instance.new(Class) or Class
    for Property, Value in next, Properties do
        ClassInt[Property] = Value
    end
    return ClassInt
end

local ESPHolder = CreateClass("ScreenGui", {Parent = CoreGui, Name = "ESPHolder"})

local Camera = workspace.CurrentCamera

local function DupeCheck(plr)
    if ESPHolder:FindFirstChild(plr.Name) then
        ESPHolder[plr.Name]:Destroy()
    end
end

function char:getweapon(c)
    for _, v in pairs(c:GetChildren()) do
        if v:IsA("Tool") then
            return v.Name
        elseif v:IsA("Model") and v.PrimaryPart and (v:FindFirstChild("Handle") or v:FindFirstChild("Main") or v:FindFirstChild("Attachments")) then
            return v.Name
        end
    end
    return "None"
end

function char:UpdateESP(plrd)
    coroutine.wrap(DupeCheck)(plrd)
    
    local Container = CreateClass("Frame", {Parent = ESPHolder, Name = plrd.Name, BackgroundTransparency = 1})
    
    local Cham = Instance.new("Highlight")
    Cham.Name = "ESP_Cham_" .. plrd.Name
    Cham.Parent = ESPHolder
    Cham.Enabled = false
    Cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Cham.FillTransparency = frag.esp.chams.fillTransparency
    Cham.OutlineTransparency = frag.esp.chams.outlineTransparency
    Cham.FillColor = frag.esp.chams.fillColor
    Cham.OutlineColor = frag.esp.chams.outlineColor

    local BoxFrame = CreateClass("Frame", {Parent = ESPHolder, BackgroundTransparency = 1})
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Parent = BoxFrame
    BoxStroke.Thickness = frag.esp.boxOutlineThickness or 1.4
    BoxStroke.Color = frag.esp.boxOutlineColor or Color3.fromRGB(0, 0, 0)
    BoxStroke.Transparency = frag.esp.boxOutlineTransparency or 0
    BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BoxStroke.LineJoinMode = Enum.LineJoinMode.Round
    
    local BoxGradient = Instance.new("UIGradient")
    BoxGradient.Parent = BoxStroke

    local FillBox = CreateClass("Frame", {Parent = BoxFrame, BackgroundTransparency = frag.esp.fillTransparency, BorderSizePixel = 0})
    local GradientFill = CreateClass("UIGradient", {Parent = FillBox, Rotation = -90})

    local NameLabel = CreateClass("TextLabel", {
        Parent = ESPHolder,
        FontFace = frag.fonts.smallestpixel7,
        TextSize = 11,
        TextColor3 = frag.esp.nameColor,
        TextStrokeColor3 = Color3.new(0,0,0),
        TextStrokeTransparency = 0,
        BackgroundTransparency = 1,
        RichText = true
    })
    
    local WeaponLabel = CreateClass("TextLabel", {
        Parent = ESPHolder,
        FontFace = frag.fonts.smallestpixel7,
        TextSize = 11,
        TextColor3 = frag.esp.weaponColor,
        TextStrokeColor3 = Color3.new(0,0,0),
        TextStrokeTransparency = 0,
        BackgroundTransparency = 1,
        RichText = true
    })
    
    local DistanceLabel = CreateClass("TextLabel", {
        Parent = ESPHolder,
        FontFace = frag.fonts.smallestpixel7,
        TextSize = 11,
        TextColor3 = frag.esp.distanceLabelColor,
        TextStrokeColor3 = Color3.new(0,0,0),
        TextStrokeTransparency = 0,
        BackgroundTransparency = 1,
        RichText = true
    })
    
    local Healthbar = CreateClass("Frame", {Parent = ESPHolder, BackgroundTransparency = 0})
    local BehindHealthbar = CreateClass("Frame", {Parent = ESPHolder, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0,0,0)})
    local HealthGrad = CreateClass("UIGradient", {Parent = Healthbar, Rotation = -90})
    local HealthText = CreateClass("TextLabel", {
        Parent = ESPHolder,
        FontFace = frag.fonts.smallestpixel7,
        TextSize = 11,
        TextColor3 = frag.esp.healthtextColor,
        TextStrokeColor3 = Color3.new(0,0,0),
        TextStrokeTransparency = 0,
        BackgroundTransparency = 1,
        RichText = true,
        Visible = false
    })

    local CurrentHealth = 0
    local scaleMultiplier = 1.2
    local fillGradientRotation = 90
    local boxGradientRotation = frag.esp.boxGradientManualRotation
    local sharedGradientRotation = boxGradientRotation

    local function ColorESP()
        if frag.esp.boxUseGradient then
            BoxStroke.Color = Color3.new(1,1,1)
            BoxGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, frag.esp.boxGradient[1]),
                ColorSequenceKeypoint.new(1, frag.esp.boxGradient[2])
            }
            BoxGradient.Enabled = true
            if frag.esp.boxGradientUseManual then
                BoxGradient.Rotation = frag.esp.boxGradientManualRotation
            end
        else
            BoxStroke.Color = frag.esp.boxColor
            BoxGradient.Enabled = false
        end
        
        FillBox.BackgroundTransparency = frag.esp.fillTransparency
        if frag.esp.fill then
            if frag.esp.fillUseGradient then
                GradientFill.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, frag.esp.fillGradient[1]),
                    ColorSequenceKeypoint.new(1, frag.esp.fillGradient[2])
                }
            else
                GradientFill.Color = ColorSequence.new(frag.esp.fillColor)
            end
        end
        
        if frag.esp.healthbar then
            if frag.esp.healthUseGradient then
                HealthGrad.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, frag.esp.healthGradient[1]),
                    ColorSequenceKeypoint.new(1, frag.esp.healthGradient[2])
                }
            else
                HealthGrad.Color = ColorSequence.new(frag.esp.healthColor)
            end
        end
        
        NameLabel.TextColor3 = frag.esp.nameColor
        WeaponLabel.TextColor3 = frag.esp.weaponColor
        DistanceLabel.TextColor3 = frag.esp.distanceLabelColor
        HealthText.TextColor3 = frag.esp.healthtextColor
    end

    local function HideESP()
        BoxFrame.Visible = false
        FillBox.Visible = false
        NameLabel.Visible = false
        WeaponLabel.Visible = false
        DistanceLabel.Visible = false
        Healthbar.Visible = false
        BehindHealthbar.Visible = false
        HealthText.Visible = false
    end

    local connection
    connection = RunService.Heartbeat:Connect(function(delta)
        local plrChar = plrd.Character
        if plrChar and plrChar:FindFirstChild("HumanoidRootPart") and plrChar:FindFirstChild("Humanoid") and plrChar.Humanoid.Health > 0 then
            if not frag.esp.enabled or (frag.esp.teamcheck and plrd.Team == LocalPlayer.Team) then
                Cham.Enabled = false
                HideESP()
                return
            end
            
            local rootPart = plrChar.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToScreenPoint(rootPart.Position)
            local scaleFactor = 15 / (Pos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
            local Dist = (rootPart.Position - Camera.CFrame.Position).Magnitude
            local w, h = 2.4 * scaleFactor, 3.79 * scaleFactor
            local bigW, bigH = w * scaleMultiplier, h * scaleMultiplier
            
            if frag.esp.distanceESPCheck and Dist > frag.esp.maxdist then
                Cham.Enabled = false
                HideESP()
                return
            end
            
            if frag.esp.chams.enabled then
                Cham.Adornee = plrChar
                Cham.Enabled = true
                Cham.FillColor = frag.esp.chams.fillColor
                Cham.OutlineColor = frag.esp.chams.outlineColor
                Cham.FillTransparency = frag.esp.chams.fillTransparency
                Cham.OutlineTransparency = frag.esp.chams.outlineTransparency
                Cham.DepthMode = frag.esp.chams.visibleCheck and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            else
                Cham.Enabled = false
            end
            
            if OnScreen then
                ColorESP()
                
                local useSync = frag.esp.syncGradientAnimation 
                             and frag.esp.boxGradientAnimation 
                             and frag.esp.fillGradientRotationEnabled
                
                if useSync then
                    sharedGradientRotation = (sharedGradientRotation + frag.esp.boxGradientRotationSpeed * delta) % 360
                    
                    if frag.esp.boxUseGradient and not frag.esp.boxGradientUseManual then
                        BoxGradient.Rotation = sharedGradientRotation
                    end
                    
                    if frag.esp.fillUseGradient and not frag.esp.fillGradientUseManualRotation then
                        GradientFill.Rotation = sharedGradientRotation
                    end
                else
                    if frag.esp.boxUseGradient and not frag.esp.boxGradientUseManual and frag.esp.boxGradientAnimation then
                        boxGradientRotation = (boxGradientRotation + frag.esp.boxGradientRotationSpeed * delta) % 360
                        BoxGradient.Rotation = boxGradientRotation
                    end
                    
                    if frag.esp.fillUseGradient then
                        if frag.esp.fillGradientUseManualRotation then
                            GradientFill.Rotation = frag.esp.fillGradientManualRotation
                        elseif frag.esp.fillGradientRotationEnabled then
                            fillGradientRotation = (fillGradientRotation + frag.esp.fillGradientRotationSpeed * delta) % 360
                            GradientFill.Rotation = fillGradientRotation
                        end
                    end
                end
                
                BoxFrame.Visible = frag.esp.box
                BoxFrame.Position = UDim2.new(0, Pos.X - bigW/2, 0, Pos.Y - bigH/2)
                BoxFrame.Size = UDim2.new(0, bigW, 0, bigH)
                
                FillBox.Visible = frag.esp.fill
                FillBox.Position = UDim2.new(0, 0, 0, 0)
                FillBox.Size = UDim2.new(1, 0, 1, 0)
                
                if frag.esp.healthbar then
                    local maxHealth = plrChar.Humanoid.MaxHealth
                    local currentHealth = plrChar.Humanoid.Health
                    local targetHealth = math.clamp(currentHealth / maxHealth, 0, 1)
                    
                    if frag.esp.healthLerpEnabled then
                        CurrentHealth = CurrentHealth + (targetHealth - CurrentHealth) * math.clamp(delta / math.max(frag.esp.healthLerpDuration, 0.01), 0, 1)
                    else
                        CurrentHealth = targetHealth
                    end
                    
                    Healthbar.Visible = true
                    BehindHealthbar.Visible = true
                    
                    local thickness = frag.esp.healthThickness
                    Healthbar.Position = UDim2.new(0, Pos.X - bigW/2 - (thickness + 4), 0, Pos.Y - bigH/2 + bigH * (1 - CurrentHealth))
                    Healthbar.Size = UDim2.new(0, thickness, 0, bigH * CurrentHealth)
                    
                    BehindHealthbar.Position = UDim2.new(0, Pos.X - bigW/2 - (thickness + 4), 0, Pos.Y - bigH/2)
                    BehindHealthbar.Size = UDim2.new(0, thickness, 0, bigH)
                    
                    if frag.esp.healthtext then
                        HealthText.Visible = true
                        HealthText.Text = tostring(math.floor(CurrentHealth * 100)) .. "%"
                        HealthText.Position = UDim2.new(0, Pos.X - bigW/2 - (thickness + 22), 0, Pos.Y - bigH/2 + 1)
                    else
                        HealthText.Visible = false
                    end
                else
                    Healthbar.Visible = false
                    BehindHealthbar.Visible = false
                    HealthText.Visible = false
                end
                
                NameLabel.Visible = frag.esp.name
                NameLabel.Text = plrd.Name
                NameLabel.Position = UDim2.new(0, Pos.X, 0, Pos.Y - bigH/2 - 9)
                
                local baseY = Pos.Y + bigH/2
                
                WeaponLabel.Visible = frag.esp.weapon
                if frag.esp.weapon then
                    WeaponLabel.Text = char:getweapon(plrChar)
                    WeaponLabel.Position = UDim2.new(0, Pos.X, 0, baseY + 5)
                    DistanceLabel.Position = UDim2.new(0, Pos.X, 0, baseY + 15)
                else
                    WeaponLabel.Visible = false
                    DistanceLabel.Position = UDim2.new(0, Pos.X, 0, baseY + 5)
                end
                
                DistanceLabel.Visible = frag.esp.distanceesp
                DistanceLabel.Text = math.floor(Dist) .. "m"
            else
                HideESP()
            end
        else
            Cham.Enabled = false
            HideESP()
            
            if not plrd or not plrd.Parent then
                pcall(function()
                    if Cham and Cham.Parent then Cham:Destroy() end
                    if Container and Container.Parent then Container:Destroy() end
                    if BoxFrame and BoxFrame.Parent then BoxFrame:Destroy() end
                    if FillBox and FillBox.Parent then FillBox:Destroy() end
                    if NameLabel and NameLabel.Parent then NameLabel:Destroy() end
                    if WeaponLabel and WeaponLabel.Parent then WeaponLabel:Destroy() end
                    if DistanceLabel and DistanceLabel.Parent then DistanceLabel:Destroy() end
                    if Healthbar and Healthbar.Parent then Healthbar:Destroy() end
                    if BehindHealthbar and BehindHealthbar.Parent then BehindHealthbar:Destroy() end
                    if HealthText and HealthText.Parent then HealthText:Destroy() end
                end)
                
                if connection and connection.Connected then connection:Disconnect() end
            end
        end
    end)
end

local ESPSection = EspTab:Section({Name = "Esp", Side = 1})
local Chamsettings = EspTab:Section({Name = "Cham settings", Side = 1})
local ESPSettings = EspTab:Section({Name = "Esp settings", Side = 2})
local Boxsettings = EspTab:Section({Name = "Box settings", Side = 2})
local Fillboxsettings = EspTab:Section({Name = "Fill box settings", Side = 2})
local Healthsetting = EspTab:Section({Name = "Health setting", Side = 2})

ESPSection:Toggle({Name = "Enable esp", Flag = "ESPEnabled", Default = frag.esp.enabled, Callback = function(Value) frag.esp.enabled = Value end})
ESPSettings:Toggle({Name = "Enable team check", Flag = "TeamCheck", Default = frag.esp.teamcheck, Callback = function(Value) frag.esp.teamcheck = Value end})
ESPSettings:Toggle({Name = "Enable distance check", Flag = "DistanceCheck", Default = frag.esp.distanceESPCheck, Callback = function(Value) frag.esp.distanceESPCheck = Value end})
ESPSettings:Slider({Name = "Max distance", Flag = "MaxDistance", Min = 50, Max = 5000, Default = frag.esp.maxdist, Decimals = 0.1, Callback = function(Value) frag.esp.maxdist = Value end})

local BoxESP = ESPSection:Toggle({Name = "Box", Flag = "BoxESP", Default = frag.esp.box, Callback = function(Value) frag.esp.box = Value end})
BoxESP:Colorpicker({Name = "Box Color", Flag = "BoxColor", Default = frag.esp.boxColor, Callback = function(Value) frag.esp.boxColor = Value end})

local boxgra = ESPSection:Toggle({Name = "Box use gradient", Flag = "BoxUseGradient", Default = frag.esp.boxUseGradient, Callback = function(Value) frag.esp.boxUseGradient = Value end})
boxgra:Colorpicker({Name = "Gradient Color 1", Flag = "BoxGradientColor1", Default = frag.esp.boxGradient[1], Callback = function(Value) frag.esp.boxGradient[1] = Value end})
boxgra:Colorpicker({Name = "Gradient Color 2", Flag = "BoxGradientColor2", Default = frag.esp.boxGradient[2], Callback = function(Value) frag.esp.boxGradient[2] = Value end})
Boxsettings:Toggle({Name = "Box gradient animation", Flag = "BoxGradientAnimation", Default = frag.esp.boxGradientAnimation, Callback = function(Value) frag.esp.boxGradientAnimation = Value end})
Boxsettings:Slider({Name = "Box gradient animation speed", Flag = "BoxGradientRotationSpeed", Min = 10, Max = 360, Default = frag.esp.boxGradientRotationSpeed, Decimals = 1, Callback = function(Value) frag.esp.boxGradientRotationSpeed = Value end})
Boxsettings:Toggle({Name = "Box gradient rotation", Flag = "BoxGradientUseManual", Default = frag.esp.boxGradientUseManual, Callback = function(Value) frag.esp.boxGradientUseManual = Value end})
Boxsettings:Slider({Name = "Box gradient rotation angle", Flag = "BoxGradientManualRotation", Min = 0, Max = 360, Default = frag.esp.boxGradientManualRotation, Decimals = 1, Callback = function(Value) frag.esp.boxGradientManualRotation = Value end})

Boxsettings:Toggle({
    Name = "Sync gradient animation",
    Flag = "SyncGradientAnim",
    Default = frag.esp.syncGradientAnimation,
    Callback = function(Value)
        frag.esp.syncGradientAnimation = Value
    end
})

local FillESP = ESPSection:Toggle({Name = "Fill box", Flag = "FillESP", Default = frag.esp.fill, Callback = function(Value) frag.esp.fill = Value end})
FillESP:Colorpicker({Name = "Fill Color", Flag = "FillColor", Default = frag.esp.fillColor, Callback = function(Value) frag.esp.fillColor = Value end})
local FillGradient = ESPSection:Toggle({Name = "Fill use gradient", Flag = "FillUseGradient", Default = frag.esp.fillUseGradient, Callback = function(Value) frag.esp.fillUseGradient = Value end})
FillGradient:Colorpicker({Name = "Fill Gradient 1", Flag = "FillGradientColor1", Default = frag.esp.fillGradient[1], Callback = function(Value) frag.esp.fillGradient[1] = Value end})
FillGradient:Colorpicker({Name = "Fill Gradient 2", Flag = "FillGradientColor2", Default = frag.esp.fillGradient[2], Callback = function(Value) frag.esp.fillGradient[2] = Value end})
Fillboxsettings:Slider({Name = "Fill transparency", Flag = "FillBoxTransparency", Min = 0, Max = 1, Default = frag.esp.fillTransparency, Decimals = 0.1, Callback = function(Value) frag.esp.fillTransparency = Value end})
Fillboxsettings:Toggle({Name = "Fill gradient animation", Flag = "FillGradientRotationEnabled", Default = frag.esp.fillGradientRotationEnabled, Callback = function(Value) frag.esp.fillGradientRotationEnabled = Value end})
Fillboxsettings:Slider({Name = "Fill gradient animation speed", Flag = "FillGradientRotationSpeed", Min = 1, Max = 500, Default = frag.esp.fillGradientRotationSpeed, Decimals = 1, Callback = function(Value) frag.esp.fillGradientRotationSpeed = Value end})
Fillboxsettings:Toggle({Name = "Fill gradient rotation", Flag = "FillGradientManualRotationToggle", Default = frag.esp.fillGradientUseManualRotation, Callback = function(Value) frag.esp.fillGradientUseManualRotation = Value end})
Fillboxsettings:Slider({Name = "Fill gradient rotation angle", Flag = "FillGradientManualRotationSlider", Min = 0, Max = 360, Default = frag.esp.fillGradientManualRotation, Callback = function(Value) frag.esp.fillGradientManualRotation = Value end})

local HealthBar = ESPSection:Toggle({Name = "Health bar", Flag = "HealthESP", Default = frag.esp.healthbar, Callback = function(Value) frag.esp.healthbar = Value end})
HealthBar:Colorpicker({Name = "Health Color", Flag = "HealthColor", Default = frag.esp.healthColor, Callback = function(Value) frag.esp.healthColor = Value end})
local HealthText = ESPSection:Toggle({Name = "Health text", Flag = "HealthText", Default = frag.esp.healthtext, Callback = function(Value) frag.esp.healthtext = Value end})
HealthText:Colorpicker({Name = "Health Text Color", Flag = "HealthTextColor", Default = frag.esp.healthtextColor, Callback = function(Value) frag.esp.healthtextColor = Value end})
local HealthGradient = ESPSection:Toggle({Name = "Health use gradient", Flag = "HealthUseGradient", Default = frag.esp.healthUseGradient, Callback = function(Value) frag.esp.healthUseGradient = Value end})
HealthGradient:Colorpicker({Name = "Health Gradient 1", Flag = "HealthGradientColor1", Default = frag.esp.healthGradient[1], Callback = function(Value) frag.esp.healthGradient[1] = Value end})
HealthGradient:Colorpicker({Name = "Health Gradient 2", Flag = "HealthGradientColor2", Default = frag.esp.healthGradient[2], Callback = function(Value) frag.esp.healthGradient[2] = Value end})
Healthsetting:Slider({Name = "Health bar thickness", Flag = "HealthThickness", Min = 1, Max = 10, Default = frag.esp.healthThickness, Decimals = 1, Callback = function(Value) frag.esp.healthThickness = Value end})

local Chams = ESPSection:Toggle({Name = "Chams", Flag = "ChamsEnabled", Default = frag.esp.chams.enabled, Callback = function(Value) frag.esp.chams.enabled = Value end})
Chams:Colorpicker({Name = "Chams fill", Flag = "ChamsFill", Default = frag.esp.chams.fillColor, Callback = function(Value) frag.esp.chams.fillColor = Value end})
Chams:Colorpicker({Name = "Chams outline", Flag = "ChamsOutline", Default = frag.esp.chams.outlineColor, Callback = function(Value) frag.esp.chams.outlineColor = Value end})
Chamsettings:Toggle({Name = "Chams visible check", Flag = "ChamsVisibleCheck", Default = frag.esp.chams.visibleCheck, Callback = function(Value) frag.esp.chams.visibleCheck = Value end})
Chamsettings:Toggle({Name = "Chams thermal", Flag = "ChamsThermal", Default = frag.esp.chams.thermal, Callback = function(Value) frag.esp.chams.thermal = Value end})
Chamsettings:Slider({Name = "Chams fill transparency", Flag = "ChamsFillTrans", Min = 0, Max = 1, Default = frag.esp.chams.fillTransparency, Decimals = 0.1, Callback = function(Value) frag.esp.chams.fillTransparency = Value end})
Chamsettings:Slider({Name = "Chams outline transparency", Flag = "ChamsOutlineTrans", Min = 0, Max = 1, Default = frag.esp.chams.outlineTransparency, Decimals = 0.1, Callback = function(Value) frag.esp.chams.outlineTransparency = Value end})

local NameESP = ESPSection:Toggle({Name = "Name", Flag = "NameESP", Default = frag.esp.name, Callback = function(Value) frag.esp.name = Value end})
NameESP:Colorpicker({Name = "Name Color", Flag = "NameColor", Default = frag.esp.nameColor, Callback = function(Value) frag.esp.nameColor = Value end})
local WeaponESP = ESPSection:Toggle({Name = "Weapon", Flag = "WeaponESP", Default = frag.esp.weapon, Callback = function(Value) frag.esp.weapon = Value end})
WeaponESP:Colorpicker({Name = "Weapon Color", Flag = "WeaponColor", Default = frag.esp.weaponColor, Callback = function(Value) frag.esp.weaponColor = Value end})
local DistanceESP = ESPSection:Toggle({Name = "Distance", Flag = "DistanceESP", Default = frag.esp.distanceesp, Callback = function(Value) frag.esp.distanceesp = Value end})
DistanceESP:Colorpicker({Name = "Distance Color", Flag = "DistanceColor", Default = frag.esp.distanceLabelColor, Callback = function(Value) frag.esp.distanceLabelColor = Value end})

for _,v in next,Players:GetPlayers() do
    if v ~= LocalPlayer then
        char:UpdateESP(v)
    end
end

Players.PlayerAdded:Connect(function(v)
    if v ~= LocalPlayer then
        char:UpdateESP(v)
    end
end)

Players.PlayerRemoving:Connect(function(v)
    if ESPHolder:FindFirstChild(v.Name) then
        pcall(function() ESPHolder[v.Name]:Destroy() end)
    end
    local cham = ESPHolder:FindFirstChild("ESP_Cham_" .. v.Name)
    if cham then pcall(function() cham:Destroy() end) end
end)
end
do
local HitSoundEnabled = false
local KillSoundEnabled = false
local HitNotifyEnabled = false
local KillNotifyEnabled = false
local SelectedHitSound = "Rust"
local SelectedKillSound = "Rust"
local HitSoundVolume = 3
local KillSoundVolume = 3
local HitNotifyTime = 4
local KillNotifyTime = 4

local sounds = {
    ["RIFK7"] = "rbxassetid://9102080552",
    ["Bubble"] = "rbxassetid://9102092728",
    ["Minecraft"] = "rbxassetid://5869422451",
    ["Cod"] = "rbxassetid://160432334",
    ["Bameware"] = "rbxassetid://6565367558",
    ["Neverlose"] = "rbxassetid://6565370984",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"] = "rbxassetid://6565371338",
}

local HitBase = Instance.new("Sound")
HitBase.Name = "HitSound"
HitBase.Volume = HitSoundVolume
HitBase.SoundId = sounds[SelectedHitSound]
HitBase.Parent = SoundService

local KillBase = Instance.new("Sound")
KillBase.Name = "KillSound"
KillBase.Volume = KillSoundVolume
KillBase.SoundId = sounds[SelectedKillSound]
KillBase.Parent = SoundService

local hitPool, hitIdx = {}, 1
local killPool, killIdx = {}, 1

local function nextHitSound()
    if hitIdx > #hitPool then
        local s = HitBase:Clone()
        s.Looped = false
        s.Parent = SoundService
        table.insert(hitPool, s)
    end
    local s = hitPool[hitIdx]
    hitIdx = (hitIdx % #hitPool) + 1
    return s
end

local function nextKillSound()
    if killIdx > #killPool then
        local s = KillBase:Clone()
        s.Looped = false
        s.Parent = SoundService
        table.insert(killPool, s)
    end
    local s = killPool[killIdx]
    killIdx = (killIdx % #killPool) + 1
    return s
end

local function playHit()
    if not HitSoundEnabled then return end
    local s = nextHitSound()
    s.TimePosition = 0
    s:Play()
end

local function playKill()
    if not KillSoundEnabled then return end
    local s = nextKillSound()
    s.TimePosition = 0
    s:Play()
end

local lastHealth = {}
local didKill = {}

local function onCharacter(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end

    lastHealth[hum] = hum.Health
    didKill[hum] = false

    hum.HealthChanged:Connect(function(newHealth)
        local tag = hum:FindFirstChild("creator")
        if tag and tag.Value == LocalPlayer then
            local damage = lastHealth[hum] - newHealth

            if damage > 0 then
                playHit()
                if HitNotifyEnabled then
                    Library:Notification(
                        "Hit " .. char.Name .. " (" .. math.floor(damage) .. " dmg)",
                        HitNotifyTime,
                        Library.Theme.Accent
                    )
                end
            end

            if newHealth <= 0 and not didKill[hum] then
                playKill()
                if KillNotifyEnabled then
                    Library:Notification(
                        "You killed " .. char.Name .. "!",
                        KillNotifyTime,
                        Library.Theme.Accent
                    )
                end
                didKill[hum] = true
            end
        end

        lastHealth[hum] = newHealth
    end)

    hum.Died:Connect(function()
        lastHealth[hum] = nil
        didKill[hum] = nil
    end)
end

local function onPlayer(plr)
    if plr == LocalPlayer then return end
    if plr.Character then onCharacter(plr.Character) end
    plr.CharacterAdded:Connect(onCharacter)
end

for _, p in ipairs(Players:GetPlayers()) do
    onPlayer(p)
end

Players.PlayerAdded:Connect(onPlayer)

local Hitsound = MiscsTab:Section({Name = "Hitsound", Side = 1})

Hitsound:Toggle({
    Name = "Enable hitsound",
    Flag = "HitSoundToggle",
    Default = false,
    Callback = function(v) HitSoundEnabled = v end
})

Hitsound:Dropdown({
    Name = "Hitsound select",
    Flag = "HitSoundSelect",
    Default = "Rust",
    Items = (function()
        local t = {}
        for k in pairs(sounds) do table.insert(t, k) end
        return t
    end)(),
    Callback = function(v)
        SelectedHitSound = v
        HitBase.SoundId = sounds[v]
        for _, s in ipairs(hitPool) do s.SoundId = sounds[v] end
    end
})

Hitsound:Slider({
    Name = "Hitsound volume",
    Flag = "HitSoundVolume",
    Min = 0,
    Max = 10,
    Default = HitSoundVolume,
    Decimals = 1,
    Callback = function(v)
        HitSoundVolume = v
        HitBase.Volume = v
        for _, s in ipairs(hitPool) do s.Volume = v end
    end
})

Hitsound:Button({
    Name = "Play Hit Sound",
    Callback = function()
        playHit()
    end
})

Hitsound:Toggle({
    Name = "Enable killsound",
    Flag = "KillSoundToggle",
    Default = false,
    Callback = function(v) KillSoundEnabled = v end
})

Hitsound:Dropdown({
    Name = "Killsound select",
    Flag = "KillSoundSelect",
    Default = "Rust",
    Items = (function()
        local t = {}
        for k in pairs(sounds) do table.insert(t, k) end
        return t
    end)(),
    Callback = function(v)
        SelectedKillSound = v
        KillBase.SoundId = sounds[v]
        for _, s in ipairs(killPool) do s.SoundId = sounds[v] end
    end
})

Hitsound:Slider({
    Name = "Killsound volume",
    Flag = "KillSoundVolume",
    Min = 0,
    Max = 10,
    Default = KillSoundVolume,
    Decimals = 1,
    Callback = function(v)
        KillSoundVolume = v
        KillBase.Volume = v
        for _, s in ipairs(killPool) do s.Volume = v end
    end
})

Hitsound:Button({
    Name = "Play Kill Sound",
    Callback = function()
        playKill()
    end
})

local Hitnotify = MiscsTab:Section({Name = "Hitnotify", Side = 2})

Hitnotify:Toggle({
    Name = "Enable hit notify",
    Flag = "HitNotifyToggle",
    Default = false,
    Callback = function(v) HitNotifyEnabled = v end
})

Hitnotify:Slider({
    Name = "Hit notify lifetime",
    Flag = "HitNotifyLifetime",
    Min = 1,
    Max = 10,
    Default = HitNotifyTime,
    Decimals = 1,
    Callback = function(v) HitNotifyTime = v end
})

Hitnotify:Toggle({
    Name = "Enable kill notify",
    Flag = "KillNotifyToggle",
    Default = false,
    Callback = function(v) KillNotifyEnabled = v end
})

Hitnotify:Slider({
    Name = "Kill notify lifetime",
    Flag = "KillNotifyLifetime",
    Min = 1,
    Max = 10,
    Default = KillNotifyTime,
    Decimals = 1,
    Callback = function(v) KillNotifyTime = v end
})
local fovEnabled = false
local fovValue = 120
local zoomAllowed = false
local zoomActive = false
local zoomFov = 40
local DEFAULT_FOV = 70
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNewIndex = mt.__newindex
mt.__newindex = newcclosure(function(self, key, value)
    if self == Camera and key == "FieldOfView" then
        if zoomAllowed and zoomActive then
            return oldNewIndex(self, key, zoomFov)
        end
        if fovEnabled then
            return oldNewIndex(self, key, fovValue)
        end
    end
    return oldNewIndex(self, key, value)
end)
setreadonly(mt, true)
RunService.RenderStepped:Connect(function()
    if zoomAllowed and zoomActive then
        Camera.FieldOfView = zoomFov
    elseif fovEnabled then
        Camera.FieldOfView = fovValue
    end
end)
local Fovchanger = MiscsTab:Section({Name = "Fov changer", Side = 1})
Fovchanger:Toggle({
    Name = "Enable fov changer",
    Flag = "ForceFOVToggle",
    Default = false,
    Callback = function(v)
        fovEnabled = v
        if not v and not zoomActive then
            Camera.FieldOfView = DEFAULT_FOV
        end
    end
})
Fovchanger:Slider({
    Name = "Fov value",
    Flag = "ForceFOVSlider",
    Default = 120,
    Min = 30,
    Max = 120,
    Decimals = 1,
    Callback = function(v)
        fovValue = v
        if fovEnabled and not zoomActive then
            Camera.FieldOfView = fovValue
        end
    end
})
Fovchanger:Toggle({
    Name = "Enable zoom",
    Flag = "ZoomEnable",
    Default = false,
    Callback = function(v)
        zoomAllowed = v
        if not v then
            zoomActive = false
            if fovEnabled then
                Camera.FieldOfView = fovValue
            else
                Camera.FieldOfView = DEFAULT_FOV
            end
        end
    end
}):Keybind({
    Name = "Zoom key",
    Flag = "ZoomKey",
    Default = Enum.KeyCode.Period,
    Mode = "Hold",
    Callback = function(v)
        if not zoomAllowed then return end
        zoomActive = v
        if not v then
            if fovEnabled then
                Camera.FieldOfView = fovValue
            else
                Camera.FieldOfView = DEFAULT_FOV
            end
        end
    end
})
Fovchanger:Slider({
    Name = "Zoom value",
    Flag = "ZoomFov",
    Default = 40,
    Min = 10,
    Max = 90,
    Decimals = 1,
    Callback = function(v)
        zoomFov = v
        if zoomActive then
            Camera.FieldOfView = zoomFov
        end
    end
})
local ThirdPerson = {
    Allowed = false,
    Active = false,
    Offset = Vector3.new(0, 2, -8),
    Sensitivity = 0.15
}
local ThirdPerson = {
    Allowed = false,
    Active = false,
    Offset = Vector3.new(0, 2, -8),
    Sensitivity = 0.15
}
local camConn
local oldType
local oldSubject
local oldMouseBehavior
local yaw, pitch = 0, 0
local lastCFrame
local function getYawPitch(cf)
    local look = cf.LookVector
    return math.deg(math.atan2(-look.X, -look.Z)), math.deg(math.asin(look.Y))
end
local function enableThirdPerson()
    if ThirdPerson.Active then return end
    local char = localPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    ThirdPerson.Active = true
    oldType = Camera.CameraType
    oldSubject = Camera.CameraSubject
    oldMouseBehavior = UserInputService.MouseBehavior
    yaw, pitch = getYawPitch(Camera.CFrame)
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CameraSubject = nil
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    camConn = RunService.RenderStepped:Connect(function()
        if not ThirdPerson.Active or not hrp.Parent then return end

        local delta = UserInputService:GetMouseDelta()
        yaw -= delta.X * ThirdPerson.Sensitivity
        pitch -= delta.Y * ThirdPerson.Sensitivity
        pitch = math.clamp(pitch, -80, 80)
        local rot = CFrame.fromEulerAnglesYXZ(
            math.rad(pitch),
            math.rad(yaw),
            0
        )
        local off = ThirdPerson.Offset
        local camPos =
            hrp.Position +
            rot.RightVector * off.X +
            Vector3.new(0, off.Y, 0) +
            rot.LookVector * off.Z

        local lookPos = camPos + rot.LookVector * 100

        local cf = CFrame.new(camPos, lookPos)
        Camera.CFrame = cf
        lastCFrame = cf
    end)
end
local function disableThirdPerson()
    if not ThirdPerson.Active then return end
    ThirdPerson.Active = false
    if camConn then
        camConn:Disconnect()
        camConn = nil
    end
    if lastCFrame then
        Camera.CFrame = lastCFrame
    end
    Camera.CameraType = oldType or Enum.CameraType.Custom
    Camera.CameraSubject =
        oldSubject
        or (localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid"))

    UserInputService.MouseBehavior = oldMouseBehavior or Enum.MouseBehavior.Default
end
localPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if ThirdPerson.Allowed and ThirdPerson.Active then
        enableThirdPerson()
    end
end)
local CameraSec = MiscsTab:Section({Name = "Third person", Side = 2})
CameraSec:Toggle({
    Name = "Enable third person",
    Flag = "ThirdPersonToggle",
    Default = false,
    Callback = function(v)
        ThirdPerson.Allowed = v
        if not v then
            disableThirdPerson()
        end
    end
}):Keybind({
    Name = "Third Person",
    Flag = "ThirdPersonKey",
    Default = Enum.KeyCode.Period,
    Mode = "Toggle",
    Callback = function(v)
        if not ThirdPerson.Allowed then return end
        if v then
            enableThirdPerson()
        else
            disableThirdPerson()
        end
    end
})
CameraSec:Slider({
    Name = "X",
    Flag = "TP_X",
    Min = -10,
    Max = 10,
    Default = 0,
    Decimals = 1,
    Callback = function(v)
        ThirdPerson.Offset = Vector3.new(v, ThirdPerson.Offset.Y, ThirdPerson.Offset.Z)
    end
})
CameraSec:Slider({
    Name = "Y",
    Flag = "TP_Y",
    Min = -5,
    Max = 10,
    Default = 2,
    Decimals = 1,
    Callback = function(v)
        ThirdPerson.Offset = Vector3.new(ThirdPerson.Offset.X, v, ThirdPerson.Offset.Z)
    end
})
CameraSec:Slider({
    Name = "Z",
    Flag = "TP_Z",
    Min = -25,
    Max = 25,
    Default = -8,
    Decimals = 1,
    Callback = function(v)
        ThirdPerson.Offset = Vector3.new(ThirdPerson.Offset.X, ThirdPerson.Offset.Y, v)
    end
})
end
do
local fov = 250
local smoothing = 1
local aimbotEnabled = false
local aimbotActive = false
local aimbotMode = "Hold"
local fovCircleEnabled = false
local rgbEffectEnabled = false
local fovColor = Color3.fromRGB(255, 255, 255)
local teamCheckEnabled = false
local wallCheckEnabled = false
local healthCheckEnabled = false
local TargetPart = "Head"
local currentBind = Enum.UserInputType.MouseButton2
local currentModifiers = {}
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = fov
FOVring.Transparency = 1
FOVring.Color = fovColor
local function updateFOVCircle()
    if not fovCircleEnabled then
        FOVring.Visible = false
        return
    end
    FOVring.Visible = true
    FOVring.Position = UserInputService:GetMouseLocation()
    FOVring.Radius = fov
    FOVring.Color = rgbEffectEnabled and Color3.fromHSV(tick() % 1, 1, 1) or fovColor
end
local function isTargetVisible(targetPart)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character or workspace}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    local direction = (targetPart.Position - camera.CFrame.Position).Unit * 5000
    local result = workspace:Raycast(camera.CFrame.Position, direction, params)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return false
end
local function getClosestPart(character, mousePos)
    local closest, dist = nil, math.huge
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if d < dist then
                    dist = d
                    closest = part
                end
            end
        end
    end
    return closest
end
local function getPlayerUnderCursor()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == localPlayer then continue end
        if not plr.Character then continue end
        local char = plr.Character
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if healthCheckEnabled and (not humanoid or humanoid.Health <= 0) then
            continue
        end
        if teamCheckEnabled and plr.Team == localPlayer.Team then
            continue
        end
        if forcefieldCheckEnabled and char:FindFirstChildOfClass("ForceField") then
            continue
        end
        local targetPart = TargetPart
        if TargetPart == "Closest" then
            targetPart = getClosestPart(char, mousePos)
        else
            targetPart = char:FindFirstChild(TargetPart)
        end
        if not targetPart then continue end
        local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if distance < fov and distance < dist then
            if not wallCheckEnabled or isTargetVisible(targetPart) then
                dist = distance
                closest = plr
            end
        end
    end
    return closest
end
local function handleAimbot()
    if not aimbotEnabled or not aimbotActive then return end
    local target = getPlayerUnderCursor()
    if target and target.Character then
        local part = TargetPart == "Closest" and getClosestPart(target.Character, UserInputService:GetMouseLocation()) or target.Character:FindFirstChild(TargetPart)
        if part then
            local dir = (part.Position - camera.CFrame.Position).Unit
            local newCF = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + dir)
            camera.CFrame = camera.CFrame:Lerp(newCF, math.clamp(smoothing / 10, 0.01, 1))
        end
    end
end
RunService.RenderStepped:Connect(function()
    handleAimbot()
    updateFOVCircle()
end)
local function onAimbotKeyPressed(state)
    if not aimbotEnabled then
        aimbotActive = false
        return
    end
    if aimbotMode == "Hold" then
        aimbotActive = state
    elseif aimbotMode == "Toggle" then
        if state then
            aimbotActive = not aimbotActive
        end
    elseif aimbotMode == "Always" then
        aimbotActive = aimbotEnabled
    end
end
local AimbotTab = CombatTab:Section({Name = "Aimbot", Side = 1})
AimbotTab:Toggle({
    Name = "Enable aimbot",
    Flag = "AimbotToggle",
    Default = false,
    Callback = function(Value)
        aimbotEnabled = Value
        if not Value then
            aimbotActive = false
        end
    end
}):Keybind({
    Name = "Aimbot",
    Flag = "AimbotKey",
    Default = Enum.UserInputType.MouseButton2,
    Mode = "Hold",
    Callback = onAimbotKeyPressed,
    ChangedCallback = function(NewKey)
    end,
    ModeChangedCallback = function(NewMode)
        aimbotMode = NewMode or "Hold"
        if aimbotMode == "Always" then
            aimbotActive = aimbotEnabled
        end
    end
})
AimbotTab:Slider({
    Name = "Smoothness",
    Flag = "SmoothingSlider",
    Min = 1,
    Max = 10,
    Default = 1,
    Decimals = 1,
    Callback = function(v)
        smoothing = v
    end
})
AimbotTab:Dropdown({
    Name = "Aim part",
    Flag = "Aimpart",
    Default = "Head",
    Items = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest" },
    Callback = function(Value)
        TargetPart = Value
    end
})
_G.HeadExpanderEnabled = false
_G.TeamCheckEnabled = false
_G.HeadSize = 15
_G.HeadTransparency = 0.5
_G.HeadColor = Color3.fromRGB(255, 0, 0)
_G.UseRGBColor = false
_G.RGBDelay = 0.05
local originalProperties = {}
local function RGBColorCycle()
    local hue = 0
    return function()
        hue = (hue + 0.001) % 1
        return Color3.fromHSV(hue, 1, 1)
    end
end
local GetNextRGBColor = RGBColorCycle()
local function restorePlayerHead(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        local props = originalProperties[head]
        if props then
            pcall(function()
                head.Size = props.Size
                head.Transparency = props.Transparency
                head.BrickColor = props.BrickColor
                head.Material = props.Material
                head.CanCollide = props.CanCollide
                head.Massless = props.Massless
            end)
            originalProperties[head] = nil
        end
    end
end
local function applyHitboxExpander()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local isEnemy = not teamCheckEnabled or player.Team ~= LocalPlayer.Team
            if isEnemy then
                local head = player.Character.Head
                if not originalProperties[head] then
                    originalProperties[head] = {
                        Size = head.Size,
                        Transparency = head.Transparency,
                        BrickColor = head.BrickColor,
                        Material = head.Material,
                        CanCollide = head.CanCollide,
                        Massless = head.Massless
                    }
                end
                pcall(function()
                    head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                    head.Transparency = _G.HeadTransparency
                    head.BrickColor = BrickColor.new(_G.UseRGBColor and GetNextRGBColor() or _G.HeadColor)
                    head.Material = Enum.Material.Neon
                    head.CanCollide = false
                    head.Massless = true
                end)
            else
                restorePlayerHead(player)
            end
        end
    end
end
local function restoreHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        restorePlayerHead(player)
    end
    originalProperties = {}
end
task.spawn(function()
    while true do
        if _G.HeadExpanderEnabled then
            applyHitboxExpander()
        end
        task.wait(_G.RGBDelay)
    end
end)
local Hitboxexpander = CombatTab:Section({Name = "Hitbox expander", Side = 3})
Hitboxexpander:Toggle({
    Name = "Enable hitbox expander",
    Flag = "HeadExpanderToggle",
    Default = false,
    Callback = function(Value)
        _G.HeadExpanderEnabled = Value
        if not Value then
            restoreHitboxes()
        else
            applyHitboxExpander()
        end
    end
}):Colorpicker({
    Name = "Head Color",
    Flag = "HeadColorPicker",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        _G.HeadColor = Value
        if _G.HeadExpanderEnabled then
            applyHitboxExpander()
        end
    end
})
Hitboxexpander:Slider({
    Name = "Head size",
    Flag = "HeadSizeSlider",
    Min = 2,
    Max = 50,
    Default = 15,
    Decimals = 1,
    Callback = function(Value)
        _G.HeadSize = Value
        if _G.HeadExpanderEnabled then
            applyHitboxExpander()
        end
    end
})
Hitboxexpander:Slider({
    Name = "Head transparency",
    Flag = "HeadTransparencySlider",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Decimals = 0.1,
    Callback = function(Value)
        _G.HeadTransparency = Value
        if _G.HeadExpanderEnabled then
            applyHitboxExpander()
        end
    end
})
local Settings = CombatTab:Section({Name = "Combat settings", Side = 3})
Settings:Toggle({
    Name = "Enable team check",
    Flag = "TeamCheckToggle",
    Default = false,
    Callback = function(v)
        teamCheckEnabled = v
    end
})
Settings:Toggle({
    Name = "Enable wall check",
    Flag = "WallCheckToggle",
    Default = false,
    Callback = function(v)
        wallCheckEnabled = v
    end
})
Settings:Toggle({
    Name = "Enable health check",
    Flag = "HealthCheckToggle",
    Default = false,
    Callback = function(v)
        healthCheckEnabled = v
    end
})
Settings:Toggle({
    Name = "Enable forcefield check",
    Flag = "ForcefieldCheckToggle",
    Default = false,
    Callback = function(v)
        forcefieldCheckEnabled = v
    end
})
task.spawn(function()
    while task.wait(0.2) do
        if Options and Options.AimbotKey then
            local mode = Options.AimbotKey.Mode or "Hold"
            aimbotMode = mode
            if mode == "Always" then
                aimbotActive = aimbotEnabled
            end
        end
    end
end)
local SilentAimEnabled = false
local SilentAimMethod = "Raycast"
local TargetPartName = "Head"
local BodyPart = nil
local RaycastTarget = nil
local ShowSnapline = false
local RGBFOV = false
local HitChance = 100
local SilentAimSettings = {MultiplyUnitBy = 600, BulletTP = false}
local AutoShootEnabled = false
local AutoShootDelay = 0.1
local snaplineColor = Color3.fromRGB(255, 0, 0)
local snapline = Drawing.new("Line")
snapline.Visible = ShowSnapline
snapline.Thickness = 1
snapline.Color = snaplineColor

local function WTS(Object)
    local screenPos = camera:WorldToViewportPoint(Object.Position)
    if screenPos.Z > 0 then
        return Vector2.new(screenPos.X, screenPos.Y)
    else
        return nil
    end
end

local function MousePos2Vector2()
    return UserInputService:GetMouseLocation()
end

local function IsOnScreen(Object)
    local _, onScreen = camera:WorldToViewportPoint(Object.Position)
    return onScreen
end

local function Filter(Object)
    if string.find(Object.Name, "Gun") then return false end
    return Object:IsA("Part") or Object:IsA("MeshPart")
end

local function CheckWall(TargetPartObj)
    if not wallCheckEnabled then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    local dir = (TargetPartObj.Position - camera.CFrame.Position).Unit * 1000
    local ray = workspace:Raycast(camera.CFrame.Position, dir, params)
    return ray and ray.Instance and ray.Instance:IsDescendantOf(TargetPartObj.Parent)
end

local function RollChance()
    return math.random(1,100) <= HitChance
end

local function GetTargetPartName()
    if TargetPartName == "Random" then
        local parts = {"Head","HumanoidRootPart"}
        return parts[math.random(1,#parts)]
    end
    return TargetPartName
end

local function IsValidSilentTarget(player)
    if player == localPlayer then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if healthCheckEnabled and (not humanoid or humanoid.Health <= 0) then return false end
    if teamCheckEnabled and player.Team == localPlayer.Team then return false end
    if forcefieldCheckEnabled and player.Character:FindFirstChildOfClass("ForceField") then return false end
    return true
end

local function UpdateRaycastTarget()
    local closestDist = math.huge
    RaycastTarget = nil
    local mousePos = MousePos2Vector2()
    for _, player in pairs(Players:GetPlayers()) do
        if not IsValidSilentTarget(player) then continue end
        local part = player.Character:FindFirstChild(GetTargetPartName())
        if not part then continue end
        if Filter(part) and IsOnScreen(part) and CheckWall(part) then
            local screenPos = WTS(part)
            if screenPos and (screenPos - mousePos).Magnitude <= fov then
                local dist = (screenPos - mousePos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    RaycastTarget = player
                end
            end
        end
    end
end

local function UpdateClosestBodyPart()
    local closestDist = math.huge
    BodyPart = nil
    local mousePos = MousePos2Vector2()
    for _, player in pairs(Players:GetPlayers()) do
        if not IsValidSilentTarget(player) then continue end
        local part = player.Character:FindFirstChild(GetTargetPartName())
        if not part then continue end
        if Filter(part) and IsOnScreen(part) and CheckWall(part) then
            local screenPos = WTS(part)
            if screenPos then
                local dist = (screenPos - mousePos).Magnitude
                if dist <= fov and dist < closestDist then
                    closestDist = dist
                    BodyPart = part
                end
            end
        end
    end
end

local function modifyRay(Origin, HitPart)
    if SilentAimSettings.BulletTP and HitPart then
        Origin = (HitPart.CFrame * CFrame.new(0, 0, 1)).p
    end
    return Origin, (HitPart.Position - Origin).Unit
end

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if not checkcaller() and SilentAimEnabled and RollChance() then
        if (Method == "FindPartOnRayWithIgnoreList" or Method == "findpartonraywithignorelist") 
            and SilentAimMethod == "FindPartOnRayWithIgnoreList" 
            and BodyPart then
            local Origin, Direction = modifyRay(camera.CFrame.Position, BodyPart)
            Args[1] = Ray.new(Origin, Direction * SilentAimSettings.MultiplyUnitBy)
            return OldNameCall(Self, unpack(Args))
        elseif (Method == "Raycast" or Method == "raycast") 
            and SilentAimMethod == "Raycast" 
            and RaycastTarget then
            local incomingOrigin = Args[1] or camera.CFrame.Position
            local Origin, Direction = modifyRay(incomingOrigin, RaycastTarget.Character[GetTargetPartName()])
            Args[1] = Origin
            Args[2] = Direction * SilentAimSettings.MultiplyUnitBy
            return OldNameCall(Self, unpack(Args))
        end
    end
    return OldNameCall(Self, ...)
end)

task.spawn(function()
    while task.wait() do
        if AutoShootEnabled then
            local target = RaycastTarget or (BodyPart and BodyPart.Parent and Players:GetPlayerFromCharacter(BodyPart.Parent))
            if target and target.Character and target.Character:FindFirstChild(GetTargetPartName()) then
                local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                if healthCheckEnabled and (not humanoid or humanoid.Health <= 0) then continue end
                local part = target.Character[GetTargetPartName()]
                if part and CheckWall(part) then
                    mouse1press()
                    task.wait(AutoShootDelay)
                    mouse1release()
                end
            end
        end
    end
end)

RunService:BindToRenderStep("SilentAimVisuals", 120, function()
    if SilentAimMethod == "Raycast" then
        UpdateRaycastTarget()
    elseif SilentAimMethod == "FindPartOnRayWithIgnoreList" then
        UpdateClosestBodyPart()
    end
    local targetPos
    if SilentAimMethod == "Raycast" and RaycastTarget then
        targetPos = WTS(RaycastTarget.Character[GetTargetPartName()])
    elseif SilentAimMethod == "FindPartOnRayWithIgnoreList" and BodyPart then
        targetPos = WTS(BodyPart)
    end
    if ShowSnapline and targetPos then
        snapline.From = MousePos2Vector2()
        snapline.To = targetPos
        snapline.Visible = true
    else
        snapline.Visible = false
    end
    FOVring.Visible = fovCircleEnabled
    FOVring.Position = MousePos2Vector2()
    FOVring.Radius = fov
    if RGBFOV then
        FOVring.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    else
        FOVring.Color = fovColor
    end
    snapline.Color = snaplineColor
end)
local SilentTab = CombatTab:Section({Name = "Silent aim", Side = 2})
SilentTab:Toggle({
    Name = "Enable silent aim",
    Flag = "EnableSilentAim",
    Default = false,
    Callback = function(Value)
        SilentAimEnabled = Value
    end
})
SilentTab:Dropdown({
    Name = "Method",
    Flag = "SilentAimMethod",
    Default = "Raycast",
    Multi = false,
    Items = {"Raycast", "FindPartOnRayWithIgnoreList"},
    Callback = function(Value)
        SilentAimMethod = Value
    end
})
SilentTab:Dropdown({
    Name = "Aim part",
    Flag = "TargetPartSelect",
    Default = "Head",
    Items = {"Head", "HumanoidRootPart", "Random"},
    Callback = function(Value)
        TargetPartName = Value
    end
})
SilentTab:Slider({
    Name = "Hit chance",
    Flag = "HitChance",
    Default = 100,
    Min = 1,
    Max = 100,
    Decimals = 1,
    Callback = function(Value)
        HitChance = Value
    end
})
SilentTab:Toggle({
    Name = "Auto shoot",
    Flag = "AutoShoot",
    Default = false,
    Callback = function(Value)
        AutoShootEnabled = Value
    end
})
SilentTab:Slider({
    Name = "Auto shoot delay",
    Flag = "AutoShootDelay",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Decimals = 0.1,
    Callback = function(Value)
        AutoShootDelay = Value
    end
})
SilentTab:Toggle({
    Name = "Enable bulletTP",
    Flag = "BulletTP",
    Default = false,
    Callback = function(Value)
        SilentAimSettings.BulletTP = Value
    end
})
SilentTab:Slider({
    Name = "Direction multiplier",
    Flag = "MultiplyUnitBy",
    Default = 600,
    Min = 100,
    Max = 2000,
    Decimals = 1,
    Callback = function(Value)
        SilentAimSettings.MultiplyUnitBy = Value
    end
})
local indicatorsEnabled = false

local targetHudGui = nil
local targetHudElements = {}

local function createTargetHud()
    if targetHudGui then return end

    local G2L = {}
    G2L["1"] = Instance.new("ScreenGui")
    G2L["1"].Name = "TargetHUD"
    G2L["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    G2L["1"].IgnoreGuiInset = true
    G2L["1"].Parent = gethui()

    G2L["2"] = Instance.new("Frame", G2L["1"])
    G2L["2"].BorderSizePixel = 0
    G2L["2"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["2"].AnchorPoint = Vector2.new(0.5, 0.75)
    G2L["2"].Size = UDim2.new(0, 322, 0, 147)
    G2L["2"].Position = UDim2.new(0.5, 0, 0.85, 0)
    G2L["2"].BorderColor3 = Library.Theme["Border"]
    G2L["2"].Active = true
    G2L["2"].Draggable = true

    G2L["3"] = Instance.new("Frame", G2L["2"])
    G2L["3"].BorderSizePixel = 0
    G2L["3"].BackgroundColor3 = Library.Theme["Accent"]
    G2L["3"].Size = UDim2.new(1, -2, 1, -2)
    G2L["3"].Position = UDim2.new(0, 1, 0, 1)

    G2L["4"] = Instance.new("Frame", G2L["3"])
    G2L["4"].BorderSizePixel = 0
    G2L["4"].BackgroundColor3 = Library.Theme["Background 2"]
    G2L["4"].Size = UDim2.new(1, -2, 1, -2)
    G2L["4"].Position = UDim2.new(0, 1, 0, 1)

    G2L["5"] = Instance.new("Frame", G2L["4"])
    G2L["5"].BorderSizePixel = 0
    G2L["5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["5"].Size = UDim2.new(1, -2, 1, -4)
    G2L["5"].Position = UDim2.new(0, 1, 0, 2)
    G2L["5"].BackgroundTransparency = 1

    G2L["6"] = Instance.new("UIPadding", G2L["5"])
    G2L["6"].PaddingLeft = UDim.new(0, 6)

    G2L["7"] = Instance.new("Frame", G2L["5"])
    G2L["7"].BorderSizePixel = 0
    G2L["7"].BackgroundColor3 = Library.Theme["Element"]
    G2L["7"].Size = UDim2.new(1, 0, 1, -18)
    G2L["7"].Position = UDim2.new(0, -3, 0, 16)
    G2L["7"].Name = "holder"

    G2L["8"] = Instance.new("Frame", G2L["7"])
    G2L["8"].BorderSizePixel = 0
    G2L["8"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["8"].Size = UDim2.new(1, -2, 1, -2)
    G2L["8"].Position = UDim2.new(0, 1, 0, 1)

    G2L["9"] = Instance.new("Frame", G2L["8"])
    G2L["9"].BorderSizePixel = 0
    G2L["9"].BackgroundColor3 = Library.Theme["Inline"]
    G2L["9"].Size = UDim2.new(1, -2, 1, -2)
    G2L["9"].Position = UDim2.new(0, 1, 0, 1)

    G2L["a"] = Instance.new("UIPadding", G2L["9"])
    G2L["a"].PaddingTop = UDim.new(0, 4)
    G2L["a"].PaddingLeft = UDim.new(0, 4)

    G2L["b"] = Instance.new("Frame", G2L["9"])
    G2L["b"].BorderSizePixel = 0
    G2L["b"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["b"].Size = UDim2.new(1, -4, 1, -4)

    G2L["c"] = Instance.new("Frame", G2L["b"])
    G2L["c"].BorderSizePixel = 0
    G2L["c"].BackgroundColor3 = Library.Theme["Element"]
    G2L["c"].Size = UDim2.new(1, -2, 1, -2)
    G2L["c"].Position = UDim2.new(0, 1, 0, 1)

    G2L["d"] = Instance.new("Frame", G2L["c"])
    G2L["d"].BorderSizePixel = 0
    G2L["d"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["d"].Size = UDim2.new(1, -2, 1, -2)
    G2L["d"].Position = UDim2.new(0, 1, 0, 1)

    G2L["e"] = Instance.new("UIGradient", G2L["d"])
    G2L["e"].Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Library.Theme["Background 1"]),
        ColorSequenceKeypoint.new(1.000, Library.Theme["Background 2"])
    }

    G2L["f"] = Instance.new("UIPadding", G2L["d"])
    G2L["f"].PaddingTop = UDim.new(0, 4)
    G2L["f"].PaddingRight = UDim.new(0, 3)
    G2L["f"].PaddingLeft = UDim.new(0, 4)
    G2L["f"].PaddingBottom = UDim.new(0, 3)

    G2L["10"] = Instance.new("Frame", G2L["d"])
    G2L["10"].BorderSizePixel = 0
    G2L["10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["10"].Size = UDim2.new(1, 0, 1, 3)
    G2L["10"].BackgroundTransparency = 1

    G2L["11"] = Instance.new("UIListLayout", G2L["10"])
    G2L["11"].Padding = UDim.new(0, 4)
    G2L["11"].SortOrder = Enum.SortOrder.LayoutOrder

    G2L["12"] = Instance.new("UIPadding", G2L["10"])
    G2L["12"].PaddingBottom = UDim.new(0, 4)

    G2L["13"] = Instance.new("Frame", G2L["10"])
    G2L["13"].BorderSizePixel = 0
    G2L["13"].BackgroundColor3 = Library.Theme["Element"]
    G2L["13"].Size = UDim2.new(1, -1, 1, 0)

    G2L["14"] = Instance.new("Frame", G2L["13"])
    G2L["14"].BorderSizePixel = 0
    G2L["14"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["14"].Size = UDim2.new(1, -2, 1, -2)
    G2L["14"].Position = UDim2.new(0, 1, 0, 1)

    G2L["15"] = Instance.new("Frame", G2L["14"])
    G2L["15"].BorderSizePixel = 0
    G2L["15"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["15"].Size = UDim2.new(1, -2, 1, -2)
    G2L["15"].Position = UDim2.new(0, 1, 0, 1)

    G2L["16"] = Instance.new("UIGradient", G2L["15"])
    G2L["16"].Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Library.Theme["Background 1"]),
        ColorSequenceKeypoint.new(1.000, Library.Theme["Background 2"])
    }

    G2L["17"] = Instance.new("Frame", G2L["15"])
    G2L["17"].BorderSizePixel = 0
    G2L["17"].BackgroundColor3 = Library.Theme["Accent"]
    G2L["17"].Size = UDim2.new(1, 0, 0, 2)
    G2L["17"].Name = "bar"

    G2L["19"] = Instance.new("Frame", G2L["15"])
    G2L["19"].BorderSizePixel = 0
    G2L["19"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["19"].Size = UDim2.new(1, -2, 1, -24)
    G2L["19"].Position = UDim2.new(0, 1, 0, 22)
    G2L["19"].Name = "holder"
    G2L["19"].BackgroundTransparency = 1

    G2L["1a"] = Instance.new("UIPadding", G2L["19"])
    G2L["1a"].PaddingTop = UDim.new(0, -1)
    G2L["1a"].PaddingRight = UDim.new(0, 3)
    G2L["1a"].PaddingLeft = UDim.new(0, 3)
    G2L["1a"].PaddingBottom = UDim.new(0, 2)

    G2L["1b"] = Instance.new("Frame", G2L["19"])
    G2L["1b"].BorderSizePixel = 0
    G2L["1b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["1b"].Size = UDim2.new(1, 0, 1, 0)
    G2L["1b"].Name = "playerinfo"
    G2L["1b"].BackgroundTransparency = 1

    G2L["1c"] = Instance.new("Frame", G2L["1b"])
    G2L["1c"].BorderSizePixel = 0
    G2L["1c"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["1c"].Size = UDim2.new(0, 68, 1, 0)
    G2L["1c"].Name = "icon"

    G2L["1d"] = Instance.new("Frame", G2L["1c"])
    G2L["1d"].BorderSizePixel = 0
    G2L["1d"].BackgroundColor3 = Library.Theme["Element"]
    G2L["1d"].Size = UDim2.new(1, -2, 1, -2)
    G2L["1d"].Position = UDim2.new(0, 1, 0, 1)

    G2L["1e"] = Instance.new("Frame", G2L["1d"])
    G2L["1e"].BorderSizePixel = 0
    G2L["1e"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["1e"].Size = UDim2.new(1, -2, 1, -2)
    G2L["1e"].Position = UDim2.new(0, 1, 0, 1)

    G2L["1f"] = Instance.new("ImageLabel", G2L["1e"])
    G2L["1f"].BorderSizePixel = 0
    G2L["1f"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["1f"].Image = "rbxassetid://119472238324544"
    G2L["1f"].Size = UDim2.new(1, 0, 1, 0)
    G2L["1f"].BackgroundTransparency = 1

    G2L["20"] = Instance.new("UIGradient", G2L["1e"])
    G2L["20"].Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Library.Theme["Background 1"]),
        ColorSequenceKeypoint.new(1.000, Library.Theme["Background 2"])
    }

    G2L["21"] = Instance.new("Frame", G2L["1b"])
    G2L["21"].BorderSizePixel = 0
    G2L["21"].BackgroundColor3 = Library.Theme["Background 1"]
    G2L["21"].AnchorPoint = Vector2.new(0, 1)
    G2L["21"].Size = UDim2.new(1, -72, 0, 14)
    G2L["21"].Position = UDim2.new(0, 72, 1, 0)
    G2L["21"].Name = "health"

    G2L["22"] = Instance.new("Frame", G2L["21"])
    G2L["22"].BorderSizePixel = 0
    G2L["22"].BackgroundColor3 = Library.Theme["Element"]
    G2L["22"].Size = UDim2.new(1, -2, 1, -2)
    G2L["22"].Position = UDim2.new(0, 1, 0, 1)

    G2L["23"] = Instance.new("Frame", G2L["22"])
    G2L["23"].BorderSizePixel = 0
    G2L["23"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["23"].Size = UDim2.new(1, -2, 1, -2)
    G2L["23"].Position = UDim2.new(0, 1, 0, 1)

    G2L["24"] = Instance.new("UIGradient", G2L["23"])
    G2L["24"].Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Library.Theme["Background 1"]),
        ColorSequenceKeypoint.new(1.000, Library.Theme["Background 2"])
    }

    G2L["25"] = Instance.new("Frame", G2L["23"])
    G2L["25"].BorderSizePixel = 0
    G2L["25"].BackgroundColor3 = Library.Theme["Accent"]
    G2L["25"].Size = UDim2.new(1, 0, 1, 0)
    G2L["25"].Name = "healthbarvalue"

    G2L["26"] = Instance.new("UIGradient", G2L["25"])
    G2L["26"].Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1.000, Color3.fromRGB(125, 125, 125))
    }

    G2L["27"] = Instance.new("TextLabel", G2L["23"])
    G2L["27"].BorderSizePixel = 0
    G2L["27"].TextSize = 12
    G2L["27"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["27"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    G2L["27"].TextColor3 = Library.Theme["Text"]
    G2L["27"].BackgroundTransparency = 1
    G2L["27"].AnchorPoint = Vector2.new(0.5, 0.5)
    G2L["27"].Size = UDim2.new(1, 0, 1, 0)
    G2L["27"].Text = "100/100"
    G2L["27"].Name = "healthvalue"
    G2L["27"].Position = UDim2.new(0.5, 0, 0.5, 0)

    G2L["28"] = Instance.new("UIStroke", G2L["27"])
    G2L["28"].LineJoinMode = Enum.LineJoinMode.Miter
    G2L["28"].Color = Color3.new(0, 0, 0)

    G2L["29"] = Instance.new("Frame", G2L["1b"])
    G2L["29"].BorderSizePixel = 0
    G2L["29"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["29"].Size = UDim2.new(0, 198, 0, 31)
    G2L["29"].Position = UDim2.new(0.27007, 0, 0.02941, 0)
    G2L["29"].BackgroundTransparency = 1

    G2L["2a"] = Instance.new("UIListLayout", G2L["29"])
    G2L["2a"].Padding = UDim.new(0, 2)
    G2L["2a"].SortOrder = Enum.SortOrder.LayoutOrder

    G2L["2b"] = Instance.new("TextLabel", G2L["29"])
    G2L["2b"].BorderSizePixel = 0
    G2L["2b"].TextSize = 12
    G2L["2b"].TextXAlignment = Enum.TextXAlignment.Left
    G2L["2b"].TextYAlignment = Enum.TextYAlignment.Top
    G2L["2b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["2b"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    G2L["2b"].TextColor3 = Library.Theme["Text"]
    G2L["2b"].BackgroundTransparency = 1
    G2L["2b"].Size = UDim2.new(0.39152, 0, 0.41935, 0)
    G2L["2b"].Text = "finobe"
    G2L["2b"].Name = "name"

    G2L["2c"] = Instance.new("UIStroke", G2L["2b"])
    G2L["2c"].LineJoinMode = Enum.LineJoinMode.Miter
    G2L["2c"].Color = Color3.new(0, 0, 0)

    G2L["2d"] = Instance.new("TextLabel", G2L["29"])
    G2L["2d"].BorderSizePixel = 0
    G2L["2d"].TextSize = 12
    G2L["2d"].TextXAlignment = Enum.TextXAlignment.Left
    G2L["2d"].TextYAlignment = Enum.TextYAlignment.Top
    G2L["2d"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["2d"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    G2L["2d"].TextColor3 = Library.Theme["Text"]
    G2L["2d"].BackgroundTransparency = 1
    G2L["2d"].Size = UDim2.new(0.39152, 0, 0.41935, 0)
    G2L["2d"].Text = "finobe studs"
    G2L["2d"].Name = "studs"

    G2L["2e"] = Instance.new("UIStroke", G2L["2d"])
    G2L["2e"].LineJoinMode = Enum.LineJoinMode.Miter
    G2L["2e"].Color = Color3.new(0, 0, 0)

    G2L["37"] = Instance.new("Frame", G2L["15"])
    G2L["37"].BorderSizePixel = 0
    G2L["37"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["37"].Size = UDim2.new(1, 0, 0, 20)
    G2L["37"].Position = UDim2.new(0, 0, 0, 2)
    G2L["37"].BackgroundTransparency = 1
    G2L["37"].Name = "top"

    G2L["38"] = Instance.new("TextLabel", G2L["37"])
    G2L["38"].BorderSizePixel = 0
    G2L["38"].TextSize = 12
    G2L["38"].TextXAlignment = Enum.TextXAlignment.Left
    G2L["38"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["38"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    G2L["38"].TextColor3 = Color3.fromRGB(137, 137, 137)
    G2L["38"].BackgroundTransparency = 1
    G2L["38"].Size = UDim2.new(1, 0, 1, 0)
    G2L["38"].Text = "Info"

    G2L["39"] = Instance.new("UIPadding", G2L["38"])
    G2L["39"].PaddingLeft = UDim.new(0, 5)

    G2L["3a"] = Instance.new("UIStroke", G2L["38"])
    G2L["3a"].LineJoinMode = Enum.LineJoinMode.Miter
    G2L["3a"].Color = Color3.new(0, 0, 0)

    G2L["3b"] = Instance.new("Frame", G2L["5"])
    G2L["3b"].BorderSizePixel = 0
    G2L["3b"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["3b"].Size = UDim2.new(1, -4, 0, 20)
    G2L["3b"].Name = "top"
    G2L["3b"].BackgroundTransparency = 1

    G2L["3c"] = Instance.new("TextLabel", G2L["3b"])
    G2L["3c"].BorderSizePixel = 0
    G2L["3c"].TextSize = 12
    G2L["3c"].TextXAlignment = Enum.TextXAlignment.Left
    G2L["3c"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    G2L["3c"].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    G2L["3c"].TextColor3 = Library.Theme["Text"]
    G2L["3c"].BackgroundTransparency = 1
    G2L["3c"].Size = UDim2.new(0.5, 0, 1, 0)
    G2L["3c"].Text = "Indicator"

    G2L["3d"] = Instance.new("UIPadding", G2L["3c"])
    G2L["3d"].PaddingTop = UDim.new(0, -4)
    G2L["3d"].PaddingLeft = UDim.new(0, -2)
    G2L["3d"].PaddingBottom = UDim.new(0, 4)

    G2L["3e"] = Instance.new("UIStroke", G2L["3c"])
    G2L["3e"].LineJoinMode = Enum.LineJoinMode.Miter
    G2L["3e"].Color = Color3.new(0, 0, 0)

    targetHudGui = G2L["1"]
    targetHudElements = {
        nameLabel = G2L["2b"],
        distLabel = G2L["2d"],
        healthLabel = G2L["27"],
        healthBar = G2L["25"],
        playerIcon = G2L["1f"],
        mainFrame = G2L["2"]
    }

    targetHudGui.Enabled = false
end

createTargetHud()

local function isSameTeam(plr)
    if not plr or not localPlayer then return false end
    if plr.Team and localPlayer.Team then
        return plr.Team == localPlayer.Team
    end
    return plr.TeamColor == localPlayer.TeamColor
end

local function updateTargetHud()
    if not indicatorsEnabled then
        targetHudGui.Enabled = false
        return
    end

    local mousePos = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDist = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == localPlayer then continue end
        if not plr.Character then continue end

        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        if healthCheckEnabled and (not humanoid or humanoid.Health <= 0) then
            continue
        end

        if teamCheckEnabled and isSameTeam(plr) then
            continue
        end

        -- Forcefield check (same as aimbot & silent aim)
        if forcefieldCheckEnabled and plr.Character:FindFirstChildOfClass("ForceField") then
            continue
        end

        local part = TargetPart == "Closest"
            and getClosestPart(plr.Character, mousePos)
            or plr.Character:FindFirstChild(TargetPart)

        if part then
            local pos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude

                if dist <= fov
                    and dist < closestDist
                    and (not wallCheckEnabled or isTargetVisible(part)) then
                    closestDist = dist
                    closestPlayer = plr
                end
            end
        end
    end

    if not closestPlayer or not closestPlayer.Character then
        targetHudGui.Enabled = false
        return
    end

    local char = closestPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        targetHudGui.Enabled = false
        return
    end

    targetHudElements.nameLabel.Text =
        closestPlayer.Name .. " (@" .. closestPlayer.DisplayName .. ")"

    targetHudElements.distLabel.Text =
        math.round((root.Position - camera.CFrame.Position).Magnitude) .. " studs"

    local health = math.floor(humanoid.Health)
    local maxHealth = humanoid.MaxHealth

    targetHudElements.healthLabel.Text = health .. " / " .. maxHealth
    targetHudElements.healthBar.Size = UDim2.new(math.clamp(health / maxHealth, 0, 1), 0, 1, 0)

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                closestPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok then
            targetHudElements.playerIcon.Image = img
        end
    end)

    targetHudGui.Enabled = true
end

RunService.RenderStepped:Connect(function()
    handleAimbot()
    updateFOVCircle()
    updateTargetHud()
end)

local Fov = VisualsTab:Section({Name = "Fov", Side = 1})
local Indicator = VisualsTab:Section({Name = "Indicator", Side = 1})
local Snapline = VisualsTab:Section({Name = "Snapline", Side = 1})
local Circle = Fov:Toggle({
    Name = "Enable fov",
    Flag = "ToggleFOV",
    Default = false,
    Callback = function(Value)
        fovCircleEnabled = Value
        FOVring.Visible = Value
    end
})
Circle:Colorpicker({
    Name = "Fov circle color",
    Flag = "FOVColorPicker",
    Default = fovColor,
    Transparency = 0,
    Callback = function(Value)
        fovColor = Value
        if not rgbEffectEnabled then
            FOVring.Color = Value
        end
    end
})
Fov:Slider({
    Name = "Fov radius",
    Flag = "FOVSlider",
    Min = 25,
    Max = 1000,
    Default = fov,
    Decimals = 1,
    Callback = function(Value)
        fov = Value
        FOVring.Radius = fov
    end
})
Fov:Slider({
    Name = "Fov thickness",
    Flag = "FOVThickness",
    Min = 1,
    Max = 5,
    Default = 1,
    Decimals = 1,
    Callback = function(Value)
        FOVring.Thickness = Value
    end
})
Fov:Slider({
    Name = "Fov transparency",
    Flag = "FOVTransparency",
    Min = 0,
    Max = 1,
    Default = 1,
    Decimals = 0.1,
    Callback = function(Value)
        FOVring.Transparency = Value
    end
})
Indicator:Toggle({
    Name = "Enable indicator",
    Flag = "IndicatorsToggle",
    Default = false,
    Callback = function(Value)
        indicatorsEnabled = Value
        if not Value then targetHudGui.Enabled = false end
    end
})
local line = Snapline:Toggle({
    Name = "Enable snapline",
    Flag = "ToggleSnapline",
    Default = false,
    Callback = function(Value)
        ShowSnapline = Value
        snapline.Visible = Value
    end
})
line:Colorpicker({
    Name = "Snapline Color",
    Flag = "SnaplineColorPicker",
    Default = snaplineColor,
    Title = "Snapline Color",
    Transparency = 0,
    Callback = function(Value)
        snaplineColor = Value
        snapline.Color = Value
    end
})
local ambientEnabled = false
local ambientColor = Color3.fromRGB(255, 255, 255)
local timeEnabled = false
local timeValue = 12
local brightnessEnabled = false
local brightnessValue = 2
task.spawn(function()
    while task.wait(0.1) do
        if ambientEnabled then
            Lighting.Ambient = ambientColor
            Lighting.OutdoorAmbient = ambientColor
        end

        if timeEnabled then
            Lighting.ClockTime = timeValue
        end

        if brightnessEnabled then
            Lighting.Brightness = brightnessValue
        end
    end
end)

local WorldVisuals = VisualsTab:Section({Name = "World visuals", Side = 2})
WorldVisuals:Toggle({
    Name = "Enable ambient changer",
    Flag = "AmbientToggle",
    Default = false,
    Callback = function(Value)
        ambientEnabled = Value
        if not Value then
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end
}):Colorpicker({
    Name = "Indoor ambient",
    Flag = "AmbientColor",
    Default = Color3.fromRGB(255, 200, 150),
    Callback = function(Value)
        ambientColor = Value
    end
})
WorldVisuals:Toggle({
    Name = "Enable time changer",
    Flag = "TimeToggle",
    Default = false,
    Callback = function(Value)
        timeEnabled = Value
        if not Value then
            Lighting.ClockTime = 14
        end
    end
})
WorldVisuals:Slider({
    Name = "Time of day",
    Flag = "TimeSlider",
    Default = 12,
    Min = 0,
    Max = 24,
    Decimals = 1,
    Callback = function(Value)
        timeValue = Value
    end
})
WorldVisuals:Toggle({
    Name = "Enable brightness",
    Flag = "BrightnessToggle",
    Default = false,
    Callback = function(Value)
        brightnessEnabled = Value
        if not Value then
            Lighting.Brightness = 2
        end
    end
})
WorldVisuals:Slider({
    Name = "Brightness",
    Flag = "BrightnessSlider",
    Default = 2,
    Min = 0,
    Max = 10,
    Decimals = 0.1,
    Callback = function(Value)
        brightnessValue = Value
    end
})
local char = player.Character or player.CharacterAdded:Wait()
local isChamEnabled = false
local isRGBEnabled = false
local forceFieldColor = Color3.new(1, 0, 0)
local function applyForceField()
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.ForceField
            part.Color = forceFieldColor
        end
    end
end
local function resetMaterials()
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Plastic
            part.Color = Color3.new(1, 1, 1)
        end
    end
end
local function startRGBEffect()
    RunService.RenderStepped:Connect(function()
        if isRGBEnabled then
            forceFieldColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            if isChamEnabled then
                applyForceField()
            end
        end
    end)
end
local function updateCham()
    if isChamEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.ForceField
                part.Color = forceFieldColor
            end
        end
    else
        resetMaterials()
    end
end
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    char:WaitForChild("Humanoid")
    RunService.RenderStepped:Connect(function()
        updateCham()
    end)
end)
startRGBEffect()
local PlayerCham = VisualsTab:Section({Name = "Player cham", Side = 2})
PlayerCham:Toggle({Name = "Enable player cham", Flag = "ChamToggle", Default = false, Callback = function(Value)
    isChamEnabled = Value
    updateCham()
end}):Colorpicker({Name = "ForceField Color", Flag = "ColorPicker", Default = Color3.new(1, 0, 0), Callback = function(Color)
    forceFieldColor = Color
    updateCham()
end})
end
do
local AntiAimSettings = {
    Enabled = false,
    YawBase = "camera",
    YawOffset = 0,
    Modifier = "none",
    ModifierOffset = 0,
}

local JitterToggle = false

local FakelagSettings = {
    Enabled = false,
    Method = "static",
    Limit = 6,
    FreezeWorld = false,
    Tick = 0,
    Active = false,
}

local VisualizeSettings = {
    Enabled = false,
    Color = Color3.fromRGB(255, 0, 255),
    Transparency = 0.65,
    SizeBoost = Vector3.new(0.04, 0.04, 0.04)
}

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not (AntiAimSettings.Enabled and char and root and hum) then
        if hum then hum.AutoRotate = true end
        return
    end

    hum.AutoRotate = false

    local baseAngle
    if AntiAimSettings.YawBase == "camera" then
        baseAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
    elseif AntiAimSettings.YawBase == "random" then
        baseAngle = math.rad(math.random(0, 360))
    elseif AntiAimSettings.YawBase == "spin" then
        baseAngle = math.rad(tick() * 360 % 360)
    elseif AntiAimSettings.YawBase == "targets" then
        local closest, dist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local pos, _ = Camera:WorldToViewportPoint(hrp.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
            if mag < dist then
                dist = mag
                closest = hrp
            end
        end
        if closest then
            baseAngle = math.atan2((closest.Position - root.Position).Z, (closest.Position - root.Position).X)
            baseAngle = baseAngle + math.rad(-90)
        else
            baseAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
        end
    else
        baseAngle = -math.atan2(Camera.CFrame.LookVector.Z, Camera.CFrame.LookVector.X) + math.rad(-90)
    end

    local yawOffset = math.rad(AntiAimSettings.YawOffset)
    JitterToggle = not JitterToggle
    local modifierOffset = 0
    if JitterToggle then
        if AntiAimSettings.Modifier == "jitter" or AntiAimSettings.Modifier == "offset jitter" then
            modifierOffset = math.rad(AntiAimSettings.ModifierOffset)
        end
    end

    local finalAngle = baseAngle + yawOffset + modifierOffset
    if root then
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, finalAngle, 0)
    end
end)

local Network = game:GetService("NetworkClient")

task.spawn(function()
    while true do
        task.wait(1/16)
        local char = LocalPlayer.Character
        if not char then 
            task.wait(0.3)
            continue 
        end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then
            local old = char:FindFirstChild("Fakelag")
            if old then old:Destroy() end
            Network:SetOutgoingKBPSLimit(9e9)
            FakelagSettings.Tick = 0
            continue
        end
        FakelagSettings.Tick = FakelagSettings.Tick + 1
        local shouldChoke = FakelagSettings.Active and FakelagSettings.Enabled
        local maxTick = if FakelagSettings.Method == "static" 
            then FakelagSettings.Limit 
            else math.random(1, FakelagSettings.Limit)
        local isChoking = shouldChoke and FakelagSettings.Tick < maxTick
        if isChoking then
            Network:SetOutgoingKBPSLimit(1)
        else
            Network:SetOutgoingKBPSLimit(9e9)
            FakelagSettings.Tick = 0
            if VisualizeSettings.Enabled then
                local oldFolder = char:FindFirstChild("Fakelag")
                if oldFolder then oldFolder:Destroy() end
                local folder = Instance.new("Folder")
                folder.Name = "Fakelag"
                folder.Parent = char
                char.Archivable = true
                local clone = char:Clone()
                for _, obj in clone:GetDescendants() do
                    if obj:IsA("Humanoid") 
                        or obj:IsA("LocalScript") 
                        or obj:IsA("Script") 
                        or obj.Name == "HumanoidRootPart" then
                        obj:Destroy()
                    elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
                        if obj.Transparency >= 0.99 then
                            obj:Destroy()
                        else
                            obj.Anchored = true
                            obj.CanCollide = false
                            obj.Material = Enum.Material.ForceField
                            obj.Color = VisualizeSettings.Color
                            obj.Transparency = VisualizeSettings.Transparency
                            obj.Size += VisualizeSettings.SizeBoost
                        end
                    end
                end
                for _, obj in clone:GetDescendants() do
                    pcall(function()
                        obj.CanCollide = false
                    end)
                end
                clone.Parent = folder
            end
        end
    end
end)

local AA = PlayerTab:Section({Name = "Anti aim", Side = 1})
AA:Toggle({Name = "Enable anti aim", Flag = "aa_enabled", Default = false, Callback = function(v)
    AntiAimSettings.Enabled = v
end})
AA:Dropdown({Name = "Yaw base", Flag = "aa_yaw_base", Default = "camera", Items = {"camera", "random", "spin", "targets"}, Callback = function(v)
    AntiAimSettings.YawBase = v
end})
AA:Slider({Name = "Yaw offset", Flag = "aa_yaw_offset", Min = -180, Max = 180, Default = 0, Decimals = 1, Callback = function(v)
    AntiAimSettings.YawOffset = v
end})
AA:Dropdown({Name = "Modifier", Flag = "aa_yaw_modifier", Default = "none", Items = {"none", "jitter", "offset jitter"}, Callback = function(v)
    AntiAimSettings.Modifier = v
end})
AA:Slider({Name = "Modifier offset", Flag = "aa_modifier_offset", Min = -180, Max = 180, Default = 0, Decimals = 1, Callback = function(v)
    AntiAimSettings.ModifierOffset = v
end})

local FL = PlayerTab:Section({Name = "Fake lag", Side = 1})
local flToggleEnabled = false
FL:Toggle({Name = "Enable fake lag", Flag = "fl_enabled", Default = false, Callback = function(v)
    flToggleEnabled = v
    FakelagSettings.Enabled = v
end}):Keybind({Name = "Fake lag", Flag = "fl_hotkey", Default = Enum.KeyCode.Period, Mode = "Toggle", Callback = function(v)
    if flToggleEnabled then
        FakelagSettings.Active = v
    end
end})
FL:Dropdown({Name = "Method", Flag = "fl_method", Default = "static", Items = {"static", "random"}, Callback = function(v)
    FakelagSettings.Method = v
end})
FL:Slider({Name = "Limit", Flag = "fl_limit", Min = 1, Max = 16, Default = 6, Decimals = 1, Callback = function(v)
    FakelagSettings.Limit = v
end})
FL:Toggle({Name = "Freeze world", Flag = "fl_freeze", Default = false, Callback = function(v)
    FakelagSettings.FreezeWorld = v
    settings().Network.IncomingReplicationLag = v and 1000 or 0
end})

FL:Toggle({
    Name = "Visualize fakelag",
    Flag = "fl_visualize",
    Default = false,
    Callback = function(v)
        VisualizeSettings.Enabled = v
        if not v then
            local char = LocalPlayer.Character
            if char then
                local folder = char:FindFirstChild("Fakelag")
                if folder then folder:Destroy() end
            end
        end
    end
}):Colorpicker({
    Name = "Visualize color",
    Flag = "fl_vis_color",
    Default = Color3.fromRGB(255, 0, 255),
    Callback = function(color)
        VisualizeSettings.Color = color
    end
})

FL:Slider({
    Name = "Visualize transparency",
    Flag = "fl_vis_transparency",
    Min = 0.1,
    Max = 0.95,
    Default = 0.65,
    Decimals = 0.1,
    Callback = function(v)
        VisualizeSettings.Transparency = v
    end
})
local speedMaster = false
local speedKeyState = false
local speedMode = "CFrame"
local speedValue = 50
local speedConnection = nil
local gyro = nil
local jumpMaster = false
local jumpKeyState = false
local jumpValue = 50
local gravityMaster = false
local gravityKeyState = false
local gravityValue = 196.2
local flyMaster = false
local flyKeyState = false
local flySpeed = 4
local flyConn = nil
local noclipMaster = false
local noclipKeyState = false
local noclipConn = nil
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHRP()
    local char = getChar()
    return char:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local char = getChar()
    return char:FindFirstChildWhichIsA("Humanoid")
end
local function stopSpeed()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    if gyro then gyro:Destroy() gyro = nil end
end

local function startSpeed()
    stopSpeed()
    local hrp = getHRP()
    local hum = getHum()
    if not (hrp and hum) then return end
    if speedMode == "BodyGyro" then
        gyro = Instance.new("BodyGyro")
        gyro.P = 30000
        gyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
        gyro.Parent = hrp
    end
    speedConnection = RunService.Heartbeat:Connect(function(dt)
        if not speedMaster or not speedKeyState then return end
        local dir = hum.MoveDirection
        if dir.Magnitude < 0.1 then return end
        if speedMode == "CFrame" then
            hrp.CFrame = hrp.CFrame + (dir * speedValue * dt)
        else
            hrp.Velocity = dir * speedValue
            gyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + dir)
        end
    end)
end
local function refreshSpeed()
    if speedMaster and speedKeyState then startSpeed() else stopSpeed() end
end
local function updateJump()
    local hum = getHum()
    if not hum then return end
    if jumpMaster and jumpKeyState then
        hum.UseJumpPower = true
        hum.JumpPower = jumpValue
    else
        hum.JumpPower = 50
    end
end
local function updateGravity()
    workspace.Gravity = (gravityMaster and gravityKeyState) and gravityValue or 196.2
end
local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
end
local function startFly()
    stopFly()
    local hrp = getHRP()
    if not hrp then return end
    flyConn = RunService.Heartbeat:Connect(function()
        if not flyMaster or not flyKeyState then return end
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        hrp.Velocity = move * flySpeed * 25
    end)
end
local function refreshFly()
    if flyMaster and flyKeyState then startFly() else stopFly() end
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
end
local function startNoclip()
    stopNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipMaster or not noclipKeyState then return end
        local char = getChar()
        for _,part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end
local function refreshNoclip()
    if noclipMaster and noclipKeyState then startNoclip() else stopNoclip() end
end
local Movements = PlayerTab:Section({Name = "Movements", Side = 2})
Movements:Toggle({
    Name="Enable speed",
    Flag="SpeedToggle",
    Callback=function(v)
        speedMaster = v
        refreshSpeed()
    end
}):Keybind({
    Name="Speed",
    Flag="SpeedKey",
    Default=Enum.KeyCode.Period,
    Mode="Toggle",
    Callback=function(val)
        speedKeyState = val
        refreshSpeed()
    end
})
Movements:Dropdown({
    Name="Speed mode",
    Flag="SpeedMode",
    Items={"CFrame","BodyGyro"},
    Default="CFrame",
    Callback=function(v)
        speedMode = v
        refreshSpeed()
    end
})
Movements:Slider({
    Name="Speed",
    Flag="SpeedValue",
    Min=16, Max=500,
    Default=speedValue,
    Callback=function(v)
        speedValue = v
    end
})
Movements:Toggle({
    Name="Enable jumpPower",
    Flag="JumpToggle",
    Callback=function(v)
        jumpMaster = v
        updateJump()
    end
}):Keybind({
    Name="Jump",
    Flag="JumpKey",
    Default=Enum.KeyCode.Period,
    Mode="Toggle",
    Callback=function(val)
        jumpKeyState = val
        updateJump()
    end
})
Movements:Slider({
    Name="Jumppower",
    Flag="JumpValue",
    Min=50, Max=500,
    Default=jumpValue,
    Callback=function(v)
        jumpValue = v
        if jumpMaster then updateJump() end
    end
})
Movements:Toggle({
    Name="Enable gravity",
    Flag="GravityToggle",
    Callback=function(v)
        gravityMaster = v
        updateGravity()
    end
}):Keybind({
    Name="Gravity",
    Flag="GravityKey",
    Default=Enum.KeyCode.Period,
    Mode="Toggle",
    Callback=function(val)
        gravityKeyState = val
        updateGravity()
    end
})
Movements:Slider({
    Name="Gravity",
    Flag="GravityValue",
    Min=0, Max=500,
    Default=gravityValue,
    Callback=function(v)
        gravityValue = v
        if gravityMaster then updateGravity() end
    end
})
Movements:Toggle({
    Name="Enable fly",
    Flag="FlyToggle",
    Callback=function(v)
        flyMaster = v
        refreshFly()
    end
}):Keybind({
    Name="Fly",
    Flag="FlyKey",
    Default=Enum.KeyCode.Period,
    Mode="Toggle",
    Callback=function(val)
        flyKeyState = val
        refreshFly()
    end
})
Movements:Slider({
    Name="Fly speed",
    Flag="FlySpeed",
    Min=1, Max=10,
    Default=flySpeed,
    Callback=function(v)
        flySpeed = v
    end
})
Movements:Toggle({
    Name="Enable noclip",
    Flag="NoclipToggle",
    Callback=function(v)
        noclipMaster = v
        refreshNoclip()
    end
}):Keybind({
    Name="Noclip",
    Flag="NoclipKey",
    Default=Enum.KeyCode.Period,
    Mode="Toggle",
    Callback=function(val)
        noclipKeyState = val
        refreshNoclip()
    end
})
end
