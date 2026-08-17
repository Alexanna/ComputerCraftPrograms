local appName = ...

package.path = package.path .. ";../?;../?.lua;../?/init.lua"

local rootURL = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/"
local programList = "programs.json"
local jsonPath = "extlib/json.lua"
local json = {}
local fetch = {}
local hasGottenJson = false
local hasGottenList = false
local programListJson

function fetch.Download(path)
    local page = http.get(rootURL .. path)
    local text = page.readAll();
    local file = fs.open(path, "w")
    if string.byte(text) == 63 then text = string.sub(text, 2) end
    file.write(text)
    file.close()
    page.close()
    return text
end

function fetch.GetJson()
    if hasGottenJson then
        return
    end
    fetch.Download(jsonPath)
    json = require("extlib.json")
    hasGottenJson = true
end

function fetch.UpdateList(force)
    force = force or false
    if hasGottenList and not force then
        return
    end
    fetch.GetJson()

    local programListData = fetch.Download(programList)
    programListJson = json.decode(programListData)
    hasGottenList = true
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

function fetch.Fetch(programName)
    fetch.UpdateList()

    local program = programListJson[programName]
    print("Fetching:" .. programName)

    if type(program["dependencies"]) == "table" then
        for i, v in pairs(program["dependencies"]) do
            fetch.Fetch(i)
        end
    end

    
    for i, v in pairs(program["files"]) do
        fetch.Download(i)
    end
    
end

fetch.Fetch(appName)

return fetch