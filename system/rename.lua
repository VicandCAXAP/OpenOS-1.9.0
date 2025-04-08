-- Переименовывает файл
local args = {...}
if #args < 2 then
  print("Usage: rename <oldname> <newname>")
  return
end

if fs.exists(args[1]) then
  fs.rename(args[1], args[2])
  print("File renamed!")
else
  print("File not found!")
end