-- RemoteExecution
-- Pastebin ID is SSKTXicb

role = "RE"

function dbgPrint(text)
	modem.transmit(2, 2, "[ID " .. os.getComputerID() .. ", " .. role .. "] " .. text)
end
function printCorrectPrefixes()
	print('You can use other prefixes aswell, these are for the Project "TechCompany 2"')
	print("So if you modified the program to use others, ignore this message :)")
	print("")
	print('"th_" for Testhalle')
	print('"ep_" for Erzproduktion')
	-- print('"_" for ') -- one empty (use as template)
	dbgPrint("Correct Prefixes printed!")
end
function chkCfg() -- Check Config -- If != exists dann abfrage öffnen
	if not fs.exists("tc2pre") then
		print('Please write the prefix that should be used into the first line of the file "tc2pre"')
		dbgPrint("Config not found!")
	else rdCfg() end
end
function rdCfg() -- Read Config
	dbgPrint("Will now read config!")
	h = fs.open("tc2pre", "r")
	activePre = h.readLine()
	h.close()
	if activePre == "th_" or activePre == "ep_" then
		print("Correct Prefix used :D")
		sleep(0.5)
	else printCorrectPrefixes() end
	dbgPrint("Config read successful!")
end
function getModem()
	for a,b in pairs(rs.getSides()) do -- #geklauteZeile
		if peripheral.getType(b) == 'modem' then -- #geklauteZeile
			modemSide = b -- #geklauteZeile #trotzdemModifiziert
			modem = peripheral.wrap(modemSide)
			dbgPrint("Modem found on side " .. modemSide)
			break -- #geklauteZeile
		end -- #geklauteZeile
	end -- #geklauteZeile

	if modemSide then
		chkCfg()
		run()
	else
		term.setCursorPos(1,9)
		print("                  No modem found!                  ")
	end
end
function run()
	term.clear()
	term.setCursorPos(1,8)
	print("---------------------------------------------------")
	print("---------------  Executing RemExec  ---------------")
	print("---------------------------------------------------")

	modem.open(1)

	while true do
		local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message") -- #geklauteZeile #geklautAusWiki

		dbgPrint("Message received: " .. message)
		if message ==  activePre .. "LichtAn" then
			rs.setOutput("left", false)
			dbgPrint('Toggled light in "Testhalle" on!')
		elseif message ==  activePre .. "LichtAus" then
			rs.setOutput("left", true)
			dbgPrint('Toggled light in "Testhalle" off!')
		elseif message ==  activePre .. "TorAuf" then
			rs.setOutput("right", false)
			dbgPrint('Opened gate in "Testhalle"!')
		elseif message ==  activePre .. "TorZu" then
			rs.setOutput("right", true)
			dbgPrint('Closed gate in "Testhalle"!')
		else dbgPrint('Unknown message!') end
	end
end

getModem()


-- Credits: Modem side detection: pastebin/K6jYG3Aw
-- Credits: Read/Write Config: computercraft.info/forums2/index.php?/topic/21411-create-and-read-config-files/