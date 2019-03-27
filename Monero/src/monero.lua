
require "ext_libs.stringUtils"
require "ext_libs.ioUtils"

require "bc"
require "util"

COIN_DIR = "moedas"


function main(...)
    local args = {...}
    if args[1] == "busca" then
        local countryName = args[2]
        local day = args[3] or os.date("%Y%m%d")

        local inputFileName = COIN_DIR .. "\\" .. "M" .. day .. ".csv"
        local contents = readTextFromFile(inputFileName)
        if contents == nil then
            print(string.format("Arquivo nao encontrado: %s", inputFileName))
            os.exit()
            -- Baixar Arquivo do BC:
        end
        local coins = readCoins(contents)
        local filteredCoins = filterCoinsByCountry(coins, string.upper(countryName))
        local validCoins = filterValidCoins(filteredCoins)
        local code = validCoins[1].coinCode

        print("Codigo: " .. code)

    end
end

main(...)
