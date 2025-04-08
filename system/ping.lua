-- Пингует другой компьютер по сети
local modem = require("component").modem
local args = {...}

if #args < 1 then
  print("Usage: ping <address>")
  return
end

modem.broadcast(123, "ping")
print("Pinging " .. args[1] .. "...")