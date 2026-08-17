local rootURL = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/"
local programList = "programs.cfg"
local json =require("ExternalLibs/json.lua")


function GetUrlTable(url)
    return http.get(url)
end

function DownloadAllInList(url)
    local listTable = GetUrlTable(rootURL .. url)
    local line = listTable.readLine()
    while line ~= nill and #line > 0 do
        local page = http.get(rootURL .. line)
        local text = page.readAll();
        local file = fs.open(line, "w")
        if string.byte(text) == 63 then text = string.sub(text, 2) end
        file.write(text)
        file.close()
        page.close()
        line = listTable.readLine()
    end
end

function Fetch(program)
    local page = http.get(rootURL .. programList)
    local programListData = page.readAll()
    local programListJson = json.decode(programListData)
    
    
end