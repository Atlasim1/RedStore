local modem = peripheral.find("modem") or error("No modem attached", 0)

modem.open(6943)

function drawList()
    term.setBackgroundColour(colors.blue)
    term.setTextColour(colors.white)
    term.clear()
    term.setCursorPos(((term.getSize()) / 2) - 7, 1)
    term.write("STORAGE SYSTEM")
end

drawList(0)

--[[while true do
    -- Fancyness
    term.setTextColor(colors.yellow)
    term.clear()
    term.setCursorPos(1,1)
    print("Storage System")
    term.setTextColor(colors.white)
    print("Type list for items")
    print("Request Storage Item\n> ")
    term.setCursorPos(3,4)
    -- Get Request
    local request = io.read()
    if request == "list" then -- list Items
        print("this will one day be a list")
    else
        print("How Much?\n> ")
        term.setCursorPos(3,6)
        local itemquantity = io.read()
        -- Formatting
        local requesteditem = request .. " of " .. itemquantity
        
        -- Request Item
        modem.transmit(6942, 6943, requesteditem)
        print("Requesting for " .. request)
        -- Wait For Answer from storage system
        local waitfor = true
        while waitfor do -- Wait for Awnser Event
            event = {os.pullEvent()}
            local eventtimeout = os.startTimer(3) -- Start Timeout Timer
            if event[1] == "timer" then -- if Timeout
                term.setTextColor(colors.red)
                print("Timed Out, Invalid Item")
                term.setTextColor(colors.white)
                waitfor = false
                break
            elseif event[1] == "modem_message" then
                if event[5] == request .. " done" then -- If No Timeout
                    term.setTextColor(colors.green)
                    print("Item Is Being Sent")
                    term.setTextColor(colors.white)
                    waitfor = false
                    break
                end
            else -- If stray event
                term.getCursorPos() -- Do Nothing

            end
        end
    end
    sleep(3) -- Wait for User to be able to read before Clearing Screen
    term.clear()
    
end 
--]]
