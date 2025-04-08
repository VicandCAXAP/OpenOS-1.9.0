-- Скрипт для форматирования жесткого диска в FAT32 в OpenComputers
local component = require("component")
local term = require("term")
local fs = require("filesystem")

-- Проверяем наличие жестких дисков
if not component.isAvailable("drive") then
  print("Жесткий диск не обнаружен. Подключите диск и попробуйте снова.")
  return
end

-- Получаем список всех жестких дисков
local drives = {}
for address in component.list("drive") do
  table.insert(drives, address)
end

-- Если дисков несколько, предлагаем выбрать
local driveAddress
if #drives > 1 then
  print("Обнаружено несколько жестких дисков:")
  for i, addr in ipairs(drives) do
    local proxy = component.proxy(addr)
    local label = proxy.getLabel() or "Без метки"
    print(i .. ": " .. label .. " (" .. addr .. ")")
  end
  io.write("Выберите номер диска для форматирования: ")
  local choice = tonumber(io.read())
  if choice and choice >= 1 and choice <= #drives then
    driveAddress = drives[choice]
  else
    print("Неверный выбор. Выход.")
    return
  end
else
  driveAddress = drives[1]
end

-- Получаем прокси диска
local drive = component.proxy(driveAddress)

-- Предупреждение о потере данных
print("\nВНИМАНИЕ: Форматирование уничтожит все данные на диске!")
print("Диск: " .. (drive.getLabel() or "Без метки") .. " (" .. driveAddress .. ")")
print("Размер: " .. math.floor(drive.size() / 1024) .. " KB")
io.write("Продолжить форматирование? (y/n): ")

local confirm = io.read()
if confirm:lower() ~= "y" then
  print("Отмена форматирования.")
  return
end

-- Форматируем диск в FAT32
print("\nНачинаем форматирование в FAT32...")

local success, reason = pcall(function()
  -- Отключаем файловую систему (если смонтирована)
  if fs.get(driveAddress) then
    fs.umount(driveAddress)
  end
  
  -- Форматируем с файловой системой FAT32
  require("computer").beep(1000, 0.2)
  drive.format("fat32")
  require("computer").beep(1500, 0.2)
  
  -- Монтируем заново
  fs.mount(driveAddress, "/mnt/" .. driveAddress:sub(1, 3))
end)

if success then
  print("\nФорматирование успешно завершено!")
  print("Файловая система: FAT32")
  print("Метка диска: " .. (drive.getLabel() or "Без метки"))
  print("Смонтирован в: /mnt/" .. driveAddress:sub(1, 3))
else
  print("\nОшибка форматирования: " .. tostring(reason))
  if reason:find("not supported") then
    print("Данный жесткий диск не поддерживает FAT32.")
    print("Попробуйте использовать другой диск или файловую систему.")
  end
end