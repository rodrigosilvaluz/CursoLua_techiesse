
--[[
a = 2
b = 10
c = 5


maior = a

if b > maior then
    maior = b
end

if c > maior then
    maior = c
end

print(maior)
]]


v = {2, 10, 5, 6, 20, 15, 7, 100, 50, 45, 65, 132, 20}

maior = v[1]
for i = 2, #v do
    if v[i] > maior then
        maior = v[i]
    end
end

print(maior)

