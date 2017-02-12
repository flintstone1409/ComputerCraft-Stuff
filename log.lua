-- Wireless Logging
-- Pastebin ID is DMfngtXF

function getModem()
	for a,b in pairs(rs.getSides()) do -- #geklauteZeile
		if peripheral.getType(b) == 'modem' then -- #geklauteZeile
			modemSide = b -- #geklauteZeile #trotzdemModifiziert
		end -- #geklauteZeile
		if peripheral.getType(b) == 'monitor' then -- #geklauteZeile
			monitorSide = b -- #geklauteZeile #trotzdemModifiziert
			term.redirect(peripheral.wrap(monitorSide))
		end -- #geklauteZeile
		if monitorSide and modemSide then
			break
		end
	end -- #geklauteZeile

	if modemSide then
		modem = peripheral.wrap(modemSide)
		modem.open(1)
		modem.open(2)
		if monitorSide then
			monitor = peripheral.wrap(monitorSide)
		end
		run()
	else
		term.setCursorPos(1,9)
		print("No modem found!")
	end
end
function run()
	term.clear()
	term.setCursorPos(1,1)
	print("Program running!")
	while true do
		local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message") -- #geklauteZeile #geklautAusWiki

		if senderChannel == 1 then
			term.setTextColor(colors.lime)
		elseif senderChannel == 2 then
			term.setTextColor(colors.yellow)
		end
		channelMessage = "[CH " .. senderChannel .. "] " .. message
		print(channelMessage)
		term.setTextColor(colors.black)
	end
end

getModem()

-- Credits: Modem side detection: pastebin/K6jYG3Aw