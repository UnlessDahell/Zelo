-- Zelo UI | Murder Mystery 2
-- WindUI Framework Conversion

local WindUI = loadstring(game:HttpGet("https://article-hub-studio.github.io/WindUI-Skibidi/loader.lua"))()

WindUI:SetMotionPreset("Liquid")

WindUI:LoadingCreate({
	Title = "Zielo Hub",
	Desc = "Loading Murder Mystery 2 features...",
	Icon = "moon",
	Width = 350,
	Steps = { "Core", "Features", "Ready" },
	ScrimTransparency = 0.28,
	CardTransparency = 0.14,
})

WindUI:LoadingSet(0.22, "Loading core services")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
game:GetService("HttpService")

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Window
local Window = WindUI:CreateWindow({
	Title = "Zielo Hub",
	Folder = "ZieloHub",
	Icon = "moon",
	Default = false,
	NewElements = true,
	ElementTransparency = 0.18,
	ElementGap = 8,
	LiquidGlass = false,
	ToggleKey = Enum.KeyCode.RightControl,
	KeyBindMenu = {
		DefaultKey = "RightControl",
		QuickKeys = { "RightControl", "F", "LeftControl" },
		Scrim = false,
		BackgroundTransparency = 0.52,
		Compact = true,
		UseWindowBackground = true,
	},
	Watermark = {
		Title = "Zelo UI",
		Desc = "MM2",
		Icon = "moon",
		Position = "BottomRight",
		Transparency = 0.2,
		Draggable = true,
	},
	Settings = {
		DefaultConfig = "zelo-mm2",
		Width = 460,
		Height = 380,
		ScrimTransparency = 0.76,
	},
	Motion = { Preset = "Liquid", Reduced = false },
	Topbar = { Height = 44, ButtonsType = "Mac" },
	OpenButton = {
		Title = "Zielo Hub",
		Icon = "moon",
		Glass = false,
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		Scale = 0.55,
		Position = "TopCenter",
		Height = 46,
		IconSize = 20,
		BackgroundTransparency = 0.42,
		StrokeTransparency = 0.34,
		Color = ColorSequence.new(Color3.fromHex("#FFFFFF"), Color3.fromHex("#888888")),
	},
	BackgroundColor = Color3.fromHex("#0A0A0A"),
	BackgroundGradient = WindUI:Gradient({
		["0"]   = { Color = Color3.fromHex("#0A0A0A"), Transparency = 0.06 },
		["50"]  = { Color = Color3.fromHex("#1A1A1A"), Transparency = 0.3  },
		["100"] = { Color = Color3.fromHex("#0A0A0A"), Transparency = 0.54 },
	}, { Rotation = 118 }),
	BackgroundOverlayTransparency = 0.47,
})

WindUI:LoadingSet({ Step = 2, Progress = 0.58, Status = "Building features" })
task.delay(0.2, function()
	WindUI:LoadingSet({ Step = 3, Progress = 1, Status = "Ready", Close = true, Delay = 0.16 })
end)

-- Tabs
local InfoTab      = Window:Tab({ Title = "Info",     Icon = "info"       })
local MainTab      = Window:Tab({ Title = "Main",     Icon = "crosshair"  })
local FarmTab      = Window:Tab({ Title = "Farming",  Icon = "coins"      })
local MurdTab      = Window:Tab({ Title = "Murder",   Icon = "sword"      })
local SheriffTab   = Window:Tab({ Title = "Sheriff",  Icon = "shield"     })
local ESPTab       = Window:Tab({ Title = "ESP",      Icon = "eye"        })
local TeleportTab  = Window:Tab({ Title = "Teleport", Icon = "map-pin"    })
local PlayerTab    = Window:Tab({ Title = "Player",   Icon = "user"       })
local TrollingTab  = Window:Tab({ Title = "Trolling", Icon = "laugh"      })
local MiscTab      = Window:Tab({ Title = "Extra",    Icon = "settings"   })
local SpawnersTab  = Window:Tab({ Title = "Spawners", Icon = "package"    })
local ConfigTab    = Window:Tab({ Title = "Configs",  Icon = "save"       })

-- Gradient helper (original, preserved)
function gradient(p1, p2, p3)
	local s1 = ""
	local v194 = #p1
	for i = 1, v194 do
		local v196 = (i - 1) / math.max(v194 - 1, 1)
		s1 = s1 .. "<font color=\"rgb(" .. math.floor((p2.R + (p3.R - p2.R) * v196) * 255) .. ", " .. math.floor((p2.G + (p3.G - p2.G) * v196) * 255) .. ", " .. math.floor((p2.B + (p3.B - p2.B) * v196) * 255) .. ")\">" .. p1:sub(i, i) .. "</font>"
	end
	return s1
end

-- Executor detection
local s2 = "Unknown"
pcall(function()
	if identifyexecutor then s2 = identifyexecutor() end
end)

do
	local v16
	do
		local v14 = string.lower(s2)
		local t2 = { solara = true, xeno = true, volcano = true, velocity = true }
		v16 = false
		for k in pairs(t2) do
			if v14:find(k) then v16 = true break end
		end
	end
	local v18 = v16 and s2 .. " (Not 100% Supported)" or s2 .. " Supported"
	local v19 = v16 and "Some features may not work correctly with your executor." or s2 .. " should run everything fine."
	local v20 = v16 and "Warning" or "Success"

	InfoTab:Callout({ Title = v18, Desc = v19, Variant = v20 })
	InfoTab:Callout({
		Title = "Zelo UI - Murder Mystery 2",
		Desc  = "Game info, roles, ESP, farming and\nmore features across all tabs.",
		Variant = "Info",
	})
end

-- Role tracking
local t3 = { GetCurrentPlayerData = ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true) }
local t4 = { Roles = {}, Murderer = "Unknown", Sheriff = "Unknown", Perk = "None" }

local u23 = MainTab:KeyValue({
	Title = "Game Info",
	Items = {
		{ Title = "Murderer",      Value = "Unknown" },
		{ Title = "Sheriff",       Value = "Unknown" },
		{ Title = "Murderer Perk", Value = "None"    },
		{ Title = "Gun Dropped",   Value = "No"      },
	},
})

function u24()
	if t3.GetCurrentPlayerData and t3.GetCurrentPlayerData:IsA("RemoteFunction") then
		local ok, result = pcall(function() return t3.GetCurrentPlayerData:InvokeServer() end)
		if ok and typeof(result) == "table" then
			t4.Roles    = result
			t4.Perk     = "None"
			t4.Sheriff  = "Unknown"
			t4.Murderer = "Unknown"
			for k, v in pairs(t4.Roles) do
				local k2 = Players:FindFirstChild(k)
				if k2 and k2.Character and k2.Character:FindFirstChild("Humanoid") and k2.Character.Humanoid.Health > 0 then
					if v.Role == "Murderer" then t4.Murderer = k t4.Perk = v.Perk or "None"
					elseif v.Role == "Sheriff" then t4.Sheriff = k end
				end
			end
		end
	end
end

function u25()
	for _, descendant in ipairs(Workspace:GetDescendants()) do
		if descendant.Name == "GunDrop" then return true end
	end
	return false
end

function u26()
	u24()
	local v206 = u25() and "Yes" or "No"
	if u23 and u23.SetItems then
		u23:SetItems({
			{ Title = "Murderer",      Value = t4.Murderer },
			{ Title = "Sheriff",       Value = t4.Sheriff  },
			{ Title = "Murderer Perk", Value = t4.Perk     },
			{ Title = "Gun Dropped",   Value = v206        },
		})
	end
end

task.spawn(function()
	while true do u26() task.wait(0.2) end
end)

-- UI toggle keybind
getgenv().ZeloUIVisible = true
getgenv().ZeloToggleKey = "G"

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode[getgenv().ZeloToggleKey] then
		getgenv().ZeloUIVisible = not getgenv().ZeloUIVisible
		if not getgenv().ZeloUIVisible then
			WindUI:Notify({
				Title   = "Zelo UI Hidden",
				Content = "Press " .. getgenv().ZeloToggleKey .. " to reopen",
				Duration = 5, Icon = "eye-off", Style = "Notice",
			})
		end
	end
end)

-- Misc Tab
MiscTab:Callout({
	Title = "Extra / Misc",
	Desc  = "Toggle key, Infinite Yield and\nanti-stealer options.",
	Variant = "Info",
})

MiscTab:Keybind({
	Title = "Toggle UI Keybind",
	Desc  = "Open or close the UI",
	Value = getgenv().ZeloToggleKey,
	Callback = function(p4)
		local ok, result = pcall(function() return Enum.KeyCode[p4] end)
		if ok and result then
			getgenv().ZeloToggleKey = p4
			Window:SetToggleKey(result)
		end
	end,
})

MiscTab:Button({
	Title = "Infinite Yield",
	Icon  = "terminal",
	Callback = function()
		loadstring(game:HttpGet("https://rawscripts.net/raw/Infinite-Yield_500"))()
	end,
})

getgenv().AntiStealerEnabled = false
MiscTab:Toggle({
	Title = "Anti Stealer",
	Desc  = "Auto decline trade requests",
	Value = false,
	Callback = function(p19) getgenv().AntiStealerEnabled = p19 end,
})

-- Role notification logic
getgenv().AutoRoleNotify = false
getgenv().RoleNotifMurd  = nil
getgenv().RoleNotifSher  = nil

function u32()
	local t5 = {}
	local GetCurrentPlayerData = ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true)
	if GetCurrentPlayerData and GetCurrentPlayerData:IsA("RemoteFunction") then
		t5 = GetCurrentPlayerData:InvokeServer() or {}
	end
	local v216 = nil
	local v217 = nil
	for k, v in pairs(t5) do
		if v.Role == "Murderer" then v216 = k
		elseif v.Role == "Sheriff" then v217 = k end
	end
	return v216, v217
end

function u33(p5, p6, p7)
	local s4 = "rbxassetid://129260712070622"
	if p7 then
		local p7_2 = Players:FindFirstChild(p7)
		if p7_2 then
			local ok, result = pcall(function()
				return Players:GetUserThumbnailAsync(p7_2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
			end)
			if ok then s4 = result end
		end
	end
	WindUI:Notify({ Title = p5, Content = p6, Duration = 30, Icon = s4, IconThemed = true })
end

function u34(p8, p9)
	local v229 = p8 == "Murderer" and "Murderer" or "Sheriff"
	local v230 = p9 or "No " .. p8
	u33(v229, v230, p9)
end

task.spawn(function()
	while true do
		if getgenv().AutoRoleNotify then
			local v231, v232 = u32()
			if v231 ~= getgenv().RoleNotifMurd then u34("Murderer", v231) end
			if v232 ~= getgenv().RoleNotifSher  then u34("Sheriff",  v232) end
			getgenv().RoleNotifMurd = v231
			getgenv().RoleNotifSher = v232
		end
		task.wait(0.5)
	end
end)

-- Main Tab
MainTab:Callout({
	Title = "Main Features",
	Desc  = "Game info, gun pickup, role alerts,\nauto gun sound and misc tools.",
	Variant = "Info",
})

MainTab:Toggle({
	Title = "Auto Role Notification",
	Desc  = "Notify when roles are detected or changed",
	Value = false,
	Callback = function(p10)
		getgenv().AutoRoleNotify = p10
		if p10 then
			getgenv().RoleNotifMurd = nil
			getgenv().RoleNotifSher = nil
		end
	end,
})

MainTab:Button({
	Title = "Notify Murderer",
	Icon  = "sword",
	Callback = function()
		local v234 = u32()
		u34("Murderer", v234)
	end,
})

MainTab:Button({
	Title = "Notify Sheriff",
	Icon  = "shield",
	Callback = function()
		local _, v236 = u32()
		u34("Sheriff", v236)
	end,
})

-- Auto Get Gun
getgenv().AutoGetGun  = false
getgenv().GunPickBusy = false

local Players2    = game:GetService("Players")
local Workspace2  = game:GetService("Workspace")
local LocalPlayer2 = Players2.LocalPlayer

task.spawn(function()
	while task.wait(0.25) do
		local v244
		if not getgenv().AutoGetGun or getgenv().GunPickBusy then
			v244 = true
		else
			local Character = LocalPlayer2.Character
			local _HRP2 = Character and Character:FindFirstChild("HumanoidRootPart")
			if _HRP2 then
				if Character:FindFirstChild("Gun") or LocalPlayer2.Backpack:FindFirstChild("Gun") then
					v244 = true
				else
					local GunDrop = Workspace2:FindFirstChild("GunDrop", true)
					if GunDrop and GunDrop:IsA("BasePart") then
						getgenv().GunPickBusy = true
						firetouchinterest(_HRP2, GunDrop, 0)
						task.wait()
						firetouchinterest(_HRP2, GunDrop, 1)
						task.delay(0.5, function() getgenv().GunPickBusy = false end)
					end
					v244 = true
				end
			else v244 = true end
		end
		if not v244 then return end
	end
end)

MainTab:Toggle({
	Title = "Auto Get Gun",
	Desc  = "Automatically pick up the dropped gun",
	Value = false,
	Callback = function(p11)
		getgenv().AutoGetGun = p11
		WindUI:Notify({
			Title   = "Auto Gun",
			Content = p11 and "Enabled" or "Disabled",
			Duration = 3, Icon = "hand",
			Style   = p11 and "Success" or "Notice",
		})
	end,
})

MainTab:Button({
	Title = "Get Gun Now",
	Icon  = "hand",
	Callback = function()
		local v238 = nil
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant.Name == "GunDrop" and descendant:IsA("Part") then
				v238 = descendant break
			end
		end
		if not v238 then
			WindUI:Notify({ Title = "Gun Pickup", Content = "Gun has not been dropped", Duration = 5, Icon = "x", Style = "Warning" })
		else
			local _HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if _HRP then
				for _, v in ipairs(v238:GetConnections()) do
					if v.Name == "TouchInterest" then v:Fire(_HRP) end
				end
			end
			WindUI:Notify({ Title = "Gun Pickup", Content = "Gun successfully touched!", Duration = 5, Icon = "hand", Style = "Success" })
		end
	end,
})

-- Gun Drop Sound
getgenv().GunSoundId  = "rbxassetid://1076907875"
getgenv().GunSoundVol = 1
getgenv().GunSoundOn  = false

local t6 = {
	Discord                           = "rbxassetid://1076907875",
	["Fire alarm"]                    = "rbxassetid://497153454",
	Oof                               = "rbxassetid://79348298352567",
	["Gun sfx"]                       = "rbxassetid://1585183374",
	["Samsung Notification"]          = "rbxassetid://6205717931",
	Notify                            = "rbxassetid://225320558",
	["Windows Notify System Generic"] = "rbxassetid://489103549",
	Custom                            = "",
}
local t7 = {}
for k in pairs(t6) do table.insert(t7, k) end

MainTab:Input({
	Title = "Custom Gun Drop Sound URL",
	Placeholder = "rbxassetid://",
	Compact = true,
	Callback = function(p12)
		if p12 ~= "" then getgenv().GunSoundId = p12 end
	end,
})

MainTab:Dropdown({
	Title = "Gun Drop Sound",
	Values = t7,
	Value  = "Discord",
	Compact = true,
	Callback = function(p13)
		if p13 ~= "Custom" then getgenv().GunSoundId = t6[p13] end
	end,
})

MainTab:Button({
	Title = "Preview Gun Drop Sound",
	Icon  = "volume-2",
	Callback = function()
		local Sound = Instance.new("Sound")
		Sound.SoundId = getgenv().GunSoundId
		Sound.Volume  = getgenv().GunSoundVol
		Sound.Parent  = Workspace2
		Sound:Play()
		Sound.Ended:Connect(function() Sound:Destroy() end)
	end,
})

MainTab:Slider({
	Title = "Gun Drop Volume",
	Value = { Min = 0, Max = 1, Default = 1, Increment = 0.05 },
	Callback = function(p14) getgenv().GunSoundVol = p14 end,
})

MainTab:Toggle({
	Title = "Gun Drop Sound Alert",
	Desc  = "Play sound and notify when gun drops",
	Value = false,
	Callback = function(p15) getgenv().GunSoundOn = p15 end,
})

task.spawn(function()
	local t8 = {}
	while true do
		task.wait(0.5)
		if getgenv().GunSoundOn then
			for _, descendant in ipairs(Workspace2:GetDescendants()) do
				if descendant.Name == "GunDrop" and not t8[descendant] then
					local Sound = Instance.new("Sound")
					Sound.SoundId = getgenv().GunSoundId
					Sound.Volume  = getgenv().GunSoundVol
					Sound.Parent  = descendant
					Sound:Play()
					Sound.Ended:Connect(function() Sound:Destroy() end)
					WindUI:Notify({ Title = "Gun!", Content = "Gun Dropped", Duration = 10, Icon = "crosshair", Style = "Notice" })
					t8[descendant] = true
				end
			end
		end
	end
end)

-- Round Timer
MainTab:Toggle({
	Title = "Round Timer Display",
	Desc  = "Show a draggable round timer on screen",
	Compact = true,
	Callback = function(p16)
		if not p16 then
			local _TimerGui = LocalPlayer2.PlayerGui and LocalPlayer2.PlayerGui:FindFirstChild("TimerDisplayGui")
			if _TimerGui then _TimerGui:Destroy() end
		else
			local PlayerGui      = LocalPlayer2.PlayerGui
			local RoundTimerPart = Workspace2:FindFirstChild("RoundTimerPart")
			local _Surface       = RoundTimerPart and (RoundTimerPart:FindFirstChild("SurfaceGui") and RoundTimerPart.SurfaceGui:FindFirstChild("Timer"))
			if not PlayerGui or not _Surface then return end

			local ScreenGui = Instance.new("ScreenGui")
			ScreenGui.Name         = "TimerDisplayGui"
			ScreenGui.Parent       = PlayerGui
			ScreenGui.ResetOnSpawn = false

			local TextLabel = Instance.new("TextLabel")
			TextLabel.Size                   = UDim2.new(0, 150, 0, 30)
			TextLabel.Position               = UDim2.new(0.5, 0, 0.05, 0)
			TextLabel.AnchorPoint            = Vector2.new(0.5, 0)
			TextLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled             = true
			TextLabel.RichText               = true
			TextLabel.Text                   = "Waiting..."
			TextLabel.FontFace               = Font.new("rbxassetid://16658221428", Enum.FontWeight.Bold)
			TextLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
			TextLabel.TextStrokeTransparency = 0
			TextLabel.Parent                 = ScreenGui

			local u264 = false
			local u265 = nil
			local inputPosition    = nil
			local TextLabelPosition = nil

			TextLabel.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					u264 = true
					inputPosition     = input.Position
					TextLabelPosition = TextLabel.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then u264 = false end
					end)
				end
			end)
			TextLabel.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then u265 = input end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if input == u265 and u264 then
					local v870 = input.Position - inputPosition
					TextLabel.Position = UDim2.new(TextLabelPosition.X.Scale, TextLabelPosition.X.Offset + v870.X, TextLabelPosition.Y.Scale, TextLabelPosition.Y.Offset + v870.Y)
				end
			end)
			task.spawn(function()
				while ScreenGui.Parent do
					if _Surface and _Surface:IsA("TextLabel") then TextLabel.Text = _Surface.Text end
					task.wait(0.1)
				end
			end)
		end
	end,
})

