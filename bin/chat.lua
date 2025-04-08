------------------------------------------------------------
-- Чат-клиент для работы по сети OpenNet
-- by Zer0Galaxy
------------------------------------------------------------
gpu  = require("component").gpu
text = require("text")
wlen = require("unicode").wlen
beep = require("computer").beep
thread=require("thread")
on   = require("opennet")
term = require("term")
event= require("event")

server=({...})[1]
if not server then
  print("Формат вызова:")
  print("chat <IP или dns-имя сервера>")
  return
end
ev, _, _, _, Name=event.pull(1,"key_up")
if not ev then
  term.write("Нажмите любую клавишу")
  ev, _, _, _, Name=event.pull("key_up")
end

------ Переменные и функции для работы с окном вывода ------
local cursorX, cursorY = 1, 1
local WinW, WinH = gpu.getResolution()
WinH=WinH-2
local Left,Top = 1, 1

function winwrite(value)
  value = text.detab(tostring(value))
  if wlen(value) == 0 then
    return
  end
  do
    local noBell = value:gsub("\a", "")
    if #noBell ~= #value then
      value = noBell
      beep()
    end
  end
  local line, nl
  repeat
    line, value, nl = text.wrap(value, WinW - (cursorX - 1), WinW)
    gpu.set(cursorX+Left-1, cursorY+Top-1, line)
    cursorX = cursorX + wlen(line)
    if nl or (cursorX > WinW) then
      cursorX = 1
      cursorY = cursorY + 1
    end
    if cursorY > WinH then
      gpu.copy(Left, Top+1, WinW, WinH-1, 0, -1)
      gpu.fill(Left, WinH+Top-1, WinW, 1, " ")
      cursorY = WinH
    end
  until not value
end

function winclear()
  gpu.fill(Left, Top, WinW, WinH, " ")
  cursorX, cursorY = 1, 1
  gpu.set(Left, Top+WinH, string.rep("═",WinW-25).."Введите 'quit' для выхода")
end
------------------------------------------------------------

ok,err=on.getIP()
if not ok then
  print(err)
  return
end

function getmess()
  while true do
    local ip,sender,mess=on.receive()
	if ip==server then
	  gpu.setForeground(0xFFFF00)
	  winwrite(sender)
	  if mess then winwrite(": ") else mess="" end
	  gpu.setForeground(0xFFFFFF)
	  winwrite(mess)
	  winwrite("\n")
	end
  end
end

t=thread.create(getmess)

local History={}

winclear()
on.send(server,"login",Name)
while true do
  term.setCursor(Left, Top+WinH+1)
  term.clearLine()
  mess=term.read(History,false)
  mess=mess:gsub("\n", "")
  if mess=="quit" then break end
  if mess~=History[#History] then History[#History+1]=mess end
  on.send(server,"write",mess)
end
on.send(server,"logout")
os.sleep(1)
t:kill()