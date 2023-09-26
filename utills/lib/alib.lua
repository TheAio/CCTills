--alib - aios code library
function loadingBar(procent,title,subTitle,ResetX,ResetY)
    local MX,MY=term.getSize()
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
    term.setCursorPos(ResetX,ResetY)
    return true
end
function reset(resetColor)
    term.setCursorPos(1,1)
    if resetColor then
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
    end
    term.clear()
    return true
end
function readFile(path)
    local data={}
    if fs.exists(path) then
        h=fs.open(path,"r")
        while true do
            i=h.readLine()
            if i==nil then break else
                data[#data+1]=i
            end
        end
        h.close()
        return data
    else
        return false
    end
end
function CharcodeFile(path,output)
    if output == nil or path == nil then
        error("alib: argument error")
    end
    local data=readFile(path)
    if data == false then
        error("alib: read error")
    else
        print("Prepering data...")
        for line=1,#data do
            data[line] = data[line].."\n"
        end
        local h=fs.open(output,"w")
        print("Compiling...")
        local st=os.time()
        for line=1,#data do
            for char=1,string.len(data[line]) do
                if os.time()-st > 0.21 then
                    print((line/#data)*(char/string.len(data[line])))
                    sleep(0)
                    st=os.time()
                end
                h.writeLine(string.byte(string.sub(data[line],char,char)))
            end
        end
        h.close()
    end
end
function UnCharcodeFile(path,output)
    if output == nil or path == nil then
        error("alib: argument error")
    end
    local data=readFile(path)
    if data == false then
        error("alib: read error")
    else
        local h=fs.open(output,"w")
        local line={}
        for lineNr=1,#data do
            if tonumber(data[lineNr]) == nil then error("File is non-binary and can not be computed in a binary perspective.") end
            if data[lineNr] == "10" then
                h.writeLine(table.concat(line))
                line={}
            else
                line[#line+1] = string.char(tonumber(data[lineNr]))
            end
            sleep(0)
        end
        h.close()
    end
end
function BinaryToDecimal(binary)
    if _VERSION ~= "Lua 5.1" then
        error("alib: Incompatible lua version expected Lua 5.1 got ".._VERSION.."! Sorry :(")
    end
    binary=tostring(binary)
    local res=0
    for digit=0,string.len(binary)-1 do
        local currentDigit=string.len(binary)-digit
        res=res+(tonumber(string.sub(binary,currentDigit,currentDigit)))*math.pow(2,digit)
    end
    return res
end
function DecimalToHex(decimal)
    local hexTable={{"A",10},{"A",11},{"C",12},{"D",13},{"E",14},{"F",15}}
    local res={}
    if tonumber(decimal) < 10 then
        return tostring(decimal)
    end
    decimal=tonumber(decimal)
    local st = os.time()
    while true do
        if os.time()-st > 0.21 then
            sleep(0)
            st=os.time
        end
        local intQuo=math.floor(decimal/16)
        local decRem=math.mod(decimal,16)
        if decRem > 10 then
            for i=1,#hexTable do
                if decRem == hexTable[i][2] then
                    res[#res+1] = hexTable[i][1]
                end
            end
        else
            res[#res+1] = tostring(decRem)
        end
        if intQuo == 0 then
            break
        else
            decimal = intQuo
        end
    end
    local ret=""
    for i=0,#res-1 do
        ret=ret..res[#res-i]
    end
    return ret
end
function CharfileToHexfile(path,output)
    if output == nil or path == nil then
        error("alib: argument error")
    end
    local data=readFile(path)
    if data == false then
        error("alib: read error")
    else
        local h=fs.open(output,"w")
        local line={}
        local st=os.time()
        for lineNr=1,#data do
            if tonumber(data[lineNr]) == nil then error("File is char coded and can not be computed in a char coded perspective.") end
            h.writeLine(DecimalToHex(data[lineNr]))
            if os.time()-st > 0.21 then
                print(math.floor(100*(lineNr/#data)),"%")
                sleep(0)
                st=os.time()
            end
        end
        print("Wrote:",#data/1000,"k lines")
        h.close()
    end
end
function HexfileToACHF(path,output)
    if output == nil or path == nil then
        error("alib: argument error")
    end
    local data=readFile(path)
    if data == false then
        error("alib: read error")
    else
        local specialTab = 
        {"!","#","%","&","/","(",")","=","?","<",">","@","$","{","}","^","~","*","|","G","H","I","J","K","L",
        "M","N","O","P","Q","R","S","T","V","W","X","Y","Z","_",".",",",";",":","-","a","b","c","d","e","f",
        "g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
        local h=fs.open(output,"w")
        local matches={}
        local newData={}
        local st=os.time()
        for line=1,#data do
            
            local hasMatch = false
            for i=1,#matches do
                if data[line] == matches[i][1] then
                    hasMatch = true
                    newData[#newData+1] = matches[i][2]
                end
            end
            if not hasMatch then
                if #matches < #specialTab then
                    matches[#matches+1] = {data[line],specialTab[#matches]}
                    newData[#newData+1] = data[line]..specialTab[#matches]
                else
                    newData[#newData+1] = data[line]
                end
            end
            if os.time()-st > 0.21 then
                print(line/#data)
                sleep(0)
                st=os.time()
            end
        end
        for i=1,#newData do
            h.writeLine(newData[i])
        end
        h.close()
    end
end
function ACHFToHexfile(path,output)
    if output == nil or path == nil then
        error("alib: argument error")
    end
    local data=readFile(path)
    if data == false then
        error("alib: read error")
    else
        local specialTab = 
        {"!","#","%","&","/","(",")","=","?","<",">","@","$","{","}","^","~","*","|"}
        local h=fs.open(output,"w")
        local matches={}
        for line=1,#data do
            local newData={}
            local isMatcher=false
            if string.len(data[line]) > 1 then
                for char=1,#specialTab do
                    if string.sub(data[line],string.len(data[line]),string.len(data[line])) == specialTab[char] then
                        matches[#matches+1] = {specialTab[char],string.sub(data[line],1,string.len(data[line])-1)}
                        isMatcher = true
                        break
                    end
                end
            end
            if isMatcher then
                newData[#newData+1] = string.sub(data[line],1,string.len(data[line])-1)
            else
                local foundMatch=false
                for char=1,#matches do
                    if data[line] == matches[char][1] then
                        newData[#newData+1] = matches[char][2]
                        foundMatch=true
                    end
                end
                if not foundMatch then
                    newData[#newData+1] = data[line]
                end
            end
            h.writeLine(table.concat(newData))
        end
        h.close()
    end
end
function printCenter(str,centerVert,customY)
    local MX,MY = term.getSize()
    local X = (MX/2)-(string.len(str)/2)
    if centerVert then
        term.setCursorPos(X,MY/2)
    else
        term.setCursorPos(X,customY)
    end
    return true
end
function wget(url,path,runAfterSave)
    shell.run("wget",url,path)
    if runAfterSave then
        shell.run(path)
    end
end
return {loadingBar=loadingBar,reset=reset,readFile=readFile,printCenter=printCenter,wget=wget,ACHFToHexfile=ACHFToHexfile,
HexfileToACHF=HexfileToACHF,CharfileToHexfile=CharfileToHexfile,DecimalToHex=DecimalToHex,BinaryToDecimal=BinaryToDecimal,
UnCharcodeFile=UnCharcodeFile,CharcodeFile=CharcodeFile}
