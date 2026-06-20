local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local activeChests = {
	Chest = false,
	["Dark Chest"] = false,
	["Light Chest"] = false,
	["Skin Chest"] = false,

	--	["Magic Egg"] = false,
}

-- Создаем минимальный интерфейс
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CompactChestUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Контейнер с возможностью перетаскивания
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.1, 0, 0.3, 0)
frame.Position = UDim2.new(0, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 1
frame.Parent = screenGui

-- Заголовок для перетаскивания
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Auto Open Chests"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.TextScaled = true
title.Parent = frame

local totalChestsLabel = Instance.new("TextLabel")
totalChestsLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
totalChestsLabel.Position = UDim2.new(0.05, 0, 0.89, 0)
totalChestsLabel.Text = "Общее число сундуков: 0"
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

-- Создаем кнопку на всю ширину с количеством
local function createButtonAndCounter(name, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.94, 0, 0.12, 0)
	btn.Position = UDim2.new(0.03, 0, yPos, 0)
	btn.Text = name .. ": ВЫКЛ [0]"
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.new(1, 0.5, 0)
	btn.BorderColor3 = Color3.new(1, 1, 0)
	btn.BorderSizePixel = 2
	btn.TextScaled = true
	btn.Parent = frame

	return {button = btn, count = 0}
end

local function setButtonColors(ctrl, name)
	if name == "Chest" then
		ctrl.button.BackgroundColor3 = Color3.new(0.392157, 0.12549, 0)
		ctrl.button.BorderColor3 = Color3.new(0.686275, 0.227451, 0) 
		ctrl.button.TextColor3 = Color3.new(1, 0.333333, 0)
	elseif name == "Dark Chest" then
		ctrl.button.BackgroundColor3 = Color3.new(0.12549, 0, 0.392157)
		ctrl.button.BorderColor3 = Color3.new(0.227451, 0, 0.686275)
		ctrl.button.TextColor3 = Color3.new(0.333333, 0, 1)
	elseif name == "Light Chest" then
		ctrl.button.BackgroundColor3 = Color3.new(0.392157, 0.392157, 0)
		ctrl.button.BorderColor3 = Color3.new(0.686275, 0.686275, 0)
		ctrl.button.TextColor3 = Color3.new(1, 1, 0)
	elseif name == "Skin Chest" then
		ctrl.button.BackgroundColor3 = Color3.new(0.392157, 0, 0.392157)
		ctrl.button.BorderColor3 = Color3.new(0.686275, 0, 0.686275)
		ctrl.button.TextColor3 = Color3.new(1, 0, 1)
		--	elseif name == "Magic Egg" then
		--		ctrl.button.BackgroundColor3 = Color3.new(0, 0.333333, 1)
		--		ctrl.button.BorderColor3 = Color3.new(0, 0.666667, 1)
		--		ctrl.button.TextColor3 = Color3.new(0, 1, 1)
	end

end

local yStart = 0.12
local rowSpacing = 0.16
local controls = {}
local index = 0
for _, name in ipairs({"Chest", "Dark Chest", "Light Chest", "Skin Chest", }) do
	index = index + 1
	controls[name] = createButtonAndCounter(name, yStart + (index - 1) * rowSpacing)
	setButtonColors(controls[name], name)
end

-- Обработка нажатий
for name, ctrl in pairs(controls) do
	ctrl.button.MouseButton1Click:Connect(function()
		activeChests[name] = not activeChests[name]
		if activeChests[name] then
			ctrl.button.Text = name .. ": ВКЛ [" .. ctrl.count .. "]"
			ctrl.button.BackgroundColor3 = Color3.new(0,1,0)
		else
			ctrl.button.Text = name .. ": ВЫКЛ [" .. ctrl.count .. "]"
			setButtonColors(ctrl, name) -- возвращаем исходные цвета
		end
	end)
end

-- Обновление счетчиков по сундукам
local function updateChestCounters()
	local backpack = player:WaitForChild("Backpack")
	local counts = {Chest=0,["Dark Chest"]=0,["Light Chest"]=0,["Skin Chest"]=0,}
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			if counts[tool.Name] ~= nil then
				counts[tool.Name] = counts[tool.Name] + 1
			end
		end
	end
	local total = 0
	for name, count in pairs(counts) do
		controls[name].count = count
		local state = activeChests[name] and ": ВКЛ [" or ": ВЫКЛ ["
		controls[name].button.Text = name .. state .. count .. "]"
		total = total + count
	end
	-- обновляем общий счетчик
	totalChestsLabel.Text = "Общее число сундуков [" .. total .. "]"
end

-- Обновление общего количества сундуков
local function updateTotalChestCount()
	local backpack = player:WaitForChild("Backpack")
	local totalCount = 0
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name == "Chest" or tool.Name == "Dark Chest" or tool.Name == "Light Chest" or tool.Name == "Skin Chest") then
			totalCount = totalCount + 1
		end
	end
	-- Можно вывести или использовать это значение по необходимости
	print("Общее число сундуков: " .. totalCount)
end

-- Активировать сундуки
local isActivating = false

local function activateChests()
	if isActivating then return end

	local backpack = player:FindFirstChild("Backpack")
	local character = player.Character
	if not backpack or not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Собираем инструменты для активации
	local toolsToActivate = {}
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and activeChests[tool.Name] then
			table.insert(toolsToActivate, tool)
		end
	end

	if #toolsToActivate == 0 then return end

	isActivating = true

	task.spawn(function()
		for _, tool in ipairs(toolsToActivate) do
			-- Цикл повторных попыток: убираем из рук, берём снова, активируем
			while tool and tool.Parent and activeChests[tool.Name] do
				-- Убираем Tool из рук
				humanoid:UnequipTools()
				task.wait(0.1)

				if not tool or not tool.Parent then break end

				-- Берём Tool в руки
				humanoid:EquipTool(tool)
				task.wait(0.1)

				if not tool or not tool.Parent then break end

				-- Активируем Tool
				tool:Activate()
				task.wait(0.05)

				-- Если Tool исчез — сервер удалил его, активация прошла успешно
				if not tool or not tool.Parent then
					break
				end

				-- Удаляем Tool после активации
				tool:Destroy()
				break
			end
		end

		isActivating = false
	end)
end

-- Главный цикл
RunService.RenderStepped:Connect(function()
	updateChestCounters()
	updateTotalChestCount()
	for n, active in pairs(activeChests) do
		if active then
			activateChests()
			break
		end
	end
end)
