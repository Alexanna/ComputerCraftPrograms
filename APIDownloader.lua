local apiList = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/ApiUrlList.txt"
local programList = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/ProgramUrlList.txt"
local configList = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/ConfigUrlList.txt"

local page = http.get("https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/Apis/configAPI.lua")
local file = fs.open("downloads/tests/configAPI.lua", "w")

if file then
    file.write(page.readAll())
    file.close()
end

function GetUrlTable(url)
    return http.get(url)
end

function DownloadAllInList(url)
    local listTable = getUrlTable(url)
    local line = listTable.readLine()
    while line ~= nill and #line > 0 do
        local urlTable = GetUrlTable(line)
        
        
        line = listTable.readLine()
    end
end

function APIs()
    
end

function Programs()
    
end

function Configs()
    
end 

function All()
    
end