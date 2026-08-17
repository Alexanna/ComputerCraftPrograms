local rootURL = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/"
local programList = "programs.json"
local jsonPath = "extlibs/json.lua"
local json
local fetch
local hasGottenJson = false

function fetch.GetJson()
    if hasGottenJson then
        return
    end
    
    page = http.get(rootURL .. jsonPath)
    text = page.readAll();
    file = fs.open(jsonPath, "w")
    if string.byte(text) == 63 then text = string.sub(text, 2) end
    file.write(text)
    file.close()
    page.close()
    json = require("extlib.json")

    hasGottenJson = true
end

function fetch.DownloadAllInList(url)
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

function fetch.Fetch(program)
    fetch.GetJson()
    
    local page = http.get(rootURL .. programList)
    local programListData = page.readAll()
    local file = fs.open(programList, "w")
    if string.byte(programListData) == 63 then programListData = string.sub(programListData, 2) end
    file.write(programListData)
    
    local programListJson = json.decode(programListData)
end


return fetch