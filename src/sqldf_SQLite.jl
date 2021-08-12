function sqldf_SQLite(query::String)

    # Normalize Query
    query = replace(query,"\n"=>" ")

    # Extract tables in query
    tables = SQLdf.qtables(query)

    # Remove duplicates
    query = "SELECT * from ("*query*")"
    
    # Load DataFrame tables in SQLite
    db = SQLite.DB();
    for t in tables
        Main.eval(Main.Meta.parse(t)) |> SQLite.load!(db, t)
    end

    DBInterface.execute(db, query) |> DataFrame
    
end

