from os import urandom
from math import isqrt

def F(n):
    if n <= 0:
        return (0, 0, 0, 0)
    
    s = isqrt(n)
    for i in range(0, s + 1):
        a = s - i
        x = n - a * a
        if x == 0:
            return (a, 0, 0, 0)
        
        b = isqrt(x)
        x -= b * b
        if x == 0:
            return (a, b, 0, 0)
        
        c = isqrt(x)
        x -= c * c
        if x == 0:
            return (a, b, c, 0)
        
        d = isqrt(x)
        x -= d * d
        if x == 0:
            return (a, b, c, d)

n = int.from_bytes(urandom(8), 'little')
v = F(n)
print(n)
print(v)
print(n == v[0] * v[0] + v[1] * v[1] + v[2] * v[2] + v[3] * v[3])

