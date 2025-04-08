-- Ищет файлы по имени
local args = {...}
if #args < 1 then
  print("Usage: find <filename>")
  return
end

local function search(dir, name)
  for _, file in ipairs(fs.list(dir)) do
    local path = dir .. "/" .. file
    if fs.isDirectory(path) then
      search(path, name)
    elseif file:find(name) then
      print(path)
    end
  end
end

search("/", args[1])