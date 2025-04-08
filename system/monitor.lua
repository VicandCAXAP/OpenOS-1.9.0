-- Выводит текст на подключенный монитор
local gpu = require("component").gpu
local screen = require("component").screen

if not screen then
  print("No monitor connected!")
  return
end

gpu.bind(screen.address)
gpu.set(1, 1, "Hello from OpenComputers!")