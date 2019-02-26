

function readTextFromFile(fileName)
    local file = io.open(fileName, "r")
    if file == nil then
        return nil, "Nao foi possivel abrir o arquivo " .. fileName
    end

    local contents = file:read("*a")
    file:close()
    return contents
end


function saveTextToFile(text, fileName)
    local file = io.open(fileName, "w")
    local res = file:write(text)
    file:close()
    return res
end
