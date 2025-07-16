import random

Fp = GF(101)

# Let's say that our circuit has 20 wires, so we'll need to commit to 20 values
# So we need a VOLE with 20 values
N_WIRES = 20

# The number of values in the initial VOLE (= number of leaves in the GGM tree)
# Since the GGM tree is binary, this is a power of 2
N = 2**3

# We generate a random matrix G
# This matrix is public, it will be used at the end
G = Matrix(Fp, [[Fp.random_element() for _ in range(N)] for _ in range(N_WIRES)])

# Verifier generates a random delta
delta = Fp.random_element()

# Here's the process for each initial VOLE, also called Single-Point VOLE
# This will result in a VOLE correlation where `e` is a sparse vector of Hamming weight 1 (at index `alpha`)
def VOLE():
    # prover picks a random index `alpha`
    alpha = random.randint(0, N - 1)

    # and generates a sparse vector `e` with a 1 at the index `alpha`
    e = vector([0] * N)
    e[alpha] = 1

    # Verifier generates a random vector `s`
    # This should be generated from a GGM tree, but we'll skip that construction here
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

# Now let's try to construct one big pseudorandom VOLE

# To do that, first let's run a few of these initial VOLEs
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


# We now have a pseudorandom VOLE of 
assert F == S - E * delta

# Now let's apply it to some circuit
# that's the "derandomize" phase

# Remember that we want to commit to some witness
# We'll generate a random witness here, but in reality this should come from our actual circuit
W = vector([Fp.random_element() for _ in range(N_WIRES)])

# The Prover can "correct" his share `E` of the VOLE by the witness `W`
# and send it to the Verifier
correction = E - W

# Verifier can then compute his new share of the VOLE commitment as
S = S - correction * delta

# And now both the Prover and Verifier hold the correct VOLE commitment
assert F == S - W * delta