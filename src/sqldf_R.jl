function sqldf_R(query::String)::DataFrame
    
    # Normalize Query
    query = replace(query,"\n"=>" ")
        
    # Extract tables in query
    tables = qtables(query)
    
    # Prepare R
    for t in tables
        Main.eval(Main.Meta.parse("@rput "*t))
    end

    # Retrieve and Return
    rquery = "c7e881694dfe63f2 = sqldf('"*query*"')"
    rquery = replace(rquery,"\"" => "\\\"")

    eval(Meta.parse("R\""*rquery*"\""))
    R"colnames(c7e881694dfe63f2) <- make.unique(colnames(c7e881694dfe63f2),sep=':')"
    res = rcopy(R"c7e881694dfe63f2")

    # Clean Up
    R"rm(c7e881694dfe63f2)"
    for t in tables
        eval(Meta.parse("R"*"\"rm("*t*")\""))
    end
    R"gc()"
    
    return res
end

