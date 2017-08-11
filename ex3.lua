
-- Exemplo estrutura de sequencia:

-- Resolução de uma equação do 2o grau
-- ax^2 + bx + x = 0
-- x1 = (-b - sqrt(delta)) / (2 * a)
-- x2 = (-b + sqrt(delta)) / (2 * a)
-- delta = b^2 - 4 * a * c

-- x^2 - 5x + 6 = 0


a = 2
b = -10
c = 12

delta = b^2 - 4 * a * c
x1 = (-b - math.sqrt(delta)) / (2 * a)
x2 = (-b + math.sqrt(delta)) / (2 * a)

print(x1, x2)


