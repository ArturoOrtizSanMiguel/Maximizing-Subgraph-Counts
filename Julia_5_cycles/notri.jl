println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
model = Model(Ipopt.Optimizer)

d = 5
n = 40
#m  = 5*(4-3*(d-2))
# n = Gn * Gd * (Gd-1)
# d = Gd-1

start_idx =2


@variable(model, -d <= λ[i = start_idx:n] <= d)

@objective(model, Max, d^6 + sum(λ[i]^6 for i in start_idx:n))


@constraint(model, sum(λ[i] for i in start_idx:n) == -d)
@constraint(model, sum(λ[i]^2 for i in start_idx:n) == n * d - d^2)
@constraint(model, sum(λ[i]^4 for i in start_idx:n)  - n*d^2 + n*d == -d^4)

set_start_value(λ[2],d)



println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)