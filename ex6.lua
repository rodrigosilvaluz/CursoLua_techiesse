

soma = function (x, y)
    return x + y
end


function prod(x, y)
    return x * y
end


function exec(f, x, y)
    return f(x, y)
end


funcs = {soma, prod, math.pow, function (a, b) return a - b end}


a = 3
b = 2

res = {}
for i = 1, #funcs do
    res[i] = exec(funcs[i], a, b)
end

for i, v in pairs(res) do
    print(i, v)
end
