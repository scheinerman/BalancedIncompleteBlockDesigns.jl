# Balanced Incomplete Block Designs

The `BalancedIncompleteBlockDesigns` module uses integer programming to create balanced incomplete block designs.

## Block Design Creation

The function `BIBD` is used to create a balanced incomplete block design.
Use `BIBD(b,v,r,k,λ)` to create a design with:
+ `b` blocks,
+ `v` vertices (varieties),
+ `r` blocks containing every vertex,
+ `k` vertices in a block, and
+ `λ` blocks containing a pair of distinct vertices.

The shorter form `BIBD(b,k,λ)` creates a symmetric design and is
equivalent to `BIBD(b,b,k,k,λ)`.

The function returns a `v`-by-`b` zero-one matrix whose `i,j`-entry
is `1` exactly when vertex `i` is in block `j`.

## Projective Planes

The function `projective(n)` creates a projective plane of order `n`.
This is equivalent to `BIBD(n*n+n+1,n+1,1)`.

## Verification

`BIBD_check(A)` determines if the integer matrix `A` is a valid
balanced incomplete block design. If so, it returns its parameters.
If not, it throws an error.

## Examples

In this example, Gurobi diagnostics have been removed.

```
julia> A = BIBD(26,13,6,3,1)

13×26 Array{Int64,2}:
 1  1  1  1  1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 1  0  0  0  0  0  1  1  1  1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
 1  0  0  0  0  0  0  0  0  0  0  1  1  1  1  1  0  0  0  0  0  0  0  0  0  0
 0  1  0  0  0  0  1  0  0  0  0  1  0  0  0  0  1  1  1  0  0  0  0  0  0  0
 0  1  0  0  0  0  0  1  0  0  0  0  1  0  0  0  0  0  0  1  1  1  0  0  0  0
 0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  0  0  0  0  0  0  1  1  1  0
 0  0  1  0  0  0  0  0  1  0  0  0  0  0  1  0  1  0  0  1  0  0  0  0  0  1
 0  0  0  0  1  0  0  0  1  0  0  0  0  1  0  0  0  0  1  0  1  0  0  0  1  0
 0  0  0  0  1  0  0  0  0  0  1  0  0  0  0  1  1  0  0  0  0  1  0  1  0  0
 0  0  0  1  0  0  0  0  0  0  1  0  0  0  1  0  0  1  0  0  1  0  1  0  0  0
 0  0  0  0  0  1  0  1  0  0  0  0  0  1  0  0  0  1  0  0  0  0  0  1  0  1
 0  0  0  1  0  0  0  0  0  1  0  1  0  0  0  0  0  0  0  0  0  1  0  0  1  1
 0  0  0  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  1  1  0  0  1  0  0  0

julia> BIBD_check(A)
 (26, 13, 6, 3, 1)

julia> A = projective(3)

13×13 Array{Int64,2}:
 0  0  1  0  1  0  1  0  1  0  0  0  0
 1  0  0  0  1  1  0  0  0  0  1  0  0
 0  0  0  0  0  1  0  1  1  1  0  0  0
 1  0  0  1  0  0  1  1  0  0  0  0  0
 0  1  0  1  0  0  0  0  1  0  1  0  0
 0  1  0  0  1  0  0  1  0  0  0  0  1
 0  0  1  0  0  0  0  1  0  0  1  1  0
 0  1  0  0  0  1  1  0  0  0  0  1  0
 0  0  0  1  1  0  0  0  0  1  0  1  0
 0  0  1  1  0  1  0  0  0  0  0  0  1
 1  1  1  0  0  0  0  0  0  1  0  0  0
 1  0  0  0  0  0  0  0  1  0  0  1  1
 0  0  0  0  0  0  1  0  0  1  1  0  1

julia> BIBD_check(A)
(13, 13, 4, 4, 1)
```
## Stern Warning

This is a demonstration project. We use integer programming to find block
designs and unless the parameters are small, this can take horribly long.
We also use the *Gurobi* solver. Edit the source to use another solver.
