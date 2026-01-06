local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local activeChests = {
	["Troll Burger"] = false,
	["Tro-colate Bar"] = false,
	["Tomato"] = false,
	["Onion"] = false,
	["Four-Leaf Clover"] = false,
}

-- Создаем минимальный интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CompactChestUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Контейнер с возможностью перетаскивания
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 270)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 1
frame.Parent = screenGui

-- Заголовок для перетаскивания
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Auto Activ Items"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.TextScaled = true
title.Parent = frame

local totalChestsLabel = Instance.new("TextLabel")
totalChestsLabel.Size = UDim2.new(1, -20, 0, 25)
totalChestsLabel.Position = UDim2.new(0, 10, 0, 245)
totalChestsLabel.Text = "Общее число предметов: 0"
totalChestsLabel.TextColor3 = Color3.new(1, 1, 1)
totalChestsLabel.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
totalChestsLabel.BorderColor3 = Color3.new(0, 0, 0)
totalChestsLabel.BorderSizePixel = 2
totalChestsLabel.TextScaled = true
totalChestsLabel.Parent = frame

-- Обработка перетаскивания
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

title.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

local yOffset = 30

-- Создаем кнопку и счетчик на одной линии
local function createButtonAndCounter(name, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 25)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = "AutoActiv [ВЫКЛ]"
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.new(1, 0.5, 0) -- оранжевый по умолчанию, поменяем для каждого
	btn.BorderColor3 = Color3.new(1, 1, 0) -- желтый контур по умолчанию, поменяем
	btn.BorderSizePixel = 2
	btn.TextScaled = true
	btn.Parent = frame

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 80, 0, 25)
	lbl.Position = UDim2.new(0, 120, 0, yPos)
	lbl.Text = name .. "[0]"
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
	lbl.BorderColor3 = Color3.new(1, 1, 0) -- по умолчанию желтый, поменяем
	lbl.BorderSizePixel = 2
	lbl.TextScaled = true
	lbl.Parent = frame

	return {button = btn, label = lbl}
end

local function setButtonColors(ctrl, name)
	if name == "Troll Burger" then
		ctrl.button.BackgroundColor3 = Color3.new(0.576471, 0.384314, 0)
		ctrl.button.BorderColor3 = Color3.new(1, 0.666667, 0) 
		ctrl.button.TextColor3 = Color3.new(1, 0.666667, 0)
	elseif name == "Tro-colate Bar" then
		ctrl.button.BackgroundColor3 = Color3.new(0.290196, 0.0862745, 0)
		ctrl.button.BorderColor3 = Color3.new(0.635294, 0.2, 0)
		ctrl.button.TextColor3 = Color3.new(0.635294, 0.2, 0)
	elseif name == "Tro-colate Milk" then
		ctrl.button.BackgroundColor3 = Color3.new(0.290196, 0.0862745, 0)
		ctrl.button.BorderColor3 = Color3.new(0.635294, 0.2, 0)
		ctrl.button.TextColor3 = Color3.new(0.635294, 0.2, 0)
	elseif name == "Tomato" then
		ctrl.button.BackgroundColor3 = Color3.new(0.333333, 0, 0)
		ctrl.button.BorderColor3 = Color3.new(1, 0, 0)
		ctrl.button.TextColor3 = Color3.new(1, 0, 0)
	elseif name == "Onion" then
		ctrl.button.BackgroundColor3 = Color3.new(0.392157, 0.368627, 0.2)
		ctrl.button.BorderColor3 = Color3.new(0.713725, 0.666667, 0.364706)
		ctrl.button.TextColor3 = Color3.new(0.713725, 0.666667, 0.364706)
	elseif name == "Four-Leaf Clover" then
		ctrl.button.BackgroundColor3 = Color3.new(0, 0.333333, 0)
		ctrl.button.BorderColor3 = Color3.new(0, 1, 0)
		ctrl.button.TextColor3 = Color3.new(0, 1, 0)
	end

	-- Аналогичные изменения для счетчиков
	local lbl = ctrl.label
	if name == "Troll Burger" then
		lbl.BackgroundColor3 = Color3.new(0.576471, 0.384314, 0)
		lbl.BorderColor3 = Color3.new(1, 0.666667, 0)
		lbl.TextColor3 = Color3.new(1, 0.666667, 0)
	elseif name == "Tro-colate Bar" then
		lbl.BackgroundColor3 = Color3.new(0.290196, 0.0862745, 0)
		lbl.BorderColor3 = Color3.new(0.635294, 0.2, 0)
		lbl.TextColor3 = Color3.new(0.635294, 0.2, 0)
	elseif name == "Tro-colate Milk" then
		lbl.BackgroundColor3 = Color3.new(0.290196, 0.0862745, 0)
		lbl.BorderColor3 = Color3.new(0.635294, 0.2, 0)
		lbl.TextColor3 = Color3.new(0.635294, 0.2, 0)
	elseif name == "Tomato" then
		lbl.BackgroundColor3 = Color3.new(0.333333, 0, 0)
		lbl.BorderColor3 = Color3.new(1, 0, 0)
		lbl.TextColor3 = Color3.new(1, 0, 0)
	elseif name == "Onion" then
		lbl.BackgroundColor3 = Color3.new(0.392157, 0.368627, 0.2)
		lbl.BorderColor3 = Color3.new(0.713725, 0.666667, 0.364706)
		lbl.TextColor3 = Color3.new(0.713725, 0.666667, 0.364706)
	elseif name == "Four-Leaf Clover" then
		lbl.BackgroundColor3 = Color3.new(0, 0.333333, 0)
		lbl.BorderColor3 = Color3.new(0, 1, 0)
		lbl.TextColor3 = Color3.new(0, 1, 0)
	end
