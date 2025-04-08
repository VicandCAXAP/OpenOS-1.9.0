-- Выводит информацию о видеокарте
local gpu = require("component").gpu
print("Screen resolution: " .. gpu.maxResolution())
print("Depth: " .. gpu.getDepth())