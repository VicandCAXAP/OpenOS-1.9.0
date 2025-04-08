local component = require("component")
local sysutils = require("sysutils")
local forms = require("forms")
local term = require("term")
local theme = sysutils.gettheme()

local cardlist = {}

function configurate()
  if tonumber(Edit1.text) or component.type(List1.items[List1.index]) == "tunnel"  then
    local config = {}
    config.address = List1.items[List1.index]
    config.port = tonumber(Edit1.text)
	config.type = component.type(config.address)
    sysutils.writeconfig("racoonnet",config)
	term.clear()
	forms.stop()
  else
    Edit1.text = ""
	Label3.visible = true
	Label3:redraw()
  end
end

for address in pairs(component.list("modem")) do
cardlist[address] = "(Сетевая)"..address
end
for address in pairs(component.list("tunnel")) do
cardlist[address] = "(Туннель)"..address
end

term.clear()
forms.ignoreAll()

Form1=forms.addForm()
Form1.border=1
Form1.H=16
Form1.W=50
Form1.color = theme.cl1[2]
Form1.fontcolor = theme.cl1[1]

Label1=Form1:addLabel(2,2,"Выберите сетевую карту RacoonNet:")
Label1.W=33
Label1.color = theme.cl1[2]
Label1.fontcolor = theme.cl1[1]

List1=Form1:addList(2,3)
List1.W=48
List1.H=6
List1.color = theme.cl1[2]
List1.fontcolor = theme.cl1[1]
List1.selColor = theme.cl3[2]
List1.sfColor = theme.cl3[1]

for addr, text in pairs(cardlist) do
  List1:insert(text,addr)
end

Label2=Form1:addLabel(5,10,"Введите порт:")
Label2.W=13
Label2.color = theme.cl1[2]
Label2.fontcolor = theme.cl1[1]

Label3=Form1:addLabel(2,12,"Неверно указан порт!!!")
Label3.color = theme.cl1[2]
Label3.fontcolor = theme.cl1[1]
Label3.visible = false

Edit1=Form1:addEdit(20,9)
Edit1.W=8
Edit1.color = theme.cl1[2]
Edit1.fontcolor = theme.cl1[1]

Button1=Form1:addButton(35,9,"Готово",configurate)
Button1.H=3
Button1.W=8
Button1.color = theme.cl4[2]
Button1.fontcolor = theme.cl4[1]

forms.run(Form1)
term.clear()