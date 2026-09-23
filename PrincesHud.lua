-- ============ SISTEMA DE KEY (PRINCES HUD) ============
local correctKey = "humildeONhud"
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "PrincesHudKeySystem"
keyGui.ResetOnSpawn = false
pcall(function() keyGui.Parent = CoreGui end)
if not keyGui.Parent then keyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

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
title.Text = "Princes Hud - Verificación"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 35)
keyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Ingresa la Key..."
keyInput.Text = ""
keyInput.Font = Enum.Font.SourceSans
keyInput.TextSize = 16
keyInput.Parent = mainFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.5, 0, 0, 35)
submitBtn.Position = UDim2.new(0.25, 0, 0.68, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
submitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
submitBtn.Text = "Entrar"
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 16
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
		submitBtn.Text = "Incorrecta"
		submitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		task.wait(1)
		submitBtn.Text = "Entrar"
		submitBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
	end
end)

repeat task.wait(0.2) until keyPassed

-- ============ UI: Elerium v2 (estilo Silence, adaptador Rayfield) ============
local GUI_LIB_URL = "https://raw.githubusercontent.com/momoneta/momoneta-hub/refs/heads/main/mome.lua"
local library = loadstring(game:HttpGet(GUI_LIB_URL, true))()
local _UIS_MOBILE = game:GetService("UserInputService")
local _isMobileUI = _UIS_MOBILE.TouchEnabled and not _UIS_MOBILE.KeyboardEnabled

local _eleriumWindow = library:AddWindow("Princes Hud", {
	main_color = Color3.fromRGB(255, 215, 0),
	bg_color = Color3.fromRGB(15, 15, 15),
	min_size = _isMobileUI and Vector2.new(360, 560) or Vector2.new(500, 620),
	can_resize = not _isMobileUI,
})
local Rayfield = {}
function Rayfield:CreateWindow(_config)
	local Window = {}
	function Window:CreateTab(opt)
		local name = type(opt) == "table" and (opt.name or opt.Name or "Tab") or tostring(opt)
		local tab = _eleriumWindow:AddTab(name)
		local T = {}
		function T:CreateToggle(opt2)
			local state = false
			local busy = false
			local sw = tab:AddSwitch(opt2.Name, function(v)
				if busy then return end
				state = v and true or false
				pcall(opt2.Callback, state)
			end)
			if opt2.CurrentValue == true then
				sw:Set(true)
			end
			return {
				Set = function(_, v)
					v = (v == true)
					if state == v then return end
					busy = true
					sw:Set(v)
					busy = false
					state = v
					pcall(opt2.Callback, v)
				end,
				Get = function() return state end,
			}
		end
		function T:CreateDropdown(opt2)
			local dd = tab:AddDropdown(opt2.Name, function(sel)
				pcall(opt2.Callback, sel)
			end)
			if type(opt2.Options) == "table" then
				for _, op in ipairs(opt2.Options) do
					pcall(function() dd:Add(op) end)
				end
			end
			return dd
		end
		function T:CreateSlider(opt2)
			local range = opt2.Range or { 1, 100 }
			local inc = tonumber(opt2.Increment) or 1
			local defVal = tonumber(opt2.CurrentValue or opt2.Default or range[1]) or range[1]

			local sl, sliderGui = tab:AddSlider(opt2.Name, function(v)
				v = tonumber(v) or defVal
				if inc >= 1 then v = math.floor(v + 0.5) end
				v = math.clamp(v, range[1], range[2])
				pcall(opt2.Callback, v)
			end, { min = range[1], max = range[2], default = defVal })

			if _isMobileUI and sliderGui then
				pcall(function()
					sliderGui.Active = true
					local dragging = nil
					local function updateTouch(x)
						local left = sliderGui.AbsolutePosition.X
						local width = math.max(sliderGui.AbsoluteSize.X, 1)
						local percent = math.clamp(((x - left) / width) * 100, 0, 100)
						pcall(function()
							sl:Set(percent)
						end)
					end

					sliderGui.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							dragging = input
							updateTouch(input.Position.X)
						end
					end)

					sliderGui.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then
							updateTouch(input.Position.X)
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if dragging and input == dragging then
							updateTouch(input.Position.X)
						end
					end)

					UserInputService.InputEnded:Connect(function(input)
						if dragging and input == dragging then
							dragging = nil
						end
					end)
				end)
			end

			pcall(opt2.Callback, math.clamp(defVal, range[1], range[2]))
			return sl
		end
		function T:CreateButton(opt2)
			return tab:AddButton(opt2.Name, function()
				pcall(opt2.Callback)
			end)
		end
		function T:CreateText(opt2)
			local label = tab:AddLabel(opt2.Name or "")
			if opt2.Description then
				label.Text = tostring(opt2.Name or "") .. "\n" .. tostring(opt2.Description)
			end
			pcall(function()
				label.TextTruncate = Enum.TextTruncate.None
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Size = UDim2.new(1, -10, 0, 130) -- Altura expandida para que todo vaya hacia abajo sin taparse
			end)
			return {
				Set = function(_, t)
					label.Text = tostring(t)
					pcall(function()
						label.Size = UDim2.new(1, -10, 0, 130)
					end)
				end,
			}
		end
		function T:CreateDivider(opt2)
			if type(opt2) == "table" then
				tab:AddLabel(tostring(opt2.text or opt2.Text or ""))
			else
				tab:AddLabel(tostring(opt2 or ""))
			end
		end
		return T
	end
	function Window:Notify(opt2)
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = tostring(opt2.Title or "Hub"),
				Text = tostring(opt2.Content or opt2.Text or ""),
				Duration = tonumber(opt2.Duration) or 3,
			})
		end)
	end
	return Window
