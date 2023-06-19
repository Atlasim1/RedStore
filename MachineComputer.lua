local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(6942)

function string:split( inSplitPattern, outResults )
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
  end

local itemfile = fs.open("handleitem.lua", "r")
HANDLED_ITEM = itemfile.readAll()
itemfile.close()

print(HANDLED_ITEM)

function outputItem(time)
    redstone.setOutput("back", true)
    sleep(time * 0.2)
    redstone.setOutput("back", false)
end

while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if event == "modem_message" then
        if message:split(" of ")[1] == HANDLED_ITEM then
            modem.transmit(replyChannel, 6942, HANDLED_ITEM .. " done")
            pcall(outputItem, message:split(" of ")[2])
        end
    end
end


