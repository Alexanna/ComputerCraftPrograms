local confFileName = "movementConf"
os.loadAPI("apis/configAPI.lua")
os.loadAPI("apis/refuelAPI.lua")
os.loadAPI("apis/displayAPI.lua")
local printName = "MovementAPI"

currentPos = vector.new(0,0,0)
homePos = vector.new(0,0,0)

dirNorth = 1
dirEast = 2
dirSouth = 3
dirWest = 4
currentDir = dirNorth

local moveCount = 0

function Refuel()
    refuelAPI.Refuel()
end

function GetConfArray() 
    return {currentDir, "Current Dir: ", currentPos.x,"Current Pos X: ",currentPos.y,"Current Pos Y: ",currentPos.z,"Current Pos Z: ", homePos.x, "Home Pos X: ", homePos.y, "Home Pos Y: ", homePos.z,"Home Pos Z: "}
end

function ApplyConfArray(args)
    currentDir = args[1]
    currentPos.x = args[3]
    currentPos.y = args[5]
    currentPos.z = args[7]
    homePos.x = args[9]
    homePos.y = args[11]
    homePos.z = args[13]
end

function WriteConfFile()
    configAPI.WriteConfFile(confFileName, GetConfArray())
    displayAPI.Write(printName .. ".HomePos","Home Pos  : " .. homePos:tostring())
    displayAPI.Write(printName .. ".CurrentPos","CurrentPos: " .. currentPos:tostring())

    if currentDir == dirNorth then
        displayAPI.Write(printName .. ".CurrentDir","CurrentDir: " .. "North")
    elseif currentDir == dirEast then
        displayAPI.Write(printName .. ".CurrentDir","CurrentPos: " .. "East")
    elseif currentDir == dirSouth then
        displayAPI.Write(printName .. ".CurrentDir","CurrentPos: " .. "South")
    elseif currentDir == dirWest then
        displayAPI.Write(printName .. ".CurrentDir","CurrentPos: " .. "West")
    end
end

function FixDirection(dir)
    if dir > 4 then
        dir = dir - 4
    elseif dir < 1 then
        dir = dir + 4
    end
    
    return dir
end

function Sleep()
    moveCount = moveCount + 1

    if moveCount % 10 == 0 then
        sleep(0)
    end
end

function TurnRight()
    turtle.turnRight()
    currentDir = currentDir + 1
    currentDir = FixDirection(currentDir)
    WriteConfFile()
    Sleep()
end

function TurnLeft()
    turtle.turnLeft()
    currentDir = currentDir - 1
    currentDir = FixDirection(currentDir)
    WriteConfFile()
    Sleep()
end

function TurnDir(dir)
    dir = FixDirection(dir)

    displayAPI.Print(printName, "Want to turn to: " .. dir .. "Current Dir:" .. currentDir)
    --read()

    local turnLeft = (dir == FixDirection(currentDir + 3))

    while dir ~= currentDir do
        if turnLeft then
            TurnLeft()
        else
            TurnRight()
        end
    end
end


function MoveForward(distance, doDig)
    local dig = doDig or false

    displayAPI.Print(printName,"Move Forward: " .. distance)
    
    for i = 1, distance do

        if dig then
            turtle.dig()
        end
        
        local firstAttempt = false
        while not turtle.forward() do
            displayAPI.Print(printName,"Could not move forwards")
            Refuel()

            if not firstAttempt then
                sleep(10)
            end
            
            firstAttempt = true
            if dig then
                turtle.dig()
            end
        end

        if currentDir == dirNorth then
            currentPos.z = currentPos.z - 1

        elseif currentDir == dirEast then
            currentPos.x = currentPos.x + 1

        elseif currentDir == dirSouth then
            currentPos.z = currentPos.z + 1

        elseif currentDir == dirWest then
            currentPos.x = currentPos.x - 1

        end
        WriteConfFile()

        Sleep()
    end    
end

function MoveUp(distance, doDig)
    local dig = doDig or false

    displayAPI.Print(printName,"Move Up:" .. distance)
    
    for i = 1, distance do
        if dig then
            turtle.digUp()
        end

        local firstAttempt = false
        while not turtle.up() do
            displayAPI.Print(printName,"Could not move up")
            Refuel()

            if not firstAttempt then
                sleep(10)
            end

            firstAttempt = true
        end
        currentPos.y = currentPos.y + 1
        WriteConfFile()
        Sleep()

    end
end

function MoveDown(distance, doDig)
    local dig = doDig or false

    displayAPI.Print(printName,"Move Up:", distance)
    for i = 1, distance do

        if dig then
            turtle.digDown()
        end

        local firstAttempt = false
        while not turtle.down() do
            displayAPI.Print(printName,"Could not move down")
            Refuel()

            if not firstAttempt then
                sleep(10)
            end

            firstAttempt = true
        end
        currentPos.y = currentPos.y - 1
        WriteConfFile()
        Sleep()
    end
end

function MoveToPos(targetPos, doDig)
    local dig = doDig or false

    local diffVector =  targetPos - currentPos
    displayAPI.Print(printName,"Move To Position: " .. targetPos:tostring() .. " Current Pos: " .. currentPos:tostring() .. " Dif: " .. diffVector:tostring())
    --read()

    if diffVector.y ~= 0 then
        if diffVector.y > 0 then
            MoveUp(math.abs(diffVector.y), dig)
        else
            MoveDown(math.abs(diffVector.y), dig)
        end
    end
    
    if diffVector.x ~= 0 then

        if diffVector.x > 0 then
            TurnDir(dirEast)
            MoveForward(math.abs(diffVector.x), dig)
        else
            TurnDir(dirWest)
            MoveForward(math.abs(diffVector.x), dig)
        end
    end

    if diffVector.z ~= 0 then
        if diffVector.z > 0  then
            TurnDir(dirSouth)
            MoveForward(math.abs(diffVector.z), dig)
        else
            TurnDir(dirNorth)
            MoveForward(math.abs(diffVector.z), dig)
        end
    end
end

function GoHome(doDig)
local dig = doDig or false
    displayAPI.Print(printName,"Returning Home")
    --read()
    
    MoveToPos(homePos, dig)
end

local confArr = GetConfArray()
configAPI.SetupConfig(confFileName, confArr)
ApplyConfArray(confArr)