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
	h.writeLine("shell.run('pastebin run Gk9jsfmJ')")
	h.close()
	sr("label set RemoteControl")
	reboot()
elseif toInstall == "2" then
	h = fs.open("startup", "w")
	h.writeLine("shell.run('pastebin run SSKTXicb')")
	h.close()
	sr("label set RemoteExecution")
	reboot()
elseif toInstall == "3" then
	h = fs.open("startup", "w")
	h.writeLine("shell.run('pastebin run DMfngtXF')")
	h.close()
	sr("label set Wireless Logging")
	reboot()
elseif toInstall == "4" then
	h = fs.open("startup", "w")
	h.writeLine("shell.run('pastebin run DutDfZgm')")
	h.close()
	sr("pastebin get XCJUA6NS ReactorServer_config")
	sr("label set ReactorServer")
	reboot()
elseif toInstall == "5" then
	pwac()
	h = fs.open("startup", "w")
	h.writeLine("shell.run('pastebin run Sn2fzhZp')")
	h.close()
	reboot()
elseif toInstall == "6" then
	reboot()
else
	print("Unknown Option! Try Again...")
	sr("pastebin run 7SjLSFX1")
end