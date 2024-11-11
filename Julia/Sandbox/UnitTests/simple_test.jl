using Printf
using Test
try
    @testset verbose=true "simple_test" begin
        @testset verbose=true "this_will_fail" begin
            @test false
        end
        @testset verbose=true "this_will_pass" begin
            @test true
        end

        @testset verbose=true "trigonometric identities" begin
            θ = 2/3*π
            @test sin(-θ) ≈ -sin(θ)
            @test cos(-θ) ≈ cos(θ)
            @test sin(2θ) ≈ 2*sin(θ)*cos(θ)
            @test cos(2θ) ≈ cos(θ)^2 - sin(θ)^2
        end
    end
catch e
    println("\nSome tests failed")
    # println("Type of exception:", typeof(e))
    # @printf("%d passed, %d failed, %d errors, %d broken\n", e.pass, e.fail, e.error, e.broken)
    # println(e.errors_and_fails)
end
