local rootURL = "https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/"
local apiList = "ApiUrlList.txt"
local programList = "ProgramUrlList.txt"
local configList = "ConfigUrlList.txt"

page = http.get("https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/APIDownloader.lua")
file = fs.open("APIDownloader.lua", "w")
file.write(page.readAll())
file.close()
page.close()

function GetUrlTable(url)
    return http.get(url)
end

function DownloadAllInList(url)
    local listTable = GetUrlTable(rootURL .. url)
    local line = listTable.readLine()
    while line ~= nill and #line > 0 do
        local page = http.get(rootURL .. line)
        local file = fs.open(line, "w")
        file.write(page.readAll())
        file.close()
        page.close()
        line = listTable.readLine()
    end
end

function APIs()
    DownloadAllInList(apiList)
end

function Programs()
    DownloadAllInList(programList)
end

function Configs()
    DownloadAllInList(configList)
end 

function All()
    APIs()
    Programs()
    Configs()
end