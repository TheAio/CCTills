local password = "password"
term.setCursorPos(1,1)
print("Booting into PR")
local unsafeLib = {
fs.open
}
local autoOkConfigPath = "/pr/fs/autoOk.conf"
local autoOkList = {}
local autoOkConfigHandler = unsafeLib[1]("/pr/fs/autoOk.conf","r")
if autoOkConfigHandler == nil then
    autoOkList = {}
else
    while true do
        local i = autoOkConfigHandler.readLine()
        if i == nil then break end
        autoOkList[#autoOkList+1] = i
    end
    autoOkConfigHandler.close()
end

function fs.open(path,mode)
    for i=1,#autoOkList do
        if path == autoOkList[i] then
            return unsafeLib[1](path,mode)
        end
    end
    printError("-- PR --")
    printError("Request to open non-config file")
    printError("Request is to open",path)
    printError("in mode",mode)
    printError("Enter password to allow")
    printError("--------")
    if read("*") == password then
        return unsafeLib[1](path,mode)
    end
end
sleep(0)
term.clear()
textutils.slowPrint("Welcome to protected runtime!")
