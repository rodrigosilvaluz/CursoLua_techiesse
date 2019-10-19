local path = {}

path.SEPARATOR = package.config:sub(1, 1)

function path.join(...)
    local parts = {...}
    if type(parts[1]) == 'table' then
        parts = parts[1]
    end
    return table.concat(parts, path.SEPARATOR)
end

return path
