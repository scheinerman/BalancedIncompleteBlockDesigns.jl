using Test, BalancedIncompleteBlockDesigns

n = 3
b = n * n + n + 1
v = b
k = n + 1
r = n + 1
l = 1

A = projective(n)
@test BIBD_check(A) == (b, v, r, k, l)
