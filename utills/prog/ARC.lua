Args={...}
--ARC AiosRemoteControll
--Setup OTP first!
if not fs.exists("skynet") then
    print("skynet seems to be missing!")
    print("Y - install it")
    print("n - continue anyways")
    if string.upper(read()) == "Y" then
        if fs.exists("APM2") then
            shell.run("APM2 install skynet")
        else
            shell.run("wget https://raw.githubusercontent.com/osmarks/skynet/master/client.lua skynet")
        end
    end
end
if #Args < 5 then
    print("--TOO FEW ARGUMENTS--")
    print("To send:")
    print("ARC TX channel password OTP command")
    print("To receive:")
    print("ARC RX channel password logfile OTP")
    print("To make a OTP file:")
    print("ARC OTP path num2 num3 num4")
    return false
end
if Args[1] == "OTP" then
    local h=fs.open(Args[2],"w")
    local j = fs.open("rom/startup.lua","r")
    local k={}
    for i=tonumber(Args[3]),tonumber(Args[4]) do
        A=j.readLine()
        if A == nil then
            j.close()
            local j = fs.open("rom/startup.lua","r")
        end
    end
    k[#k+1] = A
    print(A)
    for i=tonumber(Args[4]),tonumber(Args[5]) do
        A=j.readLine()
        if A == nil then
            j.close()
            local j = fs.open("rom/startup.lua","r")
        end
    end
    j.close()
    print(A)
    k[#k+1] = A
    local out = table.concat(k)..table.concat(k)..table.concat(k)..table.concat(k)..table.concat(k)
    for i=1,string.len(out) do
        h.writeLine(string.byte(string.sub(out,i,i)))
    end
    h.close()
    error("")
end
Sky = require "skynet"
function FetchOTP(path)
    local h = fs.open(path,"r")
    local k = math.floor(os.time())
    for _=1,k do
        h.readLine()
    end
    local i = h.readLine()
    print("OTP READ IS",i,"@",math.floor(os.time()))
    h.close()
    return i
end
if Args[1] == "TX" then
    Sky.send(tonumber(Args[2]),Args[3]..FetchOTP(Args[4])..Args[5])
    return true
else
    local passLen = string.len(Args[3])
    local counter = 0
    while true do
        local h = fs.open(Args[4],"w")
        h.writeLine("OK")
        print("OK")
        CH,MSG = Sky.receive(tonumber(Args[2]))
        print(MSG)
        if tonumber(CH) == tonumber(Args[2]) then
            local otp = FetchOTP(Args[5])
            print("OTP =",otp,"@",os.time())
            local otpLen = string.len(otp)
            if string.sub(MSG,1,passLen) == Args[3] then
                if string.sub(MSG,passLen+1,passLen+otpLen) == otp then
                    local cmd = string.sub(MSG,passLen+otpLen+1,string.len(MSG))
                    h.writeLine("COMMAND > "..cmd)
                    h.writeLine(os.time())
                    if cmd == "QUIT" then
                        h.close()
                        error("QUIT COMMAND")
                    end
                    shell.run(cmd)
                    counter = 0
                else
                    counter=counter+1
                    print("-FAILED OTP-")
                    h.writeLine("-FAILED OTP-")
                    h.writeLine(os.time())
                    Sky.send(tonumber(Args[2]),">ARC A FAILED OTP VALUE, TRY AGAIN SOON!")
                    h.writeLine("-FAIL2BAN ACTIVE-")
                    h.writeLine(os.time())
                    sleep(5)
                end
            else
                print("-FAILED LOGIN-")
                counter=counter+1
                h.writeLine("-FAILED LOGIN-")
                h.writeLine(os.time())
                if counter > 2 then
                    Sky.send(tonumber(Args[2]),">ARC GOT 3 FAILED LOGIN ATTEMPTS, FAIL2BAN ACTIVATED!")
                    h.writeLine("-FAIL2BAN ACTIVE-")
                    h.writeLine(os.time())
                    sleep(240)
                    counter = 0
                end
            end
        end
        h.close()
    end
end
