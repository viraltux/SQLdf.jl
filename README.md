# SQLdf

This package allows SQL queries on any Julia type implementing the Table.jl interface an in particular the DataFrame type from DataFrames.jl. All results from a query are returned in a DataFrame type.

Versions prior to 0.2.0 would use R/sqldf via RCall. Although this is still possible by executing setRDB("R") before using sqldf, the default SQL engine is SQLite from SQLite.jl. If the default RDB is changed to "R" it can be set to its default with setRDB("SQLite").

The use setRDB("R") requires [R to be
installed](https://juliainterop.github.io/RCall.jl/stable/installation/) with sqldf within.


# Introduction

Simply treat DataFrame objects (or any type implementing Tables.jl) like SQL tables.

# Examples

```julia 
using SQLdf
```

## Simple Queries on DataFrames

```julia 
T = DataFrame(a=1:14,  b=14:-1:1, c = split("Julia is great",""))

@sqldf "select count(*) from T"
1×1 DataFrame
 Row │ count(*) 
     │ Int64    
─────┼──────────
   1 │       14

    
sqldf("""
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
```

## Join DataFrames Query

```julia 
S = DataFrame((a=1:14, c=split("Julia is fast!","")))

sqldf("""
      select * 
      from T join S on T.b = S.a
      order by T.a
      """)
14×5 DataFrame
 Row │ a      b      c       a:1    c:1    
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

## Join Query Types implementing Tables interface

```julia 
using TimeSeries, Dates

dates = Date(2018, 1, 1):Day(1):Date(2018, 1, 14)
TA = TimeArray(dates, 1:14)

@sqldf "select * from TA join T where TA.A = T.a"
14×5 DataFrame
 Row │ timestamp   A      a:1    b      c      
     │ Date        Int64  Int64  Int64  String 
─────┼─────────────────────────────────────────
   1 │ 2018-01-01      1      1     14  J
   2 │ 2018-01-02      2      2     13  u
   3 │ 2018-01-03      3      3     12  l
   4 │ 2018-01-04      4      4     11  i
   5 │ 2018-01-05      5      5     10  a
   6 │ 2018-01-06      6      6      9
   7 │ 2018-01-07      7      7      8  i
   8 │ 2018-01-08      8      8      7  s
   9 │ 2018-01-09      9      9      6
  10 │ 2018-01-10     10     10      5  g
  11 │ 2018-01-11     11     11      4  r
  12 │ 2018-01-12     12     12      3  e
  13 │ 2018-01-13     13     13      2  a
  14 │ 2018-01-14     14     14      1  t
```

