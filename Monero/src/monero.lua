
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

        local inputFileName = COIN_DIR .. "\\" .. genCoinTableFileName(day)
        local contents = readTextFromFile(inputFileName)
        if contents == nil then
            print(string.format("Arquivo nao encontrado: %s", inputFileName))
            os.exit()
            -- Baixar Arquivo do BC:
            downloadCoinTable(day, COIN_DIR)
            contents = readTextFromFile(inputFileName)
        end
        local coins = readCoins(contents)
        local filteredCoins = filterCoinsByCountry(coins, string.upper(countryName))
        local validCoins = filterValidCoins(filteredCoins)
        local code = validCoins[1].coinCode

        print("Codigo: " .. code)

    end
end

main(...)


function test()
    downloadCoinTable('20190723', 'moedas')
    downloadQuotationTable('20190723', 'moedas')
end

-- test()
