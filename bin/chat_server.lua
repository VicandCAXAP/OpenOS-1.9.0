on = require("opennet")

client={}

local myIP,err=on.getIP("chatroom")
if not myIP then
  print(err)
  return
end
print(myIP)
local sendIP, command

commands={}
function commands.ping()
  on.send(sendIP, command, "pong")
end

function commands.ver()
  on.send(sendIP, command, "Разговорная комната 1.0")
end

function commands.login(Name)
  client[sendIP]=Name
  for ip in pairs(client) do
    on.send(ip, Name.." подключился(ась) к чату")
  end
end

function commands.write(mess)
  for ip in pairs(client) do
    on.send(ip, client[sendIP] or "Неизвестный", mess)
  end
end

function commands.logout()
  for ip in pairs(client) do
    on.send(ip, client[sendIP].." отключился(ась) от чата")
  end
  client[sendIP]=nil
end

while true do
  local dat = {on.receive()}
  sendIP, command = dat[1], dat[2]
  if command then
    print("-->",table.unpack(dat))
    if commands[command] then
      commands[command](table.unpack(dat,3))
--      on.send(sendIP, command, commands[command](table.unpack(dat,3)) )
	end
  end
end