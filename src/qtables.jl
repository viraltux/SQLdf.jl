# String Vector with the tables used in 'query'
function qtables(query::String)::Vector{String}
    
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
    tables
    
end
