-- Настройка Wi-Fi (если есть беспроводной модем)
local modem = require("component").modem
if not modem.isWireless() then
  print("No wireless modem!")
  return
end

modem.setStrength(100) -- Максимальная мощность
print("Wireless modem ready!")