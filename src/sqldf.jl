"""
Package: SQLDF

    sqldf(query::String)::DataFrame

Execute R sqldf and return a julia DataFrame.

Columns in the DataFrame must have a type other than Any. In order to work with dates expressions like
\"""select strftime("%Y", datetime_column, "unixepoch") as year from T\""" may be used.

# Arguments
`query`: SQL query handled by R sqldf

# Returns
Julia DataFrame with the results from R sqldf

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
```
"""
function sqldf(query::String)::DataFrame
    
    # Normalize Query
    query = replace(query,"\n"=>" ")
    nq = split(query," ")
    nq = nq[nq .!= ""]
        
    # Extract tables in query
    tables = String[]
    nt = false
    for w in nq
        nt = nt ? push!(tables,w)==0 : lowercase(w) in ["from","join"]
    end
    
    # Prepare R
    for t in tables
        Main.eval(Main.Meta.parse("@rput "*t))
    end

    # Retrieve and Return
    rquery = "c7e881694dfe63f2 = sqldf('"*query*"')"
    rquery = replace(rquery,"\"" => "\\\"")

    eval(Meta.parse("R\""*rquery*"\""))
    R"colnames(c7e881694dfe63f2) <- make.unique(colnames(c7e881694dfe63f2),sep='_')"
    res = rcopy(R"c7e881694dfe63f2")

    # Clean Up
    R"rm(c7e881694dfe63f2)"
    for t in tables
        eval(Meta.parse("R"*"\"rm("*t*")\""))
    end
    R"gc()"
    
    return res
end
