--local dl = http.get("https://raw.githubusercontent.com/cat1554/RedStore/patch-1/MainComputer.lua")
--local hl = dl.readAll()
--dl.close()

--local fl = fs.open("/main.lua", "w")
--fl.write(hl)
--fl.close()
--sleep(1)
shell.run("/main.lua")
