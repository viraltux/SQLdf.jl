module SQLdf

using DataFrames, RCall

import DataFrames: DataFrame

export sqldf, @sqldf, DataFrame, @rput

function __init__()

    if !rcopy(R""" "sqldf" %in% installed.packages() """)
        @error "'sqldf' needs to be installed in R. \nMore information at https://juliainterop.github.io/RCall.jl/latest/installation.html"
    else
        R"library(proto); library(gsubfn); library(RSQLite); library(sqldf)"
    end

end

include("sqldf.jl")

"""
Execute R sqldf via RCall and return a julia DataFrame.
"""
SQLdf

end
