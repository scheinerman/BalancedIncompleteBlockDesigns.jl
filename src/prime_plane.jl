export prime_plane


"""
`prime_plane(n)` returns a finite projective plane of order `n` provided
`n` is prime.
"""
function prime_plane(p::Int)
    @assert isprime(p) "$p is not prime"
    alist = [ [a,b,1] for a=0:p-1 for b=0:p-1 ]
    blist = [ [a,1,0] for a=0:p-1 ]
    clist = [ [1,0,0] ]

    list = [alist; blist; clist ]

    n = length(list)

    A = zeros(Int,n,n)
    for i=1:n
        for j=1:n
            d = list[i]' * list[j]
            A[i,j] = mod(d[1],p) == 0
        end
    end
    return A
end
