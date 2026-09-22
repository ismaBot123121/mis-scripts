-- ============ UI: Princes Hub Premium (Dorado y Negro) ============
local GUI_LIB_URL = "https://raw.githubusercontent.com/momoneta/momoneta-hub/refs/heads/main/mome.lua"
local library = loadstring(game:HttpGet(GUI_LIB_URL, true))()
local _UIS_MOBILE = game:GetService("UserInputService")
local _isMobileUI = _UIS_MOBILE.TouchEnabled and not _UIS_MOBILE.KeyboardEnabled

-- Temática Premium: Dorado y Negro
local _eleriumWindow = library:AddWindow("Princes Hub Premium", {
	main_color = Color3.fromRGB(255, 215, 0), -- Dorado
	bg_color = Color3.fromRGB(15, 15, 15),    -- Negro oscuro
	text_color = Color3.fromRGB(255, 255, 255),
	min_size = _isMobileUI and Vector2.new(360, 560) or Vector2.new(500, 620),
	can_resize = not _isMobileUI,
})

-- Adaptador Rayfield para compatibilidad de tu código
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
			if opt2.CurrentValue == true then sw:Set(true) end
			return {
				Set = function(_, v)
					v = (v == true)
					if state == v then return end
					busy = true; sw:Set(v); busy = false; state = v
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
				for _, op in ipairs(opt2.Options) do pcall(function() dd:Add(op) end) end
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
						pcall(function() sl:Set(percent) end)
					end
					sliderGui.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then dragging = input; updateTouch(input.Position.X) end
					end)
					sliderGui.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Touch then updateTouch(input.Position.X) end
					end)
					_UIS_MOBILE.InputChanged:Connect(function(input)
						if dragging and input == dragging then updateTouch(input.Position.X) end
					end)
					_UIS_MOBILE.InputEnded:Connect(function(input)
						if dragging and input == dragging then dragging = nil end
					end)
				end)
			end
			pcall(opt2.Callback, math.clamp(defVal, range[1], range[2]))
			return sl
		end
		function T:CreateText(opt2)
			local label = tab:AddLabel(opt2.Name or "")
			if opt2.Description then label.Text = tostring(opt2.Name or "") .. "\n" .. tostring(opt2.Description) end
			pcall(function() label.TextTruncate = Enum.TextTruncate.AtEnd; label.TextXAlignment = Enum.TextXAlignment.Left end)
			return { Set = function(_, t) label.Text = tostring(t); pcall(function() label.Size = UDim2.new(1, -10, 0, 20) end) end }
		end
		function T:CreateDivider(opt2)
			tab:AddLabel(type(opt2) == "table" and tostring(opt2.text or opt2.Text or "") or tostring(opt2 or ""))
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

local Window = Rayfield:CreateWindow({ Name = "Princes Hub Premium" })

local MainTab = Window:CreateTab({ name = "Main" })
local FarmTab = Window:CreateTab({ name = "Auto Farm" })
local TrackerTab = Window:CreateTab({ name = "Stats Tracker" })

-- ============ SERVICIOS Y VARIABLES ============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local muscleEvent = LocalPlayer:WaitForChild("muscleEvent")
local rebirthRemote = ReplicatedStorage.rEvents:WaitForChild("rebirthRemote")

local function formatNumber(v)
	if not v or type(v) ~= "number" then return "0" end
	local abs_v = math.abs(v)
	if abs_v >= 1e18 then return string.format("%.2f Qi", v / 1e18)
	elseif abs_v >= 1e15 then return string.format("%.2f Qa", v / 1e15)
	elseif abs_v >= 1e12 then return string.format("%.2f T", v / 1e12)
	elseif abs_v >= 1e9 then return string.format("%.2f B", v / 1e9)
	elseif abs_v >= 1e6 then return string.format("%.2f M", v / 1e6)
	elseif abs_v >= 1e3 then return string.format("%.2f K", v / 1e3)
	else return tostring(math.floor(v)) end
end

local function getRawStrength()
	local st = LocalPlayer:FindFirstChild("leaderstats")
	if st and st:FindFirstChild("Strength") then
		local val = st.Strength.Value
		if type(val) == "number" then return val end
	end
	return 0
end

