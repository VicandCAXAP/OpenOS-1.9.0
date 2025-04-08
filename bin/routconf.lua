local component=require("component")
local sysutils=require("sysutils")
local rconf = {}
local address
local port
local t
rconf.wan = {}
rconf.lan ={}
local cardlist = {}
local i = 0

for address in pairs(component.list("modem")) do
i = i + 1
cardlist[i] = address
end
for address in pairs(component.list("tunnel")) do
i = i + 1
cardlist[i] = address
end

function selcard()
i = 0

for number, address in pairs(cardlist) do
print(number..") "..address)
i = i + 1
end
answ = tonumber(io.read())

if cardlist[answ] then
  cardaddr = cardlist[answ]
  if component.type(cardaddr) == "tunnel" then
    t = "tunnel"
    port = 0
  else
	print("Enter port: ")
	t = "modem"
    port = io.read()
  end
  if tonumber(port) == nil then
  print("Incorrect port")
  return nil, nil
  end
  table.remove(cardlist, answ)
  i = i - 1
  return cardaddr, tonumber(port)
else
return nil, nil
end
end

print("Select WAN card. Type \"N\" if you dont have WAN card.")
rconf.wan.address, rconf.wan.port = selcard()
if rconf.wan.address then 
rconf.wan.type = component.type(rconf.wan.address)
end

while true do
if i == 0 then break end
print("Select LAN card. Type \"N\" to end.")
address, port = selcard()
if address then
rconf.lan[cardaddr:sub(1,3)] = {}
rconf.lan[cardaddr:sub(1,3)].address = address
rconf.lan[cardaddr:sub(1,3)].type = t
rconf.lan[cardaddr:sub(1,3)].port = port
else
break
end
end
sysutils.writeconfig("router", rconf)