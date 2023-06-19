local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(6942)


local itemfile = fs.open("list","r")
HANDLED_ITEM == itemfile.read()
itemfile.close()



function outputItem(time)
    redstone.setOutput("back", true)
    sleep(item * 0.2)
    redstone.setOutput("back", false)
end

repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
until event == "message" and message[1] == HANDLED_ITEM
modem.transmit(replyChannel, 6942, HANDLED_ITEM .. " done")
pcall(outputItem, message[2])


