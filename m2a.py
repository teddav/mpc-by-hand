import random

p = 101

# Convert a number to binary
def to_binary(v):
    return [int(i) for i in list(bin(v)[2:])]

# Generate two random numbers `a` and `b`
a = random.randint(0, p)
b = random.randint(0, p)
print("a =", a, "b =", b)
print("a * b =", (a * b) % p)

# Receiver's input `b` is converted to binary (in little endian)
b_bits = to_binary(b)[::-1]

# Sender generates a mask `s` of the same length as bits in `b`
s = [random.randint(0,p) for _ in range(len(b_bits))]

# Sender computes two messages `t0` and `t1`
t0 = s.copy()
t1 = [(a * pow(2, i) + s[i]) % p for i in range(len(s))]

# Receiver gets a mix of messages `t0` and `t1`, based on its input `b`
tb = [t0[i] if bit == 0 else t1[i] for i,bit in enumerate(b_bits)]

# Share `x`, received by the Sender is the sum of the mask `s`
x = (-sum(s)) % p
# Share `y`, received by the Receiver is the sum of the mix of masks `v`
y = sum(tb)
print("x =", x, "y =", y)

print("x + y =", (x + y) % p)

assert (x + y) % p == (a * b) % p

# The sender hides his values `a` with a mask in two messages `t0` and `t1`
# - `t0` is the mask
# - `t1` is the mask + `a`
# So: tb = a * b + the mask
# if we subtract the mask from `tb`, we get `a * b`
# which is what we do in `x + y`
# Therefore: x + y = a * b