end

local Window = Rayfield:CreateWindow({
	Name = "Princes Hud",
	LoadingTitle = "Princes Hud",
	LoadingSubtitle = "by Yail",
	ConfigurationSaving = { Enabled = true, FolderName = "PrincesHud", FileName = "Config" },
	KeySystem = false
})

local MainTab = Window:CreateTab({ name = "Main" })
local FarmTab = Window:CreateTab({ name = "Farm" })
local TravelTab = Window:CreateTab({ name = "Islands" })
local ShopTab = Window:CreateTab({ name = "Shop" })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local muscleEvent = LocalPlayer:WaitForChild("muscleEvent")
local equipPetEvent = ReplicatedStorage.rEvents:WaitForChild("equipPetEvent")
local exclusiveEggOpenRemote = ReplicatedStorage.rEvents:WaitForChild("exclusiveEggOpenRemote")
local enemyNPCs = Workspace:WaitForChild("enemyNPCs")
local currentMap = LocalPlayer:WaitForChild("currentMap")
local rebirthRemote = ReplicatedStorage.rEvents:WaitForChild("rebirthRemote")
local machineInteractRemote = ReplicatedStorage.rEvents:WaitForChild("machineInteractRemote")
local changeSpeedSizeRemote = ReplicatedStorage.rEvents:WaitForChild("changeSpeedSizeRemote")

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

local punchVisual = { character = nil, tracks = {} }
local function clearPunchVisual()
	for _, tr in pairs(punchVisual.tracks) do
		pcall(function() tr:Stop(0.05) tr:Destroy() end)
	end
	punchVisual.character = nil
	punchVisual.tracks = {}
end
local function playPunchVisual()
	local c = LocalPlayer.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	local animator = h and (h:FindFirstChildOfClass("Animator") or h:FindFirstChild("Animator"))
	if not c or not animator then return end
	if punchVisual.character ~= c or #punchVisual.tracks == 0 then
		clearPunchVisual()
		punchVisual.character = c
		local shared = ReplicatedStorage:FindFirstChild("shared")
		local assets = shared and shared:FindFirstChild("assets")
		local anims = assets and assets:FindFirstChild("animations")
		local gameAnims = anims and anims:FindFirstChild("gameAnims")
		local tools = gameAnims and gameAnims:FindFirstChild("Tools")
		local punch = tools and tools:FindFirstChild("Punch")
		local attacks = punch and punch:FindFirstChild("attacks")
		if attacks then
			for _, a in pairs(attacks:GetChildren()) do
				if a:IsA("Animation") then
					local ok, track = pcall(animator.LoadAnimation, animator, a)
					if ok and track then
						track.Priority = Enum.AnimationPriority.Action
						table.insert(punchVisual.tracks, track)
					end
				end
			end
		end
	end
	if #punchVisual.tracks == 0 then return end
	for _, tr in pairs(punchVisual.tracks) do
		if tr.IsPlaying then pcall(function() tr:Stop(0.02) end) end
	end
	pcall(function() punchVisual.tracks[1]:Play(0.02, 1, 1.8) end)
