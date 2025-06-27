import random

Fp = GF(101)

# We ultimately want a VOLE with 5 values
N_VOLES = 5

# The number of values in the initial VOLE (= number of leaves in the GGM tree)
N = 15

# We generate a random matrix G
# This matrix is public, it will be used at the end
G = Matrix(Fp, [[Fp.random_element() for _ in range(N)] for _ in range(N_VOLES)])

# Verifier generates a random delta
# delta = F.random_element()
delta = Fp(10)
print("delta", delta)

# Here's the process for each initial VOLE
def VOLE():
    # prover picks a random index `alpha`
    alpha = random.randint(0, N - 1)

    # and generates a sparse vector `e` with a 1 at the index `alpha`
    e = vector([0] * N)
    e[alpha] = 1

    # Verifier generates a random vector `s`
    # This would be generated from a GGM tree
    s = vector([Fp.random_element() for _ in range(N)])

    # Prover and Verifier run log(N) OTs to exchange N-1 values
    f = s[:]
    # Prover receives all values except the one at index `alpha`
    f[alpha] = 0

    # Verifier computes `c`, and sends to Prover
    c = sum(s) - delta

    # Prover can now recover the value at `alpha`, hidden with `delta`
    f[alpha] = c - sum(f)

    assert f == s - e * delta

    return f, s, e

# Run 3 initial VOLEs
f1, s1, e1 = VOLE()
f2, s2, e2 = VOLE()
f3, s3, e3 = VOLE()

# VOLEs are additively homomorphic, so we can add them together
f = f1 + f2 + f3
e = e1 + e2 + e3
# Verifier can do the same
s = s1 + s2 + s3

# and the equality still holds
assert f == s - e * delta

# Now we use the LPN (learning parity with noise) assumption
# we multiply the values with the public matrix G
F = G * f
E = G * e
S = G * s
assert F == S - E * delta

print(E)

# But we now have a pseudorandom VOLE
# Remember that we want to commit our witness
W = vector([Fp(5), Fp(10), Fp(15), Fp(20), Fp(25)])

# The Prover can "correct" the E by the witness W
# and send it to the Verifier
correction = E - W

# Verifier can then compute his new part of the VOLE commitment as
S = S - correction * delta

# And now both the Prover and Verifier hold the correct VOLE commitment
assert F == S - W * delta