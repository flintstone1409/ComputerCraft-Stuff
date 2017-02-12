-- ReactorServer
-- Pastebin ID is DutDfZgm

dbg = 0 -- Debug (0 to disable, 1 to enable basic output, 2 for ultimate spam)

------------------------------------------------------------------------------------------------------------------

function clear() -- just like "clear" in console
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.white)
end

function printLogo()
	term.setCursorPos(1,8)
	print("---------------------------------------------------")
	print("-----------------  ReactorServer  -----------------")
	print("---------------------------------------------------")
end

function tableLength(tb) -- quoted with love from stackoverflow (look at credits) ;)
	count = 0
	for _ in pairs(tb) do count = count + 1 end
	if dbg > 1 then print("Tablelength: " .. count) end -- debug-print
	return count
end

function converttopercentage(valuetoconvert) -- converts and returns given value to percent (just for reactor rod insertion, fills to next number instead of correct round)
	newVal = 100*valuetoconvert
	newVal = math.ceil(newVal)
	return newVal
end

function mc() -- monitor clear
	for key,value in pairs(monitors) do
		m = peripheral.wrap(monitors[key])
		m.clear()
		m.setTextColor(colors.white)
		if tableLength(monitors) == 0 then clear() end
		if dbg > 0 then print("Monitor '" .. monitors[key] .. "' cleared!") end -- debug-print
	end
end

function mp(line,txt) -- monitor print
	for key,value in pairs(monitors) do
		m = peripheral.wrap(monitors[key])
		if dbg > 1 then print("Active Peripheral (monitor): " .. monitors[key]) end -- debug-print
		m.setCursorPos(1,line)
		m.write(txt)
		if not tableLength(monitors) then print(txt) end
	end
end

function setVars() -- sets Variables which are used later
	if dbg > 0 then print("Will now setVars()") end -- debug-print

	autodetect = 1 -- for case config is incorrect
	napDuration = 0.5 -- for case config is incorrect
	ignoredPercentage = 20 -- for case config is incorrect

	EnergyLevel = {} -- just to calculate

	statPrintLine = 1 -- for stat printing to count active line, regarding "if only one reactor..."-scenario
	energyProducedLastTick = 0 -- clearing
	averageEnergyPerReactor = 0 -- clearing
	overallFuelAmount = 0 -- clearing
	fuelPercentage = 0 -- clearing
	maxFuelAmount = 0 -- clearing
	averageTemperature = 0 -- clearing
	highestTemperature = 0 -- clearing
	lowestTemperature = 10000 -- clearing
	storedEnergy = 0 -- clearing
	maxStoredEnergy = 0 -- clearing

	if dbg > 0 then print("Successful setVars()") end -- debug-print
end

function detectDevices()
	if fs.exists("ReactorServer_config") then -- reads config-file "ReactorServer_config"
		shell.run("ReactorServer_config") -- includes peripherals to use
	end

	if autodetect == 1 then
		reactors = {} -- clears to prevent errors because of entrys in the config-file ("ReactorServer_config")
		capacitors = {} -- clears to prevent errors because of entrys in the config-file ("ReactorServer_config")
		monitors = {} -- clears to prevent errors because of entrys in the config-file ("ReactorServer_config")
		for key,value in pairs(peripheral.getNames()) do -- scans every found peripheral for "BigReactors" in the name. Dont try so scan for strings including "-", computer won't find it :/
			if string.find(value,"BigReactors") then
				reactors[key] = value
			end
		end
		for key,value in pairs(peripheral.getNames()) do -- scans every found peripheral for "capacitor_bank_" in the name
			if string.find(value,"capacitor_bank_") then
				capacitors[key] = value
			end
		end
		for key,value in pairs(peripheral.getNames()) do -- scans every found peripheral for "monitor_" in the name
			if string.find(value,"monitor_") then
				monitors[key] = value
			end
		end

		if dbg > 0 then -- debug-print
			for key,value in pairs(reactors) do
				print("Found: " .. value)
			end
			for key,value in pairs(capacitors) do
				print("Found: " .. value)
			end
			for key,value in pairs(monitors) do
				print("Found: " .. value)
			end
		end
	end
