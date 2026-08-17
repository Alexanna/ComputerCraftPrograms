os.loadAPI("Apis/displayAPI.lua")
local printName = "ConfigAPI"

local confPath = "Configs/"
local confExtension = ".cfg"

function GetInputNumber(displayTest)
    write(displayTest)
    return tonumber(read())
end

function SetupConfig(confName, args)

    if(not fs.exists(confPath .. confName .. confExtension)) then
        displayAPI.Print(printName, "Config for '" .. confName .. "' could not be found.")
        displayAPI.Print(printName, "Doing setup now:")

        for i = 1, #args, 2 do
            args[i] = GetInputNumber(args[i + 1])
        end

        WriteConfFile(confName, args)
        return true
    else
        ReadConfFile(confName, args)
        return false
    end
end

function ReadConfFile(confName, args)
    displayAPI.Print(printName, "Reading config: '" .. confName .. "'")

    local confFile = fs.open(confPath .. confName .. confExtension, "r")

    if confFile then
        displayAPI.Print(printName, "Reading File")

        for i = 1, #args, 2 do
            confFile.readLine() -- header
            args[i] = tonumber(confFile.readLine())
        end
        
        confFile.close()
    end
end


function ReadToEndFile(confName, args)
    displayAPI.Print(printName, "Reading config: '" .. confName .. "'")

    local confFile = fs.open(confPath .. confName .. confExtension, "r")

    if confFile then
        displayAPI.Print(printName, "Reading File")

        table.remove(args)
        local line = confFile.readLine()
        while line ~= nil and #line > 0 do
            table.insert(args, line)
            line = confFile.readLine()
        end
        confFile.close()
    end
end

function WriteConfFile(confName, args)
    local confFile = fs.open(confPath .. confName .. confExtension, "w")

    if confFile then
        for i = 1, #args, 2 do
            confFile.writeLine(args[i + 1]) -- header
            confFile.writeLine(args[i])
        end
        confFile.close()
    end

    displayAPI.Print(printName, "Wrote to config: '" .. confName .. "'")
end