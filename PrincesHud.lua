-- ============ SISTEMA DE KEY (PRINCES HUB) ============
local correctKey = "humildeONhud"
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "PrincesHubKeySystem"
keyGui.ResetOnSpawn = false

-- Compatibilidad con ejecutores móviles como Delta
local success = pcall(function() keyGui.Parent = CoreGui end)
if not success then 
    keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 160)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = keyGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Princes Hub - Verificación"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = mainFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 35)
keyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Ingresa la Key aquí..."
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 16
keyInput.ClearTextOnFocus = false
keyInput.Parent = mainFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.5, 0, 0, 35)
submitBtn.Position = UDim2.new(0.25, 0, 0.65, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
submitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
submitBtn.Text = "Entrar"
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 18
submitBtn.Parent = mainFrame

local keyPassed = false

submitBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then
        submitBtn.Text = "¡Correcto!"
        submitBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        task.wait(0.5)
        keyPassed = true
        keyGui:Destroy()
    else
        submitBtn.Text = "Key Incorrecta"
        submitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        submitBtn.Text = "Entrar"
        submitBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end
end)

-- Pausa el hilo actual hasta que la contraseña sea correcta
repeat task.wait(0.2) until keyPassed

-- ============ SCRIPT PRINCIPAL (PRINCES HUB) ============
-- Librería interna basada en Elerium V2 + Funciones del Script
local Library = {}