end

local yStart = 30
local controls = {}
local index = 0
for _, name in ipairs({"Troll Burger", "Tro-colate Bar", "Tro-colate Milk", "Tomato", "Onion", "Four-Leaf Clover"}) do
	index = index + 1
	controls[name] = createButtonAndCounter(name, yStart + (index - 1) * 35)
	setButtonColors(controls[name], name)
end

-- Обработка нажатий
for name, ctrl in pairs(controls) do
	ctrl.button.MouseButton1Click:Connect(function()
		activeChests[name] = not activeChests[name]
		if activeChests[name] then
			ctrl.button.Text = name .. ": ВКЛ"
			ctrl.button.BackgroundColor3 = Color3.new(0,1,0)
		else
			ctrl.button.Text = name .. ": ВЫКЛ"
			setButtonColors(ctrl, name) -- возвращаем исходные цвета
		end
	end)
end

-- Обновление счетчиков по сундукам
local function updateChestCounters()
	local backpack = player:WaitForChild("Backpack")
	local counts = {["Troll Burger"]=0,["Tro-colate Bar"]=0,["Tro-colate Milk"]=0,["Tomato"]=0,["Onion"]=0,["Four-Leaf Clover"]=0}
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			if counts[tool.Name] ~= nil then
				counts[tool.Name] = counts[tool.Name] + 1
			end
		end
	end
	local total = 0
	for name, count in pairs(counts) do
		controls[name].label.Text = name .. "[" .. count .. "]"
		total = total + count
	end
	-- обновляем общий счетчик
	totalChestsLabel.Text = "Общее число предметов [" .. total .. "]"
end

-- Обновление общего количества сундуков
local function updateTotalChestCount()
	local backpack = player:WaitForChild("Backpack")
	local totalCount = 0
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name == "Troll Burger" or tool.Name == "Tro-colate Bar" or tool.Name == "Tro-colate Milk" or tool.Name == "Tomato" or tool.Name == "Onion" or tool.Name == "Four-Leaf Clover") then
			totalCount = totalCount + 1
		end
	end
	-- Можно вывести или использовать это значение по необходимости
	print("Общее число предметов: " .. totalCount)
end

-- Активировать сундуки
local function activateChests()
	local backpack = player:WaitForChild("Backpack")
	local character = player.Character
	if not character then return end
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and activeChests[tool.Name] then
			player.Character.Humanoid:EquipTool(tool)
			if tool.Activate then pcall(function() tool:Activate() end) end
		end
	end
end

-- Главный цикл
RunService.RenderStepped:Connect(function()
	updateChestCounters()
	updateTotalChestCount() -- вызывается отдельно и не меняет заголовок
	for n, active in pairs(activeChests) do
		if active then
			activateChests()
			break
		end
	end
end)
