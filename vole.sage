Fp = GF(101)

# xor = lambda a, b: Fp(int(a) ^^ int(b))

delta = Fp.random_element()
k = Fp.random_element()

u = 0

m0 = k
m1 = k + delta

m = m0 if u == 0 else m1

print(m)
print(u * delta + k)