-- God Mode
MainTab:Button({
	Title = "God Mode",
	Desc  = "Disable death state on your character",
	Icon  = "shield-check",
	Callback = function()
		WindUI:Notify({ Title = "God Mode", Content = "God mode is on", Icon = "shield-check", Duration = 5, Style = "Success" })
		local function u269(p18)
			p18:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end
		local LocalPlayer3 = game:GetService("Players").LocalPlayer
		u269(LocalPlayer3.Character.Humanoid)
		LocalPlayer3.CharacterAdded:Connect(function(character)
			u269(character:WaitForChild("Humanoid"))
		end)
	end,
})

-- FOV
MainTab:Slider({
	Title = "FOV",
	Value = { Min = 50, Max = 120, Default = CurrentCamera.FieldOfView, Increment = 1 },
	Compact = true,
	Callback = function(p20) CurrentCamera.FieldOfView = p20 end,
})

-- Anti Fling
MainTab:Toggle({
	Title = "Anti Fling",
	Desc  = "Prevent other players from flinging you",
	Value = false,
	Callback = function(p21)
		if not p21 then
			if getgenv().AntiFlingConnection then
				getgenv().AntiFlingConnection:Disconnect()
				getgenv().AntiFlingConnection = nil
			end
		else
			getgenv().AntiFlingConnection = RunService.Heartbeat:Connect(function()
				for _, player in ipairs(Players2:GetPlayers()) do
					if player ~= LocalPlayer2 and player.Character then
						for _, descendant in ipairs(player.Character:GetDescendants()) do
							if descendant:IsA("BasePart") and not descendant.Anchored and descendant.Velocity.Magnitude > 100 then
								descendant.RotVelocity = Vector3.zero
								descendant.Velocity    = Vector3.zero
								descendant.Anchored    = true
								task.delay(0.5, function()
									if descendant and descendant.Parent then descendant.Anchored = false end
								end)
							end
						end
					end
				end
			end)
		end
	end,
})

-- Anti Stealer logic
do
	local Trade       = ReplicatedStorage:WaitForChild("Trade")
	local StartTrade  = Trade:WaitForChild("StartTrade")
	local DeclineTrade = Trade:WaitForChild("DeclineTrade")
	local u51 = false

	local function u52()
		if u51 then return end
		u51 = true
		task.spawn(function()
			while getgenv().AntiStealerEnabled do
				pcall(function() DeclineTrade:FireServer() end)
				task.wait(0.1)
			end
			u51 = false
		end)
	end

	StartTrade.OnClientEvent:Connect(function()
		if not getgenv().AntiStealerEnabled then return end
		pcall(function() DeclineTrade:FireServer() end)
		u52()
	end)
end

-- u141 role checker (used by multiple tabs)
local Players9     = game:GetService("Players")
local LocalPlayer17 = Players9.LocalPlayer
local LocalPlayer11 = game:GetService("Players").LocalPlayer

function u141(p78)
	local Backpack = p78:FindFirstChild("Backpack")
	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				if child.Name:lower():find("knife") or child.Name:lower():find("murderer") then return "Murderer" end
				if child.Name:lower():find("gun")   or child.Name:lower():find("sheriff")  then return "Sheriff"  end
			end
		end
	end
	local Character = p78.Character
	if Character then
		for _, child in ipairs(Character:GetChildren()) do
			if child:IsA("Tool") then
				if child.Name:lower():find("knife") or child.Name:lower():find("murderer") then return "Murderer" end
				if child.Name:lower():find("gun")   or child.Name:lower():find("sheriff")  then return "Sheriff"  end
			end
		end
	end
	return "Innocent"
end

-- Fling logic (shared by Main/Trolling)
getgenv().OldPos = nil
getgenv().FPDH   = workspace.FallenPartsDestroyHeight

local u135 = false

local function u140(p73)
	local Character  = LocalPlayer11.Character
	local _Humanoid3 = Character and Character:FindFirstChildOfClass("Humanoid")
	local _RootPart  = _Humanoid3 and _Humanoid3.RootPart
	local Character3 = p73.Character
	if not Character3 then return end
	local Humanoid  = nil; local RootPart = nil; local Head = nil; local Accessory = nil; local Handle = nil
	if Character3:FindFirstChildOfClass("Humanoid") then Humanoid = Character3:FindFirstChildOfClass("Humanoid") end
	if Humanoid and Humanoid.RootPart then RootPart = Humanoid.RootPart end
	if Character3:FindFirstChild("Head") then Head = Character3.Head end
	if Character3:FindFirstChildOfClass("Accessory") then Accessory = Character3:FindFirstChildOfClass("Accessory") end
	if Accessory and Accessory:FindFirstChild("Handle") then Handle = Accessory.Handle end
	if Character and _Humanoid3 and _RootPart then
		if _RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = _RootPart.CFrame end
		if Humanoid and Humanoid.Sit then return end
		if Head then workspace.CurrentCamera.CameraSubject = Head
		elseif not Handle then if Humanoid and RootPart then workspace.CurrentCamera.CameraSubject = Humanoid end
		else workspace.CurrentCamera.CameraSubject = Handle end
		if not Character3:FindFirstChildWhichIsA("BasePart") then return end
		local function u529(p74, p75, p76)
			_RootPart.CFrame = CFrame.new(p74.Position) * p75 * p76
			Character:SetPrimaryPartCFrame(CFrame.new(p74.Position) * p75 * p76)
			_RootPart.Velocity    = Vector3.new(90000000, 900000000, 90000000)
			_RootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
		end
		local function v530(p77)
			local timestamp = tick(); local n13 = 0
			repeat
				if _RootPart and Humanoid then
					if p77.Velocity.Magnitude < 50 then
						n13 = n13 + 100
						u529(p77, CFrame.new(0,  1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
						u529(p77, CFrame.new(0,  1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
						u529(p77, CFrame.new(0,  1.5, 0) + Humanoid.MoveDirection, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection, CFrame.Angles(math.rad(n13), 0, 0)) task.wait()
					else
						u529(p77, CFrame.new(0,  1.5,  Humanoid.WalkSpeed),  CFrame.Angles(math.rad(90), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, -Humanoid.WalkSpeed),  CFrame.Angles(0, 0, 0))            task.wait()
						u529(p77, CFrame.new(0,  1.5,  Humanoid.WalkSpeed),  CFrame.Angles(math.rad(90), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))            task.wait()
						u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)) task.wait()
						u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))            task.wait()
					end
				end
			until timestamp + 2 < tick() or not u135
		end
		workspace.FallenPartsDestroyHeight = 0 / 0
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Parent   = _RootPart
		BodyVelocity.Velocity = Vector3.new(0, 0, 0)
		BodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
		_Humanoid3:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		if not RootPart then
			if Head then v530(Head) elseif Handle then v530(Handle) end
		else v530(RootPart) end
		BodyVelocity:Destroy()
		_Humanoid3:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = _Humanoid3
		if getgenv().OldPos then
			repeat
				_RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
				Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
				_Humanoid3:ChangeState("GettingUp")
				for _, child in pairs(Character:GetChildren()) do
					if child:IsA("BasePart") then child.RotVelocity = Vector3.new() child.Velocity = Vector3.new() end
				end
				task.wait()
			until (_RootPart.Position - getgenv().OldPos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		end
	end
end

-- End Round
local t21 = {}
local function u137()
	local n12 = 0
	for _ in pairs(t21) do n12 = n12 + 1 end
end

MainTab:Button({
	Title = "End Round",
	Desc  = "Fling murderers to end the round",
	Icon  = "skull",
	Callback = function()
		if u135 then return end
		t21 = {}
		for _, player in ipairs(Players9:GetPlayers()) do
			if player ~= LocalPlayer11 and u141(player) == "Murderer" then t21[player.Name] = player end
		end
		u137()
		if next(t21) then
			u135 = true
			task.spawn(function()
				for _, v in pairs(t21) do
					if v and v.Parent then u140(v) task.wait(0.5) end
				end
				u135 = false; u137()
			end)
		end
	end,
})

-- Sheriff Tab
SheriffTab:Callout({
	Title = "Sheriff Tools",
	Desc  = "Aimlock, camlock and orbit.\nRequires Sheriff role to be effective.",
	Variant = "Info",
})

local Players3      = game:GetService("Players")
local RunService2   = game:GetService("RunService")
local UserInputService2 = game:GetService("UserInputService")
local LocalPlayer4  = Players3.LocalPlayer
local n2 = 0.18; local n3 = 5000; local n4 = 0.08
local E  = Enum.KeyCode.E
local u61 = false; local u62 = nil; local u63 = false; local u64 = nil

local function u65()
	local Character = LocalPlayer4.Character
	if Character then
		for _, child in ipairs(Character:GetChildren()) do
			if child:IsA("Tool") and child:FindFirstChild("Shoot") then return child, child:FindFirstChild("Shoot") end
		end
	end
	local Backpack = LocalPlayer4:FindFirstChild("Backpack")
	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") and child:FindFirstChild("Shoot") then return child, child:FindFirstChild("Shoot") end
		end
	end
	return nil, nil
end

local function u66(p22)
	if not p22 then return false end
	local Backpack = p22:FindFirstChild("Backpack")
	if not Backpack or not Backpack:FindFirstChild("Knife") then
		local Character = p22.Character
		if Character and Character:FindFirstChild("Knife") then return true end
		return false
	end
	return true
end

local function u67()
	local Character = LocalPlayer4.Character
	if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
	local HRP   = Character.HumanoidRootPart
	local v285  = nil; local huge = math.huge
	for _, player in ipairs(Players3:GetPlayers()) do
		local v289
		if player ~= LocalPlayer4 then
			if not player.Character then v289 = true
			else
				local Humanoid = player.Character:FindFirstChild("Humanoid")
				if not Humanoid or Humanoid.Health <= 0 then v289 = true
				else
					local HRP2 = player.Character:FindFirstChild("HumanoidRootPart")
					if not HRP2 then v289 = true
					elseif not u66(player) then v289 = true
					else
						local Mag = (HRP.Position - HRP2.Position).Magnitude
						if Mag < n3 and Mag < huge then huge = Mag v285 = player end
						v289 = true
					end
				end
			end
		else v289 = true end
		if not v289 then return v285 end
	end
	return v285
end

local function u68(p23)
	if p23 then
		return p23 + Vector3.new((math.random() - 0.5) * n4, (math.random() - 0.5) * n4, (math.random() - 0.5) * n4)
	end
	return CFrame.new()
end

local function u69()
	local v294, v295 = u65()
	if v294 and v295 then
		local Character = LocalPlayer4.Character
		if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
		local v297 = u67()
		if v297 then
			local HRP  = Character.HumanoidRootPart
			local HRP3 = v297.Character:FindFirstChild("HumanoidRootPart")
			if HRP3 then local v300 = u68(HRP3.CFrame) v295:FireServer(HRP.CFrame, v300) end
		end
	end
end

SheriffTab:Button({
	Title = "Shoot Murderer",
	Desc  = "Fire at murderer without holding gun",
	Icon  = "crosshair",
	Callback = u69,
})

SheriffTab:Toggle({
	Title = "Auto Shoot Murderer",
	Desc  = "Continuously shoot murderer automatically",
	Icon  = "crosshair",
	Value = false,
	Callback = function(p24)
		u63 = p24
		if u64 then u64:Disconnect() u64 = nil end
		if p24 then
			u64 = RunService2.Heartbeat:Connect(function()
				if not u63 then return end
				u69(); task.wait(n2)
			end)
		end
	end,
})

SheriffTab:Keybind({
	Title = "Shoot / Auto-Shoot (hold)",
	Desc  = "Hold key to keep shooting",
	Value = "E",
	Callback = function(p25)
		if Enum.KeyCode[p25] then E = Enum.KeyCode[p25] end
	end,
})

UserInputService2.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode ~= E then return end
	u61 = true; u69()
	if u62 then u62:Disconnect() end
	u62 = RunService2.Heartbeat:Connect(function()
		if not u61 then return end
		u69(); task.wait(n2)
	end)
end)
UserInputService2.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode ~= E then return end
		u61 = false
		if u62 then u62:Disconnect() u62 = nil end
	end
end)
LocalPlayer4.CharacterRemoving:Connect(function()
	u61 = false
	if u62 then u62:Disconnect() u62 = nil end
end)

local E2 = Enum.KeyCode.E
local u71 = false; local u72 = nil
UserInputService2.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == E2 then
			u71 = true; u69()
			if u72 then u72:Disconnect() end
			u72 = RunService2.Heartbeat:Connect(function()
				if u71 then u69(); task.wait(n2) end
			end)
		end
	end
end)
UserInputService2.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		if input.KeyCode == E2 then
			u71 = false
			if u72 then u72:Disconnect() u72 = nil end
		end
	end
end)

-- Camlock
local Players4     = game:GetService("Players")
local VirtualUser  = game:GetService("VirtualUser")
local RunService3  = game:GetService("RunService")
local LocalPlayer5 = Players4.LocalPlayer
local CurrentCamera2 = Workspace2.CurrentCamera
local LocalPlayer6   = Players4.LocalPlayer

getgenv().Aimlock = { Enabled = false, TargetPart = "HumanoidRootPart", Initialized = false }

