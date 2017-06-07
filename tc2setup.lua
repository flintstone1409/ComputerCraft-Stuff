-- TechCompany2 Installer
-- Pastebin ID is 7SjLSFX1

local function sr(string)
	shell.run(string)
end
local function reboot()
	print("Install process finished.")
	print("Will now reboot!")
	sleep(1.5)
	sr("reboot")
end
local function defaults()
	sr("rm *")
	h = fs.open("rb", "w")
	h.writeLine("shell.run('reboot')")
	h.close()
	sr("pastebin get Fdgj43gT github")
end
-----------------------------------------------
local function pwac()
	notmachting = true
	while notmachting do
		print("What should your password be?")
		write(" > ")
		newPw1 = read("*")
		print("Repeat Password")
		write(" > ")
		newPw2 = read("*")
		if newPw1 == newPw2 then
			if newPw1 == "debugshutd0" then
				print("Not allowed for password (Debug-Usage, won't work)!")
			elseif newPw1 == "debugreb0" then
				print("Not allowed for password (Debug-Usage, won't work)!")
			else
				print("")
				notmachting = false
			end
		else
			print("Passwords are not matching! Try again...")
		end
	end
	newPw = newPw1

	notsuccess = true
	while notsuccess do
		print("Which side should the redstone signal be emitted to?")
		write(" > ")
		sSide = read()
		for key,value in pairs(rs.getSides()) do
			if value == sSide then
				notsuccess = false
			end
		end
		if notsuccess then
			print("Unknown side!")
		end
	end

	h = fs.open("PasswordAccess_config", "w")
	h.writeLine("pw = '" .. newPw .. "'")
	h.writeLine("sSide = '" .. sSide .. "'")
	h.close()

	newPw = nil
end
-----------------------------------------------

term.clear()
term.setCursorPos(1,1)
print("Activate Beta-Mode?")
print("")
print("1) no")
print("2) yes")
print("")
write(" > ")

activateBeta = read()

if activateBeta == "1" or activateBeta == "2" then
	print("Everything is fine!")
else
	print("Unknown Option! Try Again...")
	sr("pastebin run 7SjLSFX1")
end

term.clear()
term.setCursorPos(1,1)
print("What do you want to install?")
print("")
print("1) RemoteControl")
print("2) RemoteExecution")
print("3) Wireless Logging")
print("4) ReactorServer")
print("5) PasswordAccess")
print("6) Only Defaults")
print("")
write(" > ")

toInstall = read()

defaults()

if toInstall == "1" then
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'Gk9jsfmJ'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/RemoteControl.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	sr("label set RemoteControl")
	reboot()
elseif toInstall == "2" then
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'SSKTXicb'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/RemoteExecution.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	sr("label set RemoteExecution")
	reboot()
elseif toInstall == "3" then
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'DMfngtXF'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/WirelessLogging.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	sr("label set Wireless Logging")
	reboot()
elseif toInstall == "4" then
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'DutDfZgm'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/ReactorServer.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	sr("github get flintstone1409/ComputerCraft-Stuff/master/ReactorServer_config.lua ReactorServer_config")
	sr("label set ReactorServer")
	reboot()
elseif toInstall == "5" then
	pwac()
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'Sn2fzhZp'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/PasswordAccess.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	reboot()
elseif toInstall == "6" then
	reboot()
elseif toInstall == "7" then
	h = fs.open("startup", "w")
	if activateBeta == "1" then h.writeLine("state = 'stable'") elseif activateBeta == "2" then h.writeLine("state = 'beta'") end
	h.writeLine("pbid = 'fqUQrw6D'\nghid = 'flintstone1409/ComputerCraft-Stuff/master/HelloWorld.lua'")
	h.writeLine("if state == 'stable' then shell.run('pastebin run '..pbid) elseif state == 'beta' then shell.run('github run '..ghid) end")
	h.close()
	sr("label set HelloWorld")
	reboot()
else
	print("Unknown Option! Try Again...")
	sr("pastebin run 7SjLSFX1")
end