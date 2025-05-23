println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
model = Model(Ipopt.Optimizer)

d = 20
n = 42
#m  = 5*(4-3*(d-2))

start_idx =2
k=7

t =  sum(
    -2d*d^6 - d^2 * d^5 - 2d*d^5 - d^3*d^4 - d^4 * d^3 -2d^3 * d^3)

@variable(model, -d <= λ[i = start_idx:n] <= d)

@objective(model, Max, t + sum(
    sum(
        -2d*λ[i]^6 - d^2 * λ[i]^5 - 2d*λ[i]^5 - d^3*λ[i]^4 - d^4 * λ[i]^3 -2d^3 * λ[i]^3 + 3d*λ[i]^5 + 3d^2 * λ[i]^4
    for i in start_idx:n
)))
#8.57829e+06

# 8.57829e+06 but this point is not feassible since need one of the lambdas to be 0.
#set_start_value(λ[2], d)
#set_start_value(λ[3], -1)
# set_start_value(λ[4], 0)
# set_start_value(λ[5], 0)
# set_start_value(λ[6], 0)
# set_start_value(λ[7], 3.1)
# set_start_value(λ[8], 3.1)
# set_start_value(λ[9], -8.1)
# set_start_value(λ[10], -8.1)


@constraint(model, d + sum(λ[i] for i in start_idx:n) == 0)
@constraint(model, d^2 + sum(λ[i]^2 for i in start_idx:n) == n * d)

println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)