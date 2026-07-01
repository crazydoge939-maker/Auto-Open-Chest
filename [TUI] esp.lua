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
	["ICE Chest"] = false,

	["IceLolly"] = false,
	["Big IceLolly"] = false,
	["Huge IceLolly"] = false,

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
title.Text = "Auto Activator"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
title.TextScaled = true
title.Parent = frame

-- ScrollingFrame для кнопок
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 0.7, 0)
scrollFrame.Position = UDim2.new(0, 0, 0.11, 0)
scrollFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 2
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = frame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0.02, 0)
list.Parent = scrollFrame

local totalChestsLabel = Instance.new("TextLabel")
totalChestsLabel.Size = UDim2.new(1, 0, 0.12, 0)
totalChestsLabel.Position = UDim2.new(0, 0, 0.85, 0)
totalChestsLabel.Text = "Общее число Tool [0]"
totalChestsLabel.TextColor3 = Color3.new(1, 1, 1)
totalChestsLabel.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
totalChestsLabel.BorderSizePixel = 1
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
local function createButtonAndCounter(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.96, 0, 0.2, 0)
	btn.Text = name .. ": ВЫКЛ [0]"
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.new(1, 0.5, 0)
	btn.BorderColor3 = Color3.new(1, 1, 0)
	btn.BorderSizePixel = 2
	btn.TextScaled = true
	btn.Parent = scrollFrame

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
	elseif name == "ICE Chest" then
		ctrl.button.BackgroundColor3 = Color3.new(0, 0.282353, 0.282353)
		ctrl.button.BorderColor3 = Color3.new(0, 0.654902, 0.654902)
		ctrl.button.TextColor3 = Color3.new(0, 1, 1)

	elseif name == "IceLolly" then
		ctrl.button.BackgroundColor3 = Color3.new(0.666667, 0.333333, 0.498039)
		ctrl.button.BorderColor3 = Color3.new(0.403922, 0.2, 0.301961)
		ctrl.button.TextColor3 = Color3.new(1, 0.498039, 0.74902)
	elseif name == "Big IceLolly" then
		ctrl.button.BackgroundColor3 = Color3.new(0.270588, 0, 0.403922)
		ctrl.button.BorderColor3 = Color3.new(0.486275, 0, 0.729412)
		ctrl.button.TextColor3 = Color3.new(0.666667, 0, 1)
	elseif name == "Huge IceLolly" then
		ctrl.button.BackgroundColor3 = Color3.new(0.380392, 0, 0.380392)
		ctrl.button.BorderColor3 = Color3.new(0.619608, 0, 0.619608)
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
for _, name in ipairs({"Chest", "Dark Chest", "Light Chest", "Skin Chest", "ICE Chest", "IceLolly", "Big IceLolly", "Huge IceLolly"}) do
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
	local counts = {Chest=0,["Dark Chest"]=0,["Light Chest"]=0,["Skin Chest"]=0,["Ice Chest"]=0,["IceLolly"]=0,["Big IceLolly"]=0,["Huge IceLolly"]=0,}
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
	totalChestsLabel.Text = "Общее число объектов [" .. total .. "]"
end

-- Обновление общего количества сундуков
local function updateTotalChestCount()
	local backpack = player:WaitForChild("Backpack")
	local totalCount = 0
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") 
			and (tool.Name == "Chest" 
			or tool.Name == "Dark Chest" 
			or tool.Name == "Light Chest" 
			or tool.Name == "Skin Chest" 
			or tool.Name == "ICE Chest" 
				or tool.Name == "IceLolly"
				or tool.Name == "Big IceLolly"
				or tool.Name == "Huge IceLolly"
			) 	then
			totalCount = totalCount + 1
		end
	end
	-- Можно вывести или использовать это значение по необходимости
	print("Общее число сундуков: " .. totalCount)
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
