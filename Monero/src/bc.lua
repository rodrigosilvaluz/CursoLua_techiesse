
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


function readQuotationTable(quotationTableContent)
    local quotations = {}
    local lines = split(trim(quotationTableContent), '\n')
    for i, line in ipairs(lines) do
        table.insert(quotations, readQuotation(line))
    end
    return quotations
end

function readQuotation(quotationLine)
    -- 26/07/2019;005;A;AFN;0,04720000;0,04732000;79,75000000;79,95000000
    -- Data;Codigo;Tipo;Simbolo;Tx Compra;Tx Venda;P Compra;P Venda
    local fields = split(quotationLine, ';')
    local quotation =
    {
        coinCode = trim(fields[2]),
        coinType = trim(fields[3]),
        coinSymbol = trim(fields[4]),
        buyRate = bcPriceToNumber(trim(fields[5])),
        sellRate = bcPriceToNumber(trim(fields[6])),
        buyParity = bcPriceToNumber(trim(fields[7])),
        sellParity = bcPriceToNumber(trim(fields[8])),
    }
    return quotation
end


function bcPriceToNumber(bcPrice)
    local cleanedPrice = string.gsub(bcPrice, ',', '.')
    return tonumber(cleanedPrice)
    -- return tonumber((string.gsub(bcPrice, ',', '.')))
end


function showQuotation(quotation)
    return table.concat(
        {
            string.format('Moeda: %s (%s)', quotation.coinSymbol ,quotation.coinType),
            string.format('Taxa     => Compra: %s, Venda: %s', quotation.buyRate, quotation.sellRate),
            string.format('Paridade => Compra: %s, Venda: %s', quotation.buyParity, quotation.sellParity),
        },
        '\n'
    )
end


function toDollar(amount, srcQuotation)
    if srcQuotation.coinType == 'A' then
        return amount / srcQuotation.sellParity
    else
        return amount * srcQuotation.sellParity
    end
end


function fromDollar(amount, destQuotation)
    if destQuotation.coinType == 'A' then
        return amount * destQuotation.sellParity
    else
        return amount / destQuotation.sellParity
    end
end


function convert(amount, srcQuotation, destQuotation)
    return fromDollar(toDollar(amount, srcQuotation), destQuotation)
end
