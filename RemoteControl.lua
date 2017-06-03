-- RemoteControl
-- Pastebin ID is Gk9jsfmJ

dbg = 0 -- Debug (set 1 to enable, else 0)
varPrintTouchornot = "false"
activePre = "not"
role = "RC"

function dbgPrint(text)
	modem.transmit(2, 2, "[ID " .. os.getComputerID() .. ", " .. role .. "] " .. text)
end
function printCorrectPrefixes() -- have to modify while adding prefixes
	print('You can use other prefixes aswell, these are for the Project "TechCompany 2"')
	print("So if you modified the program to use others, ignore this message :)")
	print("")
	print('"th_" for Testhalle')
	print('"ep_" for Erzproduktion')
	print('"mh_" for Maschinenhalle')
	-- print('"_" for ') -- one empty used as template
end
function chkCfg() -- Check Config -- If != exists dann abfrage öffnen
	if not fs.exists("tc2cfg") then
		dbgPrint("Could not find config!")
		printPrefixes_touch()
	end
end
function rdCfg() -- Read Config
	dbgPrint("Will now read config!")
	h = fs.open("tc2cfg", "r")
	activePre = h.readLine()
	h.close()
	if activePre == "th_" or activePre == "ep_" then -- have to modify while adding prefixes
		getModem()
	else
		printCorrectPrefixes()
	end
	dbgPrint("Read Config successfully!")
end
function svCfg() -- Save Config
	dbgPrint("Will now save config!")
	h = fs.open("tc2cfg", "w")
	h.writeLine(activePre)
	h.close()
	dbgPrint("Config saved.")
end
function getModem()
	for a,b in pairs(rs.getSides()) do -- #geklauteZeile
		if peripheral.getType(b) == 'modem' then -- #geklauteZeile
			modemSide = b -- #geklauteZeile #trotzdemModifiziert
			modem = peripheral.wrap(modemSide)
			dbgPrint("Found modem on side: " .. modemSide)
			break -- #geklauteZeile
		end -- #geklauteZeile
	end -- #geklauteZeile

	if modemSide then
		printTouchornot()

		event,side,x,y = os.pullEvent() -- #geklauteZeile
		if dbg == 1 then print("X: " .. x .. " Y: " .. y) end -- DebugMessage
		dbgPrint("Event came up!")
		dbgPrint("  X: " .. x .. " Y: " .. y)
		if dbg == 1 then print("Event: " .. event) end -- DebugMessage
		dbgPrint("  Event: " .. event)
		if dbg == 1 then sleep(5) end -- DebugMessage
		if event == 'mouse_click' then -- #geklauteZeile #trotzdemModifiziert
			if x > 4 and x < 23 then
				if y > 4 and y < 8 then
					varPrintTouchornot = "touch"
					dbgPrint("Will now use touch!")
					chkCfg()
					rdCfg()
					printOptions_touch()
				elseif y > 7 and y < 11 then
					varPrintTouchornot = "keyboard"
					dbgPrint("Will now use keyboard!")
					chkCfg()
					rdCfg()
					printOptions_keyboard()
				end
			end
		end
	else
		term.setCursorPos(1,9)
		print("                  No modem found!                  ")
	end
end
function printTouchornot()
	dbgPrint('Now printing "Touchornot"')
	term.clear()
	term.setCursorPos(1,2)
	print("--------------------------")
	print("--------  RemCon  --------")
	print("--------------------------")
	print("")
	print("    +----------------+    ")
	print("    |   Use touch    |    ")
	print("    +----------------+    ")
	print("    +----------------+    ")
	print("    | Dont use touch |    ")
	print("    +----------------+    ")
	print("")
	print(" Option without touch may ")
	print("     not work anymore!    ")
end
function printOptions_keyboard()
	dbgPrint("Now printing keyboard-options.")
	term.clear()
	term.setCursorPos(1,2)
	print("--------------------------")
	print("--------  RemCon  --------")
	print("--------------------------")
	term.setCursorPos(1,8)
	print("Choose one option:")
	term.setCursorPos(1,10)
	print("1) Licht an.")
	print("2) Licht aus.")
	print("3) Tor auf.")
	print("4) Tor zu.")
	term.setCursorPos(1,15)
	write(" > ")
	
	getOption = read()
	dbgPrint("Successful read: " .. getOption)
	evaluate_keyboard()
end
function evaluate_keyboard()
	if getOption == "1" then
		modem.transmit(1, 1, activePre .. "LichtAn")
	elseif getOption == "2" then
		modem.transmit(1, 1, activePre .. "LichtAus")
	elseif getOption == "3" then
		modem.transmit(1, 1, activePre .. "TorAuf")
	elseif getOption == "4" then
		modem.transmit(1, 1, activePre .. "TorZu")
	elseif getOption == "rb" then
		print("Will now reboot!")
		sleep(1)
		shell.run("reboot")
	end
	printOptions_keyboard()