end

function round(numberToRound) -- mathematical correct rounding
	if numberToRound - math.floor(numberToRound) >= 0.5 then
		numberToRound = math.ceil(numberToRound)
	else
		numberToRound = math.floor(numberToRound)
	end
	
	return numberToRound
end
------------------------------------------------------------------------------------------------------------------
-- functions that are directly used (not just to go to them if needed, goes straight from one function to another)

function nap()
	setVars()
	sleep(napDuration)
	detectDevices()
	stats()
end

function stats()
	for key,value in pairs(reactors) do
		r = peripheral.wrap(reactors[key])
		if dbg > 1 then print("Active Peripheral (reactor): " .. reactors[key]) end -- debug-print
		energyProducedLastTick = energyProducedLastTick + r.getEnergyProducedLastTick()
		overallFuelAmount = overallFuelAmount + r.getFuelAmount()
		averageTemperature = averageTemperature + r.getFuelTemperature()
		maxFuelAmount = maxFuelAmount + r.getFuelAmountMax()
		if r.getFuelTemperature() > highestTemperature then highestTemperature = r.getFuelTemperature() end
		if r.getFuelTemperature() < lowestTemperature then lowestTemperature = r.getFuelTemperature() end
	end

	for key,value in pairs(capacitors) do
		c = peripheral.wrap(capacitors[key])
		storedEnergy = storedEnergy + c.getEnergyStored()
		maxStoredEnergy = maxStoredEnergy + c.getMaxEnergyStored()
	end

	averageEnergyPerReactor = energyProducedLastTick / tableLength(reactors)
	averageTemperature = averageTemperature / tableLength(reactors)
	fuelPercentage = overallFuelAmount / maxFuelAmount * 100

	energyProducedLastTick = round(energyProducedLastTick)
	mc() -- monitor clear
	if energyProducedLastTick > 1000000 then -- bigger than one million
		energyProducedLastTick = energyProducedLastTick / 1000
		energyProducedLastTick = round(energyProducedLastTick)
		energyProducedLastTick = energyProducedLastTick / 1000
		mp(statPrintLine,"Overall Energy last Tick: " .. energyProducedLastTick .. "M")
	elseif energyProducedLastTick > 1000 then -- bigger than one thousand
		mp(statPrintLine,"Overall Energy last Tick: " .. energyProducedLastTick / 1000 .. "K")
	else
		mp(statPrintLine,"Overall Energy last Tick: " .. energyProducedLastTick)
	end
	statPrintLine = statPrintLine + 1
	if tableLength(reactors) > 1 then
		mp(statPrintLine,"Average Energy per Reactor: " .. averageEnergyPerReactor)
		statPrintLine = statPrintLine + 1
	end
	mp(statPrintLine,"Average Temperature: " .. averageTemperature)
	statPrintLine = statPrintLine + 1
	if tableLength(reactors) > 1 then
		mp(statPrintLine,"Lowest Temperature: " .. lowestTemperature)
		statPrintLine = statPrintLine + 1
		mp(statPrintLine,"Highest Temperature: " .. highestTemperature)
		statPrintLine = statPrintLine + 1
	end
	mp(statPrintLine,"Fuel Amount: " .. overallFuelAmount .. " / " .. maxFuelAmount)
	statPrintLine = statPrintLine + 1
	mp(statPrintLine,"Fuel Percentage: " .. fuelPercentage)
	statPrintLine = statPrintLine + 1

	if storedEnergy > 1000000 then -- bigger than one million
		storedEnergy = storedEnergy / 1000
		storedEnergy = round(storedEnergy)
		storedEnergy = storedEnergy / 1000
		strStoredEnergy = storedEnergy .. "M"
	elseif energyProducedLastTick > 1000 then -- bigger than one thousand
		storedEnergy = storedEnergy / 1000
		strStoredEnergy = storedEnergy .. "K"
	else
		strStoredEnergy = storedEnergy
	end
	if maxStoredEnergy > 1000000 then -- bigger than one million
		maxStoredEnergy = maxStoredEnergy / 1000
		maxStoredEnergy = round(maxStoredEnergy)
		maxStoredEnergy = maxStoredEnergy / 1000
		strMaxStoredEnergy = maxStoredEnergy .. "M"
	elseif energyProducedLastTick > 1000 then -- bigger than one thousand
		maxStoredEnergy = maxStoredEnergy / 1000
		strMaxStoredEnergy = maxStoredEnergy .. "K"
	else
		strMaxStoredEnergy = maxStoredEnergy
	end
	mp(statPrintLine,"Overall Energy Amount: " .. strStoredEnergy .. " / " .. strMaxStoredEnergy)
	statPrintLine = statPrintLine + 1
	if statRodValue then
		mp(statPrintLine,"RodValue: " .. statRodValue)
		statPrintLine = statPrintLine + 1
	end

	getEnergyLevel()
