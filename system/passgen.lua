-- Генерирует случайный пароль
local function generate(length)
  local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  local pass = ""
  for i = 1, (length or 8) do
    pass = pass .. chars:sub(math.random(1, #chars), math.random(1, #chars))
  end
  return pass
end

print("Password: " .. generate(12))