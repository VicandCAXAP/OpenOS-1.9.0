-- Создает бэкап файлов
local args = {...}
if #args < 1 then
  print("Usage: backup <folder>")
  return
end

local backupName = args[1] .. "_backup_" .. os.date("%Y%m%d")
if fs.exists(backupName) then
  print("Backup already exists!")
  return
end

fs.copy(args[1], backupName)
print("Backup created: " .. backupName)