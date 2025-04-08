-- Показывает текущее время (если есть RTC)
local computer = require("computer")
if computer.uptime() > 0 then
  print("Uptime: " .. computer.uptime() .. "s")
else
  print("No RTC detected!")
end