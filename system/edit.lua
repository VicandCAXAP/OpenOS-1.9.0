-- Мини-редактор файлов
local args = {...}
if #args < 1 then
  print("Usage: edit <filename>")
  return
end

local file = fs.open(args[1], "w")
print("Enter text (Ctrl+D to save):")
while true do
  local line = io.read()
  if not line then break end
  file.write(line .. "\n")
end
file.close()