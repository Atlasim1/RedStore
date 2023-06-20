local modem = peripheral.find("modem")
local prog = peripheral.find("monitor")

if not modem then
	term.setTextColour(colors.red)
	term.write("This programme requires a modem.")
	print("")
	return 0
end
modem.open(6943)

itemList = {
	{name = "Cobblestone", id = "cobblestone"},
	{name = "Stone", id = "stone"},
	{name = "Stone Bricks", id = "stone_bricks"},
	{name = "Apple", id = "apple"},
	{name = "Glass", id = "glass"},
	{name = "Egg", id = "egg"},
	{name = "Carrot", id = "carrot"},
	{name = "Tourist Trap", id = "sweet_berries"},
	{name = "Cloth (Red)", id = "red_wool"},
	{name = "Cloth (Green)", id = "green_wool"},
	{name = "Cloth (Blue)", id = "blue_wool"},
	{name = "Iron Bars", id = "iron_bars"}
}
listPos = 1
quant = 0
mode = false
lockup = false

termSizeX, termSizeY = term.getSize()
if prog then
	term2SizeX, term2SizeY = prog.getSize()
end

function listSorter(a, b)
	return (a.name < b.name)
end

table.sort(itemList, listSorter)

function drawList(scrollPos)
	term.setBackgroundColour(colors.blue)
	term.setTextColour(colors.white)
	term.clear()
	term.setCursorPos(((termSizeX) / 2) - 6, 1)
	term.write("STORAGE SYSTEM")
	term.setCursorPos(1, termSizeY)
	term.write(" "..#itemList.." ITEMS")
	term.setCursorBlink(false)
	paintutils.drawLine(1, math.floor(termSizeY / 2) + 1, termSizeX, math.floor(termSizeY / 2) + 1, colors.white)
	term.setTextColour(colors.blue)
	term.setCursorPos(termSizeX - 3, math.floor(termSizeY / 2) + 1)
	term.write(scrollPos)
	term.setCursorPos(2, math.floor(termSizeY / 2) + 1)
	citm = itemList[scrollPos]
	term.write(citm.name)

	term.setBackgroundColour(colors.blue)
	term.setTextColour(colors.white)
	offset = (math.floor(termSizeY / 2) + 1)
	for i=(math.floor(termSizeY / 2)), 3, -1 do
		term.setCursorPos(2, i)
		if itemList[scrollPos + (i - offset)] ~= nil then
			term.write(itemList[scrollPos + (i - offset)].name)
		end
	end

	term.setBackgroundColour(colors.blue)
	term.setTextColour(colors.white)
	offset = (math.floor(termSizeY / 2) + 1)
	for i=(math.floor(termSizeY / 2) + 2), termSizeY - 2, 1 do
		term.setCursorPos(2, i)
		if itemList[scrollPos + (i - offset)] ~= nil then
			term.write(itemList[scrollPos + (i - offset)].name)
		end
	end
end

function drawPrinter()
	term.setBackgroundColour(colors.blue)
	term.setTextColour(colors.white)
	paintutils.drawFilledBox(1, (math.floor(termSizeY / 2) + 2), termSizeX, termSizeY - 2)
	paintutils.drawFilledBox(1, 2, termSizeX, (math.floor(termSizeY / 2)))
	term.setCursorPos(2, math.floor(termSizeY / 2) - 1)
	term.write("ENTER QUANTITY")
	term.setTextColour(colors.white)
	term.setCursorPos(2, math.floor(termSizeY / 2) + 3)
	term.write("< x"..quant)
	term.setCursorPos(11, math.floor(termSizeY / 2) + 3)
	term.write(">")
end

function drawProgress(ke)
	if prog then
		prog.setBackgroundColour(colors.black)
		prog.setTextColour(colors.orange)
		prog.clear()
		prog.setCursorPos(1, 1)
		prog.write(ke)
		prog.setCursorPos(term2SizeX - 2, 1)
		prog.write("00%")
		prog.setCursorPos(1, 2)
		local ot = term.redirect(prog)
			paintutils.drawLine(1, 2, (64 * (term2SizeX / 100)), 2, colors.gray)
		term.redirect(ot)
	end
end

function lockedup()
	term.setTextColor(colors.white)
	term.setBackgroundColour(colors.red)
	paintutils.drawFilledBox(1, 1, termSizeX, termSizeY)

	term.setCursorPos(13, 6)
	term.write("AN EXCEPTION HAS OCCURRED:")
	term.setCursorPos((termSizeX / 2) - 2, 7)
	term.write("NR_LS")
	term.setCursorPos(5, 10)
	term.write("RESTART THE MACHINE IF THE PROBLEM PERSISTS.")
	term.setCursorPos(7, 12)
	term.write("FOR FURTHER SUPPORT, CONTACT PAWKIN AND")
	term.setCursorPos(9, 13)
	term.write("PROVIDE DETAILED REPRODUCTION NOTES")
	term.setCursorPos(15, 15)
	term.write("PRESS SPACE TO CONTINUE")
end

drawList(listPos)
--drawProgress()

while true do
	local event, key = os.pullEvent("key")
	if lockup == true then
		if key == 32 then
			lockup = false
			mode = false
			drawList(listPos)
		else
			lockedup()
		end
	else
		if mode == true then
			if key == 263 then
				quant = math.max(0, quant - 1)
			end
			if key == 262 then
				quant = math.min(512, quant + 1)
			end
			drawPrinter()
			if key == 257 then
				if quant == 0 then
					mode = false
					drawList(listPos)
				else
					term.setTextColour(colors.lightGray)
					term.setCursorPos(2, math.floor(termSizeY / 2) + 3)
					term.write("< x"..quant)
					term.setCursorPos(11, math.floor(termSizeY / 2) + 3)
					term.write(">")
	
					rqi = citm["id"].." of "..quant
					modem.transmit(6942, 6943, requesteditem)
					local wf = true
					while wf do
						event = {os.pullEvent()}
						local eventtimeout = os.startTimer(1)
						if event[1] == "timer" then
							sleep(1)
							term.setBackgroundColour(colors.black)
							paintutils.drawFilledBox(1, 1, termSizeX, termSizeY)
							sleep(1)
							lockedup()
							lockup = true
							wf = false
							break
						elseif event[1] == "modem_message" then
							if event[5] == citm["id"].." done" then
								term.setTextColor(colors.green)
								term.setCursorPos(2, math.floor(termSizeY / 2) + 4)
								term.write("SENT")
								wf = false
								sleep(1.5)
								mode = false
								drawList(listPos)
								break
							end
						end
					end
				end
			end
		else
			if key == 265 then
				listPos = math.max(1, listPos - 1)
			end
			if key == 264 then
				listPos = math.min(#itemList, listPos + 1)
			end
			drawList(listPos)
			if key == 257 then
				quant = 0
				mode = true
				drawPrinter()
			end
		end
	end
	drawProgress(key)
	sleep()
end