Args = {...}
CX,CY=term.getCursorPos()
function bar(procent,title,subTitle)
    MX,MY=term.getSize()
    if title ~= nil then
        term.clearLine()
        print(title)
    else
        print("")
    end
    if subTitle ~= nil then
        term.clearLine()
        print(subTitle)
    else
        print("")
    end
    if procent ~= nil then
        term.clearLine()
        BX,BY=term.getCursorPos()
        print(string.rep(" ",MX))
        term.setCursorPos(BX,BY)
        print(string.rep("#",MX*procent))
    end
    term.setCursorPos(CX,CY)
end
function compact()
    Content = {}
    Root=""
    if Args[4] ~= nil then
        if fs.exists(Args[4]) then
            Ignore={Args[4]}
            local h = fs.open(Args[4],"r")
            while true do
                sleep(0)
                local i = h.readLine()
                if i == nil then break end
                Ignore[#Ignore+1] = i
            end
            h.close()
        else
            print("Path",Args[4],"not found!")
            return false
        end
    else
        Ignore={}
    end
    print("Please enter a destination path for the output:")
    Destination=read()
    function compileTree(Path)
        if Path == nil then Path = "" end
        bar(0,"Scanning folders",Path)
        print(Root,"/",Path)
        local folder = fs.list(Path)
        for file=1,#folder do
            local illegalFile = false
            bar((file/#folder),"Scanning folders",folder[file])
            for illegalFileNr=1,#Ignore do
                if folder[file] == Ignore[illegalFileNr] then
                    illegalFile = true
                    break
                end
            end
            if not illegalFile then
                if fs.isDir(Path.."/"..folder[file]) then
                    compileTree(Path.."/"..folder[file])
                else
                    local data = {}
                    local h=fs.open(Path.."/"..folder[file],"r")
                    counter=0
                    while true do
                        counter=counter+1
                        bar(0,"Reading file",folder[file])
                        if h==nil then
                            sleep(1)
                            error("Failed to read "..Path.."/"..folder[file])
                        end
                        i=h.readLine()
                        if i == nil then break else
                            data[#data+1] = i
                            if counter > 499 then
                                sleep(0)
                                counter=0
                            end
                        end
                    end
                    h.close()
                    print(Path)
                    Content[#Content+1]={Path.."/"..folder[file],data}
                end
            end
        end
    end
    if Args[2] == "." or Args[2] == "./" then
        compileTree(nil)
    else
        compileTree(Args[2])
    end
    Counter=1
    Pass=0
    function translateTree(dataTable)
        for i=1,Counter do
            for i=1,#dataTable do
                Pass=Pass+1
                if type(dataTable[i][1]) == "table" then
                    dataTable[i]=table.unpack(dataTable[i])
                    Counter=Content+1
                end
            end
        end
    end
    for j=1,#Content do
        translateTree(Content)
        bar((j/#Content),"Translateing files","Pass:"..Pass)
        sleep(0)
    end
    Counter=0
    function saveFile()
        h=fs.open(Destination,"w")
        for i=1,#Content do
            local p,d=table.unpack(Content[i])
            bar((i/#Content),"Saveing to OFS file",i)
            h.writeLine(p)
            h.writeLine(#d)
            for j=1,#d do
                Counter=Counter+1
                h.writeLine(d[j])
                if Counter > 199 then
                    sleep(0)
                    Counter = 0
                end
            end
        end
        h.close()
    end
    saveFile()
    if Args[3] == "-ACHF" then
        local alib = require "alib"
        alib.CharcodeFile(Destination,Destination)
        alib.CharfileToHexfile(Destination,Destination)
        alib.HexfileToACHF(Destination,Destination)
    elseif Args[3] == "-HF" then
        local alib = require "alib.lua"
        alib.CharcodeFile(Destination,Destination)
        alib.CharfileToHexfile(Destination,Destination)
    elseif Args[3] == "-CF" then
        local alib = require "alib.lua"
        alib.CharcodeFile(Destination,Destination)
    end
end
if #Args < 2 then
    print("Usage: OFS.lua <mode> <input> {mntPoint/compmode} {ofsIgnoreFilePath}")
    print("Modes:")
    print("-c compacts <input> into output.OFS with compression [compmode]")
    print("-e extracts <input> into the folder <mntPoint>")
    print("Comp modes (requires alib.lua):")
    print("-ACHF")
    print("-HF")
    print("-CF")
    return false
end
function extract(OFS,DEST)
    if fs.exists(OFS) then
        h=fs.open(OFS,"r")
        local data={}
        Counter = 0
        while true do
            Counter = Counter + 1
            local line=h.readLine()
            if line == nil then break end
            data[#data+1]=line
            if Counter > 199 then
                Counter = 0
                sleep(0)
            end
        end
        h.close()
        shell.run("mkdir",DEST)
        Path=""
        Len=0
        Stage=1
        local function writeToFile(FilePath,Len,start,raw)
            Counter=0
            h=fs.open(DEST..Path,"w")
            for i=0,Len do
                Counter=Counter+1
                if Counter > 499 then
                    sleep(0)
                    Counter=0
                end
                h.writeLine(raw[start+i])
            end
            h.close()
        end
        line=0
        while true do
            line=line+1
            if line==#data then break end
            bar((line/#data),"Extracting OFS file","")
            if Stage == 1 then
                Stage=2
                Path=data[line]
            elseif Stage == 2 then
                Len=tonumber(data[line])
                Stage=3
            elseif Stage == 3 then
                if Path == nil then break end
                writeToFile(DEST..Path,Len,line,data)
                Stage=1
                line=line+Len-1
            end
        end
    else
        print("File not found")
        return false
    end
end
if Args[1] == "-c" then
    compact()
elseif Args[1] == "-e" then
    if #Args < 3 then
        print("Too few arguments")
        return false
    end
    extract(Args[2],Args[3])
else
    print("Not a mode")
    print("Modes: -c & -e")
    return false
end
