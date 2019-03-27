

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


