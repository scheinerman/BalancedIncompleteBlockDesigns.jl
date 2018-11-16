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

#### Blocks

If `A` is the output of `BIBD`, the `blocks(A)` returns a list of the
blocks of the design (that is, a list of sets).

## Projective Planes

The function `projective(n)` creates a projective plane of order `n`.
This is equivalent to `BIBD(n*n+n+1,n+1,1)`.

#### Projective Planes of Prime Order  

As a convenience, we include `prime_plane(p)` to construct a projective
plane of order `p` when `p` is prime. This is constructed without the use of
integer programming and therefore is fast.

## Verification

`BIBD_check(A)` determines if the integer matrix `A` is a valid
balanced incomplete block design. If so, it returns its parameters.
If not, it throws an error.

## Examples

In this example, Gurobi messages have been removed.

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

julia> using ShowSet

julia> blocks(A)
 13-element Array{Set{Int64},1}:
  {2,4,11,12}
  {5,6,8,11}  
  {1,7,10,11}
  {4,5,9,10}  
  {1,2,6,9}   
  {2,3,8,10}  
  {1,4,8,13}  
  {3,4,6,7}   
  {1,3,5,12}  
  {3,9,11,13}
  {2,5,7,13}  
  {7,8,9,12}  
  {6,10,12,13}

julia> A = prime_plane(17);

julia> BIBD_check(A)
  (307, 307, 18, 18, 1)
```
## Stern Warning

This is a demonstration project. We use integer programming to find block
designs and unless the parameters are small, this can take horribly long.
We also use the *Gurobi* solver. Edit the source to use another solver.
