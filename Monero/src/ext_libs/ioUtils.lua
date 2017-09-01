
local ioUtils = {}


function ioUtils.readTextFromFile(fileName)
    local file = io.open(fileName, "r")
    if file == nil then
        error("Nao foi possivel abrir o arquivo " .. fileName, 2)
    end

    local contents = file:read("*a")
    file:close()
    return contents
end


function ioUtils.saveTextToFile(text, fileName)
    local file = io.open(fileName, "w")
    local res = file:write(text)
    file:close()
    return res
end


return ioUtils
