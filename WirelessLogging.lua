-- Wireless Logging
-- Pastebin ID is DMfngtXF

channels = {
	1;
	2;
}

if fs.exists("WirelessLogging_config") then
	shell.run("WirelessLogging_config") -- has to contain array like above
	for key,channel in pairs(channels) do
		print(key .. ": " .. channel)
	end
end

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
		for key,channel in pairs(channels) do
			modem.open(channel)
		end
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

		if type(message) == "table" then
			print("[CH " .. senderChannel .. "]")
			for k,v in pairs(message) do
				print("key: "..k.." var: "..v)
			end
			print("")
			print("-----------------")
			print("")
		else
			channelMessage = "[CH " .. senderChannel .. "] " .. message
			print(channelMessage)
		end

		term.setTextColor(colors.white)
	end
end

getModem()

-- Credits: Modem side detection: pastebin/K6jYG3Aw
