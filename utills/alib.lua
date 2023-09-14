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
    if fs.exists(path)
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
return {loadingBar=loadingBar,reset=reset,readFile=readFile,printCenter=printCenter,wget=wget}
