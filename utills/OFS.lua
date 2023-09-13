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
    function compileTree(Path)
        if Path == nil then Path = "" end
        bar(0,"Scanning folders",Path)
        print(Root,"/",Path)
        local folder = fs.list(Path)
        for file=1,#folder do
            bar((file/#folder),"Scanning folders",folder[file])
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
        h=fs.open("output.OFS","w")
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
end
if #Args < 2 then
    print("Usage: OFS.lua <mode> <input> {mntPoint}")
    print("Modes:")
    print("-c compacts <input> into output.OFS")
    print("-e extracts <input> into the folder <mntPoint>")
    return false
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
