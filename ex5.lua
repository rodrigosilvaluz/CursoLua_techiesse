

function maior(v)
    local m = v[1]
    for i = 2, #v do
        local a = i
        if v[i] > m then
            m = v[i]
        end
    end
    return m
end

v = {2, 10, 5, 6, 20, 15, 7, 100, 50, 45, 65, 132, 20}
--v2 = {2, 310, 5, 6, 20, 15, 7, 100, 50, 45, 65, 132, 20}


print(maior(v))
print(maior({2, 310, 5, 6, 20, 15, 7, 100, 50, 45, 65, 132, 20}))