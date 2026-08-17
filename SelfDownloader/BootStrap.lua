page = http.get("https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/SelfDownloader/Fetch.lua")
text = page.readAll();
file = fs.open("Fetch.lua", "w")
if string.byte(text) == 63 then text = string.sub(text, 2) end
file.write(text)
file.close()
page.close()

page = http.get("https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/ExternalLibs/json.lua")
text = page.readAll();
file = fs.open("ExternalsLibs/json.lua", "w")
if string.byte(text) == 63 then text = string.sub(text, 2) end
file.write(text)
file.close()
page.close()