end

-- Rocks (Fast Glitch)
local Rocks = {
	{label="Industrial Rock", durability=25000000},
	{label="Ancient Rock", durability=10000000},
	{label="Muscle King Rock", durability=5000000},
	{label="Legend Rock", durability=1000000},
	{label="Eternal Rock", durability=750000},
	{label="Mythical Rock", durability=400000},
	{label="Frost Rock", durability=150000},
	{label="Beach Rock", durability=5000},
	{label="Starter Rock", durability=100},
	{label="Tiny Rock", durability=0},
}
local selectedRock = nil
local function findRock(durability)
	local mf = Workspace:FindFirstChild("machinesFolder")
	if not mf then return nil end
	for _, d in ipairs(mf:GetDescendants()) do
		if d.Name == "neededDurability" and d:IsA("ValueBase") and tonumber(d.Value) == durability then
			local rock = d.Parent and d.Parent:FindFirstChild("Rock")
			if rock and rock:IsA("BasePart") then return rock end
		end
	end
	return nil
end

local function setFastPunch(on)
	fastPunchGen += 1
	local gen = fastPunchGen
	fastPunch = on
	if not fastPunch then
		clearPunchVisual()
		local c = LocalPlayer.Character
		local t = c and c:FindFirstChild("Punch")
		local at = t and t:FindFirstChild("attackTime")
		if at then at.Value = 0.3 end
		if t and LocalPlayer:FindFirstChild("Backpack") then t.Parent = LocalPlayer.Backpack end
		return
	end
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
		local lastActivate = 0
		while fastPunch and fastPunchGen == gen do
			if bossFightActive then
				local tBoss = getPunchTool()
				if tBoss then
					local atB = tBoss:FindFirstChild("attackTime")
					if atB and atB.Value ~= 0 then pcall(function() atB.Value = 0 end) end
				end
				task.wait(0.5)
			else
				local me = LocalPlayer:FindFirstChild("muscleEvent")
				local t = getPunchTool()
				if me and me:IsA("RemoteEvent") then
					pcall(function() me:FireServer("punch", "rightHand") end)
					pcall(function() me:FireServer("punch", "leftHand") end)
				end
				if t and time() - lastActivate >= 0.25 then
					lastActivate = time()
					pcall(function() t:Activate() end)
					playPunchVisual()
				end
				if selectedRock and type(firetouchinterest) == "function" then
					local c = LocalPlayer.Character
					local lh = c and c:FindFirstChild("LeftHand")
					local rh = c and c:FindFirstChild("RightHand")
					local rock = findRock(selectedRock)
					if rock and lh and rh then
						pcall(function() firetouchinterest(rock, rh, 0) end)
						pcall(function() firetouchinterest(rock, rh, 1) end)
						pcall(function() firetouchinterest(rock, lh, 0) end)
						pcall(function() firetouchinterest(rock, lh, 1) end)
					end
				end
				task.wait(0.05)
			end
		end
	end)
end

local fastPunchToggle = nil
fastPunchToggle = MainTab:CreateToggle({
	Name = "Fast Punch",
	CurrentValue = false,
	Flag = "FastPunch",
	Callback = function(v)
		setFastPunch(v)
		Window:Notify({Title="Princes Hud", Content=v and "Fast Punch ON" or "Fast Punch OFF", Duration=2})
	end
})

MainTab:CreateDropdown({
	Name = "Roca (Fast Glitch)",
	Options = (function()
		local o = {"Ninguna"}
		for _, r in ipairs(Rocks) do table.insert(o, r.label) end
		return o
	end)(),
	CurrentOption = "Ninguna",
	Callback = function(o)
		selectedRock = nil
		for _, r in ipairs(Rocks) do
			if r.label == o then selectedRock = r.durability break end
		end
	end
})

local currentMapLabel = MainTab:CreateText({Name="Current: "..currentMap.Value})
currentMap.Changed:Connect(function() currentMapLabel:Set("Current: "..currentMap.Value) end)

