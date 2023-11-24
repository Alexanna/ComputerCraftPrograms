local confFileName = "loggerConf"
os.loadAPI("apis/configAPI.lua")
os.loadAPI("apis/movementAPI.lua")
os.loadAPI("apis/refuelAPI.lua")
os.loadAPI("apis/gridMoveAPI.lua")
os.loadAPI("apis/displayAPI.lua")
local printName = "Logger"

local treesCut = 0

function GetConfArray()
    return { treesCut, "treesCut: "}
end

function ApplyConfArray(args)
    local i = 1
    treesCut = args[i]
    i = i + 2
end

function WriteConfFile()
    configAPI.WriteConfFile(confFileName, GetConfArray())
end

function ChopTree()
    displayAPI.Write(printName..".IsChopping", "Is Chopping: true")
    turtle.digDown()

    local height = 0
    while turtle.detectUp() do
        movementAPI.MoveUp(1, true)
        height = height + 1
    end
    movementAPI.MoveDown(height, true)

    for i = 1, 4 do
        movementAPI.TurnRight()
        turtle.dig()
    end

    turtle.suckDown()
    turtle.suckDown()
    turtle.suckDown()

    treesCut = treesCut + 1;
    WriteConfFile()
    
    displayAPI.Write(printName..".TreesCut", "Trees Cut: " .. treesCut)
    displayAPI.Write(printName..".IsChopping", "Is Chopping: false")
end

function ChopTrees() 
    while gridMoveAPI.MoveNext(true) do
        local foundBlock, details = turtle.inspectUp()
        
        if foundBlock and details.name == "minecraft:spruce_log" then
            ChopTree()
        end
      
        foundBlock, details = turtle.inspectDown()
        if foundBlock and  details.name ~= "minecraft:spruce_sapling" then
            ChopTree()
            foundBlock = false
        end
      
        if not foundBlock then
            turtle.select(16)
            if turtle.getItemCount() == 0 then
                turtle.select(15)
            end
            turtle.placeDown()
            turtle.select(1)
        end
    end
end

function Main()
    
    local confArr = GetConfArray()
    configAPI.SetupConfig(confFileName, confArr)
    ApplyConfArray(confArr)

    movementAPI.GoHome(true)
    
    while true do
        while rs.getInput("back") do
            displayAPI.Write(printName..".IsWaiting", "Is Waiting: true")
            sleep(10)
        end
        displayAPI.Write(printName..".IsWaiting", "Is Waiting: false")
        
        turtle.select(16)
        turtle.suckDown()
        turtle.select(15)
        turtle.suckDown()
        refuelAPI.RefuelFromChestUp()
        turtle.select(1)
        
        
        movementAPI.MoveForward(1, true)

        for slot = 2, 14 do
            turtle.select(slot)
            turtle.dropDown()
        end

        movementAPI.MoveForward(1, true)

        ChopTrees()
        
    end
end

Main()