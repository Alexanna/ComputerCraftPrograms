page = http.get("https://raw.githubusercontent.com/Alexanna/ComputerCraftPrograms/main/SelfDownloader/fetch.lua")
text = page.readAll();
file = fs.open("apps/fetch.lua", "w")
if string.byte(text) == 63 then text = string.sub(text, 2) end
file.write(text)
file.close()
page.close()
