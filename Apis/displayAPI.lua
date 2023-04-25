local nameToPos = {}
local count = 1


function Write(name, data)
    local pos = nameToPos[name]
    if pos == nil then
        pos = count
        nameToPos[name] = pos
        count = count + 1
    end
    term.setCursorPos(1,pos)
    term.write("                                                                                                       ")
    term.setCursorPos(1,pos)
    term.write(data)
end

function Print(name, data)
    term.setCursorPos(1,13)
    term.write("                                                                                                       ")
    term.setCursorPos(1,13)
    term.write(data)
end

--term.setCursorBlink(false)

for i = 1, 14 do
    term.setCursorPos(1,i)
    term.write("                                                                                                       ")
end