function Library:Load()
	local _UIS_MOBILE = game:GetService("UserInputService")
	local _isMobileUI = _UIS_MOBILE.TouchEnabled and not _UIS_MOBILE.KeyboardEnabled
	local RS = game:GetService("RunService")
	local UIS = game:GetService("UserInputService")
	local mouse = LocalPlayer:GetMouse()

	local gui = Instance.new("ScreenGui")
	gui.Name = "PrincesHubGUI"
	gui.ResetOnSpawn = false
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
		gui.Parent = game:GetService("CoreGui")
	else
		pcall(function() gui.Parent = game:GetService("CoreGui") end)
		if not gui.Parent then
			gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end
	end

	local prefabs = Instance.new("Folder")
	prefabs.Name = "Prefabs"
	prefabs.Parent = gui

	local main_win = Instance.new("Frame")
	main_win.Name = "Window"
	main_win.Size = _isMobileUI and UDim2.new(0, 360, 0, 560) or UDim2.new(0, 500, 0, 620)
	main_win.Position = UDim2.new(0.5, -180, 0.5, -280)
	main_win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	main_win.BorderSizePixel = 0
	main_win.Active = true
	main_win.Draggable = true
	main_win.Parent = gui

	local top_bar = Instance.new("Frame")
	top_bar.Name = "TopBar"
	top_bar.Size = UDim2.new(1, 0, 0, 30)
	top_bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	top_bar.BorderSizePixel = 0
	top_bar.Parent = main_win

	local title_label = Instance.new("TextLabel")
	title_label.Name = "Title"
	title_label.Size = UDim2.new(1, -10, 1, 0)
	title_label.Position = UDim2.new(0, 10, 0, 0)
	title_label.BackgroundTransparency = 1
	title_label.TextColor3 = Color3.fromRGB(255, 215, 0) 
	title_label.TextSize = 16
	title_label.Font = Enum.Font.SourceSansBold
	title_label.TextXAlignment = Enum.TextXAlignment.Left
	title_label.Text = "Princes Hub"
	title_label.Parent = top_bar

	local tab_selection = Instance.new("Frame")
	tab_selection.Name = "TabSelection"
	tab_selection.Size = UDim2.new(1, 0, 0, 30)
	tab_selection.Position = UDim2.new(0, 0, 0, 30)
	tab_selection.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tab_selection.BorderSizePixel = 0
	tab_selection.Parent = main_win

	local tab_buttons = Instance.new("ScrollingFrame")
	tab_buttons.Name = "TabButtons"
	tab_buttons.Size = UDim2.new(1, 0, 1, 0)
	tab_buttons.CanvasSize = UDim2.new(2, 0, 0, 0)
	tab_buttons.BackgroundTransparency = 1
	tab_buttons.ScrollBarThickness = 0
	tab_buttons.Parent = tab_selection

	local ui_list = Instance.new("UIListLayout")
	ui_list.FillDirection = Enum.FillDirection.Horizontal
	ui_list.SortOrder = Enum.SortOrder.LayoutOrder
	ui_list.Parent = tab_buttons

	local tabs_holder = Instance.new("Folder")
	tabs_holder.Name = "Tabs"
	tabs_holder.Parent = main_win

	local function createPrefab(name, class)
		local p = Instance.new(class)
		p.Name = name
		p.Visible = false
		p.Parent = prefabs
		return p
	end

	local pf_btn = createPrefab("TabButton", "TextButton")
	pf_btn.Size = UDim2.new(0, 100, 1, 0)
	pf_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	pf_btn.TextSize = 14
	pf_btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	local img_btn = Instance.new("ImageLabel")
	img_btn.Size = UDim2.new(1, 0, 1, 0)
	img_btn.BackgroundTransparency = 1
	img_btn.ImageColor3 = Color3.fromRGB(52, 53, 56)
	img_btn.Parent = pf_btn

	local pf_tab = createPrefab("Tab", "ScrollingFrame")
	pf_tab.Size = UDim2.new(1, 0, 1, -60)
	pf_tab.Position = UDim2.new(0, 0, 0, 60)
	pf_tab.BackgroundTransparency = 1
	pf_tab.ScrollBarThickness = 4
	local t_layout = Instance.new("UIListLayout")
	t_layout.SortOrder = Enum.SortOrder.LayoutOrder
	t_layout.Parent = pf_tab

	createPrefab("Label", "TextLabel")
	createPrefab("Button", "TextButton")
	createPrefab("Switch", "TextButton")
	createPrefab("TextBox", "TextBox")
	createPrefab("Slider", "Frame")
	createPrefab("Keybind", "Frame")
	createPrefab("Dropdown", "TextButton")
	createPrefab("ColorPicker", "Frame")
	createPrefab("Console", "Frame")
	createPrefab("HorizontalAlignment", "Frame")
	createPrefab("Folder", "Frame")

	local window_data = {}
	local dropdown_open = false

	local function gNameLen(obj)
		return #obj.Text * 8 + 20
	end

	local function Resize(obj, goals, t)
		local info = TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		game:GetService("TweenService"):Create(obj, info, goals):Play()
	end

	function window_data:AddTab(tab_name)
		local tab_data = {}
		tab_name = tostring(tab_name or "New Tab")
		tab_selection.Visible = true

		local new_button = pf_btn:Clone()
		new_button.Visible = true
		new_button.Parent = tab_buttons
		new_button.Text = tab_name
		new_button.Size = UDim2.new(0, gNameLen(new_button), 1, 0)

		local new_tab = pf_tab:Clone()
		new_tab.Visible = false
		new_tab.Parent = tabs_holder

		local function show()
			if dropdown_open then return end
			for _, v in pairs(tab_buttons:GetChildren()) do
				if v:IsA("TextButton") then
					v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end
			end
			for _, v in pairs(tabs_holder:GetChildren()) do
				v.Visible = false
			end
			new_button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			new_tab.Visible = true
		end

		new_button.MouseButton1Click:Connect(function() show() end)

		if #tabs_holder:GetChildren() == 1 then show() end

		function tab_data:AddLabel(text)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 25)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
			lbl.TextSize = 14
			lbl.Font = Enum.Font.SourceSans
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Text = "  " .. tostring(text)
			lbl.Parent = new_tab
			return { Set = function(_, t) lbl.Text = "  " .. tostring(t) end }
		end

		function tab_data:AddButton(text, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 14
			btn.Font = Enum.Font.SourceSansBold
			btn.Text = tostring(text)
			btn.Parent = new_tab
			btn.MouseButton1Click:Connect(function() pcall(callback) end)
			return btn
		end

		function tab_data:AddToggle(opt)
			local toggled = opt.CurrentValue or false
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 14
			btn.Font = Enum.Font.SourceSans
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Text = "  " .. tostring(opt.Name) .. ": " .. (toggled and "[ON]" or "[OFF]")
			btn.Parent = new_tab

			btn.MouseButton1Click:Connect(function()
				toggled = not toggled
				btn.Text = "  " .. tostring(opt.Name) .. ": " .. (toggled and "[ON]" or "[OFF]")
				pcall(opt.Callback, toggled)
			end)

			return {
				Set = function(_, val)
					toggled = val
					btn.Text = "  " .. tostring(opt.Name) .. ": " .. (toggled and "[ON]" or "[OFF]")
					pcall(opt.Callback, toggled)
				end,
				Get = function() return toggled end
			}
		end

		function tab_data:AddSlider(opt)
			local range = opt.Range or {1, 100}
			local def = opt.CurrentValue or range[1]
			local current = def

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 0, 40)
			frame.BackgroundTransparency = 1
			frame.Parent = new_tab

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.TextSize = 14
			lbl.Font = Enum.Font.SourceSans
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Text = "  " .. tostring(opt.Name) .. ": " .. tostring(def)
			lbl.Parent = frame

			local bar = Instance.new("TextButton")
			bar.Size = UDim2.new(1, -10, 0, 10)
			bar.Position = UDim2.new(0, 5, 0, 25)
			bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			bar.Text = ""
			bar.Parent = frame

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((def - range[1]) / (range[2] - range[1]), 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
			fill.BorderSizePixel = 0
			fill.Parent = bar

			local function update(input)
				local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				current = math.floor(range[1] + ((range[2] - range[1]) * pos))
				fill.Size = UDim2.new(pos, 0, 1, 0)
				lbl.Text = "  " .. tostring(opt.Name) .. ": " .. tostring(current)
				pcall(opt.Callback, current)
			end

			local dragging = false
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					update(input)
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					update(input)
				end
			end)

			return {
				Set = function(_, val)
					current = math.clamp(val, range[1], range[2])
					local pos = (current - range[1]) / (range[2] - range[1])
					fill.Size = UDim2.new(pos, 0, 1, 0)
					lbl.Text = "  " .. tostring(opt.Name) .. ": " .. tostring(current)
					pcall(opt.Callback, current)
				end
			}
		end

		function tab_data:AddDivider(text)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 25)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
			lbl.TextSize = 13
			lbl.Font = Enum.Font.SourceSansBold
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Text = "  --- " .. tostring(text or "") .. " ---"
			lbl.Parent = new_tab
			return lbl
		end

		return tab_data
	end

	function window_data:Notify(opt)
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = tostring(opt.Title or "Princes Hub"),
				Text = tostring(opt.Content or ""),
				Duration = tonumber(opt.Duration) or 3,
			})
		end)
	end

	return window_data
