
CURL_EXEC = [[C:\Techiesse\Cursos\Lua\code\Monero\bin\curl-7.65.3-win64-mingw\bin\curl]]
COIN_TABLE_BASE_URL =  [[https://www4.bcb.gov.br/Download/fechamento]]
function genCoinTableFileName(day)
    return "M" .. day .. ".csv"
end

function genQuotationFileName(day)
    return day .. ".csv"
end

function downloadCoinTable(day, destDir)
    local fileName = genCoinTableFileName(day)
    local url = COIN_TABLE_BASE_URL .. '/' .. fileName
    downloadFile(url, destDir)
end


function downloadQuotationTable(day, destDir)
    local fileName = genQuotationFileName(day)
    local url = COIN_TABLE_BASE_URL .. '/' .. fileName
    downloadFile(url, destDir)
end


function downloadFile(url, destDir, fileName)
    fileName = fileName or string.match(url, '/([%w\.]+)$')
    local downloadCommand = string.format('%s -o %s\\%s %s 2>nul', CURL_EXEC, destDir, fileName, url)
    os.execute(downloadCommand)
    --os.execute(CURL_EXEC .. ' -o ' .. destDir .. '\\' .. fileName .. ' ' .. url .. ' 2>nul')
end


function toString(tbMoedas)
    local result = ""
    for i, coin in ipairs(tbMoedas) do
        result = result .. "Cod coin: " .. (coin.coinCode or "") .. "\n"
        result = result .. "Nome: " .. (coin.name or "") .. "\n"
        result = result .. "Simbolo: " .. (coin.symbol or "") .. "\n"
        result = result .. "Cod Pais: " .. (coin.countryCode or "") .. "\n"
        result = result .. "Pais: " .. (coin.country or "") .. "\n"
        result = result .. "Tipo Moeda: " .. (coin.coinType or "") .. "\n"
        result = result .. "Data Exlusao: " .. (coin.exclusionDate or "") .. "\n"
        result = result .. "\n"
    end
    return result
end


function readCoins(csvContents)
    local lines = split(csvContents, "\r?\n")
    table.remove(lines, 1) -- Removendo line de cabeçalho

    local coins = {}
    for i, line in ipairs(lines) do

        local coinFields = split(line, ";")
        if coinFields[2] ~= nil then
            local coin =
            {
                coinCode = trim(coinFields[1]),
                name = trim(coinFields[2]),
                symbol = trim(coinFields[3]),
                countryCode = trim(coinFields[4]),
                country = trim(coinFields[5]),
                coinType = trim(coinFields[6]),
                exclusionDate = trim(coinFields[7]),
            }
            table.insert(coins, coin)
        end
    end

    return coins
end



function filterCoinsByCountry(coins, country)
    local ret = {}
    for i, coin in ipairs(coins) do
        if coin.country == country then
            table.insert(ret, coin)
        end
    end

    return ret
end


function filterValidCoins(coins)
    local ret = {}
    for i, coin in ipairs(coins) do
        if #coin.exclusionDate == 0 then
            table.insert(ret, coin)
        end
    end

    return ret
end