local function u85()
	for _, player in ipairs(Players4:GetPlayers()) do
		if player ~= LocalPlayer6 and player.Character
			and (player.Character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife"))
			and player.Character:FindFirstChild("HumanoidRootPart") then
			return player
		end
	end
	return nil
end

SheriffTab:Dropdown({
	Title = "Camlock Target Part",
	Desc  = "Body part to lock camera onto",
	Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
	Value  = "HumanoidRootPart",
	Callback = function(p30) getgenv().Aimlock.TargetPart = p30 end,
})

SheriffTab:Toggle({
	Title = "Enable Camlock",
	Desc  = "Lock camera onto murderer position",
	Value = false,
	Callback = function(p31)
		getgenv().Aimlock.Enabled = p31
		if p31 and not getgenv().Aimlock.Initialized then
			getgenv().Aimlock.Initialized = true
			RunService3.RenderStepped:Connect(function()
				if getgenv().Aimlock.Enabled then
					local v878 = u85()
					if v878 and v878.Character then
						local AimlockPart = v878.Character:FindFirstChild(getgenv().Aimlock.TargetPart)
						if AimlockPart then
							CurrentCamera2.CFrame = CFrame.new(CurrentCamera2.CFrame.Position, AimlockPart.Position)
						end
					end
				end
			end)
		end
	end,
})

-- Orbit
local u86 = false; local n5 = 0; local n6 = 20; local n7 = 0; local n8 = 1
local LocalPlayer7 = Players4.LocalPlayer

local function u92()
	for _, player in ipairs(Players4:GetPlayers()) do
		if player ~= LocalPlayer7 then
			local v356 = false
			if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") then v356 = true
			elseif player.Character and player.Character:FindFirstChild("Knife") then v356 = true end
			if v356 then return player end
		end
	end
	return nil
end

SheriffTab:Slider({
	Title = "Orbit Distance Behind Murderer",
	Value = { Min = 0, Max = 120, Default = 20, Increment = 1 },
	Callback = function(p32) n6 = p32 end,
})
SheriffTab:Slider({
	Title = "Orbit Height Above Murderer",
	Value = { Min = -20, Max = 50, Default = 0, Increment = 1 },
	Callback = function(p33) n7 = p33 end,
})
SheriffTab:Slider({
	Title = "Orbit Speed",
	Desc  = "Above 10 may be too fast",
	Value = { Min = 0, Max = 200, Default = 1, Increment = 0.1 },
	Callback = function(p34) n8 = p34 end,
})
SheriffTab:Toggle({
	Title = "Enable Orbit",
	Desc  = "Orbit around the murderer",
	Value = false,
	Callback = function(p35) u86 = p35 end,
})

RunService3.RenderStepped:Connect(function(dt)
	if u86 then
		local v358 = u92()
		if v358 and v358.Character then
			local HRP  = v358.Character:FindFirstChild("HumanoidRootPart")
			local HRP5 = (LocalPlayer7.Character or LocalPlayer7.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
			if HRP then
				if not (n8 > 0) then
					local v361 = HRP.Position - HRP.CFrame.LookVector * n6 + Vector3.new(0, n7, 0)
					HRP5.CFrame = CFrame.lookAt(v361, HRP.Position)
				else
					n5 = n5 + n8 * dt * 60
					local v362 = math.rad(n5)
					HRP5.CFrame = CFrame.lookAt(HRP.Position + Vector3.new(math.sin(v362) * n6, n7, math.cos(v362) * n6), HRP.Position)
				end
			end
		end
	end
end)
RunService3.RenderStepped:Connect(function(dt)
	if u86 then
		local v367 = u92()
		if v367 and v367.Character then
			local HRP  = v367.Character:FindFirstChild("HumanoidRootPart")
			local HRP6 = (LocalPlayer7.Character or LocalPlayer7.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
			if not HRP then return end
			if n8 > 0 then
				n5 = n5 + n8 * dt * 60
				local v370 = math.rad(n5)
				HRP6.CFrame = CFrame.lookAt(HRP.Position + Vector3.new(math.sin(v370) * n6, n7, math.cos(v370) * n6), HRP.Position)
			else
				local v374 = HRP.Position - HRP.CFrame.LookVector * n6 + Vector3.new(0, n7, 0)
				HRP6.CFrame = CFrame.lookAt(v374, HRP.Position)
			end
		end
	end
end)

-- Murder Tab
local LocalPlayer5_murd = Players4.LocalPlayer
local t9  = { KillAura = { Enabled = false, Distance = 50 } }
local t11 = {}

local function u78()
	local Character = LocalPlayer5_murd.Character
	if not Character or not Character:FindFirstChild("Humanoid") then return nil end
	local _Knife = LocalPlayer5_murd.Backpack:FindFirstChild("Knife") or Character:FindFirstChild("Knife")
	if _Knife and _Knife.Parent == LocalPlayer5_murd.Backpack then
		Character.Humanoid:EquipTool(_Knife); task.wait(0.1)
	end
	return Character:FindFirstChild("Knife")
end

local function u79(p26)
	local v314 = u78()
	if not v314 then return end
	local Character = p26.Character
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid and Humanoid.Health > 0 then
			local HRP = Character:FindFirstChild("HumanoidRootPart")
			if HRP then
				VirtualUser:ClickButton1(Vector2.new())
				firetouchinterest(HRP, v314.Handle, 1)
				firetouchinterest(HRP, v314.Handle, 0)
			end
		end
	end
end

local function u80()
	local t10 = {}
	for _, player in ipairs(Players4:GetPlayers()) do
		if player ~= LocalPlayer5_murd then table.insert(t10, player.Name) end
	end
	table.sort(t10); return t10
end

MurdTab:Callout({
	Title = "Murder Tools",
	Desc  = "Kill players and kill aura.\nRequires Knife (Murderer role).\n[Risk: May trigger server kicks]",
	Variant = "Warning",
})

local u82 = MurdTab:Dropdown({
	Title = "Select Players to Kill",
	Values = u80(),
	Multi  = true,
	Compact = true,
	AllowNone = true,
	Callback = function(p27) t11 = p27 or {} end,
})

Players4.PlayerAdded:Connect(function() u82:Refresh(u80()) end)
Players4.PlayerRemoving:Connect(function()
	u82:Refresh(u80())
	local t12 = {}
	for _, v in ipairs(t11) do if Players4:FindFirstChild(v) then table.insert(t12, v) end end
	t11 = t12; u82:Select(t12)
end)
u82:Refresh(u80())

MurdTab:Button({
	Title = "Kill Selected Players",
	Desc  = "Kills only players chosen above",
	Icon  = "sword",
	Callback = function()
		if #t11 == 0 then
			WindUI:Notify({ Title = "Warning", Content = "No players selected!", Duration = 3, Style = "Warning" })
			return
		end
		for _, v in ipairs(t11) do
			local v2 = Players4:FindFirstChild(v)
			if v2 then u79(v2) task.wait(0.1) end
		end
	end,
})

MurdTab:Button({
	Title = "Kill All Players",
	Desc  = "Instantly kills every other player",
	Icon  = "sword",
	Callback = function()
		local v328 = u78()
		if not v328 then
			WindUI:Notify({ Title = "Error", Content = "You don't have the knife! (Not murderer?)", Duration = 5, Style = "Error" })
			return
		end
		for _, player in ipairs(Players4:GetPlayers()) do
			if player ~= LocalPlayer5_murd and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				VirtualUser:ClickButton1(Vector2.new())
				firetouchinterest(player.Character.HumanoidRootPart, v328.Handle, 1)
				firetouchinterest(player.Character.HumanoidRootPart, v328.Handle, 0)
				task.wait(0.05)
			end
		end
	end,
})

MurdTab:Button({
	Title = "Kill Random Player",
	Icon  = "shuffle",
	Compact = true,
	Callback = function()
		local t13 = {}
		for _, player in ipairs(Players4:GetPlayers()) do
			if player ~= LocalPlayer5_murd and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(t13, player)
			end
		end
		if not (#t13 > 0) then
			WindUI:Notify({ Title = "Info", Content = "No valid targets found!", Duration = 3, Style = "Notice" })
		else
			local v334 = t13[math.random(1, #t13)]
			u79(v334)
		end
	end,
})

MurdTab:Toggle({
	Title = "Kill Aura",
	Desc  = "Kills nearby alive players automatically",
	Value = false,
	Callback = function(p28) t9.KillAura.Enabled = p28 end,
})

MurdTab:Slider({
	Title = "Kill Aura Distance",
	Desc  = "Max studs to trigger kill aura",
	Value = { Min = 10, Max = 1000, Default = 1000, Increment = 10 },
	Callback = function(p29) t9.KillAura.Distance = p29 end,
})

task.spawn(function()
	while task.wait(0.2) do
		local v340
		if t9.KillAura.Enabled then
			local v337 = u78()
			if v337 then
				local Character = LocalPlayer5_murd.Character
				if Character then
					local HRP = Character:FindFirstChild("HumanoidRootPart")
					if not HRP then v340 = true
					else
						for _, player in ipairs(Players4:GetPlayers()) do
							if player ~= LocalPlayer5_murd then
								local Char2 = player.Character
								if Char2 then
									local Hum = Char2:FindFirstChildOfClass("Humanoid")
									if Hum and Hum.Health > 0 then
										local HRP4 = Char2:FindFirstChild("HumanoidRootPart")
										if HRP4 and (HRP.Position - HRP4.Position).Magnitude <= t9.KillAura.Distance then
											VirtualUser:ClickButton1(Vector2.new())
											firetouchinterest(HRP4, v337.Handle, 1)
											firetouchinterest(HRP4, v337.Handle, 0)
											task.wait(0.08)
										end
									end
								end
							end
						end
						v340 = true
					end
				else v340 = true end
			else v340 = true end
		else v340 = true end
		if not v340 then return end
	end
end)

-- ESP Tab
local t14 = {
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	Players           = game:GetService("Players"),
	RunService        = game:GetService("RunService"),
}
local t15          = { GetCurrentPlayerData = t14.ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true) }
local CurrentCamera3 = workspace.CurrentCamera
local LocalPlayer8   = t14.Players.LocalPlayer
local u97 = nil

local function u98()
	local ok, result = pcall(function()
		if t15.GetCurrentPlayerData then return t15.GetCurrentPlayerData:InvokeServer() or {} end
	end)
	return ok and result or {}
end

local function u99(p36)
	local v378 = u97[p36.Name]
	return v378 and (not v378.Killed and not v378.Dead)
end

local function u100(p37)
	local Backpack = p37:FindFirstChild("Backpack")
	if Backpack and Backpack:FindFirstChild("Gun") then return true end
	local v381 = p37.Character or workspace:FindFirstChild(p37.Name)
	if not v381 or not v381:FindFirstChild("Gun") then return false end
	return true
end

local t16 = {
	Highlights = { Innocent = Color3.fromRGB(0,255,0), Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,0,255), Hero = Color3.fromRGB(0,0,255), DeadInnocent = Color3.fromRGB(128,128,128) },
	Skeleton   = { Innocent = Color3.fromRGB(0,255,0), Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,0,255), Hero = Color3.fromRGB(0,0,255), DeadInnocent = Color3.fromRGB(128,128,128) },
	Tracers    = { Innocent = Color3.fromRGB(0,255,0), Murderer = Color3.fromRGB(255,0,0), Sheriff = Color3.fromRGB(0,0,255), Hero = Color3.fromRGB(0,0,255), DeadInnocent = Color3.fromRGB(128,128,128) },
}
local t17 = {
	Highlights = { Innocent = false, Murderer = false, Sheriff = false, DeadInnocent = false },
	Skeleton   = { Innocent = false, Murderer = false, Sheriff = false, DeadInnocent = false },
	Tracers    = { Innocent = false, Murderer = false, Sheriff = false, DeadInnocent = false },
}
local t18 = {
	{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},
	{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
	{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},
	{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
	{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local t19 = {}; local t20 = {}; local u107 = false

local function u108(p38)
	if t19[p38] then pcall(function() t19[p38]:Destroy() end) t19[p38] = nil end
	if t20[p38] then
		local v384 = t20[p38]
		if v384.tracer       then v384.tracer:Remove() end
		if v384.nameText     then v384.nameText:Remove() end
		if v384.skeletonLines then for _, v in ipairs(v384.skeletonLines) do v:Remove() end end
		t20[p38] = nil
	end
end

for _, player in ipairs(t14.Players:GetPlayers()) do
	if player ~= LocalPlayer8 then player.CharacterRemoving:Connect(function() u108(player) end) end
end
t14.Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer8 then player.CharacterRemoving:Connect(function() u108(player) end) end
end)
t14.Players.PlayerRemoving:Connect(u108)

t14.RunService.RenderStepped:Connect(function()
	u97 = u98()
	local v389 = next(u97) ~= nil
	local g395 = nil; local g399 = nil; local v394 = nil
	if u107 and not v389 then
		for _, player in ipairs(t14.Players:GetPlayers()) do u108(player) end
	end
	u107 = v389
	if v389 then
		for _, player in ipairs(t14.Players:GetPlayers()) do
			if player == LocalPlayer8 then v394 = true g395 = true end
			if not g395 then
				local v396 = player.Character or workspace:FindFirstChild(player.Name)
				if not v396 or not v396.Parent then u108(player) v394 = true g395 = true end
				if not g395 then
					local v397 = u97[player.Name]
					if not v397 then v394 = true g395 = true end
					if not g395 then
						local Role = v397.Role
						if not v397.Dead and not v397.Killed then
							if Role == "Innocent" and u100(player) and (not u97.Sheriff or not u99(t14.Players[u97.Sheriff])) then Role = "Hero" end
							g399 = true
						end
						if g399 or Role == "Innocent" then
							if not g399 then Role = "DeadInnocent" end
							g399 = false
							local v400 = t17.Highlights[Role] or Role == "Hero" and (t17.Highlights.Sheriff or false)
							local v401 = t17.Tracers[Role]    or Role == "Hero" and (t17.Tracers.Sheriff    or false)
							local v402 = t17.Skeleton[Role]   or Role == "Hero" and (t17.Skeleton.Sheriff   or false)
							local v403 = t16.Highlights[Role == "Hero" and "Sheriff" or Role]
							local v404 = t16.Tracers[Role    == "Hero" and "Sheriff" or Role]
							local v405 = t16.Skeleton[Role   == "Hero" and "Sheriff" or Role]
							local u406 = t19[player]
							if not v400 then
								if u406 then u406.Enabled = false end
							else
								if not u406 or v396 ~= u406.Parent then
									if u406 then pcall(function() u406:Destroy() end) end
									u406 = Instance.new("Highlight"); u406.Parent = v396
									u406.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
									u406.FillTransparency = 1; u406.OutlineTransparency = 0
									t19[player] = u406
								end
								u406.OutlineColor = v403; u406.Enabled = true
							end
							if not t20[player] then t20[player] = {} end
							local v407 = t20[player]
							if not v401 then
								if v407.tracer   then v407.tracer.Visible   = false end
								if v407.nameText then v407.nameText.Visible = false end
							else
								if not v407.tracer   then v407.tracer = Drawing.new("Line") v407.tracer.Thickness = 2 end
								if not v407.nameText then
									v407.nameText = Drawing.new("Text")
									v407.nameText.Size = 15; v407.nameText.Center = true
									v407.nameText.Outline = true; v407.nameText.Font = 2
								end
								v407.tracer.Color = v404; v407.nameText.Color = v404
								local HRP = v396:FindFirstChild("HumanoidRootPart")
								if HRP then
									local HRPPos = HRP.Position
									local v410, v411 = CurrentCamera3:WorldToViewportPoint(HRPPos)
									local Humanoid = v396:FindFirstChildOfClass("Humanoid")
									if not Humanoid or not (Humanoid.Health <= 0) then
										if v411 then
											local vec2 = Vector2.new(CurrentCamera3.ViewportSize.X / 2, CurrentCamera3.ViewportSize.Y)
											v407.tracer.From = vec2; v407.tracer.To = Vector2.new(v410.X, v410.Y); v407.tracer.Visible = true
											local _HRP3 = LocalPlayer8.Character and LocalPlayer8.Character:FindFirstChild("HumanoidRootPart")
											local v415 = _HRP3 and math.floor((_HRP3.Position - HRPPos).Magnitude) or 999
											v407.nameText.Text     = player.Name .. " [" .. v415 .. "]"
											v407.nameText.Position = Vector2.new(v410.X, v410.Y - 35)
											v407.nameText.Visible  = true
										else v407.tracer.Visible = false v407.nameText.Visible = false end
									else v407.tracer.Visible = false v407.nameText.Visible = false end
								else v407.tracer.Visible = false v407.nameText.Visible = false end
							end
							if v402 then
								if not v407.skeletonLines then
									v407.skeletonLines = {}
									for _ = 1, #t18 do local d = Drawing.new("Line") d.Thickness = 1 table.insert(v407.skeletonLines, d) end
								end
								for _, v in ipairs(v407.skeletonLines) do v.Color = v405 end
								for i, v in ipairs(t18) do
									local v422 = v396:FindFirstChild(v[1]); local v423 = v396:FindFirstChild(v[2])
									if not v422 or not v423 then v407.skeletonLines[i].Visible = false
									else
										local v424, v425 = CurrentCamera3:WorldToViewportPoint(v422.Position)
										local v426, v427 = CurrentCamera3:WorldToViewportPoint(v423.Position)
										if not v425 or not v427 then v407.skeletonLines[i].Visible = false
										else
											v407.skeletonLines[i].From = Vector2.new(v424.X, v424.Y)
											v407.skeletonLines[i].To   = Vector2.new(v426.X, v426.Y)
											v407.skeletonLines[i].Visible = true
										end
									end
								end
							elseif v407.skeletonLines then
								for _, v in ipairs(v407.skeletonLines) do v.Visible = false end
							end
							v394 = true
						else v394 = true end
					end
				end
			end
			g395 = false
			if not v394 then return end
		end
	end
end)

ESPTab:Callout({
	Title = "ESP",
	Desc  = "Highlights, tracers and skeletons\nfor all players sorted by role.",
	Variant = "Info",
})

ESPTab:Toggle({ Title = "Innocent Highlights",     Value = false, Callback = function(p39) t17.Highlights.Innocent     = p39 end })
ESPTab:Toggle({ Title = "Murderer Highlights",     Value = false, Callback = function(p40) t17.Highlights.Murderer     = p40 end })
ESPTab:Toggle({ Title = "Sheriff/Hero Highlights", Value = false, Callback = function(p41) t17.Highlights.Sheriff      = p41 end })
ESPTab:Toggle({ Title = "Dead Highlights",         Value = false, Callback = function(p42) t17.Highlights.DeadInnocent = p42 end })
ESPTab:Toggle({ Title = "Innocent Skeleton",       Value = false, Callback = function(p43) t17.Skeleton.Innocent       = p43 end })
ESPTab:Toggle({ Title = "Murderer Skeleton",       Value = false, Callback = function(p44) t17.Skeleton.Murderer       = p44 end })
ESPTab:Toggle({ Title = "Sheriff/Hero Skeleton",   Value = false, Callback = function(p45) t17.Skeleton.Sheriff        = p45 end })
ESPTab:Toggle({ Title = "Dead Skeleton",           Value = false, Callback = function(p46) t17.Skeleton.DeadInnocent   = p46 end })
ESPTab:Toggle({ Title = "Innocent Tracers",        Value = false, Callback = function(p47) t17.Tracers.Innocent        = p47 end })
ESPTab:Toggle({ Title = "Murderer Tracers",        Value = false, Callback = function(p48) t17.Tracers.Murderer        = p48 end })
ESPTab:Toggle({ Title = "Sheriff/Hero Tracers",    Value = false, Callback = function(p49) t17.Tracers.Sheriff         = p49 end })
ESPTab:Toggle({ Title = "Dead Tracers",            Value = false, Callback = function(p50) t17.Tracers.DeadInnocent    = p50 end })

ESPTab:Colorpicker({ Title = "Innocent Highlight Color",     Default = t16.Highlights.Innocent,     Callback = function(p51) t16.Highlights.Innocent     = p51 end })
ESPTab:Colorpicker({ Title = "Murderer Highlight Color",     Default = t16.Highlights.Murderer,     Callback = function(p52) t16.Highlights.Murderer     = p52 end })
ESPTab:Colorpicker({ Title = "Sheriff/Hero Highlight Color", Default = t16.Highlights.Sheriff,      Callback = function(p53) t16.Highlights.Sheriff = p53 t16.Highlights.Hero = p53 end })
ESPTab:Colorpicker({ Title = "Dead Highlight Color",         Default = t16.Highlights.DeadInnocent, Callback = function(p54) t16.Highlights.DeadInnocent = p54 end })
ESPTab:Colorpicker({ Title = "Innocent Skeleton Color",      Default = t16.Skeleton.Innocent,       Callback = function(p55) t16.Skeleton.Innocent       = p55 end })
ESPTab:Colorpicker({ Title = "Murderer Skeleton Color",      Default = t16.Skeleton.Murderer,       Callback = function(p56) t16.Skeleton.Murderer       = p56 end })
ESPTab:Colorpicker({ Title = "Sheriff/Hero Skeleton Color",  Default = t16.Skeleton.Sheriff,        Callback = function(p57) t16.Skeleton.Sheriff = p57 t16.Skeleton.Hero = p57 end })
ESPTab:Colorpicker({ Title = "Dead Skeleton Color",          Default = t16.Skeleton.DeadInnocent,   Callback = function(p58) t16.Skeleton.DeadInnocent   = p58 end })
ESPTab:Colorpicker({ Title = "Innocent Tracer Color",        Default = t16.Tracers.Innocent,        Callback = function(p59) t16.Tracers.Innocent        = p59 end })
ESPTab:Colorpicker({ Title = "Murderer Tracer Color",        Default = t16.Tracers.Murderer,        Callback = function(p60) t16.Tracers.Murderer        = p60 end })
ESPTab:Colorpicker({ Title = "Sheriff/Hero Tracer Color",    Default = t16.Tracers.Sheriff,         Callback = function(p61) t16.Tracers.Sheriff = p61 t16.Tracers.Hero = p61 end })
ESPTab:Colorpicker({ Title = "Dead Tracer Color",            Default = t16.Tracers.DeadInnocent,    Callback = function(p62) t16.Tracers.DeadInnocent    = p62 end })

-- Teleport Tab
local LocalPlayer9 = Players4.LocalPlayer
local function u112() return LocalPlayer9.Character or LocalPlayer9.CharacterAdded:Wait() end
local function u113()
	for _, child in ipairs(Workspace2:GetChildren()) do
		if child:IsA("Model") and child:FindFirstChild("Spawns") and not child.Name:lower():find("lobby") then
			for _, d in ipairs(child:GetDescendants()) do
				if d:IsA("BasePart") then return child end
			end
		end
	end
	return nil
end

TeleportTab:Callout({
	Title = "Teleport",
	Desc  = "Move to players, map spawn,\nmurderer or sheriff quickly.",
	Variant = "Info",
})

local u182 = nil; local u183 = false

local u185 = TeleportTab:Dropdown({
	Title = "Select Player to TP",
	Values = {}, Value = nil, Multi = false, AllowNone = true,
	Callback = function(p138) u182 = Players9:FindFirstChild(p138) or nil end,
})

local function v186()
	local t35 = {}
	for _, player in ipairs(Players9:GetPlayers()) do
		if player ~= LocalPlayer17 then table.insert(t35, player.Name) end
	end
	u185:Refresh(t35)
end
v186()
Players9.PlayerAdded:Connect(v186)
Players9.PlayerRemoving:Connect(v186)

local function u184(p137)
	if p137 and p137.Character then
		local HRP  = p137.Character:FindFirstChild("HumanoidRootPart")
		local Char = LocalPlayer17.Character
		local _HRP5 = Char and Char:FindFirstChild("HumanoidRootPart")
		if HRP and _HRP5 then _HRP5.CFrame = HRP.CFrame + Vector3.new(0, 3, 0) end
	end
end

TeleportTab:Button({ Title = "Teleport to Selected Player", Icon = "user",         Callback = function() if u182 then u184(u182) end end })
TeleportTab:Button({
	Title = "TP to Random Player", Icon = "shuffle",
	Callback = function()
		local t36 = {}
		for _, player in ipairs(Players9:GetPlayers()) do
			if player ~= LocalPlayer17 then table.insert(t36, player) end
		end
		if #t36 > 0 then u184(t36[math.random(1, #t36)]) end
	end,
})
TeleportTab:Toggle({
	Title = "Loop TP to Selected",
	Desc  = "Continuously teleport to selected player",
	Value = false,
	Callback = function(p139)
		u183 = p139
		if p139 then
			task.spawn(function()
				while u183 do if u182 then u184(u182) end task.wait(0.2) end
			end)
		end
	end,
})

TeleportTab:Button({
	Title = "Teleport to Spawn", Icon = "home", Compact = true,
	Callback = function()
		local v458 = u112()
		v458:WaitForChild("HumanoidRootPart")
		v458:PivotTo(CFrame.new(349.614563, 521.773132, -3.974884))
	end,
})

TeleportTab:Button({
	Title = "Teleport to Game Map", Icon = "map", Compact = true,
	Callback = function()
		local v459 = u112(); v459:WaitForChild("HumanoidRootPart")
		local v460 = u113()
		if not v460 then WindUI:Notify({ Title = "Error", Content = "Game map not found", Duration = 3, Style = "Error" }) return end
		local Spawns = v460:FindFirstChild("Spawns"); local dPos = nil
		if Spawns then
			for _, d in ipairs(Spawns:GetDescendants()) do if d:IsA("BasePart") then dPos = d.Position break end end
		end
		if not dPos then
			local zero = Vector3.zero; local n9 = 0
			for _, d in ipairs(v460:GetDescendants()) do if d:IsA("BasePart") then zero = zero + d.Position n9 = n9 + 1 end end
			if n9 > 0 then dPos = zero / n9 end
		end
		if dPos then v459:PivotTo(CFrame.new(dPos + Vector3.new(0, 5, 0))) end
	end,
})

TeleportTab:Button({
	Title = "Teleport Above Map", Icon = "chevrons-up", Compact = true,
	Callback = function()
		local v469 = u112(); v469:WaitForChild("HumanoidRootPart")
		local v470 = u113()
		if v470 then
			local v471 = -math.huge; local zero = Vector3.zero; local n10 = 0
			for _, d in ipairs(v470:GetDescendants()) do
				if d:IsA("BasePart") then v471 = math.max(v471, d.Position.Y) zero = zero + d.Position n10 = n10 + 1 end
			end
			if n10 == 0 then WindUI:Notify({ Title = "Error", Content = "No map parts found", Duration = 3, Style = "Error" }) return end
			local v476 = zero / n10
			v469:PivotTo(CFrame.new(Vector3.new(v476.X, v471 + 30, v476.Z)))
			WindUI:Notify({ Title = "Teleported", Content = "Teleported above map", Duration = 2, Style = "Success" })
			return
		end
		WindUI:Notify({ Title = "Error", Content = "Game map not found", Duration = 3, Style = "Error" })
	end,
})

TeleportTab:Button({
	Title = "TP to Murderer", Icon = "sword", Compact = true,
	Callback = function()
		local Character = game.Players.LocalPlayer.Character
		if Character then
			local v479 = nil
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player ~= game.Players.LocalPlayer and (player.Backpack and player.Backpack:FindFirstChild("Knife") or player.Character and player.Character:FindFirstChild("Knife")) then
					v479 = player break
				end
			end
			if v479 and v479.Character and v479.Character:FindFirstChild("HumanoidRootPart") then
				Character:PivotTo(CFrame.new(v479.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)))
			end
		end
	end,
})

TeleportTab:Button({
	Title = "TP to Sheriff", Icon = "shield", Compact = true,
	Callback = function()
		local Character = game.Players.LocalPlayer.Character
		if not Character then return end
		local v483 = nil
		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer and (player.Backpack and player.Backpack:FindFirstChild("Gun") or player.Character and player.Character:FindFirstChild("Gun")) then
				v483 = player break
			end
		end
		if v483 and v483.Character and v483.Character:FindFirstChild("HumanoidRootPart") then
			Character:PivotTo(CFrame.new(v483.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)))
		end
	end,
})

-- Player Tab
local Players5       = game:GetService("Players")
local UserInputService3 = game:GetService("UserInputService")
local RunService4    = game:GetService("RunService")
local Workspace3     = game:GetService("Workspace")
local LocalPlayer10  = Players5.LocalPlayer

local u119 = false; local u120 = false; local u121 = false; local u122 = false
local n11  = -50; local u124 = nil
local vector3      = Vector3.new(1000, 10, 1000)
local connection_void = nil; local vector3_3 = Vector3.new(0, 0, 0)

PlayerTab:Callout({
	Title = "Player Modifiers",
	Desc  = "Speed, jump, noclip, fly and\nvoid protection tools.",
	Variant = "Info",
})

PlayerTab:Toggle({
	Title = "Noclip",
	Desc  = "Walk through walls",
	Value = false,
	Callback = function(p63) u119 = p63 end,
})

RunService4.Stepped:Connect(function()
	if u119 and LocalPlayer10.Character then
		for _, d in ipairs(LocalPlayer10.Character:GetDescendants()) do
			if d:IsA("BasePart") then d.CanCollide = false end
		end
	end
end)

PlayerTab:Slider({ Title = "Walk Speed", Desc = "Change player movement speed", Value = { Min = 16, Max = 200, Default = 16, Increment = 1 },
	Callback = function(p64)
		local _H = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
		if _H then _H.WalkSpeed = p64 end
	end,
})

PlayerTab:Slider({ Title = "Jump Power", Value = { Min = 50, Max = 500, Default = 50, Increment = 1 },
	Callback = function(p65)
		local _H2 = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
		if _H2 then _H2.JumpPower = p65 end
	end,
})

PlayerTab:Toggle({ Title = "Zero Gravity", Desc = "Remove workspace gravity",
	Callback = function(p66) Workspace3.Gravity = p66 and 0 or 196.2 end,
})

PlayerTab:Toggle({ Title = "X-Ray", Desc = "Make all workspace parts transparent",
	Callback = function(p67)
		u121 = p67
		for _, d in pairs(Workspace3:GetDescendants()) do
			if d:IsA("BasePart") and (not LocalPlayer10.Character or not d:IsDescendantOf(LocalPlayer10.Character)) then
				d.LocalTransparencyModifier = p67 and 0.7 or 0
			end
		end
	end,
})

PlayerTab:Toggle({ Title = "Infinite Jump", Callback = function(p68) u120 = p68 end })

UserInputService3.JumpRequest:Connect(function()
	if u120 and LocalPlayer10.Character then
		local Hum = LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
		if Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

PlayerTab:Button({
	Title = "Teleport Tool",
	Desc  = "Click map to teleport there",
	Icon  = "mouse-pointer-click",
	Callback = function()
		local Tool = Instance.new("Tool")
		Tool.RequiresHandle = false; Tool.Name = "Teleport Tool"
		Tool.Activated:Connect(function()
			local v880  = LocalPlayer10:GetMouse().Hit.Position + Vector3.new(0, 5, 0)
			local _HRP4 = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChild("HumanoidRootPart")
			if _HRP4 then _HRP4.CFrame = CFrame.new(v880) end
		end)
		Tool.Parent = LocalPlayer10:WaitForChild("Backpack")
	end,
})

local function u126()
	if u124 and u124.Parent then u124:Destroy() end
	u124 = Instance.new("Part")
	u124.Name = "AntiVoidPlatform"; u124.Size = vector3
	u124.Position  = Vector3.new(0, n11 + vector3.Y / 2, 0)
	u124.Anchored  = true; u124.CanCollide = true; u124.Transparency = 0.7
	u124.Color     = Color3.fromRGB(200, 200, 200); u124.Material = Enum.Material.SmoothPlastic
	local Tex = Instance.new("Texture")
	Tex.Texture = "rbxassetid://280375461"; Tex.Face = Enum.NormalId.Top; Tex.StudsPerTileU = 50; Tex.StudsPerTileV = 50; Tex.Parent = u124
	local Tex2 = Instance.new("Texture")
	Tex2.Texture = "rbxassetid://280375461"; Tex2.Face = Enum.NormalId.Bottom; Tex2.StudsPerTileU = 50; Tex2.StudsPerTileV = 50; Tex2.Parent = u124
	u124.Friction = 0.3; u124.Elasticity = 0.1; u124.Parent = Workspace3
	return u124
end
local function u127()
	if u124 and u124.Parent then u124:Destroy() u124 = nil end
end
local function u128()
	if not u122 then u127()
	else
		if not u124 or not u124.Parent then u126() end
		local Character = LocalPlayer10.Character
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			local HRP = Character.HumanoidRootPart
			u124.Position = Vector3.new(math.floor(HRP.Position.X / 100) * 100, n11 + vector3.Y / 2, math.floor(HRP.Position.Z / 100) * 100)
		end
	end
end
local function u131()
	if connection_void then connection_void:Disconnect() end
	connection_void = RunService4.Heartbeat:Connect(function()
		if u122 and u124 then
			local Character = LocalPlayer10.Character
			if Character and Character:FindFirstChild("HumanoidRootPart") then
				local HRP = Character.HumanoidRootPart
				if (HRP.Position - vector3_3).Magnitude > 100 then
					vector3_3 = HRP.Position
					u124.Position = Vector3.new(math.floor(HRP.Position.X / 100) * 100, n11 + vector3.Y / 2, math.floor(HRP.Position.Z / 100) * 100)
				end
			end
		end
	end)
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
	if player == LocalPlayer10 then u127() if connection_void then connection_void:Disconnect() end end
end)
LocalPlayer10.CharacterAdded:Connect(function(character)
	local Hum = character:WaitForChild("Humanoid")
	Hum.WalkSpeed = 16; Hum.JumpPower = 50
	if u122 then wait(1) u128() u131() end
end)
if u122 then u128() u131() end

PlayerTab:Toggle({
	Title = "Anti Void",
	Desc  = "Platform to catch void falls",
	Value = false,
	Callback = function(p69) u122 = p69 u128() if not p69 then u127() end end,
})

PlayerTab:Button({
	Title = "Mobile Fly",
	Desc  = "Load external fly script",
	Icon  = "plane",
	Callback = function()
		loadstring("loadstring(game:HttpGet(('https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator'),true))()\n\n")()
	end,
})

-- Trolling Tab
local Players6   = game:GetService("Players")
local t21_troll  = {}
local u135_troll = false

TrollingTab:Callout({
	Title = "Trolling Tools",
	Desc  = "Fling players, emotes and server lag.\n[Risk: Heavily disrupts other players]",
	Variant = "Warning",
})

local u136 = TrollingTab:Paragraph({ Title = "Fling Status", Desc = "Select players to fling", Locked = true })

local function u137_t()
	local n12 = 0
	for _ in pairs(t21_troll) do n12 = n12 + 1 end
	if u135_troll then u136:SetDesc("Flinging " .. n12 .. " target(s)")
	else u136:SetDesc(n12 .. " player(s) selected") end
end

local function u138(p71)
	local t22 = {}
	for _, player in ipairs(Players6:GetPlayers()) do
		if player ~= LocalPlayer11 then table.insert(t22, player.Name) end
	end
	p71:Refresh(t22)
end

local u139 = TrollingTab:Dropdown({
	Title = "Select Players to Fling",
	Desc  = "Multi-select players",
	Values = {}, Value = {}, Multi = true, AllowNone = true,
	Callback = function(p72)
		t21_troll = {}
		for _, v in pairs(p72) do
			local v3 = Players6:FindFirstChild(v)
			if v3 then t21_troll[v] = v3 end
		end
		u137_t()
	end,
})

TrollingTab:Button({
	Title = "Fling Selected Players", Icon = "zap",
	Callback = function()
		if u135_troll then return end
		u135_troll = true
		task.spawn(function()
			while u135_troll do
				for _, v in pairs(t21_troll) do
					if u135_troll and v and v.Parent then u140(v) task.wait(0.1) end
				end
				task.wait(0.5)
			end
		end)
	end,
})

TrollingTab:Button({ Title = "Stop Fling", Icon = "square", Callback = function() u135_troll = false end })

TrollingTab:Button({
	Title = "Fling Murderer", Icon = "sword",
	Callback = function()
		if u135_troll then return end
		t21_troll = {}
		for _, player in ipairs(Players6:GetPlayers()) do
			if player ~= LocalPlayer11 and u141(player) == "Murderer" then t21_troll[player.Name] = player end
		end
		u137_t()
		if next(t21_troll) then
			u135_troll = true
			task.spawn(function()
				for _, v in pairs(t21_troll) do if v and v.Parent then u140(v) task.wait(0.5) end end
				u135_troll = false; u137_t()
			end)
		end
	end,
})

TrollingTab:Button({
	Title = "Fling Sheriff", Icon = "shield",
	Callback = function()
		if not u135_troll then
			t21_troll = {}
			for _, player in ipairs(Players6:GetPlayers()) do
				if player ~= LocalPlayer11 and u141(player) == "Sheriff" then t21_troll[player.Name] = player end
			end
			u137_t()
			if next(t21_troll) then
				u135_troll = true
				task.spawn(function()
					for _, v in pairs(t21_troll) do if v and v.Parent then u140(v) task.wait(0.5) end end
					u135_troll = false; u137_t()
				end)
			end
		end
	end,
})

-- Emotes
t15.PlayEmote = ReplicatedStorage.Remotes.Misc.PlayEmote
getgenv().AutoShootEnabled = false
getgenv().AutoBreakGun     = false
getgenv().SeizureLoop      = nil

local t23 = { "sit","ninja","dab","zen","floss","headless","zombie","wave","cheer","laugh" }

TrollingTab:Dropdown({
	Title = "Play Emote", Desc = "Fire a single emote",
	Values = t23, Value = t23[0],
	Callback = function(p79) t15.PlayEmote:Fire(p79) end,
})

TrollingTab:Toggle({
	Title = "Seizure Mode", Desc = "Spam-cycle all emotes rapidly",
	Callback = function(p80)
		if not p80 then
			if getgenv().SeizureLoop then task.cancel(getgenv().SeizureLoop) getgenv().SeizureLoop = nil end
		else
			getgenv().SeizureLoop = task.spawn(function()
				while task.wait(0.1) do
					for _, v in ipairs(t23) do t15.PlayEmote:Fire(v) task.wait(0.05) end
				end
			end)
		end
	end,
})

TrollingTab:Button({
	Title = "Lag Server", Desc = "[Risk: Severely disrupts the whole server]", Icon = "wifi-off",
	Callback = function()
		function CrashServer()
			local GetSyncData  = game:GetService("ReplicatedStorage").GetSyncData
			local InvokeServer = GetSyncData.InvokeServer
			local spawn2 = task.spawn; local n14 = 0
			while true do
				for _ = 1, 1 do spawn2(InvokeServer, GetSyncData) end
				n14 = n14 + 1
				if n14 == 3 then wait(0) n14 = 0 end
			end
		end
	end,
})

Players6.PlayerAdded:Connect(function() u138(u139) end)
Players6.PlayerRemoving:Connect(function(player) t21_troll[player.Name] = nil u138(u139) end)
u138(u139)

-- Auto Farm core logic (all original logic preserved in do-block)
local RunService5, Workspace4, VirtualUser2, LocalPlayer12, CoinCollected, t24, t25, u162, u163, Part, u166, u167, u168, u169, TextLabel_farm

do
	local LocalPlayer13 = game:GetService("Players").LocalPlayer
	LocalPlayer13:WaitForChild("PlayerGui", 600)
	game:GetService("HttpService"); game:GetService("Players"); game:GetService("Workspace")

	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local Players7 = game:GetService("Players")

	RunService5   = game:GetService("RunService")
	Workspace4    = game:GetService("Workspace")
	VirtualUser2  = game:GetService("VirtualUser")
	LocalPlayer12 = Players7.LocalPlayer
	CoinCollected = ReplicatedStorage2.Remotes.Gameplay.CoinCollected

	local RoundStart = ReplicatedStorage2.Remotes.Gameplay.RoundStart

	t24 = { "MouseButton1Click", "MouseButton1Down", "Activated" }

	function TapUI(p84, p85, p86)
		if p85 == "Active Check" then
			if not p84.Active then return end
			p84 = p84[p86]
		end
		if p85 == "Text Check" then
			if p84 ~= "^" then return end
		else p86 = p84 end
		local v555, v556, v557 = pairs(t24)
		while true do
			local v558; v557, v558 = v555(v556, v557)
			if v557 == nil then break end
			local v559, v560, v561 = pairs(getconnections(p86[v558]))
			while true do
				local v562; v561, v562 = v559(v560, v561)
				if v561 == nil then break end
				v562:Fire()
			end
		end
	end

	repeat
		task.wait(1)
		pcall(function() TapUI(LocalPlayer12.PlayerGui.DeviceSelect.Container.Tablet.Button) end)
		pcall(function() TapUI(game:GetService("Players").LocalPlayer.PlayerGui.Join.Friends.Play) end)
	until LocalPlayer12.PlayerGui:FindFirstChild("MainGUI")

	repeat fr = pcall(function() require(game:GetService("ReplicatedStorage").Modules.TradeModule) end) task.wait() until fr

	DefaultConfig = {
		AutoRevealRoles = false, AutoAdvertizeDiscord = false,
		CoinFarm  = { StatsOverlay = false, State = false, Settings = { Speed = 22.5, DestroyMap = false, DestroyPlayers = false, Fly = false, DieAtFullBag = false } },
		CoinFarm2 = { State = false, Settings = { Speed = 22.5, DestroyMap = false, DestroyPlayers = false, DieAtFullBag = false, Disable3DRendering = false } },
		CoinFarm3 = { State = false },
		ESP       = { Players = false, Traps = false, DroppedGun = false },
		Noclip    = false,
		Gameplay  = { AutoPickUpGun = false, AutoShooting = false },
		AutoFarm  = {
			TeleportSpawn = false, KillEveryoneAsAMurderer = false, AutoFlingMurderer = false, AutoFlingSheriff = false,
			AutoPrestige  = false, KillEveryoneAsAMurdererAtFullBag = false, TeleportUnderMap = false,
			AutoTeleportToRandomServerIfServerIsEmpty = false, AutoFlingMurdererAtFullBag = false, PlayersToAutoServerHop = 2
		},
		AnnoyingStuff  = { Fling = { PickedPlayer = nil, LoopFlingAllPlayers = false } },
		Sliders        = { Speed = LocalPlayer12.Character.Humanoid.WalkSpeed, Jump = LocalPlayer12.Character.Humanoid.JumpPower },
		AutoOpenCrates = { State = false, Crate = "MysteryBox1", CrateType = "MysteryBox" },
		VisualGun      = false, ShuffleWeapons = false,
		Emotes         = { SelectedEmote = "zen", AutoPlayEmotes = false, AutoPlaySelectedEmote = false, EmoteSpamSpeed = 1 },
	}

	function deep_copy_table(p87)
		local v564 = table.clone(p87)
		local v565, v566, v567 = pairs(v564)
		while true do
			local v568; v567, v568 = v565(v566, v567)
			if v567 == nil then break end
			if type(v568) == "table" then v564[v567] = table.clone(v568) end
		end
		return v564
	end

	Config = deep_copy_table(DefaultConfig)
	print("Loaded [MM2] - Zelo UI")
	DevelopingLog = "\r\nZelo UI | MM2\r\n"

	LocalPlayer13.Idled:connect(function() VirtualUser2:ClickButton2(Vector2.new()) end)

	function TeleportUnderMap()
		if workspace:FindFirstChild("safespot") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-106, 87.5, 2)
		else
			safespot = Instance.new("Part"); safespot.Name = "safespot"; safespot.Size = Vector3.new(25, 3, 25)
			safespot.Position = Vector3.new(-106, 83, 2); safespot.Parent = workspace
			safespot.Anchored = true; safespot.CanCollide = true; safespot.Transparency = 0
			task.wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-106, 87.5, 2)
			task.wait(0.1)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-106, 87.5, 2)
			task.wait(0.1)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-106, 87.5, 2)
		end
	end

	game:GetService("GuiService").ErrorMessageChanged:Connect(function()
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end)

	t25 = { "sit","ninja","dab","zen","floss","headless","zombie","wave","cheer","laugh" }

	function PlayEmote(p88)
		game:GetService("ReplicatedStorage").Remotes.Misc.PlayEmote:Fire(p88)
	end

	task.spawn(function()
		while task.wait(1 / Config.Emotes.EmoteSpamSpeed) do
			if Config.Emotes.AutoPlayEmotes then PlayEmote(t25[math.random(1, #t25)]) end
		end
	end)

	function fly()
		speeds = 1
		local LocalPlayer14 = game:GetService("Players").LocalPlayer
		local Character = LocalPlayer12.Character
		if Character then Character:FindFirstChildWhichIsA("Humanoid") end
		nowe = false; Duration = 5
		if nowe ~= true then
			nowe = true
			LocalPlayer12.Character.Animate.Disabled = true
			local Character4 = LocalPlayer12.Character
			local _Humanoid4 = Character4:FindFirstChildOfClass("Humanoid") or Character4:FindFirstChildOfClass("AnimationController")
			local v574, v575, v576 = pairs(_Humanoid4:GetPlayingAnimationTracks())
			while true do local v577; v576, v577 = v574(v575, v576); if v576 == nil then break end v577:AdjustSpeed(0) end
			local function setHumState(enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,         enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,      enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,         enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,        enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,         enabled)
			end
			setHumState(false)
			LocalPlayer14.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		else
			nowe = false
			local function setHumState2(enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,         enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,      enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,         enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,        enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,          enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,           enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,enabled)
				LocalPlayer14.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,         enabled)
			end
			setHumState2(true)
			LocalPlayer14.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		end
		local v578 = LocalPlayer12; local UpperTorso = v578.Character.UpperTorso
		local t26 = {f=0,b=0,l=0,r=0}; local t27 = {f=0,b=0,l=0,r=0}
		local n15 = 50; local n16 = 0
		local BodyGyro = Instance.new("BodyGyro", UpperTorso)
		BodyGyro.P = 90000; BodyGyro.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000); BodyGyro.cframe = UpperTorso.CFrame
		local BodyVelocity = Instance.new("BodyVelocity", UpperTorso)
		BodyVelocity.velocity = Vector3.new(0, 0.1, 0); BodyVelocity.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
		if nowe == true then v578.Character.Humanoid.PlatformStand = true end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()
			if t26.l + t26.r ~= 0 or t26.f + t26.b ~= 0 then
				n16 = n16 + 0.5 + n16 / n15; if n15 < n16 then n16 = n15 end
			elseif t26.l + t26.r == 0 and t26.f + t26.b == 0 and n16 ~= 0 then
				local v586 = n16 - 1; n16 = v586 < 0 and 0 or v586
			end
			if t26.l + t26.r ~= 0 or t26.f + t26.b ~= 0 then
				BodyVelocity.velocity = (game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (t26.f + t26.b) + (game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(t26.l + t26.r, (t26.f + t26.b) * 0.2, 0).p - game.Workspace.CurrentCamera.CoordinateFrame.p)) * n16
				t27 = {f=t26.f,b=t26.b,l=t26.l,r=t26.r}
			elseif t26.l + t26.r ~= 0 or t26.f + t26.b ~= 0 or n16 == 0 then
				BodyVelocity.velocity = Vector3.new(0, 0, 0)
			else
				BodyVelocity.velocity = (game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (t27.f + t27.b) + (game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(t27.l + t27.r, (t27.f + t27.b) * 0.2, 0).p - game.Workspace.CurrentCamera.CoordinateFrame.p)) * n16
			end
			BodyGyro.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((t26.f + t26.b) * 50 * n16 / n15), 0, 0)
		end
		BodyGyro:Destroy(); BodyVelocity:Destroy()
		v578.Character.Humanoid.PlatformStand = false
		LocalPlayer12.Character.Animate.Disabled = false
		tpwalking = false
	end

	function destroyplayers()
		local v587, v588, v589 = pairs(game.Players:GetPlayers())
		while true do
			local v590; v589, v590 = v587(v588, v589); if v589 == nil then break end
			if v590 ~= LocalPlayer12 and game.Workspace:WaitForChild(v590.Name, 0.01) then
				game.Workspace[v590.Name]:Destroy()
			end
		end
	end

	function DestroyMapFunc()
		local v591, v592, v593 = pairs(game.Workspace:GetChildren())
		while true do
			local v594; v593, v594 = v591(v592, v593); local u595 = v594
			if v593 == nil then break end
			if u595:IsA("Model") and u595:FindFirstChild("CoinContainer") then
				if pcall(function() basesex    = u595.Base                 end) then basesex:Destroy()     end
				if pcall(function() decoration = u595.Decoration_Christmas  end) then decoration:Destroy()  end
				if pcall(function() outfits    = u595.Outfits               end) then outfits:Destroy()     end
				if pcall(function() raggy      = u595.Raggy                 end) then raggy:Destroy()       end
				if pcall(function() interactive= u595.Interactive            end) then interactive:Destroy() end
				if pcall(function() spawns     = u595.Spawns                end) then spawns:Destroy()      end
			end
		end
	end

	function clipclop()
		local v596, v597, v598 = pairs(LocalPlayer12.Character:GetDescendants())
		while true do
			local v599; v598, v599 = v596(v597, v598); if v598 == nil then break end
			if v599:IsA("BasePart") and v599.CanCollide == true and v599.Name ~= floatName then
				v599.CanCollide = false
			end
		end
	end

	Noclipping = RunService5.Stepped:Connect(function()
		if Config.Noclip and (LocalPlayer12.Character and LocalPlayer12.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer12.Character.Humanoid.Health > 0 and LocalPlayer12.Character:FindFirstChild("HumanoidRootPart")) then
			clipclop()
		end
	end)

	function RandomItemFromInventory()
		local Weapons = require(game:GetService("ReplicatedStorage").Modules.InventoryModule).MyInventory.Data.Weapons
		local v601, v602, v603 = pairs(Weapons); local t28 = {}
		while true do
			local v605; v603, v605 = v601(v602, v603); if v603 == nil then break end
			local v606 = nil
			while true do local v607; v606, v607 = v605(nil, v606); if v606 == nil then break end table.insert(t28, v606) end
		end
		return t28[math.random(1, #t28)]
	end

	RunService5.Stepped:Connect(function()
		if Config.Emotes.AutoPlaySelectedEmote then PlayEmote(Config.Emotes.SelectedEmote) end
		if Config.ShuffleWeapons then
			local t29 = { RandomItemFromInventory(), "Weapons" }
			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("Equip"):FireServer(unpack(t29))
		end
		if game:GetService("CoreGui"):FindFirstChild("CenteredLabelGui") and game:GetService("CoreGui").CenteredLabelGui:FindFirstChild("CenteredTextLabel") then
			game:GetService("CoreGui").CenteredLabelGui.CenteredTextLabel.Visible = Config.CoinFarm.StatsOverlay
		end
		if LocalPlayer12.Character and LocalPlayer12.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer12.Character.Humanoid.Health > 0 and LocalPlayer12.Character:FindFirstChild("HumanoidRootPart") then
			if Config.Sliders.Speed ~= LocalPlayer12.Character.Humanoid.WalkSpeed then LocalPlayer12.Character.Humanoid.WalkSpeed = Config.Sliders.Speed end
			if Config.Sliders.Jump  ~= LocalPlayer12.Character.Humanoid.JumpPower  then LocalPlayer12.Character.Humanoid.JumpPower  = Config.Sliders.Jump  end
		end
	end)

	u162 = LocalPlayer12
	task.spawn(function()
		while task.wait(1) do
			if Config.CoinFarm.Settings.Fly and LocalPlayer12.Character and LocalPlayer12.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer12.Character.Humanoid.Health > 0 and LocalPlayer12.Character:FindFirstChild("HumanoidRootPart") then
				task.spawn(function() fly() end)
			end
		end
	end)

	DestroyPlayers = RunService5.Stepped:Connect(function()
		if Config.CoinFarm.Settings.DestroyPlayers then destroyplayers() end
	end)

	function u163()
		local t30 = {}
		if u162.Character and u162.Character:FindFirstChild("HumanoidRootPart") then
			local HRPPos = u162.Character.HumanoidRootPart.Position
			local v611, v612, v613 = pairs(Workspace4:GetChildren())
			while true do
				local v614; v613, v614 = v611(v612, v613); if v613 == nil then break end
				if v614:IsA("Model") and v614:FindFirstChild("CoinContainer") then
					local v615, v616, v617 = pairs(v614.CoinContainer:GetChildren())
					while true do
						local v618; v617, v618 = v615(v616, v617); if v617 == nil then break end
						if v618.Name == "Coin_Server" and not v618:FindFirstChild("CollectedCoin") and v618:FindFirstChild("TouchInterest") then
							local Mag = (HRPPos - v618.Position).Magnitude
							if Mag < 100 then table.insert(t30, { Coin = v618, Distance = Mag }) end
						end
					end
				end
			end
			table.sort(t30, function(p89, p90) return p89.Distance < p90.Distance end)
		end
		return t30[1] and t30[1].Coin
	end

	TweenService = game.TweenService

	function coinfarm1()
		local connection3 = RunService5.Heartbeat:Connect(function()
			if Config.CoinFarm.State then
				local Game = u162.PlayerGui:WaitForChild("MainGUI").Game
				if Game.CoinBags.Visible and not Game.CoinBags.Container.Candy.Full.Visible and u162.Character and u162.Character:FindFirstChild("HumanoidRootPart") then
					local HRP = u162.Character.HumanoidRootPart
					if not HRP:FindFirstChild("FLY_NIGGER") then
						local BV2 = Instance.new("BodyVelocity", HRP)
						BV2.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000); BV2.Name = "FLY_NIGGER"
					end
					AutoFarming = true; clipclop()
					local u908 = u163()
					if not u908 then HRP.Anchored = true
					else
						HRP.Anchored = false
						spawn(function()
							if u162.Character then
								local HRP7 = u162.Character:WaitForChild("HumanoidRootPart")
								local _Spd = (HRP7.Position - u908.Position).Magnitude / Config.CoinFarm.Settings.Speed
								local cF   = CFrame.new(u908.Position + Vector3.new(0, -1, 0))
								TweenService:Create(HRP7, TweenInfo.new(_Spd, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = cF }):Play()
								if u908 and u908.Parent then
									local conn2 = nil
									conn2 = u908.Touched:Connect(function(_)
										task.wait(0.1); if u908 then u908:Destroy() conn2:Disconnect() end
									end)
								end
							end
						end)
					end
					task.wait(0.02); AutoFarming = false
				end
			end
		end)
		local connection4 = CoinCollected.OnClientEvent:Connect(function(_, p93, p94)
			if p93 == p94 then connection3:Disconnect() roundEndConenction:Disconnect() end
		end)
		local connection5 = u162.Character.Humanoid.Died:Connect(function()
			task.wait(1)
			repeat task.wait() until u162.Character ~= nil
			repeat task.wait() until u162.PlayerGui ~= nil
			task.wait(1)
			repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.MainGUI ~= nil
			task.wait(1); Teleport_to_map()
		end)
		roundEndConenction = game:GetService("ReplicatedStorage").Remotes.Gameplay.RoundEndFade.OnClientEvent:Connect(function()
			connection3:Disconnect(); connection4:Disconnect(); connection5:Disconnect(); roundEndConenction:Disconnect()
		end)
	end

	CoinColldown = 2
	local vector3_5 = Vector3.new(1, -100, 1)
	Part = Instance.new("Part", workspace); u166 = LocalPlayer12
	Part.Anchored = true; Part.Position = vector3_5; Part.Size = Vector3.new(100, 1.2, 100)
	u167 = false

	function PlayerToBrick()
		u166.Character.HumanoidRootPart.CFrame = CFrame.new(Part.Position + Vector3.new(math.random(-10, 5), 5, math.random(-10, 5)))
	end
	function PlayerToCoin(p95)
		if p95 then u166.Character.HumanoidRootPart.CFrame = CFrame.new(p95.Position + Vector3.new(0, -6, 0)) end
	end
	function GetMap()
		local v624, v625, v626 = ipairs(workspace:GetChildren()); local v627
		repeat v626, v627 = v624(v625, v626); if v626 == nil then return end until v627:FindFirstChild("CoinContainer")
		return v627
	end
	function CoinFarm3()
		u167 = false
		if Config.CoinFarm3.State then PlayerToBrick() end
		while not u167 do
			local v628 = GetMap()
			if v628 then
				if not Config.CoinFarm3.State then return end
				task.spawn(function() pcall(function() DestroyMapFunc() end) end)
				local huge = math.huge; local v630, v631, v632 = ipairs(v628.CoinContainer:GetChildren()); local v633 = nil
				while true do
					local v634; v632, v634 = v630(v631, v632); if v632 == nil then break end
					if v634:FindFirstChild("TouchInterest") then
						local PY = v634.Position.Y; if PY < huge then v633 = v634 huge = PY end
					end
				end
				coin = v633; local u636 = false; PlayerToCoin(coin)
				local connection6 = CoinCollected.OnClientEvent:Connect(function(_, p97, p98, _)
					u636 = true; if p97 == p98 then u167 = true end
				end)
				if u167 then return end
				repeat
					task.wait()
					task.spawn(function()
						firetouchinterest(u166.Character.HumanoidRootPart, coin, 0)
						firetouchinterest(u166.Character.HumanoidRootPart, coin, 1)
					end)
					task.wait(); clipclop(); PlayerToCoin(coin)
				until u636 or not coin:FindFirstChild("TouchInterest")
				connection6:Disconnect(); PlayerToBrick(); wait(CoinColldown)
			else task.wait(1); if not Config.CoinFarm3.State then return end end
		end
	end

	game:GetService("ReplicatedStorage").Remotes.Gameplay.RoundStart.OnClientEvent:Connect(function()
		task.spawn(function() CoinFarm3() end); RunningCoinFarm3 = true
	end)
	game.Players.LocalPlayer.CharacterAdded:Connect(function()
		if Config.CoinFarm3.State then PlayerToBrick() end
	end)

	function init()
		if workspace:FindFirstChild("AutoCoinPart") then workspace.AutoCoinPart:Destroy() end
		local u638 = nil; local u639 = false
		local Part2 = Instance.new("Part")
		local HRPPos = LocalPlayer12.Character.HumanoidRootPart.Position
		Part2.Name = "AutoCoinPart"; Part2.Color = Color3.new(0,0,0); Part2.Material = Enum.Material.Plastic
		Part2.Transparency = 1; Part2.Position = HRPPos; Part2.Size = Vector3.new(1, 0.5, 1)
		Part2.CastShadow = true; Part2.Anchored = true; Part2.CanCollide = false; Part2.Parent = workspace
		CoinFarm2Connection = RunService5.Heartbeat:Connect(function()
			if Config.CoinFarm2.State == true and (u639 == false and LocalPlayer12.Character and LocalPlayer12.Character:FindFirstChild("HumanoidRootPart")) then
				u639 = true
				workspace.AutoCoinPart.CFrame = LocalPlayer12.Character.HumanoidRootPart.CFrame
				local v916, v917, v918 = pairs(workspace:GetDescendants())
				while true do
					local v919; v918, v919 = v916(v917, v918); if v918 == nil then break end
					if v919.Name == "Coin_Server" and v919:FindFirstChild("TouchInterest") then
						if u638 then
							if (LocalPlayer12.Character.HumanoidRootPart.Position - u638.Position).Magnitude > (LocalPlayer12.Character.HumanoidRootPart.Position - v919.Position).Magnitude then
								u638 = v919
							end
						else u638 = v919 end
					end
				end
				if u638 then
					CoinFound = true
					if not (math.floor((LocalPlayer12.Character.HumanoidRootPart.Position - u638.Position).Magnitude) < 80) then
						Teleport_to_map(); Part2.Position = LocalPlayer12.Character.HumanoidRootPart.Position; task.wait(0.1)
						TweenSpeed = math.floor((LocalPlayer12.Character.HumanoidRootPart.Position - u638.Position).Magnitude) / Config.CoinFarm2.Settings.Speed
					else
						TweenSpeed = math.floor((LocalPlayer12.Character.HumanoidRootPart.Position - u638.Position).Magnitude) / Config.CoinFarm2.Settings.Speed
					end
					if not TweenSpeed then return end
					local TweenService2 = game:GetService("TweenService")
					tweenInfo = TweenInfo.new(TweenSpeed, Enum.EasingStyle.Linear); tweenService = TweenService2
					tween = tweenService:Create(workspace.AutoCoinPart, tweenInfo, { CFrame = u638.CFrame + Vector3.new(0, -5, 0) })
					tween:Play(); wait(TweenSpeed)
					if u638 then
						pcall(function()
							firetouchinterest(LocalPlayer12.Character.HumanoidRootPart, u638, 0)
							firetouchinterest(LocalPlayer12.Character.HumanoidRootPart, u638, 1)
						end)
						u638.Parent = nil
					end
					TweenSpeed = 0.08; u638 = nil; CoinFound = false; u639 = false
				end
			end
			if Config.CoinFarm2.State == true and game:GetService("Workspace"):FindFirstChild("AutoCoinPart") and CoinFound == true and LocalPlayer12.Character and LocalPlayer12.Character:FindFirstChild("HumanoidRootPart") then
				local AutoCF = game:GetService("Workspace").AutoCoinPart.CFrame
				local cFR    = CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
				LocalPlayer12.Character.HumanoidRootPart.CFrame = CFrame.new(AutoCF.Position) * cFR
			end
		end)
		FullBagConnection = CoinCollected.OnClientEvent:Connect(function(_, p101, p102, _)
			if p101 == p102 then
				CoinFarm2Connection:Disconnect(); FullBagConnection:Disconnect(); DeathConnection:Disconnect()
				if workspace:FindFirstChild("AutoCoinPart") then workspace:FindFirstChild("AutoCoinPart"):Destroy() end
			end
		end)
		DeathConnection = LocalPlayer12.Character.Humanoid.Died:Connect(function()
			CoinFarm2Connection:Disconnect(); FullBagConnection:Disconnect(); DeathConnection:Disconnect()
			if workspace:FindFirstChild("AutoCoinPart") then workspace:FindFirstChild("AutoCoinPart"):Destroy() end
		end)
	end

	spawn(coinfarm1); spawn(init)

	function u168()
		local v642, v643, v644 = ipairs(game.Players:GetPlayers()); local v645
		repeat
			v644, v645 = v642(v643, v644)
			if v644 == nil then
				local v646, v647, v648 = ipairs(game.Players:GetPlayers()); local v649
				repeat
					v648, v649 = v646(v647, v648)
					if v648 == nil then
						if playerData then
							local v650, v651, v652 = pairs(playerData)
							repeat local v653; v652, v653 = v650(v651, v652); if v652 == nil then return nil end until v653.Role == "Murderer" and game.Players:FindFirstChild(v652)
							return game.Players:FindFirstChild(v652)
						end
						return nil
					end
				until v649.Character and v649.Character:FindFirstChild("Knife")
				return v649
			end
		until v645:FindFirstChild("Backpack") and v645.Backpack:FindFirstChild("Knife")
		return v645
	end

	function u169()
		local v654, v655, v656 = ipairs(game.Players:GetPlayers()); local v657
		repeat
			v656, v657 = v654(v655, v656)
			if v656 == nil then
				local v658, v659, v660 = ipairs(game.Players:GetPlayers()); local v661
				repeat
					v660, v661 = v658(v659, v660)
					if v660 == nil then
						if playerData then
							local v662, v663, v664 = pairs(playerData)
							repeat local v665; v664, v665 = v662(v663, v664); if v664 == nil then return nil end until v665.Role == "Sheriff" and game.Players:FindFirstChild(v664)
							return game.Players:FindFirstChild(v664)
						end
						return nil
					end
				until v661.Character and v661.Character:FindFirstChild("Gun")
				return v661
			end
		until v657:FindFirstChild("Backpack") and v657.Backpack:FindFirstChild("Gun")
		return v657
	end

	function reloadESP()
		local v666, v667, v668 = ipairs(workspace:GetChildren())
		while true do local v669; v668, v669 = v666(v667, v668); if v668 == nil then break end if v669.Name == "PlayerESP" then v669:Destroy() end end
		local children = game.Players:GetChildren(); local v671, v672, v673 = ipairs(children)
		while true do
			local v674; v673, v674 = v671(v672, v673); local u675 = v674; if v673 == nil then break end
			if u675.Character ~= nil then
				local Character = u675.Character
				if not Character:FindFirstChild("PlayerESP") then
					local Hl = Instance.new("Highlight", workspace)
					Hl.Name = "PlayerESP"; Hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					Hl.Adornee = Character; Hl.FillColor = Color3.fromRGB(255,255,255); Hl.FillTransparency = 0.5
					task.spawn(function()
						if u675 ~= u168() then
							if u675 ~= u169() then Hl.FillColor = Color3.fromRGB(0,255,0) Hl.OutlineColor = Color3.fromRGB(0,255,0)
							else Hl.FillColor = Color3.fromRGB(0,150,255) Hl.OutlineColor = Color3.fromRGB(0,150,255) end
						else Hl.FillColor = Color3.fromRGB(255,0,0) Hl.OutlineColor = Color3.fromRGB(255,0,0) end
						if Hl then if not u675 then return end Hl.Adornee = u675.Character or u675.CharactedAdded:Wait() end
					end)
				end
			end
		end
	end

	function KillEveryoneAsAMurderer()
		if not LocalPlayer12.Character:FindFirstChild("Knife") then
			LocalPlayer12.Character:FindFirstChild("Humanoid")
			if not LocalPlayer12.Backpack:FindFirstChild("Knife") then return end
			LocalPlayer12.Character:FindFirstChild("Humanoid"):EquipTool(LocalPlayer12.Backpack:FindFirstChild("Knife"))
		end
		local v678, v679, v680 = ipairs(game.Players:GetPlayers())
		while true do
			local v681; v680, v681 = v678(v679, v680); if v680 == nil then break end
			if v681.Character and v681.Character:FindFirstChild("HumanoidRootPart") and v681 ~= LocalPlayer12 then
				v681.Character:FindFirstChild("HumanoidRootPart").Anchored = true
				v681.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer12.Character:FindFirstChild("HumanoidRootPart").CFrame + LocalPlayer12.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1
			end
		end
		LocalPlayer12.Character.Knife.Stab:FireServer(unpack({ "Slash" }))
	end

	RunService5.RenderStepped:Connect(function()
		if u169() == LocalPlayer12 and Config.Gameplay.AutoShooting then
			local v682 = u168(); if not v682 then return end
			local Character = v682.Character; if not Character then return end
			local HRP = Character:FindFirstChild("HumanoidRootPart"); if not HRP then return end
			local HRPPos = HRP.Position
			if not LocalPlayer12.Character then return end
			local HRP8 = LocalPlayer12.Character:FindFirstChild("HumanoidRootPart"); if not HRP8 then return end
			local _Pos = HRPPos - HRP8.Position
			local rp = RaycastParams.new(); rp.FilterType = Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances = { LocalPlayer12.Character }
			local rr = workspace:Raycast(HRP8.Position, _Pos, rp)
			if (not rr or rr.Instance.Parent == v682.Character) and (LocalPlayer12.Character:FindFirstChild("Gun") or LocalPlayer12.Backpack:FindFirstChild("Gun")) then
				LocalPlayer12.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Gun"))
				local v690 = u168(); local UT2 = v690.Character:FindFirstChild("UpperTorso"); local H2 = v690.Character:FindFirstChild("Humanoid")
				if not UT2 then return end; if not H2 then return end
				local ALV = UT2.AssemblyLinearVelocity; local MD = H2.MoveDirection; local v695 = LocalPlayer12
				local v696 = (UT2.Position + ALV * Vector3.new(0, 0.5, 0) * 0.14 + MD * 2.8) * (v695:GetNetworkPing() * 1000 * 0 + 1)
				LocalPlayer12.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, v696, "AH2")
			end
		end
	end)

	function AdvertizeDiscord()
		local children = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
		local v698, v699, v700 = ipairs(children)
		while true do
			local v701; v700, v701 = v698(v699, v700); if v700 == nil then break end
			v701:SendAsync("Immortal hub\r\n gg PwTPex2g6T")
		end
	end

	RoundStart.OnClientEvent:Connect(function(_)
		if Config.AutoRevealRoles     then RevealRoles()      end
		if Config.AutoAdvertizeDiscord then AdvertizeDiscord() end
		if Config.AutoFarm.KillEveryoneAsAMurderer then
			task.wait(1); repeat KillEveryoneAsAMurderer() task.wait(1) until u168() ~= u162
		end
		if Config.AutoFarm.AutoFlingMurderer then
			murd = u168(); if murd and murd ~= game.Players.LocalPlayer then miniFling(murd) end
		end
		if Config.AutoFarm.AutoFlingSheriff then
			sher = u169(); if sher and sher ~= game.Players.LocalPlayer then miniFling(sher) end
		end
		if Config.AutoFarm.TeleportSpawn then Teleport_to_lobby() end
		spawn(init); spawn(coinfarm1)
	end)

	RunService5.Heartbeat:Connect(function()
		if Config.CoinFarm.Settings.DestroyMap then DestroyMapFunc() end
	end)

	game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("PlayerDataChanged", 5).OnClientEvent:Connect(function(p105)
		playerData = p105; if Config.ESP.Players then reloadESP() end
	end)

	function getMap()
		local v704, v705, v706 = ipairs(workspace:GetChildren()); local v707
		repeat v706, v707 = v704(v705, v706); if v706 == nil then return nil end until v707:FindFirstChild("CoinContainer") and v707:FindFirstChild("Spawns")
		return v707
	end

	function GetAllEmotes()
		game.ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer("GetData")
		local EmoteModule = game:GetService("ReplicatedStorage").Modules.EmoteModule
		local Emotes = LocalPlayer12.PlayerGui.MainGUI.Game:FindFirstChild("Emotes")
		require(EmoteModule).GeneratePage({ "headless","zombie","zen","ninja","floss","dab","sit" }, Emotes, "Free Emotes")
		getgenv().FreeEmotesOperator = true
		while getgenv().FreeEmotesOperator == true do
			if LocalPlayer12.PlayerGui.MainGUI.Game:FindFirstChild("Emotes") and not LocalPlayer12.PlayerGui.MainGUI.Game.Emotes.EmotePages:FindFirstChild("Free Emotes") then
				getgenv().FreeEmotesOperator = false; GetAllEmotes()
			end
			RunService5.RenderStepped:wait()
		end
	end

	function pickupgun()
		if getMap() then
			if getMap():FindFirstChild("GunDrop") then
				if u168() ~= LocalPlayer12 then
					if not LocalPlayer12.Character then return end
					local Pivot = LocalPlayer12.Character:GetPivot()
					LocalPlayer12.Character:MoveTo(getMap():FindFirstChild("GunDrop").Position)
					LocalPlayer12.Backpack.ChildAdded:Wait()
					LocalPlayer12.Character:PivotTo(Pivot)
				end
			end
		end
	end

	workspace.DescendantAdded:Connect(function(descendant)
		if Config.ESP.Traps and (descendant.Name == "Trap" and descendant.Parent:IsDescendantOf(workspace)) then
			descendant.Transparency = 0
			local clone = trapESP:Clone(); clone.Parent = workspace; clone.Adornee = descendant
		end
		if Config.ESP.DroppedGun and descendant.Name == "GunDrop" then
			if not workspace:FindFirstChild("GunESP") then
				local Hl = Instance.new("Highlight", workspace)
				Hl.OutlineTransparency = 1; Hl.FillColor = Color3.fromRGB(255,255,0); Hl.Name = "GunESP"
				Hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; Hl.Adornee = descendant; Hl.Enabled = true
			end
			workspace:FindFirstChild("GunESP").Adornee = descendant; workspace:FindFirstChild("GunESP").Enabled = true
			if Config.Gameplay.AutoPickUpGun then task.wait(0.5); for _ = 1, 5 do pickupgun() end end
		end
	end)

	workspace.DescendantRemoving:Connect(function(descendant)
		if Config.ESP.DroppedGun and descendant.Name == "GunDrop" then
			if workspace:FindFirstChild("GunESP") then workspace:FindFirstChild("GunESP"):Destroy() end
			task.wait(0.6)
			if Config.ESP.Players then
				local v716, v717, v718 = ipairs(workspace:GetChildren())
				while true do local v719; v718, v719 = v716(v717, v718); if v718 == nil then break end if v719:IsA("Highlight") then v719:Destroy() end end
			end
			local children2 = game.Players:GetChildren(); local v721, v722, v723 = ipairs(children2)
			while true do
				local v724; v723, v724 = v721(v722, v723); local u725 = v724; if v723 == nil then break end
				if u725.Character ~= nil then
					local Character = u725.Character
					if not Character:FindFirstChild("PlayerESP") then
						local Hl = Instance.new("Highlight", workspace)
						Hl.Name = "PlayerESP"; Hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						Hl.Adornee = Character; Hl.FillColor = Color3.fromRGB(255,255,255); Hl.FillTransparency = 0.5
						task.spawn(function()
							if u725 ~= u168() then
								if u725 ~= u169() then Hl.FillColor = Color3.fromRGB(0,255,0) Hl.OutlineColor = Color3.fromRGB(0,255,0)
								else Hl.FillColor = Color3.fromRGB(255,255,0) Hl.OutlineColor = Color3.fromRGB(255,255,0) end
							else Hl.FillColor = Color3.fromRGB(255,0,0) Hl.OutlineColor = Color3.fromRGB(255,0,0) end
							if Hl then if not u725 then return end Hl.Adornee = u725.Character or u725.CharactedAdded:Wait() end
						end)
					end
				end
			end
		end
	end)

	function killme() LocalPlayer12.Character:BreakJoints() end
	function Teleport_to_lobby(_) LocalPlayer12.Character:MoveTo(Vector3.new(-107, 152, 41)) end
	function Teleport_to_map(_)
		if getMap() then
			local Spawns = getMap():FindFirstChild("Spawns")
			if Spawns then local ch = Spawns:GetChildren() LocalPlayer12.Character:MoveTo(ch[math.random(1, #ch)].Position) end
		end
	end

	function miniFling(p108)
		LocalPlayer12:GetMouse()
		local Players8 = game:GetService("Players"); local LocalPlayer15 = Players8.LocalPlayer
		;(function(p109)
			local Character = LocalPlayer15.Character
			local _Humanoid5 = Character and Character:FindFirstChildOfClass("Humanoid")
			local _RootPart2  = _Humanoid5 and _Humanoid5.RootPart
			if not p109 then return end
			local Character5 = p109.Character; if not Character5 then return end
			local Humanoid2 = nil; local RootPart2 = nil; local Head2 = nil; local Accessory2 = nil; local Handle2 = nil
			if Character5:FindFirstChildOfClass("Humanoid") then Humanoid2 = Character5:FindFirstChildOfClass("Humanoid") end
			if Humanoid2 and Humanoid2.RootPart then RootPart2 = Humanoid2.RootPart end
			if Character5:FindFirstChild("Head") then Head2 = Character5.Head end
			if Character5:FindFirstChildOfClass("Accessory") then Accessory2 = Character5:FindFirstChildOfClass("Accessory") end
			if Accessory2 and Accessory2:FindFirstChild("Handle") then Handle2 = Accessory2.Handle end
			if Character and _Humanoid5 and _RootPart2 then
				if _RootPart2.Velocity.Magnitude < 50 then getgenv().OldPos = _RootPart2.CFrame end
				if not Head2 then if not Head2 and Handle2 and Handle2.Velocity.Magnitude > 500 then return end
				elseif Head2.Velocity.Magnitude > 500 then return end
				if Head2 then workspace.CurrentCamera.CameraSubject = Head2
				elseif not Head2 and Handle2 then workspace.CurrentCamera.CameraSubject = Handle2
				elseif Humanoid2 and RootPart2 then workspace.CurrentCamera.CameraSubject = Humanoid2 end
				if not Character5:FindFirstChildWhichIsA("BasePart") then return end
				local function u938(p110, p111, p112)
					_RootPart2.CFrame = CFrame.new(p110.Position) * p111 * p112
					if game.Players.LocalPlayer:FindFirstChild("Character") then
						Character:SetPrimaryPartCFrame(CFrame.new(p110.Position) * p111 * p112)
						_RootPart2.Velocity = Vector3.new(90000000, 900000000, 90000000)
						_RootPart2.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
					end
				end
				local function v939(p113)
					local timestamp = tick(); local n17 = 0
					while _RootPart2 and Humanoid2 do
						if p113.Velocity.Magnitude >= 50 then
							u938(p113, CFrame.new(0, 1.5, Humanoid2.WalkSpeed),  CFrame.Angles(math.rad(90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5,-Humanoid2.WalkSpeed),  CFrame.Angles(0, 0, 0)) task.wait()
							u938(p113, CFrame.new(0, 1.5, Humanoid2.WalkSpeed),  CFrame.Angles(math.rad(90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5,-RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0)) task.wait()
							u938(p113, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0), CFrame.Angles(math.rad(90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0), CFrame.Angles(0, 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0), CFrame.Angles(math.rad(-90), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0), CFrame.Angles(0, 0, 0)) task.wait()
						else
							n17 = n17 + 100
							u938(p113, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection * p113.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0) + Humanoid2.MoveDirection * p113.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
							u938(p113, CFrame.new(2.25, 1.5,-2.25)  + Humanoid2.MoveDirection * p113.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
							u938(p113, CFrame.new(-2.25,-1.5, 2.25) + Humanoid2.MoveDirection * p113.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
							u938(p113, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
							u938(p113, CFrame.new(0,-1.5, 0) + Humanoid2.MoveDirection, CFrame.Angles(math.rad(n17), 0, 0)) task.wait()
						end
						if p113.Velocity.Magnitude > 500 or p113.Parent ~= p109.Character or p109.Parent ~= Players8 or p109.Character ~= Character5 or Humanoid2.Sit or _Humanoid5.Health <= 0 or tick() > timestamp + 2 then return end
					end
				end
				workspace.FallenPartsDestroyHeight = 0 / 0
				local BV3 = Instance.new("BodyVelocity"); BV3.Name = "EpixVel"; BV3.Parent = _RootPart2
				BV3.Velocity = Vector3.new(900000000, 900000000, 900000000); BV3.MaxForce = Vector3.new(1/0, 1/0, 1/0)
				_Humanoid5:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
				if RootPart2 and Head2 then
					if not ((RootPart2.CFrame.p - Head2.CFrame.p).Magnitude <= 5) then v939(Head2) else v939(RootPart2) end
				elseif not RootPart2 or Head2 then
					if not RootPart2 and Head2 then v939(Head2)
					elseif not RootPart2 and not Head2 and Accessory2 and Handle2 then v939(Handle2) end
				else v939(RootPart2) end
				BV3:Destroy()
				_Humanoid5:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				workspace.CurrentCamera.CameraSubject = _Humanoid5
				while true do
					_RootPart2.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
					if not game.Players.LocalPlayer:FindFirstChild("Character") then break end
					Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
					_Humanoid5:ChangeState("GettingUp")
					table.foreach(Character:GetChildren(), function(_, p115)
						if p115:IsA("BasePart") then p115.RotVelocity = Vector3.new() p115.Velocity = Vector3.new() end
					end)
					task.wait()
					if (_RootPart2.Position - getgenv().OldPos.p).Magnitude < 25 then workspace.FallenPartsDestroyHeight = getgenv().FPDH end
				end
			end
		end)(({ p108 })[1])
		workspace.FallenPartsDestroyHeight = -50000
	end

	task.spawn(function()
		while task.wait() do
			if Config.AnnoyingStuff.Fling.LoopFlingAllPlayers then
				local v736, v737, v738 = ipairs(game.Players:GetPlayers())
				while true do
					local v739; v738, v739 = v736(v737, v738); local u740 = v739; if v738 == nil then break end
					if u740 ~= LocalPlayer12 then pcall(function() miniFling(u740) end) end
				end
			end
		end
	end)

	function ServerHop()
		local t31 = {}
		local v742 = request({ Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId) })
		local data = game:GetService("HttpService"):JSONDecode(v742.Body)
		if data and data.data then
			local _next = next; local data2 = data.data; local v746 = nil
			while true do
				local v747; v746, v747 = _next(data2, v746); if v746 == nil then break end
				if type(v747) == "table" and tonumber(v747.playing) and tonumber(v747.maxPlayers) and v747.playing < v747.maxPlayers and v747.id ~= game.JobId then
					table.insert(t31, 1, v747.id)
				end
			end
		end
		if #t31 > 0 then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, t31[math.random(1, #t31)], game:GetService("Players").LocalPlayer)
		end
	end

	game:GetService("Players").PlayerRemoving:Connect(function(_)
		if Config.AutoFarm.AutoTeleportToRandomServerIfServerIsEmpty and #game.Players:GetPlayers() < Config.AutoFarm.PlayersToAutoServerHop then
			ServerHop()
		end
	end)

	task.spawn(function()
		while task.wait(30) do
			if Config.AutoFarm.AutoPrestige then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("Prestige"):FireServer()
			end
		end
	end)

	local ScreenGui_farm = Instance.new("ScreenGui")
	ScreenGui_farm.Name = "CenteredLabelGui"; ScreenGui_farm.Parent = game:GetService("CoreGui")
	TextLabel_farm = Instance.new("TextLabel")
	TextLabel_farm.Name = "CenteredTextLabel"; TextLabel_farm.Visible = false; TextLabel_farm.Text = ""
	TextLabel_farm.Size = UDim2.new(0.5, 0, 0.1, 0); TextLabel_farm.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel_farm.AnchorPoint = Vector2.new(0.5, 0.5); TextLabel_farm.BackgroundTransparency = 1
	TextLabel_farm.TextColor3 = Color3.fromRGB(0,0,0); TextLabel_farm.Font = Enum.Font.SourceSansBold
	TextLabel_farm.TextSize = 48; TextLabel_farm.Parent = ScreenGui_farm
end

-- Coin collection tracking
startTime = tick(); totalCoinsCollected = 0

CoinCollected.OnClientEvent:Connect(function(_, p118, p119, _)
	totalCoinsCollected = totalCoinsCollected + 1; RNcoins = p118; MAXcoins = p119
	if p118 == p119 then
		if Config.AutoFarm.KillEveryoneAsAMurdererAtFullBag and u168() == LocalPlayer12 then KillEveryoneAsAMurderer() task.wait(1) end
		if Config.AutoFarm.AutoFlingMurdererAtFullBag and u168() ~= LocalPlayer12 then
			murd = u168(); if murd and murd ~= game.Players.LocalPlayer then miniFling(murd) task.wait(1) end
		end
		if not Config.AutoFarm.TeleportUnderMap then
			if Config.CoinFarm.Settings.DieAtFullBag then LocalPlayer12.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead) end
		else wait(0.1); TeleportUnderMap() end
	end
end)

task.wait(0.01); coinsPerHour = 0; MAXcoins = 40; RNcoins = 0

RunService5.RenderStepped:Connect(function()
	game:GetService("RunService"):Set3dRenderingEnabled(not Config.CoinFarm2.Disable3DRendering)
	elapsedTime = tick() - startTime
	if totalCoinsCollected <= 0 then coinsPerHour = 0
	else coinsPerHour = math.floor(totalCoinsCollected * 3600 / elapsedTime) end
	if TextLabel_farm then
		TextLabel_farm.Text = "Coins: " .. (RNcoins or 0) .. "/" .. (MAXcoins or 40) .. "\nTotal: " .. totalCoinsCollected .. "\nCPH: " .. coinsPerHour
	end
end)

task.spawn(function()
	while task.wait(15) do
		if Config.AutoOpenCrates.State then
			local t32 = { Config.AutoOpenCrates.Crate, Config.AutoOpenCrates.CrateType, "Coins" }
			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Shop"):WaitForChild("OpenCrate"):InvokeServer(unpack(t32))
		end
	end
end)

-- Visual Gun data
guns = {
	Gingerscope = {
		MeshId      = "rbxassetid://15374602183",
		Offset      = Vector3.zero,
		Scale       = Vector3.new(0.084, 0.084, 0.084),
		TextureId   = "rbxassetid://15409041564",
		VertexColor = Vector3.new(1, 1, 1),
		CFrame      = CFrame.new(0.129999995, 0, 0.075000003, 1, 0, 0, 0, 0.707388222, 0.706825197, 0, -0.706825197, 0.707388222),
		Grip        = CFrame.new(0, -0.400000006, 0.899999976, 1, 0, 0, 0, 1, 0, 0, 0, 1),
		Image       = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=15666596216",
		GuiColor    = Color3.new(0.39215686274509803, 0.0392156862745098, 1)
	}
}
chosengun = "Gingerscope"

function equipgun(p121)
	if __EQUIPPED == false then return end
	disconect(); ch = LocalPlayer12.Character
	repeat task.wait() until ch:FindFirstChild("HumanoidRootPart")
	local v756, v757, v758 = pairs(workspace.WeaponDisplays:GetChildren()); local v759 = nil; local v760 = nil
	while true do
		local v761; v758, v761 = v756(v757, v758); if v758 == nil then break end
		local RCA0 = v761.RigidConstraint.Attachment0
		if RCA0 == ch:FindFirstChild("GunBelt",   true) then v759 = v761 end
		if RCA0 == ch:FindFirstChild("KnifeBack", true) then v760 = v761 end
	end
	task.wait(0.1); if not v759 or not v760 then return end
	repeat task.wait() until v759:FindFirstChild("Attachment")
	v759.Attachment.CFrame = guns[p121].CFrame
	local v764, v765, v766 = pairs(guns[p121])
	while true do
		local v767; v766, v767 = v764(v765, v766); if v766 == nil then break end
		if v766 ~= "CFrame" and v766 ~= "Grip" and v766 ~= "Image" and v766 ~= "GuiColor" then v759.Mesh[v766] = v767 end
	end
	backpackImageConnection = LocalPlayer12.Backpack.DescendantAdded:Connect(function(_)
		if guns[p121] then
			local v942, v943, v944 = pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren())
			while true do
				local v945; v944, v945 = v942(v943, v944); if v944 == nil then break end
				if v945.Icon.Image ~= "" and u169() == LocalPlayer12 then v945.Icon.Image = guns[p121].Image end
			end
		end
	end)
	GunVisual = LocalPlayer12.Backpack.DescendantAdded:Connect(function(descendant)
		if tostring(descendant) == "Gun" then
			task.wait(); USABLEGUN = LocalPlayer12.Backpack.Gun.Handle
			local v947, v948, v949 = pairs(guns[p121])
			while true do
				local v950; v949, v950 = v947(v948, v949); if v949 == nil then break end
				if v949 ~= "CFrame" and v949 ~= "Grip" and v949 ~= "Image" and v949 ~= "GuiColor" then USABLEGUN.Mesh[v949] = v950 end
			end
			USABLEGUN.Parent.Grip = guns[p121].Grip
		end
	end)
end

function disconect()
	if backpackImageConnection then backpackImageConnection:Disconnect() backpackImageConnection = nil end
	if GunVisual   then GunVisual:Disconnect()   GunVisual   = nil end
	if autoEquipGun then autoEquipGun:Disconnect() autoEquipGun = nil end
end

function RevealRoles()
	local children = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
	local v769, v770, v771 = ipairs(children)
	while true do
		local v772; v771, v772 = v769(v770, v771); if v771 == nil then break end
		if v772.Name ~= "RBXSystem" then
			local v773 = u168(); local v774 = u169()
			local _N  = not v773 and "-" or v773.Name; local _N2 = not v774 and "-" or v774.Name
			v772:SendAsync(string.format("Murderer: %s |\r\nSheriff: %s |\r\nZelo UI", _N, _N2))
		end
	end
end

function spawnitem()
	local v777, v778, v779 = pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main.Weapons.Items.Container:GetChildren())
	while true do
		local v780; v779, v780 = v777(v778, v779); if v779 == nil then break end
		local v781, v782, v783 = pairs(v780:GetChildren())
		while true do
			local v784; v783, v784 = v781(v782, v783); if v783 == nil then break end
			v780.ChildAdded:Connect(function(child)
				if child.Name == "NewItem" then child.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
			end)
			local v785, v786, v787 = pairs(v784:GetChildren())
			while true do
				local v788; v787, v788 = v785(v786, v787); if v787 == nil then break end
				if v788.Name == "NewItem" then v788.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
			end
		end
	end
	local v789, v790, v791 = pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main.Weapons.Items.Container:GetChildren())
	while true do
		local v792; v791, v792 = v789(v790, v791); if v791 == nil then break end
		if v792.Name == "Holiday" then christmas = v792.Container.Christmas halloween = v792.Container.Halloween end
	end
	local v793, v794, v795 = pairs(christmas.Container:GetChildren())
	while true do
		local v796; v795, v796 = v793(v794, v795); if v795 == nil then break end
		if v796.Name == "NewItem" then v796.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
	end
	christmas.Container.ChildAdded:Connect(function(child)
		if child.Name == "NewItem" then child.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
	end)
	local v797, v798, v799 = pairs(halloween.Container:GetChildren())
	while true do
		local v800; v799, v800 = v797(v798, v799); if v799 == nil then break end
		if v800.Name == "NewItem" then v800.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
	end
	halloween.Container.ChildAdded:Connect(function(child)
		if child.Name == "NewItem" then child.Container.ActionButton.MouseButton1Click:Connect(function() disconect() __EQUIPPED = false end) end
	end)
	weapons = game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main.Weapons
	newitem  = game:GetService("ReplicatedStorage").Modules.InventoryModule.NewItem:Clone()
	newitem.Name   = "FakeItem"; newitem.Parent = weapons.Items.Container.Holiday.Container.Christmas.Container
	newitem.ItemName.Label.Text = chosengun; newitem.Tags.Evo.Visible = false
	newitem.Container.Icon.Image = guns[chosengun].Image; newitem.Container.Amount.Text = ""
	newitem.ItemName.BackgroundColor3 = guns[chosengun].GuiColor
	function click()
		__EQUIPPED = true; equipped = weapons.Equipped.Container.Gun.Container
		equipped.ItemName.BackgroundColor3 = guns[chosengun].GuiColor
		equipped.ItemName.Label.Text = chosengun; equipped.Container.Icon.Image = guns[chosengun].Image
		equipgun(chosengun)
		autoEquipGun = LocalPlayer12.CharacterAdded:Connect(function() equipgun(chosengun) end)
	end
	clickconnection = newitem.Container.ActionButton.MouseButton1Click:Connect(function() click() end)
	if __EQUIPPED == true then task.wait() click() end
end

LocalPlayer12.CharacterAdded:Connect(function()
	if Config.VisualGun then spawnitem() end
end)

boxmodule    = require(game:GetService("ReplicatedStorage").Modules.BoxModule)
itemdatabase = require(game:GetService("ReplicatedStorage").Database.Sync.Item)

task.spawn(function()
	repeat task.wait(0.5)
	until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainGUI") and game:GetService("Players").LocalPlayer.PlayerGui.MainGUI:FindFirstChild("Inventory") and game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Inventory:FindFirstChild("NewItem")
	local ok, result = pcall(function()
		return getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Inventory.NewItem)._G
	end)
	if not ok then warn("Failed to get poop _G:", result) else poop = result end
end)

function getrandombox()
	local MysteryBox = require(game:GetService("ReplicatedStorage").Database.Sync.MysteryBox)
	if MysteryBox and next(MysteryBox) ~= nil then
		local v804, v805, v806 = pairs(MysteryBox); local t33 = {}
		while true do local v808; v806, v808 = v804(v805, v806); if v806 == nil then break end table.insert(t33, v806) end
		return t33[math.random(1, #t33)]
	end
	return nil
end

getgenv().spawnamount = 1

function opencrate(p123, p124)
	if p124 then poop.NewItem(p123, nil, nil, "Weapons", getgenv().spawnamount)
	else boxmodule.OpenBox(getrandombox(), p123) poop.NewItem(p123, nil, nil, "Weapons", 1) end
end

function getrawnamebyrealname(p125)
	local v812, v813, v814 = pairs(itemdatabase)
	repeat local v815; v814, v815 = v812(v813, v814); if v814 == nil then return end until p125 == v814
	return v814
end

function gettable(p126)
	nikita_gay = {}
	local v817, v818, v819 = pairs(itemdatabase)
	while true do
		local v820; v819, v820 = v817(v818, v819); if v819 == nil then break end
		if string.find(v819:lower(), p126:lower()) then table.insert(nikita_gay, v819) end
	end
	return nikita_gay
end

-- Farming Tab UI
-- State helpers (used by the UI elements below)
local _farmActive = false

local function startAutoFarm()
	_farmActive = true
	Config.CoinFarm2.State = true
	-- Re-initialise the coin-farm loop by resetting the AutoCoinPart flag
	if workspace:FindFirstChild("AutoCoinPart") then
		workspace.AutoCoinPart:Destroy()
	end
	spawn(init)
end

local function stopAutoFarm()
	_farmActive = false
	Config.CoinFarm2.State = false
	if CoinFarm2Connection then pcall(function() CoinFarm2Connection:Disconnect() end) end
	if FullBagConnection   then pcall(function() FullBagConnection:Disconnect()   end) end
	if DeathConnection     then pcall(function() DeathConnection:Disconnect()     end) end
	if workspace:FindFirstChild("AutoCoinPart") then
		workspace.AutoCoinPart:Destroy()
	end
end

FarmTab:Callout({
	Title = "Auto Coin Farm",
	Desc  = "Farm coins automatically each round.\n[Risk: May trigger anti-cheat detection]",
	Variant = "Warning",
})

FarmTab:Toggle({
	Title = "Enable Auto Farm",
	Desc  = "Start farming coins automatically",
	Value = Config.CoinFarm2.State,
	Callback = function(p127)
		if p127 then startAutoFarm() else stopAutoFarm() end
	end,
})

FarmTab:Slider({
	Title = "Farm Speed",
	Value = { Min = 15, Max = 25, Default = Config.CoinFarm2.Settings.Speed, Increment = 1 },
	Callback = function(p128)
		Config.CoinFarm2.Settings.Speed = p128
		print("Speed updated to: " .. p128)
		-- Restart farm so new speed takes effect immediately
		if _farmActive then stopAutoFarm(); startAutoFarm() end
	end,
})

FarmTab:Dropdown({
	Title = "Full Bag Actions",
	Desc  = "What to do when bag is full",
	Values = { "Reset", "Teleport Under Map", "Kill Everyone (Murderer)", "Fling Murderer" },
	Value  = {}, Multi = true, AllowNone = true,
	Callback = function(p129)
		Config.CoinFarm.Settings.DieAtFullBag            = false
		Config.AutoFarm.TeleportUnderMap                 = false
		Config.AutoFarm.KillEveryoneAsAMurdererAtFullBag = false
		Config.AutoFarm.AutoFlingMurdererAtFullBag       = false
		for _, v in ipairs(p129) do
			if v == "Reset"                   then Config.CoinFarm.Settings.DieAtFullBag            = true end
			if v == "Teleport Under Map"       then Config.AutoFarm.TeleportUnderMap                 = true end
			if v == "Kill Everyone (Murderer)" then Config.AutoFarm.KillEveryoneAsAMurdererAtFullBag = true end
			if v == "Fling Murderer"           then Config.AutoFarm.AutoFlingMurdererAtFullBag       = true end
		end
		print("Full Bag Actions selected: " .. game:GetService("HttpService"):JSONEncode(p129))
	end,
})

-- Spawners Tab UI
SpawnersTab:Callout({
	Title = "Item Spawner and Unboxer",
	Desc  = "Spawn or unbox weapons.\nEnter exact item name (case sensitive).",
	Variant = "Info",
})

SpawnersTab:Button({
	Title = "Spawn Equippable Gingerscope", Icon = "package",
	Callback = function(p130) Config.VisualGun = p130 if p130 then spawnitem() end end,
})

local s7 = ""
local u175_fn = function()
	local ok, result = pcall(function() return require(game:GetService("ReplicatedStorage").Database.Sync.MysteryBox) end)
	if not ok or not result or next(result) == nil then return "StandardBox" end
	local t34 = {}; for k, _ in pairs(result) do table.insert(t34, k) end
	return t34[math.random(1, #t34)]
end
local u176_fn = function(p131)
	local _BM = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and game:GetService("ReplicatedStorage").Modules:FindFirstChild("BoxModule")
	local _DB = game:GetService("ReplicatedStorage"):FindFirstChild("Database") and (game:GetService("ReplicatedStorage").Database:FindFirstChild("Sync") and game:GetService("ReplicatedStorage").Database.Sync:FindFirstChild("Item"))
	if not _BM or not _DB then return end
	local lib = require(_BM); local lib2 = require(_DB)
	if p131 and lib2[p131] then
		local ok, result = pcall(function()
			lib.OpenBox(u175_fn(), p131)
			pcall(function()
				local v969 = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Inventory.NewItem)
				if v969 and (v969._G and v969._G.NewItem) then v969._G.NewItem(p131, nil, nil, "Weapons", 1) end
			end)
		end)
		if not ok then warn("SpawnWeapon error:", result) end
	else
		WindUI:Notify({ Title = "Error", Content = "Check spelling: " .. (p131 or "Unknown"), Icon = "alert-circle", Duration = 3, Style = "Error" })
	end
end

SpawnersTab:Input({ Title = "Item Unboxer", Desc = "Example: 'Harvester' (uppercase first)", Placeholder = "Harvester", Callback = function(p132) s7 = p132 end })
SpawnersTab:Button({
	Title = "Unbox Item", Icon = "package-open",
	Callback = function()
		if not s7 or s7 == "" then WindUI:Notify({ Title = "Error", Content = "Enter a weapon name", Icon = "alert-circle", Duration = 3, Style = "Error" })
		else u176_fn(s7) end
	end,
})
SpawnersTab:Button({ Title = "Unbox Gingerscope", Callback = function() u176_fn("Gingerscope") end })
SpawnersTab:Button({ Title = "Unbox Harvester",   Callback = function() u176_fn("Harvester")   end })
SpawnersTab:Button({ Title = "Unbox Sweet",        Callback = function() u176_fn("Sweet")       end })
SpawnersTab:Button({ Title = "Unbox Treat",        Callback = function() u176_fn("Treat")       end })

local u178 = nil; local n18 = 1

local function u177(p133, p134)
	local Item    = require(game:GetService("ReplicatedStorage").Database.Sync.Item)
	local Weapons = require(game:GetService("ReplicatedStorage").Modules.ProfileData).Weapons
	local v845 = string.lower(p133); local v846 = nil
	for k in pairs(Item) do if v845 == string.lower(k) then v846 = k break end end
	if v846 then
		if not Weapons.Owned then Weapons.Owned = {} end
		Weapons.Owned[v846] = (Weapons.Owned[v846] or 0) + p134
		t14.RunService:BindToRenderStep("InventoryUpdate", Enum.RenderPriority.Last.Value + 1, function() end)
		LocalPlayer12.Character:BreakJoints()
		return
	end
	WindUI:Notify({ Title = p133 .. " misspelled?", Content = "'" .. p133 .. "' is not a real item", Duration = 2, Style = "Warning" })
end

SpawnersTab:Input({ Title = "Weapon Name", Placeholder = "Harvester", Compact = true, Callback = function(p135) if p135 and p135 ~= "" then u178 = p135 end end })
SpawnersTab:Input({ Title = "Amount",      Placeholder = "5",         Compact = true,
	Callback = function(p136) local num = tonumber(p136); if not num or not (num > 0) then n18 = 1 else n18 = math.floor(num) end end
})
SpawnersTab:Button({
	Title = "Spawn Weapon", Icon = "sword",
	Callback = function()
		if not u178 or u178 == "" then WindUI:Notify({ Title = "Empty", Content = "Enter a weapon name first", Duration = 2, Style = "Warning" })
		else u177(u178, n18) end
	end,
})

-- Config Tab UI
ConfigTab:Callout({
	Title = "Save / Load Configs",
	Desc  = "Name a config, then save or load it.\nAuto-load keeps your settings on startup.",
	Variant = "Info",
})

do
	local s6 = "default"

	local u146 = ConfigTab:Input({ Title = "Config Name", Icon = "file-cog", Placeholder = "default", Callback = function(p81) s6 = p81 end })

	-- Collect existing saved configs from the folder
	local function getExistingConfigs()
		local list = {}
		local ok, files = pcall(function()
			return game:GetService("HttpService") -- placeholder; actual listing done below
		end)
		-- WindUI saves configs via writefile; list them with listfiles if available
		pcall(function()
			local folder = "ZieloHub/Configs"
			if isfolder and isfolder(folder) then
				for _, f in ipairs(listfiles(folder)) do
					local name = f:match("([^/\\]+)%.json$") or f:match("([^/\\]+)$")
					if name then table.insert(list, name) end
				end
			end
		end)
		return list
	end

	local v148 = getExistingConfigs()
	local u150 = ConfigTab:Dropdown({
		Title = "All Configs", Desc = "Select an existing saved config", Values = v148, Value = #v148 > 0 and v148[1] or nil,
		Callback = function(p83)
			s6 = p83
			if u146.Set then u146:Set(p83) end
		end,
	})

	ConfigTab:Button({
		Title = "Save Config", Icon = "save",
		Callback = function()
			if not s6 or s6 == "" then
				WindUI:Notify({ Title = "No Name", Content = "Enter a config name first.", Icon = "alert-circle", Duration = 3, Style = "Warning" })
				return
			end
			local ok, err = pcall(function()
				local folder = "ZieloHub/Configs"
				if not isfolder(folder) then makefolder(folder) end
				local data = game:GetService("HttpService"):JSONEncode(Config)
				writefile(folder .. "/" .. s6 .. ".json", data)
			end)
			if ok then
				WindUI:Notify({ Title = "Config Saved", Content = "Config '" .. s6 .. "' saved!", Icon = "check", Style = "Success" })
				-- Refresh dropdown with updated list
				local newList = getExistingConfigs()
				if u150.Refresh then u150:Refresh(newList) end
			else
				WindUI:Notify({ Title = "Save Failed", Content = tostring(err), Icon = "alert-circle", Duration = 4, Style = "Error" })
			end
		end,
	})

	ConfigTab:Button({
		Title = "Load Config", Icon = "download",
		Callback = function()
			if not s6 or s6 == "" then
				WindUI:Notify({ Title = "No Name", Content = "Enter or select a config name first.", Icon = "alert-circle", Duration = 3, Style = "Warning" })
				return
			end
			local ok, err = pcall(function()
				local path = "ZieloHub/Configs/" .. s6 .. ".json"
				if isfile(path) then
					local data = game:GetService("HttpService"):JSONDecode(readfile(path))
					-- Merge loaded values into live Config table
					for k, v in pairs(data) do
						if type(v) == "table" and type(Config[k]) == "table" then
							for k2, v2 in pairs(v) do Config[k][k2] = v2 end
						else
							Config[k] = v
						end
					end
				else
					error("File not found: " .. path)
				end
			end)
			if ok then
				WindUI:Notify({ Title = "Config Loaded", Content = "Config '" .. s6 .. "' loaded!", Icon = "refresh-cw", Style = "Notice" })
			else
				WindUI:Notify({ Title = "Load Failed", Content = tostring(err), Icon = "alert-circle", Duration = 4, Style = "Error" })
			end
		end,
	})

	ConfigTab:Button({
		Title = "List Saved Configs", Icon = "printer",
		Callback = function()
			local list = getExistingConfigs()
			if #list == 0 then
				print("[ZeloHub] No saved configs found.")
			else
				print("[ZeloHub] Saved configs: " .. table.concat(list, ", "))
			end
			WindUI:Notify({ Title = "Configs", Content = #list .. " config(s) found – check output.", Icon = "file-cog", Duration = 3, Style = "Notice" })
		end,
	})
end

-- Execution counter (original logic preserved)
local s8 = "https://ecution-countere.wyaburdo.workers.dev/"
local ok_ec, result_ec = pcall(function()
	if not syn or not syn.request then
		if http_request then http_request({ Url = s8, Method = "GET" }) return end
		if not request   then t14.HttpService:GetAsync(s8)              return end
		request({ Url = s8, Method = "GET" })
		return
	end
	syn.request({ Url = s8, Method = "GET" })
end)
if not ok_ec then warn("Failed", result_ec) end
