-- Скрипт для переключения монитора в 64-битный режим (8-битный цвет)
local component = require("component")
local term = require("term")

-- Проверяем, есть ли доступные мониторы
if not component.isAvailable("screen") then
  print("Монитор не обнаружен. Подключите монитор и попробуйте снова.")
  return
end

-- Получаем список всех мониторов
local screens = {}
for address in component.list("screen") do
  table.insert(screens, address)
end

-- Если мониторов несколько, предлагаем выбрать
local screenAddress
if #screens > 1 then
  print("Обнаружено несколько мониторов:")
  for i, addr in ipairs(screens) do
    print(i .. ": " .. addr)
  end
  io.write("Выберите номер монитора для настройки: ")
  local choice = tonumber(io.read())
  if choice and choice >= 1 and choice <= #screens then
    screenAddress = screens[choice]
  else
    print("Неверный выбор. Выход.")
    return
  end
else
  screenAddress = screens[1]
end

-- Получаем объект монитора и GPU
local screen = component.proxy(screenAddress)
local gpus = {}
for address in component.list("gpu") do
  table.insert(gpus, component.proxy(address))
end

-- Находим GPU, подключенный к выбранному монитору
local gpu
for _, g in ipairs(gpus) do
  if g.getScreen() == screenAddress then
    gpu = g
    break
  end
end

if not gpu then
  print("Не найден GPU, подключенный к выбранному монитору.")
  return
end

-- Проверяем текущий режим
local currentDepth = gpu.getDepth()
if currentDepth == 8 then
  print("Монитор уже работает в 64-битном режиме (глубина цвета 8 бит).")
  return
end

-- Пытаемся переключить режим
if gpu.getMaxDepth() < 8 then
  print("Данный GPU не поддерживает 64-битный режим (максимальная глубина: " .. gpu.getMaxDepth() .. " бит).")
  return
end

local success, reason = pcall(function()
  gpu.setDepth(8)
end)

if success then
  print("Монитор успешно переведен в 64-битный режим (глубина цвета 8 бит).")
  print("Теперь доступно 256 цветов вместо 16.")
else
  print("Не удалось переключить режим: " .. tostring(reason))
end