-- ============ FAST REP ============
local fastRepOn = false
local savedRepTimes = {}
local function applyRepTimeZero()
	local mf = Workspace:FindFirstChild("machinesFolder")
	if mf then
		for _, v in pairs(mf:GetDescendants()) do
			if v.Name == "repTime" and v:IsA("NumberValue") then
				if savedRepTimes[v] == nil then savedRepTimes[v] = v.Value end
				if v.Value ~= 0 then
					pcall(function() v.Value = 0 end)
				end
			end
		end
	end
	for _, loc in pairs({LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character}) do
		if loc then
			for _, tool in pairs(loc:GetChildren()) do
				if tool:IsA("Tool") then
					local r = tool:FindFirstChild("repTime", true)
					if r and r:IsA("NumberValue") then
						if savedRepTimes[r] == nil then savedRepTimes[r] = r.Value end
						if r.Value ~= 0 then pcall(function() r.Value = 0 end) end
					end
				end
			end
		end
	end
end
local function restoreRepTimes()
	for inst, orig in pairs(savedRepTimes) do
		if inst and inst.Parent then pcall(function() inst.Value = orig end) end
	end
	table.clear(savedRepTimes)
end
FarmTab:CreateToggle({
	Name = "Fast Rep",
	CurrentValue = false,
	Flag = "FastRepZero",
	Callback = function(v)
		fastRepOn = v
		if v then
			task.spawn(function()
				local ticks = 0
				while fastRepOn do
					ticks += 1
					if ticks % 30 == 1 then applyRepTimeZero() end
					local c = LocalPlayer.Character
					local h = c and c:FindFirstChildOfClass("Humanoid")
					if h and h.Health > 0 then
						local seat = getSeat(h)
						if seat then
							pcall(function() muscleEvent:FireServer("rep", seat) end)
						else
							pcall(function() muscleEvent:FireServer("rep") end)
						end
					end
					RunService.Heartbeat:Wait()
				end
			end)
		else
			restoreRepTimes()
		end
		Window:Notify({Title="Princes Hud", Content=v and "Fast Rep ON" or "Fast Rep OFF", Duration=2})
	end
})

-- ============ SUPER FAST REP ============
local superRepOn = false
local isMobileDevice = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local superRepBatch = 10
local superRepInterval = 0.02
FarmTab:CreateSlider({
	Name = "Super Rep Batch",
	Range = {1, 10},
	Increment = 1,
	CurrentValue = superRepBatch,
	Flag = "SuperRepBatch",
	Callback = function(v)
		v = math.floor((tonumber(v) or superRepBatch) + 0.5)
		local cap = 10
		superRepBatch = math.clamp(v, 1, cap)
	end
})
FarmTab:CreateToggle({
	Name = "Super Fast Rep",
	CurrentValue = false,
	Flag = "SuperFastRep",
	Callback = function(v)
		superRepOn = v
		if v then
			task.spawn(function()
				while superRepOn do
					applyRepTimeZero()
					local c = LocalPlayer.Character
					local h = c and c:FindFirstChildOfClass("Humanoid")
					if h and h.Health > 0 then
						local seat = getSeat(h)
						local hasX2 = LocalPlayer:FindFirstChild("ownedGamepasses") and LocalPlayer.ownedGamepasses:FindFirstChild("x2 Rep Time")
						local effective = superRepInterval
						if hasX2 then effective = effective * 0.5 end
						for i = 1, superRepBatch do
							if seat then
								pcall(function() muscleEvent:FireServer("rep", seat) end)
							else
								pcall(function() muscleEvent:FireServer("rep") end)
							end
						end
						task.wait(effective)
					else
						task.wait(0.2)
					end
				end
			end)
		else
			restoreRepTimes()
		end
		Window:Notify({Title="Princes Hud", Content=v and "Super Fast Rep ON" or "Super Fast Rep OFF", Duration=2})
	end
})

-- ============ AUTO RENA ============
FarmTab:CreateDivider("Auto Rena")
local autoRenaOn = false
FarmTab:CreateToggle({
	Name = "Auto Rebirth (Rena)",
	CurrentValue = false,
	Flag = "AutoRenaNormal",
	Callback = function(v)
		autoRenaOn = v
		if v then
			task.spawn(function()
				while autoRenaOn do
					pcall(function()
						rebirthRemote:InvokeServer("rebirthRequest")
					end)
					task.wait(2)
				end
			end)
		end
		Window:Notify({Title="Princes Hud", Content=v and "Auto Rena ON" or "Auto Rena OFF", Duration=2})
	end
})