end

local Window = Library:Load()

local MainTab = Window:AddTab("Main")
local FarmTab = Window:AddTab("Farm")
local TravelTab = Window:AddTab("Islands")
local ShopTab = Window:AddTab("Shop")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local muscleEvent = LocalPlayer:WaitForChild("muscleEvent")
local currentMap = LocalPlayer:WaitForChild("currentMap")
local rebirthRemote = ReplicatedStorage.rEvents:WaitForChild("rebirthRemote")

local function getSeat(h)
	if not h then return nil end
	return h.SeatPart
end

-- ============ FAST PUNCH ============
local fastPunch = false
local fastPunchGen = 0
local bossFightActive = false

local function getPunchTool()
	local c = LocalPlayer.Character
	if c then
		local t = c:FindFirstChild("Punch")
		if t then return t end
	end
	local bp = LocalPlayer:FindFirstChild("Backpack")
	if bp then
		for _, t in pairs(bp:GetChildren()) do
			if t:IsA("Tool") and t.Name:lower():find("punch") then return t end
		end
	end
	return nil
end

local function setFastPunch(on)
	fastPunchGen += 1
	local gen = fastPunchGen
	fastPunch = on
	if not fastPunch then return end
	task.spawn(function()
		while fastPunch and fastPunchGen == gen do
			local t = getPunchTool()
			if t then
				local at = t:FindFirstChild("attackTime")
				if at and at.Value ~= 0 then at.Value = 0 end
				if t.Parent ~= LocalPlayer.Character then
					local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					if h then pcall(function() h:EquipTool(t) end) end
				end
			end
			task.wait(0.05)
		end
	end)
	task.spawn(function()
		while fastPunch and fastPunchGen == gen do
			if not bossFightActive then
				local me = LocalPlayer:FindFirstChild("muscleEvent")
				if me and me:IsA("RemoteEvent") then
					pcall(function() me:FireServer("punch", "rightHand") end)
					pcall(function() me:FireServer("punch", "leftHand") end)
				end
			end
			task.wait(0.05)
		end
	end)
end

MainTab:AddToggle({
	Name = "Fast Punch",
	CurrentValue = false,
	Callback = function(v)
		setFastPunch(v)
		Window:Notify({Title="Princes Hub", Content=v and "Fast Punch ON" or "Fast Punch OFF", Duration=2})
	end
})

local currentMapLabel = MainTab:AddLabel("Current: " .. tostring(currentMap.Value))
currentMap.Changed:Connect(function() currentMapLabel:Set("Current: " .. tostring(currentMap.Value)) end)

-- ============ SUPER FAST REP ============
local superRepOn = false
local superRepBatch = 5

FarmTab:AddSlider({
	Name = "Velocidad de Repeticiones",
	Range = {1, 10},
	Increment = 1,
	CurrentValue = superRepBatch,
	Callback = function(v)
		superRepBatch = math.clamp(math.floor(tonumber(v) or 5), 1, 10)
	end
})

FarmTab:AddToggle({
	Name = "Super Fast Rep",
	CurrentValue = false,
	Callback = function(v)
		superRepOn = v
		if v then
			task.spawn(function()
				while superRepOn do
					local c = LocalPlayer.Character
					local h = c and c:FindFirstChildOfClass("Humanoid")
					if h and h.Health > 0 then
						local seat = getSeat(h)
						for i = 1, superRepBatch do
							if seat then
								pcall(function() muscleEvent:FireServer("rep", seat) end)
							else
								pcall(function() muscleEvent:FireServer("rep") end)
							end
						end
						task.wait(0.02)
					else
						task.wait(0.2)
					end
				end
			end)
		end
		Window:Notify({Title="Princes Hub", Content=v and "Super Fast Rep ON" or "Super Fast Rep OFF", Duration=2})
	end
})

-- ============ AUTO RENA ============
FarmTab:AddDivider("Sistemas Automáticos")
local autoRenaOn = false
FarmTab:AddToggle({
	Name = "Auto Rebirth (Rena)",
	CurrentValue = false,
	Callback = function(v)
		autoRenaOn = v
		if v then
			task.spawn(function()
				while autoRenaOn do
					pcall(function()
						rebirthRemote:InvokeServer("rebirthRequest")
					end)
					task.wait(3)
				end
			end)
		end
		Window:Notify({Title="Princes Hub", Content=v and "Auto Rena ON" or "Auto Rena OFF", Duration=2})
	end
})

Window:Notify({Title = "Princes Hub", Content = "¡Cargado con éxito!", Duration = 3})
