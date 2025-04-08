-- Выводит список файлов в текущей директории
local files = fs.list(shell.dir())
for _, file in ipairs(files) do
  print(file)
end