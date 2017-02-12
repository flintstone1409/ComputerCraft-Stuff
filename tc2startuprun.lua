-- TechCompany2 StartupRun
-- Pastebin ID is 

function get(sCode)
	write( "Connecting to Server... " )
	local response = http.get( textutils.urlEncode( sCode ) )

	if response then
		print( "Success." )
	
		local sResponse = response.readAll()
		response.close()
		return sResponse
	else
		printError( "Failed." )
	end
end
function dw(sURL, sFile)
	if not http then
		printError( "This setup requires http API" )
		printError( "Set http_enable to true in ComputerCraft.cfg" )
		return
	end

	local sPath = shell.resolve( sFile )
	if fs.exists( sFile ) then
		print( "File already exists" )
		return
	end

	local res = get(sURL)
	if res then        
		local file = fs.open( sFile, "w" )
		file.write( res )
		file.close()
		print( "Downloaded as "..sFile )
	end
end

dw("http://flintstone1409.de/" .. Programmname, Ziel)