end
function printPrefixes_touch()
	if dbg == 1 then modem.transmit(1, 1, "Will now print Prefixes-Screen!") end -- DebugMessage
	dbgPrint("Will now print Prefixes-Screen!")
	term.clear()
	term.setCursorPos(1,1)
	write("\n------------------------RB")
	write("\n--------  RemCon  --------")
	write("\n--------------------------")
	write("\n")
	write("\n----- Actual Prefix: -----")
	write("\n----------- " .. activePre .. " ----------")
	write("\n")
	write("\n  +--------------------+  ")
	write("\n  |    Testhalle   th_ |  ")
	write("\n  +--------------------+  ")
	write("\n  +--------------------+  ")
	write("\n  |  Erzproduktion ep_ |  ")
	write("\n  +--------------------+  ")
	write("\n  +--------------------+  ")
	write("\n  | Maschinenhalle mh_ |  ")
	write("\n  +--------------------+  ")
	write("\n  +--------------------+  ")
	write("\n  |      Mobfarm   mf_ |  ")
	write("\n  +--------------------+  ")
	
	
	if dbg == 1 then modem.transmit(1, 1, "Print ready, will now evaluate.") end -- DebugMessage
	dbgPrint("Print ready, will now evaluate.")
	evaluatePrefixes_touch()
end
function evaluatePrefixes_touch()
	sleep(0.5)
	event,side,x,y = os.pullEvent() -- #geklauteZeile
	if dbg == 1 then modem.transmit(1, 1, "Event:" .. event) end -- DebugMessage
	dbgPrint("Got event!")
	dbgPrint("  Event: " .. event)
	dbgPrint("  X: " .. x .. " Y: " .. y)
	if event == 'mouse_click' then -- #geklauteZeile #trotzdemModifiziert
		if dbg == 1 then modem.transmit(1, 1, "Event happened with:") end -- DebugMessage
		if dbg == 1 then modem.transmit(1, 1, "   X: " .. x .. " Y: " .. y) end -- DebugMessage
		if x > 4 and x < 23 then
			if y > 7 and y < 11 then
				activePre = "th_"
				dbgPrint("Active prefix is now " .. activePre)
				svCfg()
			elseif y > 10 and y < 14 then
				activePre = "ep_"
				dbgPrint("Active prefix is now " .. activePre)
				svCfg()
			elseif y > 13 and y < 17 then
				activePre = "mh_"
				dbgPrint("Active prefix is now" .. activePre)
				svCfg()
			elseif y > 16 and y < 20 then
				activePre = "mf_"
				dbgPrint("Active prefix is now" .. activePre)
				svCfg()
			end
		elseif x > 24 and y == 1 then
			dbgPrint("Will now reboot!")
			shell.run("reboot")
		end
	end
	
	if dbg == 1 then modem.transmit(1, 1, "End of Event") end -- DebugMessage
	dbgPrint("End of Event")
	
	if varPrintTouchornot == false then printTouchornot()
	elseif varPrintTouchornot == "touch" then printOptions_touch()
	elseif varPrintTouchornot == "keyboard" then printOptions_keyboard() end
end
function printOptions_touch()
	dbgPrint("Now printing Options_touch")
	term.clear()
	term.setCursorPos(1,1)
	write("\n------------------------RB")
	write("\n--------  RemCon  --------")
	write("\n---------------------" .. activePre .. "--")
	write("\n")
	write("\n    +----------------+    ")
	write("\n    |    Licht an    |    ")
	write("\n    +----------------+    ")
	write("\n    +----------------+    ")
	write("\n    |   Licht aus    |    ")
	write("\n    +----------------+    ")
	write("\n    +----------------+    ")
	write("\n    |     Tor auf    |    ")
	write("\n    +----------------+    ")
	write("\n    +----------------+    ")
	write("\n    |      Tor zu    |    ")
	write("\n    +----------------+    ")

	evaluate_touch()
end
function evaluate_touch()
	event,side,x,y = os.pullEvent() -- #geklauteZeile
	dbgPrint("Got Event!")
	dbgPrint("  X: " .. x .. " Y: " .. y)
	dbgPrint("  Event: " .. event)
	if event == 'mouse_click' then -- #geklauteZeile #trotzdemModifiziert
		if x > 4 and x < 23 then
			if y > 4 and y < 8 then
				modem.transmit(1, 1, activePre .. "LichtAn")
			elseif y > 7 and y < 11 then
				modem.transmit(1, 1, activePre .. "LichtAus")
			elseif y > 10 and y < 14 then
				modem.transmit(1, 1, activePre .. "TorAuf")
			elseif y > 13 and y < 17 then
				modem.transmit(1, 1, activePre .. "TorZu")
			end
		elseif x > 24 and y == 1 then
			dbgPrint("Will now reboot!")
			shell.run("reboot")
		elseif x > 21 and x < 25 and y == 4 then
			printPrefixes_touch()
		end
	end
	
	printOptions_touch()
end

getModem()

-- Credits: Modem side detection: pastebin/K6jYG3Aw
-- Credits: Touch event detection: pastebin/V1vnDPRt (der Nutzer hat es abgeschrieben von ReduceTheBlock)
-- Credits: Read/Write Config: computercraft.info/forums2/index.php?/topic/21411-create-and-read-config-files/
-- Credits: Event names (helped for fixing a bug, where an unexpected event came up for some reason): computercraft.info/wiki/Os.pullEvent