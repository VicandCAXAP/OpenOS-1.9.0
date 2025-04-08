-- Показывает свободное место на диске
local total = computer.totalMemory() / 1024
local used = computer.freeMemory() / 1024
print(string.format("Free: %.2fKB / %.2fKB", used, total))