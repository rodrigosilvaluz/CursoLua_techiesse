
require "ext_libs.stringUtils"
require "ext_libs.ioUtils"

require "bc"
require "util"

COIN_DIR = "moedas"


function main(...)
    local args = {...}
    if args[1] == "busca" then
        local countryName = args[2]

        local inputFileName = COIN_DIR .. "\\" .. "M" .. os.date("%Y%m%d") .. ".csv"
        local contents = readTextFromFile(inputFileName)
        if contents == nil then
            -- Baixar Arquivo do BC:
        end
        local coins = coinTable(contents)
        print(toString(coins))
    end
end

main(...)
