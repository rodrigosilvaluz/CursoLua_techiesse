

function proper(str)
    return string.upper(string.sub(str, 1, 1)) .. string.lower(string.sub(str, 2, -1))
end


print(proper("AGUA"))
print(proper("agua"))