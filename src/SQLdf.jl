module SQLdf

using SQLite, DataFrames, RCall

import DataFrames: DataFrame

export sqldf, @sqldf, DataFrame, setRDB, @rput

include("sqldf_SQLite.jl")
include("sqldf_R.jl")
include("qtables.jl")

sqldf = sqldf_SQLite

function setRDB(rdb::String)
    
    @assert rdb in ["SQLite","R"] """Posible values for RDB are "SQLite" and "R" """

    if rdb == "R"
        if !rcopy(R""" "sqldf" %in% installed.packages() """)
            @error "'sqldf' needs to be installed in R. \nMore information at https://juliainterop.github.io/RCall.jl/latest/installation.html"
        else
            R"library(proto); library(gsubfn); library(RSQLite); library(sqldf)"
        end

        global sqldf = sqldf_R
    end
    
    if rdb == "SQLite"
         global sqldf = sqldf_SQLite
    end
    
end

macro sqldf(query)
    return :( sqldf($(esc(query))) )
end

"""
Execute SQL queries on julia DataFrame and Tables
"""
SQLdf


"""
Package: SQLdf

    sqldf(query::String)::DataFrame

Execute a SQL query on julia DataFrames

By default sqldf using SQLite however it can also connect to R/sqldf via setRDB("R/sqldf").

When using "R/sqldf" only DataFrame types are accepted  and columns in the DataFrame must 
have a type other than Any. In order to  work with dates expressions like 
\"""select strftime("%Y", datetime_column, "unixepoch") as year from T\""" may be used.

When using SQLite all types implementing Tables interface will be accepted, however sqldf 
will still return and DataFrame if not default converstion can performed.

# Arguments
`query`: SQL query 

# Returns
Julia DataFrame with query results

# Examples
```julia-repl
julia> T = DataFrame(C1 = [1,2], C2 = ["a","b"])

julia> query = \"""
               select * 
               from T
               where C2 = "a" 
               \""";

julia> sqldf(query)
1×2 DataFrame
 Row │ C1     C2     
     │ Int64  String 
─────┼───────────────
   1 │     1  a

julia> @sqldf query
1×2 DataFrame
 Row │ C1     C2     
     │ Int64  String 
─────┼───────────────
   1 │     1  a


```
"""
sqldf

end
