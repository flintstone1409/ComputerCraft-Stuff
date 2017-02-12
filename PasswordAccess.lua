-- PasswordAccess
-- Pastebin ID is Sn2fzhZp

os.pullEvent = os.pullEventRaw

pw = "default-pw" -- Password if not available as "pw = <your password>" in file "PasswordAccess_config"
sSide = "right"

shell.run("PasswordAccess_config")

-- Some Information:
-- your password with an appended "3600" opens the door for one hour instead of 3.5 seconds!
-- "debugreb0" written as password restarts the computer (terminating the program is blocked due to security)
-- "debugshutd0" lets the computer shutdown

function clear()
    shell.run("clear")
    term.setTextColor(colors.lime)
	print("- - - - - - - - - Password Access - - - - - - - - -")
    term.setTextColor(colors.white)
    print("")
end

while true do
    clear()
    print("Please enter the Password:")
    print("")
    write(" > ")
    input = read("*")
    print("")
	if input == "debugreb0" then
		shell.run("reboot")
	end
	if input == "debugshutd0" then
		shell.run("shutdown")
	end
    if input == pw then
        term.setTextColor(colors.lime)
        print("                  Granted Access                   ")
        term.setTextColor(colors.white)
        rs.setOutput(sSide, true)
        sleep(3.5)
        rs.setOutput(sSide, false)
	elseif input == pw .. "3600" then
		term.setTextColor(colors.lime)
        print("               Granted Access for 1h               ")
        term.setTextColor(colors.white)
        rs.setOutput(sSide, true)
        sleep(3600)
        rs.setOutput(sSide, false)
    else
        if input == "" then
			term.setTextColor(colors.red)
			print("             Password can't be empty!              ")
			term.setTextColor(colors.white)
			sleep(1.5)
		else
			term.setTextColor(colors.red)
			print("                  Password wrong!                  ")
			term.setTextColor(colors.white)
			sleep(2)
		end
    end
end