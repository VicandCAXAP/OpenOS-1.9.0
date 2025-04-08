-- Создает директорию
local args = {...}
if #args < 1 then
  print("Usage: mkdir <dirname>")
  return
end

if not fs.exists(args[1]) then
  fs.makeDirectory(args[1])
  print("Directory created!")
else
  print("Directory already exists!")
end