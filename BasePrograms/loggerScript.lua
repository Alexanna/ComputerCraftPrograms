local confFileName = "loggerConf"
os.loadAPI("apis/configAPI.lua")
os.loadAPI("apis/movementAPI.lua")
os.loadAPI("apis/refuelAPI.lua")


local treeStartPos = vector.new(0,0,0)
local treeEndPos = vector.new(0,0,0)
local treeDistanceX = 3
local treeDistanceZ = 3
local startForward = movementAPI.dirNorth

local arrLength = 0
local arrWidth = 0

local treeVecArr = {}

function GetConfArray()
    return {startForward, "startForward: ", treeDistanceX, "treeDistanceX: ", treeDistanceZ, "treeDistanceZ: ", treeStartPos.x,"treeStartPos X: ",treeStartPos.y,"treeStartPos Y: ",treeStartPos.z,"treeStartPos Z: ", treeEndPos.x, "treeEndPos X: ", treeEndPos.y, "treeEndPos Y: ", treeEndPos.z,"treeEndPos Z: "}
end

function ApplyConfArray(args)
    local i = 1
    startForward = args[i]
    i = i + 2
    treeDistanceX = args[i]
    i = i + 2
    treeDistanceZ = args[i]
    i = i + 2
    treeStartPos.x = args[i]
    i = i + 2
    treeStartPos.y = args[i]
    i = i + 2
    treeStartPos.z = args[i]
    i = i + 2
    treeEndPos.x = args[i]
    i = i + 2
    treeEndPos.y = args[i]
    i = i + 2
    treeEndPos.z = args[i]
end

function WriteConfFile()
    configAPI.WriteConfFile(confFileName, GetConfArray())
end

function SetupTreeArray()
    print("Setting up array", treeStartPos, treeEndPos)
    
    local dif = treeEndPos - treeStartPos
    
    print(dif,(1.0 / treeDistanceX),(1.0 / treeDistanceZ))
    
    local difNormalized = vector.new(dif.x  * (1.0 / treeDistanceX), 0, dif.z  * (1.0 / treeDistanceZ))
    print(difNormalized)
    
    local dirLength = 0
    if difNormalized.x > 0 then
        dirLength = 1
    else
        dirLength = -1
    end

    local dirWidth = 0
    if difNormalized.z > 0 then
        dirWidth = 1
    else
        dirWidth = -1
    end
    
    arrLength = math.floor(math.abs(difNormalized.x)) + 1
    arrWidth = math.floor(math.abs(difNormalized.z)) + 1

    print("Array: ",dif, difNormalized, dirLength, dirWidth, arrLength, arrWidth)
    
    for i = 1, arrLength do
        treeVecArr[i] = {}
        for j = 1, arrWidth do
            treeVecArr[i][j] = treeStartPos + vector.new(treeDistanceX * (i - 1) * dirLength, 0, treeDistanceZ * (j - 1) * dirWidth)
        end
    end
    
    print("Done setting up array")
end

function ChopTree()
    print("Chopping")
    
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
end

function ChopTrees() 
    
    local startWidth = 1
    local direction = 1
    local endTarget = arrWidth
    
    for currentL = 1, arrLength do
        for currentW = startWidth, endTarget, direction do
            local treePos = treeVecArr[currentL][currentW]

            print("Going to tree: ", treePos)

            movementAPI.MoveToPos(treePos, true)

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
        
        if direction == 1 then
            startWidth = arrWidth
            direction = -1
            endTarget = 1
        else
            startWidth = 1
            direction = 1
            endTarget = arrWidth
        end
    end
end

function Main()
    
    local confArr = GetConfArray()
    configAPI.SetupConfig(confFileName, confArr)
    ApplyConfArray(confArr)

    SetupTreeArray()
    
    while true do
        movementAPI.GoHome(true)
        movementAPI.TurnDir(startForward)

        while rs.getInput("back") do
            sleep(10)
        end
        
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

        print("Sleeping 0 seconds")
        --sleep(0)

        movementAPI.MoveForward(1, true)

        ChopTrees()
        
        movementAPI.MoveForward(1, true)
    end
end



Main()