-- GitHub
-- Pastebin ID is Fdgj43gT

local function printUsage()
    print( "Usages:" )
    print( "github get <code> <filename>" )
    print( "github run <code> <arguments>" )
end
 
local tArgs = { ... }
if #tArgs < 2 then
    printUsage()
    return
end
 
if not http then
    printError( "GitHub requires http API" )
    printError( "Set http_enable to true in ComputerCraft.cfg" )
    return
end
 
local function get(paste)
    write( "Connecting to raw.githubusercontent.com... " )
    local response = http.get(
        "https://raw.githubusercontent.com/"..textutils.urlEncode( paste ) -- Change link to correct GitHub-Link
    )
        
    if response then
        print( "Success." )
        
        local sResponse = response.readAll()
        response.close()
        return sResponse
    else
        printError( "Failed." )
    end
end
 
local sCommand = tArgs[1]
if sCommand == "get" then ---------------------------------------------------------------------------------------------------
    -- Download a file from github.com
    if #tArgs < 3 then
        printUsage()
        return
    end
 
    -- Determine file to download
    local sCode = tArgs[2]
    local sFile = tArgs[3]
    local sPath = shell.resolve( sFile )
    if fs.exists( sPath ) then
        print( "File already exists" )
        return
    end
    
    -- GET the contents from github
    local res = get(sCode)
    if res then        
        local file = fs.open( sPath, "w" )
        file.write( res )
        file.close()
        
        print( "Downloaded as "..sFile )
    end 
elseif sCommand == "run" then ---------------------------------------------------------------------------------------------------
    local sCode = tArgs[2]
 
    local res = get(sCode)
    if res then
        local func, err = load(res, sCode, "t", _ENV)
        if not func then
            printError( err )
            return
        end
        local success, msg = pcall(func, table.unpack(tArgs, 3))
        if not success then
            printError( msg )
        end
    end
else
    printUsage()
    return
end

-- Credits: Copied and edited the pastebin-Program which is delivered with ComputerCraft