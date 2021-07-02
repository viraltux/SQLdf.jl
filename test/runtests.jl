using SQLDF
using Test
import DataFrames: DataFrame

@testset "SQLDF.jl" begin
    Main.eval(Meta.parse(""" x = DataFrame((a=1:14,  b=14:-1:1, c =split("Julia is great",""))) """))
    
    qr = sqldf("""
               select * 
               from x
               where a <= 3
               order by a
              """)
    @test size(qr) == (3,3)
    @test qr[1,1] == 1

    qr = sqldf("""
               select * 
               from x
               where a <= 3 and c = "J"
               order by a
              """)

    @test size(qr) == (1,3)
    @test qr[1,2] == 14
    Main.eval(Meta.parse(""" y = DataFrame((a=1:14, c=split("Julia is fast!",""))) """))
    

    qr = sqldf("""
               select * 
               from x join y on x.c = y.c
               order by a
              """)
    @test names(qr) == ["a", "b", "c", "a_1", "c_1"]
    @test qr[1,3] == "J"
    @test qr[1,5] == "J"
    @test qr[18,5] == "t"
end

