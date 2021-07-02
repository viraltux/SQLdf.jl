module SQLDF

using DataFrames, RCall

import DataFrames: DataFrame

export sqldf, DataFrame, @rput

function __init__()

    if !rcopy(R""" "sqldf" %in% installed.packages() """)
        @error "'sqldf' needs to be installed in R"
    else
        R"library(proto); library(gsubfn); library(RSQLite); library(sqldf)"
    end

    # println("""

    # R must be installed in you system for SQLDF to work
    # https://juliainterop.github.io/RCall.jl/latest/installation.html
    # """)
end

include("sqldf.jl")


"""
Execute R sqldf via RCall and return a julia DataFrame.
"""
SQLDF

end