-- ============ CALCULADORA DE STATS (NUEVO) ============
TrackerTab:CreateDivider("Calculadora de Fuerza en Tiempo Real")
local lblCurrent = TrackerTab:CreateText({Name="Fuerza Inicial: 0"})
local lblMin = TrackerTab:CreateText({Name="Ganancia / Minuto: 0"})
local lblHour = TrackerTab:CreateText({Name="Ganancia / Hora: 0"})
local lblDay = TrackerTab:CreateText({Name="Ganancia / Día: 0"})
local lblWeek = TrackerTab:CreateText({Name="Ganancia / Semana: 0"})

local trackerRunning = false
TrackerTab:CreateToggle({
	Name = "Activar Tracker de Fuerza",
	CurrentValue = false,
	Callback = function(val)
		trackerRunning = val
		if val then
			local startFuerza = getRawStrength()
			local startTime = tick()
			lblCurrent:Set("Fuerza Inicial: " .. formatNumber(startFuerza))
			
			task.spawn(function()
				while trackerRunning do
					task.wait(1)
					local currentFuerza = getRawStrength()
					local gained = currentFuerza - startFuerza
					local elapsed = tick() - startTime
					
					if elapsed > 0 and gained >= 0 then
						local perSec = gained / elapsed
						lblMin:Set("Ganancia / Minuto: " .. formatNumber(perSec * 60))
						lblHour:Set("Ganancia / Hora: " .. formatNumber(perSec * 3600))
						lblDay:Set("Ganancia / Día: " .. formatNumber(perSec * 86400))
						lblWeek:Set("Ganancia / Semana: " .. formatNumber(perSec * 604800))
					end
				end
			end)
		else
			lblMin:Set("Ganancia / Minuto: 0")
			lblHour:Set("Ganancia / Hora: 0")
			lblDay:Set("Ganancia / Día: 0")
			lblWeek:Set("Ganancia / Semana: 0")
		end
	end
})

-- ============ AUTO FARM (NUEVO MOTOR) ============
FarmTab:CreateDivider("Configuración de Farm")
local autoFarmOn = false
local farmToolName = "Weight"

FarmTab:CreateDropdown({
	Name = "Seleccionar Ejercicio",
	Options = {"Weight", "Pushups", "Situps", "Handstands"},
	CurrentOption = "Weight",
	Callback = function(opt) farmToolName = opt end
})

FarmTab:CreateToggle({
	Name = "Auto Ejercicio (Spam)",
	CurrentValue = false,
	Callback = function(v)
		autoFarmOn = v
		if v then
			task.spawn(function()
				while autoFarmOn do
					local c = LocalPlayer.Character
					if c then
						local tool = LocalPlayer.Backpack:FindFirstChild(farmToolName)
						if tool then c.Humanoid:EquipTool(tool) end
						
						local eqTool = c:FindFirstChild(farmToolName)
						if eqTool then
							eqTool:Activate()
							pcall(function() muscleEvent:FireServer("rep") end)
						end
					end
					task.wait(0.01) -- Velocidad super rápida
				end
			end)
		end
		Window:Notify({Title="Princes Hub", Content=v and "Auto Farm Activado" or "Auto Farm Desactivado", Duration=2})
	end
})

local autoRebirthOn = false
FarmTab:CreateToggle({
	Name = "Auto Rebirth Normal",
	CurrentValue = false,
	Callback = function(v)
		autoRebirthOn = v
		if v then
			task.spawn(function()
				while autoRebirthOn do
					pcall(function() rebirthRemote:InvokeServer("rebirthRequest") end)
					task.wait(3)
				end
			end)
		end
	end
})

-- ============ FAST PUNCH Y OTROS (Restaurado) ============
MainTab:CreateDivider("Funciones Rápidas")
local fastPunch = false
MainTab:CreateToggle({
	Name = "Fast Punch",
	CurrentValue = false,
	Callback = function(v)
		fastPunch = v
		if v then
			task.spawn(function()
				while fastPunch do
					local c = LocalPlayer.Character
					if c then
						local t = c:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
						if t then
							if t.Parent ~= c then c.Humanoid:EquipTool(t) end
							local at = t:FindFirstChild("attackTime")
							if at then at.Value = 0 end
							t:Activate()
							pcall(function() muscleEvent:FireServer("punch", "rightHand") end)
							pcall(function() muscleEvent:FireServer("punch", "leftHand") end)
						end
					end
					task.wait(0.05)
				end
			end)
		end
	end
})
