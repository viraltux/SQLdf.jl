# SQLdf

This package is a Julia wrapper providing access to R sqldf library. Before using it [R needs to be
installed](https://juliainterop.github.io/RCall.jl/stable/installation/) with sqldf within.


# Introduction

Simply treat DataFrame objects like tables, the default `SQL` engine in `sqldf` is `SQLite` but the `R` `sqldf` library can be configured to use other `SQL` engines like `PostgreSQL`.

# Examples

```julia 
julia> using SQLdf

julia> T = DataFrame(a=1:14,  b=14:-1:1, c = split("Julia is great",""))
    
julia> sqldf("""
             SELECT * 
             FROM T
             WHERE a <= 5
             ORDER BY  a
             """)
5×3 DataFrame
 Row │ a      b      c      
     │ Int64  Int64  String 
─────┼──────────────────────
   1 │     1     14  J
   2 │     2     13  u
   3 │     3     12  l
   4 │     4     11  i
   5 │     5     10  a

julia> S = DataFrame((a=1:14, c=split("Julia is fast!","")))

julia> sqldf("""
             select * 
             from T join S on T.b = S.a
             order by T.a
             """)
14×5 DataFrame
 Row │ a      b      c       a_1    c_1    
     │ Int64  Int64  String  Int64  String 
─────┼─────────────────────────────────────
   1 │     1     14  J          14  !
   2 │     2     13  u          13  t
   3 │     3     12  l          12  s
   4 │     4     11  i          11  a
   5 │     5     10  a          10  f
   6 │     6      9              9
   7 │     7      8  i           8  s
   8 │     8      7  s           7  i
   9 │     9      6              6
  10 │    10      5  g           5  a
  11 │    11      4  r           4  i
  12 │    12      3  e           3  l
  13 │    13      2  a           2  u
  14 │    14      1  t           1  J
```

