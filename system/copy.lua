-- Копирует файл
local args = {...}
if #args < 2 then
  print("Usage: copy <source> <destination>")
  return
end

if not fs.exists(args[1]) then
  print("Source file not found!")
  return
end

local content = fs.open(args[1], "r"):read("*a")
local dest = fs.open(args[2], "w")
dest.write(content)
dest.close()
print("File copied!")