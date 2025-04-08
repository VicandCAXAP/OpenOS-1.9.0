-- Консольный калькулятор
print("Enter expression (e.g., 5+3*2):")
local expr = io.read()
local result = load("return " .. expr)()
print("Result: " .. result)