-- ============ CALCULADORA DE RENAS Y FUERZA (EN VERTICAL HACIA ABAJO) ============
FarmTab:CreateDivider("Calculador de Progreso")

local targetRebirths = 1000
FarmTab:CreateSlider({
	Name = "Objetivo de Renas",
	Range = {1, 10000},
	Increment = 10,
	CurrentValue = 1000,
	Flag = "TargetRebirths",
	Callback = function(v)
		targetRebirths = tonumber(v) or 1000
	end
})

local statsTextLabel = FarmTab:CreateText({Name = "Calculando estadísticas..."})

local function formatNumber(n)
	if not n or type(n) ~= "number" then return "0" end
	if n < 1000 then
		return tostring(math.floor(n))
	end
	local suffixes = {"", "k", "m", "b", "t", "qd", "qn", "sx", "sp", "oc", "no", "dc"}
	local i = 1
	while n >= 1000 and i < #suffixes do
		n = n / 1000
		i = i + 1
	end
	local formatted = string.format("%.1f", n)
	if formatted:sub(-2) == ".0" then
		formatted = formatted:sub(1, -3)
	end
	return formatted .. suffixes[i]
end

task.spawn(function()
	while true do
		task.wait(1)
		local stats = LocalPlayer:FindFirstChild("leaderstats")
		local rStat = stats and stats:FindFirstChild("Rebirths")
		local sStat = stats and (stats:FindFirstChild("Strength") or stats:FindFirstChild("Durability"))

		local startR = rStat and rStat.Value or 0
		local startS = sStat and sStat.Value or 0
		local t1 = tick()

		task.wait(2)

		stats = LocalPlayer:FindFirstChild("leaderstats")
		rStat = stats and stats:FindFirstChild("Rebirths")
		sStat = stats and (stats:FindFirstChild("Strength") or stats:FindFirstChild("Durability"))

		local endR = rStat and rStat.Value or startR
		local endS = sStat and sStat.Value or startS
		local t2 = tick()

		local dt = t2 - t1
		if dt <= 0 then dt = 1 end

		local rPerSec = (endR - startR) / dt
		local sPerSec = (endS - startS) / dt

		local renasDay = rPerSec * 86400
		local renasWeek = rPerSec * 604800

		local strengthHour = sPerSec * 3600
		local strengthDay = sPerSec * 86400
		local strengthWeek = sPerSec * 604800
		local strengthMonth = sPerSec * 2592000

		local timeToTarget = "Sin progreso"
		if rPerSec > 0 and endR < targetRebirths then
			local secs = (targetRebirths - endR) / rPerSec
			if secs < 60 then
				timeToTarget = math.floor(secs) .. " seg"
			elseif secs < 3600 then
				timeToTarget = string.format("%.1f min", secs / 60)
			elseif secs < 86400 then
				timeToTarget = string.format("%.1f hrs", secs / 3600)
			else
				timeToTarget = string.format("%.1f días", secs / 86400)
			end
		elseif endR >= targetRebirths then
			timeToTarget = "¡Objetivo alcanzado!"
		end

		-- ESTRICTAMENTE VERTICAL (HACIA ABAJO) PARA QUE NO SE TAPE NADA
		local displayStr = string.format(
			"• Fuerza x Hora: %s\n" ..
			"• Fuerza x Día: %s\n" ..
			"• Fuerza x Semana: %s\n" ..
			"• Renas x Día: %s\n" ..
			"• Renas x Semana: %s\n" ..
			"• Meta (%s): %s",
			formatNumber(strengthHour),
			formatNumber(strengthDay),
			formatNumber(strengthWeek),
			formatNumber(renasDay),
			formatNumber(renasWeek),
			formatNumber(targetRebirths),
			timeToTarget
		)

		pcall(function()
			statsTextLabel:Set(displayStr)
		end)
	end
end)

