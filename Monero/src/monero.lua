
require "ext_libs.stringUtils"
require "ext_libs.ioUtils"

require "util"

local cmd = require "commands"

COIN_DIR = "moedas"

function main(...)
    local args = {...}
    local commandName = args[1]

    args = {select(2, ...)}
    if cmd[commandName] ~= nil then
        cmd[commandName](args)
    else
        print('Comando nao encontrado: ' .. commandName)
        os.exit(1)
    end
end

main(...)
