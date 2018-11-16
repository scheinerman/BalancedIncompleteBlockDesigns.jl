module BalancedIncompleteBlockDesigns

using JuMP
using MathProgBase
using Gurobi

export BIBD, projective, BIBD_check, blocks


"""
`BIBD(b,v,r,k,λ)` finds a `(b,v,r,k,λ)`-balanced incomplete block design.
The return is a `v`-by-`b` matrix of 0s and 1s whose i,j-entry  is 1
exactly when vertex i is in block j. Errors erupt if no such design exists.

The shorter form `BIBD(b,k,λ)` returns a symmetric design and is equivalent
to `BIBD(b,b,k,k,λ)`.
"""
function BIBD(b::Int,v::Int,r::Int,k::Int,l::Int)
    errmsg = "No ($b,$v,$r,$k,$l)-BIBD can be found"

    @assert b>0 && v>0 && r>0 && k>0 && l>0 && k<v "Invalid parameters: "*errmsg
    @assert b*k==v*r && r*(k-1)==l*(v-1) errmsg

    M = Model(solver=GurobiSolver())
    @variable(M, x[1:v,1:b], Bin)       # 1{vtx i in block B}
    @variable(M, y[1:v,1:v,1:b], Bin)   # 1{vtcs i,j in block B} where i≠j

    # Basics for y
    for i=1:v
        for B=1:b
            @constraint(M, y[i,i,B]==0)  # i≠j
        end
    end

    for i=1:v
        for j=1:v
            for B=1:b
                @constraint(M, y[i,j,B]==y[j,i,B]) # symmetric in i,j
            end
        end
    end

    # Each vertex is in r blocks
    for i=1:v
        @constraint(M, sum(x[i,B] for B=1:b) == r)
    end

    # Each block has k vertices
    for B=1:b
        @constraint(M, sum(x[i,B] for i=1:v) == k)
    end

    # every pair i≠j are in l blocks together
    for i=1:v
        for j=1:v
            if i!=j
                @constraint(M, sum(y[i,j,B] for B=1:b) == l)
            end
        end
    end

    # if i,j in B, then x[i,B] and x[j,B] must be 1
    for i=1:v
        for j=1:v
            for B=1:b
                @constraint(M, x[i,B] >= y[i,j,B])
            end
        end
    end

    # if i,j in B, force y[i,j,B] to 1
    for i=1:v
        for j=1:v
            if i!=j
                for B=1:b
                    @constraint(M, y[i,j,B] >= x[i,B] + x[j,B] - 1)
                end
            end
        end
    end


    status = solve(M)
    if status != :Optimal
        error(errmsg)
    end

    X = Int.(getvalue(x))
end

BIBD(b::Int,k::Int,l::Int) = BIBD(b,b,k,k,l)

"""
`projective(n)` returns a projective plane of order `n` as a 0,1-matrix.
The rows of the matrix correspond to the points and the columns to the lines.
The i,j-entry is 1 iff point i is on line j.
"""
function projective(n::Int)
    @assert n>1 "Order of the plane must be at least 2"
    return BIBD(n*n+n+1,n+1,1)
end

function _all_same(vec::Array{T,1}) where T
    n = length(vec)
    if n < 2
        return true
    end
    for k=1:n-1
        if vec[k] != vec[k+1]
            return false
        end
    end
    return true
end

"""
`BIBD_check(A)` checks if the matrix `A` represents a
balanced incomplete block design. If so, it returns
its parameters as a 5-tuple `(b,v,r,k,λ)`.
"""
function BIBD_check(A::Array{Int,2})
    if maximum(A)>1 || minimum(A)<0
        error("Not a 0,1-matrix")
    end

    v,b = size(A)

    rlist = sum(A;dims=2)[:]
    if !_all_same(rlist)
        error("Replication number fail")
    end
    r = rlist[1]

    klist = sum(A;dims=1)[:]
    if !_all_same(klist)
        error("Block size fail")
    end

    k = klist[1]

    if k==v
        error("Incompleteness fail: v==k==$v")
    end

    B = A*A'
    l = B[1,2]
    for i=1:v
        for j=1:v
            if i!=j && B[i,j]!=l
                error("Lambda fail")
            end
        end
    end

    return (b,v,r,k,l)
end

"""
`blocks(A)` gives a list of the blocks of the balanced incomplete block design
specified by the matrix `A` (e.g., the output of `BIBD`)
"""
function blocks(A::Array{Int,2})
    b,v,r,k,l = BIBD_check(A)
    [ Set(findall(A[:,j] .> 0)) for j=1:b]
end



end  # end of module
