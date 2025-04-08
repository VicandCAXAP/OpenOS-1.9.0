-- Удаляет файл
local args = {...}
if #args < 1 then
  print("Usage: delete <filename>")
  return
end

if fs.exists(args[1]) then
  fs.remove(args[1])
  print("File deleted!")
else
  print("File not found!")
end