-- ============ MOTOR RAPIDO (rebirth + strength) ORIGINAL ============
local LP = LocalPlayer
local Env = getgenv and getgenv() or _G
local StatsService = game:GetService("Stats")
local UltimateAttributes = {}
local State = {
	running = true,
	fastFarmMode = nil,
	autoWeight = false,
	hideFrames = false,
	rebirth = {},
	visualStatRecords = setmetatable({}, { __mode = "k" }),
}
State.setAutoEgg = function() return true end
local threads = {}
local threadGenerations = {}
local function stopThread(key)
	threadGenerations[key] = (threadGenerations[key] or 0) + 1
	local t = threads[key]
	if t then
		pcall(task.cancel, t)
		threads[key] = nil
	end
end
local function startThread(key, callback)
	stopThread(key)
	local generation = threadGenerations[key]
	local thread
	thread = task.defer(function()
		pcall(callback)
		if threadGenerations[key] == generation and threads[key] == thread then
			threads[key] = nil
		end
	end)
	threads[key] = thread
	return threads[key]
end
local function setHideFrames() end
local FastFarm = {
	RepToggles = {},
	MachineToggles = {},
	FullTrainToggles = {},
	MachineVisuals = {
		playIdle = function() end,
		playRep = function() end,
		stopAnimations = function() end,
	},
}
FastFarm.UpdateStrengthFramesControl = function() end
local protectBossRareOn = true
local knownBossRareIds = {}
local function isBossRara(pet)
	if not protectBossRareOn then return false end
	if not pet then return false end
	local okId, pid = pcall(function() return pet:GetAttribute("ProfileId") end)
	if okId and type(pid) == "string" and knownBossRareIds[pid] then return true end
	local ok, mark = pcall(function() return pet:GetAttribute("BossRewardDisplayName") end)
	if ok and mark ~= nil then
		if okId and type(pid) == "string" then knownBossRareIds[pid] = true end
		return true
	end
	if tostring(pet.Name or "") == "Rare Boss Pet" then
		if okId and type(pid) == "string" then knownBossRareIds[pid] = true end
		return true
	end
	return false
end
local function isProtegida(pet)
	return isBossRara(pet)
end
function FastFarm:ProtectedEquippedCount()
	local n = 0
	local eq = LP:FindFirstChild("equippedPets")
	if eq then
		for _, slot in ipairs(eq:GetChildren()) do
			local ref = slot:FindFirstChild("petReference")
			local pet = (ref and ref:IsA("ObjectValue") and ref.Value) or (slot:IsA("ObjectValue") and slot.Value) or nil
			if pet and pet:IsA("StringValue") and isProtegida(pet) then
				n = n + 1
			end
		end
	end
	return n
end
function FastFarm:FreePetSlots()
	return math.max(0, (self.GetPetSlotCapacity and self:GetPetSlotCapacity() or 0) - self:ProtectedEquippedCount())
end

local CONFIG = {
FastFarm = {
		Packs = {
			chaos = {
				label = "Señores del Caos",
				strength = { "Swift Samurai" },
				rebirth = "Tribal Overlord",
			},
			ultra = {
				label = "Ultra Titanes",
				strength = { "Powercore Hound", "Omega Overlord" },
				rebirth = "Titanium Hydra",
			},
		},
		StrengthMachine = "Industrial Bench",
		RebirthMachine = "Industrial Bar Lift",
		MaxPets = 9,
		RepsPerCycle = 48,
		RepDelay = 0.008,
		PingSoft = 180,
		PingMedium = 300,
		PingHigh = 600,
		PingCritical = 700,
		PingPause = 880,
		PingResume = 450,
		PingReducerPause = 860,
		PingReducerResume = 480,
		PingSampleInterval = 0.12,
		StrengthPingSoft = 400,
		StrengthPingMedium = 560,
		StrengthPingHigh = 720,
		StrengthPingCritical = 840,
		StrengthMinBatch = 26,
		StrengthStartBatch = 42,
		StrengthMaxBatch = 42,
		StrengthBackoffPing = 700,
		StrengthBackoffInterval = 0.35,
		StrengthRampPing = 450,
		StrengthRampInterval = 0.9,
		StrengthDelay = 0.05,
		SizeInvokeInterval = 0.75,
		SizeReleaseDuration = 5,
		FramesReleaseDuration = 10,
		RebirthCooldown = 6.0,
		RebirthSafetyMargin = 0.03,
		RebirthRepBatch = 6,
		RebirthPingRise = 100,
		RebirthPingPause = 800,
		RebirthStrengthBufferRatio = 0.1,
	}
}