end

function getEnergyLevel()
	if tableLength(capacitors) > 0 then
		for key,value in pairs(capacitors) do
			c = peripheral.wrap(capacitors[key])
			if dbg > 1 then print("Active Peripheral (capacitor): " .. capacitors[key]) end -- debug-print
			localmaxcapacitorenergy = c.getMaxEnergyStored() / 100
			notIgnoredPercentage = 100 - ignoredPercentage
			localmaxcapacitorenergy = localmaxcapacitorenergy * notIgnoredPercentage
			EnergyLevel[key] = c.getEnergyStored() / localmaxcapacitorenergy
		end
	else
		for key,value in pairs(reactors) do
			c = peripheral.wrap(reactors[key])
			if dbg > 1 then print("Active Peripheral (reactor): " .. reactors[key]) end -- debug-print
			EnergyLevel[key] = c.getEnergyStored() / 10000000
		end
	end

	RodValue = 0

	for key,value in pairs(EnergyLevel) do
		RodValue = RodValue + EnergyLevel[key]
		if dbg > 0 then print("EnergyLevel[" .. key .. "]: " .. EnergyLevel[key]) end -- debug-print
	end

	RodValue = RodValue / tableLength(EnergyLevel)
	if dbg > 0 then print("RodValue: " .. RodValue) end -- debug-print
	RodValue = converttopercentage(RodValue)
	if dbg > 0 then print("RodValue (after math.ceil): " ..RodValue) end -- debug-print
	statRodValue = RodValue

	setRodLevel(RodValue)
end

function setRodLevel(Rodvl)
	for key,value in pairs(reactors) do
		r = peripheral.wrap(reactors[key])
		if dbg > 1 then print("Active Peripheral (reactor): " .. reactors[key]) end -- debug-print
		r.setAllControlRodLevels(Rodvl)
	end
end

clear()
printLogo()
sleep(4)
while true do
	nap()
	if dbg > 0 then print("---------------------------------------------------") end -- debug-print
end

-- Template: if dbg == 1 then print() end -- debug-print
-- Credits: function tableLength(): http://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
-- Credits: Peripheral detection: http://www.computercraft.info/wiki/Peripheral.find (not used, linked to used command)
-- Credits: Peripheral detection: http://www.computercraft.info/wiki/Peripheral.getNames (used)
-- Credits: Monitor Output: http://pastebin.com/TZNtQQZL (Reactor-Monitoring Program by another person)
-- Credits: Filtering of Peripherals: http://stackoverflow.com/questions/10158450/how-to-check-if-matching-text-is-found-in-a-string-in-lua
-- Credits: Command Syntax: http://computercraft.info/wiki/index.php?title=Fs.exists
-- Credits: To fix an error while scanning the network: http://www.computercraft.info/forums2/index.php?/topic/11043-invalid-key-to-next/