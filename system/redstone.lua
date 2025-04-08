-- Включение/выключение редстоуна
local rs = require("component").redstone
local args = {...}

if #args < 2 then
  print("Usage: redstone <side> <value>")
  return
end

rs.setOutput(args[1], tonumber(args[2]))
print("Redstone updated!")